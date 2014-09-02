#include "header.h"

void init();
t_operation main_nrf_init();

void ProcessRxCmd(t_cmd * cmd);
void ProcessPendingActions(t_action * actions);
void ProcessPendingTicks(uint8 * ticks);
void SyncedDelay(uint16 ms);
void TriggerAlarm(uint16 time);

void ProcessDisplay();
void ProcessDisplayOn();
void ProcessDisplayStandby();
void CheckRFInput();

void main()
{
    init();

    nrf_powerup();
    nrf_rx_start_listening();
    
    while (1)
    {
        if (flags.rxCmdPending)
            ProcessRxCmd(&cmdPending);

        if (clockTicksPending)
            ProcessPendingTicks(&clockTicksPending);

        if (pendingActions != taNone)
            ProcessPendingActions(&pendingActions);

        ProcessDisplay();
        CheckRFInput();
    }
}

void CheckRFInput()
{
    uint8 buffer[CFG_PAYLOAD_SIZE];
    uint8 debug_i;
    
    if (flags.rxCmdPending) return;
    if (! nrf_rx_packet_ready()) return;

    // get packet
    nrf_rx_read_packet(CFG_PAYLOAD_SIZE, buffer);
    nrf_clear_interrupts(NRFCFG_RX_INTERRUPT);
    nrfpacket_from_raw_buffer(&packet, buffer);
    
    for (debug_i = 0; debug_i < CFG_PAYLOAD_SIZE; debug_i ++)
    {
        debug_sprinti_2("byte %i is %i", (int16)(debug_i), (int16)(buffer[debug_i]));
    }
    
    // if last id, discard packet
    if (nrfpacket_compare_id(&packet, packet_last_id_bytes) == 1)
    {
        // discard as repeated
        #if DEBUG
        debug_sprinti_1("RX PACK DISC %i", (int16)(packet.cmd));
        #endif
    }
    else
    {
        nrfpacket_copy_id(&packet, packet_last_id_bytes);
        #if DEBUG
        debug_sprinti_1("RX PACK OK %i", (int16)(packet.cmd));
        #endif

        cmdPending = packet.cmd;
        flags.rxCmdPending = 1;
    }
    nrf_rx_start_listening();
}

void ProcessDisplay()
{
    if (! flags.inStandby)
    {
        if (whatsChanged != tcfNone) 
            ProcessDisplayOn();
    }
    else
    {
        ProcessDisplayStandby();
    }
}

void ProcessDisplayOn()
{
    t_changed_flags localChanged;

    localChanged = whatsChanged;
    whatsChanged = 0;

    if (localChanged & tcfLocals)
        tab_refresh_locals();

    if (localChanged & tcfGuests)
        tab_refresh_guests();

    if (localChanged & tcfTime)
        tab_refresh_time();
}

void ProcessDisplayStandby()
{
    static uint16 cnt = 0;

    if (! flags.timedRoutinePending) return;
    flags.timedRoutinePending = 0;

    if (cnt == 0)
    {
         tab_send_string(".   ", 4);
         tab_strobe_time();
    }

    if (cnt == 1000)
    {
         tab_send_string("    ", 4);
         tab_strobe_time();
    }

    if (cnt == 5000) cnt = 0;
    else cnt ++;
}

void ProcessRxCmd(t_cmd * cmd)
{
    t_cmd localCmd;
    
    #if DEBUG
    debug_sprinti_1("ProcessRxCmd %i", (int16)(*cmd));
    #endif
    
    localCmd = *cmd;
    *cmd = CmdCode_None;
    
    flags.rxCmdPending = 0;
    
    if (!flags.inStandby)
        whatsChanged |= ApplyCmd(localCmd);
    else
    {
        flags.inStandby = 0;
        whatsChanged |= tcfAll;
    }
}

void ProcessPendingTicks(uint8 * ticks)
{
    uint8 localTicks;
    
    #if DEBUG
    debug_sprinti_1("ProcessTicks %i", (int16)(*ticks));
    #endif
    
    localTicks = *ticks;
    *ticks = 0;

    if (!flags.inStandby)
    {
        whatsChanged |= tcfTime;
        tabdata_add_sec(&(tab_data.time), -((int8)localTicks));

        if (tab_data.time.min == 0 && tab_data.time.sec == 0)
        {
            flags.timeStarted = 0;
            pendingActions |= taTimeEnded;
        }
    }
}

void ProcessPendingActions(t_action * actions)
{
    t_action localActions;
    int8 i8;
    char txt5[5];
    
    #if DEBUG
    debug_sprinti_1("ProcessPendingActions %i", (int16)(*actions));
    #endif
    
    localActions = *actions;
    *actions = 0;
    
    if (flags.inStandby) return;

    if (localActions & taNotifyClaxon)
    {
        if (configuration.UseClaxon)
            tab_display_msg("SOFF", 4);
        else
            tab_display_msg("S ON", 4);
            
        SyncedDelay(1000);
        whatsChanged |= tcfAll;
    }
    
    if (localActions & taTryClaxon)
    {
        for (i8 = 3; i8 > 0; i8 --)
        {
            sprinti(txt5, "   %i", (int16)i8);
            tab_display_msg(txt5, 4);
        }
    
        TriggerAlarm(750);
        whatsChanged |= tcfAll;
    }
    
    if (localActions & taTimeEnded)
    {
        tab_display_msg("----", 4);
        TriggerAlarm(1500);
        whatsChanged |= tcfAll;
    }
    
    if (localActions & taClear)
    {
        tab_send_string("    ", 4);
        tab_strobe_time();
        tab_strobe_locals();
        tab_strobe_guests();
        whatsChanged |= tcfAll;
    }
}

void InterruptLow() iv 0x0018 ics ICS_AUTO 
{
    if (INTCON.T0IF)
    {
        // each 0.997333 ms
        INTCON.T0IF = 0;
        TMR0L += 69;
        
        flags.timedRoutinePending = 1;
        if (syncedDelayCounter > 0) syncedDelayCounter --;
        
        #if DEBUG
        PIN_DBG_0 = ! PIN_DBG_0;
        #endif
    }
}

void InterruptHigh() iv 0x0008 ics ICS_AUTO
{
    if (PIR1.TMR1IF)
    {
        // each 1 sec
        TMR1H = 0x80; 
        TMR1L = 0x00;
        PIR1.TMR1IF = 0;

        // increment ticks pending if time started and not too much
        if ((flags.timeStarted) && (!flags.inStandby) && (!clockTicksPending.B7))
            clockTicksPending ++;
    }
}

void init()
{
    hw_init();

    emu_eeprom_init();
    tab_Init();
    
    variables_init();
    config_load(&configuration);
    
    tab_display_msg("    ", 4);

    if (whyRestarted == RESET_SELF)
    {
        tab_display_msg("----", 4);
        Delay_ms(1000);
    }
    
    if (! main_nrf_init())
    {
        tab_display_msg("E 01", 4);
        Delay_ms(5000);
        
        #if DEBUG
        while (1)
        {
            debug_print("tab err");
            Delay_ms(1000);
        }
        #endif
    }
    
    #if DEBUG
    Delay_ms(1000);
    debug_print("init end");
    #endif
        
    hw_int_enable();
}

void SyncedDelay(uint16 ms)
{
    syncedDelayCounter = ms;
    while (syncedDelayCounter > 0) ;
}

void TriggerAlarm(uint16 time)
{
    pinClaxon = 1;
    SyncedDelay(time);
    pinClaxon = 0;
    SyncedDelay(50);
}

t_operation main_nrf_init()
{
    uint8 addr[CFG_NUM_ADDRESS_BYTES] = {CFG_ADDRESS};

    nrf_init();
    nrf_set_output_power        (CFG_TX_POWER);
    nrf_set_crc                 (CFG_USE_CRC);
    nrf_set_channel             (CFG_RADIO_CHANNEL);
    nrf_set_interrupts          (NRFCFG_NO_INTERRUPTS);
    nrf_set_direction           (NRFCFG_DIRECTION_RX);
    nrf_enable_auto_acks        (CFG_USE_AUTOACK ? 0b000001 : 0b000000);
    nrf_enable_data_pipes       (0b000001);
    nrf_set_data_rate           (CFG_DATARATE);
    nrf_set_rx_pipe             (0, CFG_NUM_ADDRESS_BYTES, addr, CFG_PAYLOAD_SIZE);
    
    return nrf_test() ? SUCCESS : ERROR;
}