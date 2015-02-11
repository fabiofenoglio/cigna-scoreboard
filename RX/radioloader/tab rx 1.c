#include "header.h"

/* Prototypes =============================================================== */
void interrupt_low()  iv 0x0018 ics ICS_OFF { asm goto 0x1C18; }
void interrupt_high() iv 0x0008 ics ICS_OFF { asm goto 0x1C08; }

void        init                ();
t_operation main_nrf_init       ();
uint8       check_rf_input      ();
void        exit_bootloader     ();
t_bool      memory_is_blank     ();
t_bool      hook_bootloader_tx  ();
void        delay_ms_r          (int16 delay);

uint8       flash_buffer_index  ;
uint8       buffer              [BYTES_PER_PACKET];

#define HELL_FROZEN 0

void main()
{
    init();

    if (! hook_bootloader_tx())
    {
        if (memory_is_blank())
        {
            tab_display_msg("E 02", 4);
            delay_ms_r(ERROR_SHOW_TIME);
            asm RESET;
        }
        else
            exit_bootloader();
    }
    
    while (! HELL_FROZEN)
    {
        check_rf_input();
    }
}

t_bool hook_bootloader_tx()
{
    uint16 timeout = HOOK_TIME;
    
    nrf_powerup();
    nrf_rx_start_listening();
    
    while (timeout -- > 0)
    {
        Delay_ms(1);
        if (nrf_rx_packet_ready())
        {
            nrf_rx_read_packet(CFG_PAYLOAD_SIZE, buffer);
            nrf_clear_interrupts(NRFCFG_RX_INTERRUPT);
            nrf_rx_start_listening();
            return TRUE;
        }
    }
    
    return FALSE;
}

t_bool memory_is_blank()
{
    uint8 i;

    for (i = 0; i < EMPTY_CHECK_SEQUENCE_LEN; i ++)
    {
        if (FLASH_Read(addr1 + i) != EMPTY_CHECK_SEQUENCE_FIXED[i])
            return FALSE;
    }

    return TRUE;
}

void exit_bootloader()
{
    hw_int_disable();
    nrf_powerdown();
    
    asm goto USER_APP_ENTRY_POINT;
}

uint8 check_rf_input()
{
    if (! nrf_rx_packet_ready()) return 0;

    // get packet
    nrf_rx_read_packet(CFG_PAYLOAD_SIZE, buffer);
    nrf_clear_interrupts(NRFCFG_RX_INTERRUPT);

    parse_packet(buffer);
    execute_packet();

    nrf_rx_start_listening();
    return 1;
}

void parse_packet(uint8 * buffer)
{
    uint8 i;

    in_packet.command = buffer[0];

    Highest (in_packet.address) = buffer[1];
    Higher  (in_packet.address) = buffer[2];
    Hi      (in_packet.address) = buffer[3];
    Lo      (in_packet.address) = buffer[4];

    for (i = 0; i < DATA_BYTES_PER_PACKET; i ++)
        in_packet.data_bytes[i] = buffer[FIRST_DATA_BYTE_INDEX + i];
}

void execute_packet()
{
    switch (in_packet.command)
    {
        case cmd_write_buffer:
            protocolcmd_write_buffer();
            break;

        case cmd_write_flash:
            protocolcmd_write_flash();
            break;

        case cmd_erase_flash:
            protocolcmd_erase_flash();
            break;
            
        case cmd_clear_buffer:
            protocolcmd_clear_buffer();
            break;
            
        case cmd_reboot:
            asm RESET;
            break;
            
        case cmd_start_user_app:
            exit_bootloader();
            break;
    }
}

void protocolcmd_clear_buffer()
{
    flash_buffer_index = 0;
}

void protocolcmd_write_buffer()
{
    uint16 i;
    for (i = 0; i < DATA_BYTES_PER_PACKET; i ++)
    {
        flash_write_buffer[flash_buffer_index ++] = in_packet.data_bytes[i];
    }
}

void protocolcmd_write_flash()
{
    if (in_packet.address < USER_APP_ENTRY_POINT ||
        in_packet.address + FLASH_WRITE_BLOCK_SIZE - 1 >= LAST_USEFUL_FLASH_PAGE_FIRST_ADDRESS)
    {
        return;
    }

    FLASH_Write_64(in_packet.address, flash_write_buffer);
    flash_buffer_index = 0;
}

void protocolcmd_erase_flash()
{
    #if FLASH_ERASE_BLOCK_SIZE != 1024
     #error "wrong flash erase block size"
    #endif

    unsigned long addr = USER_APP_ENTRY_POINT;

    while (addr < LAST_USEFUL_FLASH_PAGE_FIRST_ADDRESS)
    {
        FLASH_Erase_1024(addr);
        addr += FLASH_ERASE_BLOCK_SIZE;
    }
}

void init()
{
    hw_init();
    tab_init();

    tab_display_msg("LOAD", 4);

    if (! main_nrf_init())
    {
        tab_display_msg("E 01", 4);
        delay_ms_r(ERROR_SHOW_TIME);
    }
    
    hw_int_enable();
    flash_buffer_index = 0;
    
    if (! ANCON1.B0)
    {
        for (flash_buffer_index = 0; flash_buffer_index < 10; flash_buffer_index ++)
            flash_write_buffer[0] = MEMORY_CHUNK_1[flash_buffer_index] + 
                                    MEMORY_CHUNK_2[flash_buffer_index];
        flash_buffer_index = 0;
    }

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

void delay_ms_r(int16 delay)
{
    while (delay >0)
    {
        delay -= 25;
        Delay_ms(25);
    }
}