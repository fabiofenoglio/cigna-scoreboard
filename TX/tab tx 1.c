#include "header.h"

void         init             ();
t_operation  init_nrf         ();
void         init_fsm         ();
void         signal_error     (error_code ecode);

t_status     status_idle,
             status_button_pressed,
             status_send,
             status_signal,
             status_unpress
             ;

uint8        rb_status =    KEYPAD_COLUMN_DISABLED * 0xFF;

uint8        cmd =          CmdCode_None;
t_bool       cmd_sent;

t_bool       battery_low =  FALSE;
t_bool       low_batt_sent;

uint16       sent_signal_time;
const uint16 sent_signal_time_max =  100;
const uint16 sent_signal_time_min =  25;
const uint16 sent_signal_time_step = 15;

error_code   pending_error = ERRORCODE_NONE;

t_status* sfnc_idle_execute()
{
    // Reset successful-command-sent blink time to maximum
    sent_signal_time = sent_signal_time_max;

    // Enable all columns
    keypad_set_columns(KEYPAD_COLUMN_ENABLED, TRUE);
    
    // Enable PortB change interrupt
    hw_rbpc_int_enable();
    hw_int_enable();
    
    // Wait for interrupt in sleep mode
    hw_powermode_sleep();
    
    return &status_button_pressed;
}

t_status* sfnc_button_pressed_execute()
{
    // Disable PortB change interrupt
    hw_rbpc_int_disable();
    hw_int_disable();
    
    // Read command
    cmd = keypad_read();
    
    // If no command to send (or only FN button pressed)
    if (cmd == CmdCode_None)
    {
        // Antibump delay and back to idle status
        hw_sleep_delay(50);
        return &status_idle;
    }
    
    // Start command send routine
    return &status_send;
}

t_status* sfnc_send_execute()
{
    // Wake up NRF module and wait for oscillator settling
    nrf_powerup();
    hw_sleep_delay(10);
    
    // Prepare command packet
    nrfpacket_set_cmd(cmd);

    // Start sending packet
    hw_int1_enable();
    nrf_tx_start_packet_send(CFG_PAYLOAD_SIZE, nrfpacket_get_buffer());
    hw_int_enable();
    
    // Wait for interrupt in sleep mode
    hw_powermode_sleep();
    
    // Parse result in cmd_sent flag and clear interrupt line
    cmd_sent = nrf_tx_packet_sent() ? TRUE : FALSE;
    nrf_clear_interrupts(NRFCFG_ALL_INTERRUPTS);
    
    // Check low battery
    battery_low = hw_is_low_voltage();

    if (battery_low)
    {
        // Send special information packet with Low Battery warning
        nrfpacket_set_special(NRFPACKET_SPECIAL_LOW_BATT);
        hw_int1_enable();
        nrf_tx_start_packet_send(CFG_PAYLOAD_SIZE, nrfpacket_get_buffer());
        hw_int_enable();
        hw_powermode_sleep();
        // Parse result in low_batt_sent flag and clear interrupt line
        low_batt_sent = nrf_tx_packet_sent() ? TRUE : FALSE;
        nrf_clear_interrupts(NRFCFG_ALL_INTERRUPTS);
    }
    
    // Poweroff NRF module and disable interrupt
    hw_int_disable();
    nrf_powerdown();
    hw_int1_disable();
    
    return &status_signal;
}

t_status* sfnc_signal_execute()
{
    // Blink if battery low
    if (battery_low)
    {
        // Blink 4xRed if battery low
        if (low_batt_sent)
            hw_led_blink(Red, Off, 100, 200, 4);
        // Blink longer (8xRed) if low-battery packet not sent
        else
            hw_led_blink(Red, Off, 100, 200, 8);
    }
    else
    {
        // Blink 1xGreen (short) if command sent
        if (cmd_sent)
            hw_led_blink(Green, Off, sent_signal_time, 0, 1);
        // Blink 2xRed if command not sent
        else
            hw_led_blink(Red, Off, 250, 150, 2);
    
        // blink less if sequent successfull command
        sent_signal_time -= sent_signal_time_step;
        if (sent_signal_time < sent_signal_time_min)
            sent_signal_time = sent_signal_time_min;
    }
    
    return &status_unpress;
}

t_status* sfnc_unpress_execute()
{
    // This status can be used to wait for button release
    // or for button retrigger (continuous mode).
    // Now using retrigger continuous mode
    
    if (keypad_something_pressed())
    {
        return &status_button_pressed;
    }
    else
    {
        return &status_idle;
    }
}

void main()
{
    init();

    while (1)
    {
        if (pending_error != ERRORCODE_NONE) 
            signal_error(pending_error);
        
        fsm_loop();
    }
}

void interrupt() iv 0x0008 ics ICS_AUTO
{
    t_bool served = FALSE;
    
    if (hw_int1_flag)
    {
        hw_int1_flag = 0;
        served = TRUE;
    }
    
    if (hw_rbpc_int_flag)
    {
        rb_status = PORTB;
        hw_rbpc_int_flag = 0;
        served = TRUE;
    }
    
    if (served != TRUE)
        pending_error = ERRORCODE_UNKNOWN_INTERRUPT_CAUGHT;
}

void init()
{
    t_operation result = SUCCESS;
    
    #if DEBUG
    debug_uart_init();
    debug_print("boot started");
    #endif
    
    hw_init();
    hw_led_set(Red);

    if (init_nrf() != SUCCESS)
    {
        result = ERROR;
        signal_error(ERRORCODE_NRF_INIT_ERROR);
    }
    
    nrfpacket_init();
    init_fsm();
    
    if (result != SUCCESS)
    {
        signal_error(ERRORCODE_GENERIC_BOOT_ERROR);
    }
    
    IF_DEBUG(debug_print("boot completed"));
    hw_led_blink(Green, Off, 1000, 0, 1);
}

void init_fsm()
{
    fsm_status_new(&status_idle);
    fsm_status_new(&status_button_pressed);
    fsm_status_new(&status_send);
    fsm_status_new(&status_signal);
    fsm_status_new(&status_unpress);

    status_idle.execute =            sfnc_idle_execute;
    status_button_pressed.execute =  sfnc_button_pressed_execute;
    status_send.execute =            sfnc_send_execute;
    status_signal.execute =          sfnc_signal_execute;
    status_unpress.execute =         sfnc_unpress_execute;

    #if DEBUG
    status_idle.name =               "idle";
    status_button_pressed.name =     "bpress";
    status_send.name =               "send";
    status_signal.name =             "signal";
    status_unpress.name =            "unpress";
    #endif

    fsm_init(&status_idle);
}

t_operation init_nrf()
{
    uint8 addr[CFG_NUM_ADDRESS_BYTES] = {CFG_ADDRESS};

    nrf_init();
    nrf_set_crc                 (CFG_USE_CRC);
    nrf_set_channel             (CFG_RADIO_CHANNEL);
    nrf_set_interrupts          (NRFCFG_ALL_INTERRUPTS);
    nrf_set_direction           (NRFCFG_DIRECTION_TX);
    nrf_enable_auto_acks        (CFG_USE_AUTOACK ? 0b000001 : 0b000000);
    nrf_enable_data_pipes       (0b000001);
    nrf_set_retransmit_delay    (CFG_RETRANSMIT_DELAY);
    nrf_set_max_retransmit      (CFG_MAX_RETRANSMIT);
    nrf_set_data_rate           (CFG_DATARATE);
    nrf_set_output_power        (CFG_TX_POWER);
    nrf_set_rx_address          (0, CFG_NUM_ADDRESS_BYTES, addr);
    nrf_set_tx_address          (CFG_NUM_ADDRESS_BYTES, addr);
    nrf_set_payload_size        (0, CFG_PAYLOAD_SIZE);

    return (nrf_test() ? SUCCESS : ERROR);
}

void signal_error(error_code ecode)
{
    uint32 delay = 2000;
    const uint32 signal_error_max_delay = 3600000;
    
    hw_int_disable();
    
    while (1)
    {
        IF_DEBUG(debug_sprinti_1("[E] error %i", (int16)ecode));
        
        hw_led_blink(Red, Off, 2000, 1000, 1);
        hw_led_blink(Red, Off, 500, 300, ecode);
        hw_sleep_delay(delay);
        
        if (delay < signal_error_max_delay)
        {
            delay *= 2;
            if (delay > signal_error_max_delay) 
                delay = signal_error_max_delay;
        }
    }
}