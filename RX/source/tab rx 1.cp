#line 1 "D:/Git/cigna-scoreboard/RX/source/tab rx 1.c"
#line 1 "d:/git/cigna-scoreboard/rx/source/header.h"
#line 1 "d:/git/cigna-scoreboard/rx/source/debug.h"





 void debug_uart_init()
 {
 Soft_uart_init(&PORTB, 6, 7, 9600, 0);
 }

 void debug_uart_send_text(char* text)
 {
 unsigned short inten;
 unsigned short i;

 inten = INTCON & 0b11000000;
 INTCON &= 0b00111111;

 for (i = 0; i < 20; i ++) Soft_uart_write('-');

 for (i = 0; text[i] != '\0'; i ++)
 Soft_uart_write(text[i]);
 Soft_uart_write(13);
 Soft_uart_write(10);

 INTCON = inten;
 Delay_ms(10);
 }

 char ___debug_line[128];
#line 1 "d:/git/cigna-scoreboard/rx/source/common_pic18.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 20 "d:/git/cigna-scoreboard/rx/source/common_pic18.h"
typedef unsigned short uint8;
typedef signed short int8;
typedef unsigned int uint16;
typedef signed int int16;
typedef unsigned long uint32;
typedef signed long int32;
typedef unsigned long long uint64;
typedef signed long long int64;

typedef enum t_bool_enum
{
 FALSE = 0,
 TRUE = 1
}
t_bool;

typedef enum t_operation_enum
{
 ERROR = 0,
 SUCCESS = 1
}
t_operation;
#line 1 "d:/git/cigna-scoreboard/rx/source/hardware.h"






sbit pinDato at LATB7_Bit;
sbit pinClock at LATB6_Bit;
sbit pinLocali at LATC6_Bit;
sbit pinTempo at LATB4_Bit;
sbit pinOspiti at LATB5_Bit;
sbit pinClaxon at LATA1_Bit;

sbit pinDato_dir at TRISB7_Bit;
sbit pinClock_dir at TRISB6_Bit;
sbit pinLocali_dir at TRISC6_Bit;
sbit pinTempo_dir at TRISB4_Bit;
sbit pinOspiti_dir at TRISB5_Bit;
sbit pinClaxon_dir at TRISA1_Bit;

sbit NRF_CE at LATB3_Bit;
sbit NRF_CE_DIR at TRISB3_Bit;
sbit NRF_CSN at LATC2_Bit;
sbit NRF_CSN_DIR at TRISC2_Bit;
sbit NRF_IRQ at LATB0_Bit;
sbit NRF_IRQ_DIR at TRISB0_Bit;


sbit PIN_DBG_0 at LATA0_Bit;
sbit PIN_DBG_0_Dir at TRISA0_Bit;


typedef enum t_reset_reason_enum
{
 NormalReset,
 SelfReset,
 WDTReset,
 PowerDownReset,
 BrownOutReset

} t_reset_reason;



void hw_init();
void hw_int_enable();
void hw_int_disable();
t_reset_reason hw_get_reset_reason();



void hw_init()
{


 ANCON0 = 0xFF;
 ANCON1 = 0x1F;





 T1CON = 0b10001111;




 T0CON = 0b11010101;



 RCON.IPEN = 1;

 IPR1.TMR1IP =  1 ;
 PIR1.TMR1IF = 0;
 PIE1.TMR1IE = 1;

 INTCON2.TMR0IP =  0 ;
 INTCON.TMR0IF = 0;
 INTCON.TMR0IE = 1;


 Unlock_IOLOCK();
 PPS_Mapping_NoLock(4, _INPUT, _SDI2);
 PPS_Mapping_NoLock(5, _OUTPUT, _SCK2);
 PPS_Mapping_NoLock(18, _OUTPUT, _SDO2);
 Lock_IOLOCK();

 SPI_Remappable_Init_Advanced(
 _SPI_REMAPPABLE_MASTER_OSC_DIV16,
 _SPI_REMAPPABLE_DATA_SAMPLE_MIDDLE,
 _SPI_REMAPPABLE_CLK_IDLE_LOW,
 _SPI_REMAPPABLE_LOW_2_HIGH
 );


 PIN_DBG_0 = 0;
 PIN_DBG_0_Dir =  0 ;

}

void hw_int_enable()
{
 INTCON.GIEH = 1;
 INTCON.GIEL = 1;
}

void hw_int_disable()
{
 INTCON.GIEH = 0;
 INTCON.GIEL = 0;
}

t_reset_reason hw_get_reset_reason()
{
 if (! RCON.TO_) return WDTReset;
 if (! RCON.PD) return PowerDownReset;

 if (! RCON.RI)
 {
 RCON.RI = 1;
 return SelfReset;
 }

 if (! RCON.BOR)
 {
 RCON.BOR = 1;
 if (RCON.POR) return BrownOutReset;
 }

 if (! RCON.POR) RCON.POR = 1;
 return NormalReset;
}
#line 1 "d:/git/cigna-scoreboard/rx/source/nrf_cfg.h"
#line 1 "d:/git/cigna-scoreboard/rx/source/f_nrf24l01p.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 8 "d:/git/cigna-scoreboard/rx/source/f_nrf24l01p.h"
extern sbit NRF_CE;
extern sbit NRF_CE_DIR;
extern sbit NRF_CSN;
extern sbit NRF_CSN_DIR;
extern sbit NRF_IRQ;
extern sbit NRF_IRQ_DIR;

typedef struct
{
 uint8 rx_data_ready;
 uint8 tx_data_sent;
 uint8 max_retries_reached;
 uint8 available_pipe;
 uint8 tx_full;
 uint8 rx_empty;

} nrf_status;

typedef struct
{
 uint8 tx_reuse;
 uint8 tx_full;
 uint8 tx_empty;
 uint8 rx_full;
 uint8 rx_empty;

} nrf_fifo_status;
#line 139 "d:/git/cigna-scoreboard/rx/source/f_nrf24l01p.h"
uint8 ___nrf_send (uint8 value);
uint8 ___nrf_send_command (uint8 cmd, uint8 numbytes, uint8 * buffer);
uint8 ___nrf_read_command (uint8 cmd, uint8 numbytes, uint8 * buffer);


void nrf_init ();
uint8 nrf_set_interrupts (uint8 interrupts);
uint8 nrf_set_crc (uint8 crc);
uint8 nrf_set_power (uint8 power);
uint8 nrf_set_direction (uint8 direction);
uint8 nrf_enable_auto_acks (uint8 channels);
uint8 nrf_enable_data_pipes (uint8 channels);
uint8 nrf_set_address_width (uint8 numbytes);
uint8 nrf_set_retransmit_delay (uint8 delayPer250us);
uint8 nrf_set_max_retransmit (uint8 maxattempts);
uint8 nrf_set_channel (uint8 channel);
uint8 nrf_set_data_rate (uint8 datarate);
uint8 nrf_set_output_power (uint8 power);
uint8 nrf_get_status (nrf_status * dest);
uint8 nrf_get_current_retransmit_count ();
uint8 nrf_get_total_retransmit_count ();
uint8 nrf_signal_detected ();
uint8 nrf_set_rx_pipe (uint8 pipenum, uint8 num, uint8 * buffer, uint8 packet_size);
uint8 nrf_set_rx_address (uint8 pipenum, uint8 num, uint8 * buffer);
uint8 nrf_set_tx_address (uint8 num, uint8 * buffer);
uint8 nrf_set_payload_size (uint8 pipenum, uint8 size);
uint8 nrf_get_fifo_status (nrf_fifo_status * dest);
uint8 nrf_enable_dynamic_payload (uint8 channels);
uint8 nrf_enable_dynamic_payload_length (uint8 enable);
uint8 nrf_enable_ack_payload (uint8 enable);
uint8 nrf_enable_no_ack_command (uint8 enable);
uint8 nrf_test ();




uint8 nrf_read_payload (uint8 size, uint8 * buffer);
uint8 nrf_write_payload (uint8 size, uint8 * buffer);
uint8 nrf_flush_tx ();
uint8 nrf_flush_rx ();
uint8 nrf_reuse_tx_payload ();
uint8 nrf_clear_interrupts (uint8 interrupts);


void nrf_rx_start_listening ();
void nrf_rx_stop_listening ();
uint8 nrf_rx_packet_ready ();
uint8 nrf_rx_get_sender_pipe ();



uint8 nrf_tx_send_packet (uint8 size, uint8 * buffer, uint8 wait);
uint8 nrf_tx_send_current (uint8 wait);
uint8 nrf_tx_packet_sent ();
uint8 nrf_tx_packet_failed ();





void nrf_init()
{
 NRF_IRQ_DIR = 1;

 NRF_CE = 0;
 NRF_CE_DIR = 0;

 NRF_CSN = 1;
 NRF_CSN_DIR = 0;

  Delay_ms(120) ;
 nrf_set_power( 0 );
 nrf_flush_tx();
 nrf_flush_rx();
}

uint8 nrf_tx_send_packet(uint8 size, uint8 * buffer, uint8 wait)
{
 nrf_write_payload(size, buffer);
 return nrf_tx_send_current(wait);
}

uint8 nrf_tx_send_current(uint8 wait)
{
 uint8 status;

  { NRF_CE = 1; Delay_us(12) ; NRF_CE = 0; } ;
 if (! wait) return 1;

 while (1)
 {
 status = ___nrf_read_command( 0b11111111 , 0, 0);
 if (status.B5)
 {
 nrf_clear_interrupts( 0b010 );
 status = 1;
 break;
 }
 if (status.B4)
 {
 nrf_clear_interrupts( 0b100 );
 status = 0;
 break;
 }
 }
 return status;
}

uint8 nrf_tx_packet_failed()
{
 uint8 status = ___nrf_read_command( 0b11111111 , 0, 0);
 if (status.B4)
 {
 nrf_clear_interrupts( 0b100 );
 return 1;
 }
 return 0;
}

uint8 nrf_tx_packet_sent()
{
 uint8 status = ___nrf_read_command( 0b11111111 , 0, 0);
 if (status.B5)
 {
 nrf_clear_interrupts( 0b010 );
 return 1;
 }
 return 0;
}

uint8 nrf_rx_get_sender_pipe()
{
 return ((___nrf_read_command( 0b11111111 , 0, 0) & 0b00001110) >> 1);
}

uint8 nrf_rx_packet_ready()
{
 uint8 fifo = 0;
 ___nrf_read_command( 0b00000000  |  0x17 , 1, &fifo);
 return (! fifo.B0);
}

void nrf_rx_start_listening()
{
  { NRF_CE = 1; Delay_us(6) ; } ;
  Delay_us(150) ;
}

void nrf_rx_stop_listening()
{
  { NRF_CE = 0; } ;
}

uint8 nrf_set_rx_pipe(uint8 pipenum, uint8 num, uint8 * buffer, uint8 packet_size)
{
 nrf_set_rx_address(pipenum, num, buffer);
 return nrf_set_payload_size(pipenum, packet_size);
}

uint8 nrf_clear_interrupts(uint8 interrupts)
{
 uint8 actual = ___nrf_read_command( 0b11111111 , 0, 0);

 actual.B6 = (interrupts &  0b001  ? 1 : 0);
 actual.B5 = (interrupts &  0b010  ? 1 : 0);
 actual.B4 = (interrupts &  0b100  ? 1 : 0);

 return ___nrf_send_command( 0b00100000  |  0x07 , 1, &actual);
}

uint8 nrf_reuse_tx_payload()
{
 return ___nrf_send_command( 0b11100011 , 0, 0);
}

uint8 nrf_flush_rx()
{
 return ___nrf_send_command( 0b11100010 , 0, 0);
}

uint8 nrf_flush_tx()
{
 return ___nrf_send_command( 0b11100001 , 0, 0);
}

uint8 nrf_write_payload(uint8 size, uint8 * buffer)
{
 uint8 i, status;
 if (size < 1) size = 1;
 if (size > 32) size = 32;

  { NRF_CSN = 0; Delay_us(10) ; } ;
 status = ___nrf_send( 0b10100000 );
 for (i = 0; i < size; i ++) ___nrf_send(buffer[i]);
  { Delay_us(10) ; NRF_CSN = 1; } ;

 return status;
}

uint8 nrf_read_payload(uint8 size, uint8 * buffer)
{
 uint8 i;
  { NRF_CSN = 0; Delay_us(10) ; } ;
 if (size ==  0  || size > 32)
 {
 ___nrf_send( 0b01100000 );
 size = ___nrf_send( 0b11111111 );

 if (size > 32)
 {
 ___nrf_send( 0b11100010 );
  { Delay_us(10) ; NRF_CSN = 1; } ;
 return 0;
 }
 }

 ___nrf_send( 0b01100001 );
 for (i = 0; i < size; i ++)
 buffer[i] = ___nrf_send( 0b11111111 );

  { Delay_us(10) ; NRF_CSN = 1; } ;
 return size;
}

uint8 nrf_enable_no_ack_command(uint8 enable)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x1D , 1, &actual);
 actual.B0 = enable ? 1 : 0;
 return ___nrf_send_command( 0b00100000  |  0x1D , 1, &actual);
}

uint8 nrf_enable_ack_payload(uint8 enable)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x1D , 1, &actual);
 actual.B1 = enable ? 1 : 0;
 return ___nrf_send_command( 0b00100000  |  0x1D , 1, &actual);
}

uint8 nrf_enable_dynamic_payload_length(uint8 enable)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x1D , 1, &actual);
 actual.B2 = enable ? 1 : 0;
 return ___nrf_send_command( 0b00100000  |  0x1D , 1, &actual);
}

uint8 nrf_enable_dynamic_payload(uint8 channels)
{
 channels &= 0b00111111;
 return ___nrf_send_command( 0b00100000  |  0x1C , 1, &channels);
}

uint8 nrf_get_fifo_status(nrf_fifo_status * dest)
{
 uint8 fstat = 0;
 ___nrf_read_command( 0b00000000  |  0x17 , 1, &fstat);

 if (dest)
 {
 dest -> tx_reuse = fstat.B6;
 dest -> tx_full = fstat.B5;
 dest -> tx_empty = fstat.B4;
 dest -> rx_full = fstat.B1;
 dest -> rx_empty = fstat.B0;
 }
 return fstat;
}

uint8 nrf_set_payload_size(uint8 pipenum, uint8 size)
{
 if (pipenum > 5) pipenum = 5;
 if (size < 1) size = 1;
 if (size > 32) size = 32;

 size &= 0b00111111;
 return ___nrf_send_command( 0b00100000  | ( 0x11  + pipenum), 1, &size);
}

uint8 nrf_set_tx_address(uint8 num, uint8 * buffer)
{
 if (num < 3) num = 3;
 if (num > 5) num = 5;
 return ___nrf_send_command( 0b00100000  |  0x10 , num, buffer);
}

uint8 nrf_set_rx_address(uint8 pipenum, uint8 num, uint8 * buffer)
{
 if (pipenum > 5) pipenum = 5;
 if (pipenum < 2)
 {
 if (num < 3) num = 3;
 if (num > 5) num = 5;
 }
 else num = 1;

 return ___nrf_send_command( 0b00100000  | ( 0x0A  + pipenum), num, buffer);
}

uint8 nrf_signal_detected()
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x09 , 1, &actual);
 return actual.B0;
}

uint8 nrf_get_total_retransmit_count()
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x08 , 1, &actual);
 return actual >> 4;
}

uint8 nrf_get_current_retransmit_count()
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x08 , 1, &actual);
 return actual & 0b00001111;
}

uint8 nrf_get_status(nrf_status * dest)
{
 uint8 status = ___nrf_read_command( 0b11111111 , 0, 0);

 if (dest)
 {
 dest -> rx_data_ready = status.B6;
 dest -> tx_data_sent = status.B5;
 dest -> max_retries_reached = status.B4;

 dest -> available_pipe = (status & 0b00001110) >> 1;
 dest -> tx_full = status.B0;
 dest -> rx_empty = (dest -> available_pipe == 0b111 ? 1 : 0);
 }
 return status;
}

uint8 nrf_set_output_power(uint8 power)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x06 , 1, &actual);

 switch (power)
 {
 case  0b00 :
 actual.B2 = 1;
 actual.B1 = 1;
 break;

 case  0b01 :
 actual.B2 = 1;
 actual.B1 = 0;
 break;

 case  0b10 :
 actual.B2 = 0;
 actual.B1 = 1;
 break;

 default:
 actual.B2 = 0;
 actual.B1 = 0;
 }

 return ___nrf_send_command( 0b00100000  |  0x06 , 1, &actual);
}

uint8 nrf_set_data_rate(uint8 datarate)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x06 , 1, &actual);

 switch (datarate)
 {
 case  0b10 :
 actual.B3 = 1;
 actual.B5 = 0;
 break;

 case  0b01 :
 actual.B3 = 0;
 actual.B5 = 0;
 break;

 default:
 actual.B3 = 0;
 actual.B5 = 1;
 }

 return ___nrf_send_command( 0b00100000  |  0x06 , 1, &actual);
}

uint8 nrf_set_channel(uint8 channel)
{
 if (channel > 127) channel = 127;
 channel &= 0b01111111;
 return ___nrf_send_command( 0b00100000  |  0x05 , 1, &channel);
}

uint8 nrf_set_max_retransmit(uint8 maxattempts)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x04 , 1, &actual);

 actual &= 0b11110000;
 if (maxattempts > 15) maxattempts = 15;
 actual |= maxattempts;

 return ___nrf_send_command( 0b00100000  |  0x04 , 1, &actual);
}

uint8 nrf_set_retransmit_delay(uint8 delayPer250us)
{
 uint8 actual = 0;

 if (delayPer250us < 1) delayPer250us = 1;
 if (delayPer250us > 16) delayPer250us = 16;

 ___nrf_read_command( 0b00000000  |  0x04 , 1, &actual);

 actual &= 0b00001111;
 actual |= ((delayPer250us - 1) << 4);

 return ___nrf_send_command( 0b00100000  |  0x04 , 1, &actual);
}

uint8 nrf_set_address_width(uint8 numbytes)
{
 if (numbytes < 3) numbytes = 3;
 if (numbytes > 5) numbytes = 5;

 numbytes = ((numbytes - 2) & 0b00000011);
 return ___nrf_send_command( 0b00100000  |  0x03 , 1, &numbytes);
}

uint8 nrf_enable_data_pipes(uint8 channels)
{
 channels &= 0b00111111;
 return ___nrf_send_command( 0b00100000  |  0x02 , 1, &channels);
}

uint8 nrf_enable_auto_acks(uint8 channels)
{
 channels &= 0b00111111;
 return ___nrf_send_command( 0b00100000  |  0x01 , 1, &channels);
}

uint8 nrf_set_direction(uint8 direction)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x00 , 1, &actual);
 actual.B0 = (direction ? 1 : 0);
 return ___nrf_send_command( 0b00100000  |  0x00 , 1, &actual);
}

uint8 nrf_set_power(uint8 power)
{
 uint8 actual = 0;
 uint8 result;

  { NRF_CE = 0; } ;

 ___nrf_read_command( 0b00000000  |  0x00 , 1, &actual);
 actual.B1 = (power ? 1 : 0);
 result = ___nrf_send_command( 0b00100000  |  0x00 , 1, &actual);
 if (power)  Delay_ms(5) ;
 else  Delay_us(100) ;
 return result;
}

uint8 nrf_set_crc(uint8 crc)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x00 , 1, &actual);

 if (crc &  0b001 ) actual.B3 = 0;
 else if (crc &  0b010 ) { actual.B3 = 1; actual.B2 = 0; }
 else { actual.B3 = 1; actual.B2 = 1; }

 return ___nrf_send_command( 0b00100000  |  0x00 , 1, &actual);
}

uint8 nrf_set_interrupts(uint8 interrupts)
{
 uint8 actual = 0;
 ___nrf_read_command( 0b00000000  |  0x00 , 1, &actual);

 actual.B6 = (interrupts &  0b001 ) ? 0 : 1;
 actual.B5 = (interrupts &  0b010 ) ? 0 : 1;
 actual.B4 = (interrupts &  0b100 ) ? 0 : 1;

 return ___nrf_send_command( 0b00100000  |  0x00 , 1, &actual);
}

uint8 ___nrf_send_command(uint8 cmd, uint8 numbytes, uint8 * buffer)
{
 uint8 status, i;

  { NRF_CSN = 0; Delay_us(10) ; } ;
 status = ___nrf_send(cmd);

 for (i = 0; i < numbytes; i ++)
 ___nrf_send(buffer[i]);

  { Delay_us(10) ; NRF_CSN = 1; } ;

 return status;
}

uint8 ___nrf_read_command(uint8 cmd, uint8 numbytes, uint8 * buffer)
{
 uint8 status, i;

  { NRF_CSN = 0; Delay_us(10) ; } ;
 status = ___nrf_send(cmd);

 for (i = 0; i < numbytes; i ++)
 buffer[i] = ___nrf_send( 0b11111111 );

  { Delay_us(10) ; NRF_CSN = 1; } ;

 return status;
}

uint8 ___nrf_send(uint8 value)
{
 uint8 result =  SPI_Remappable_Read (value);
  Delay_us(10) ;
 return result;
}

uint8 nrf_test()
{
 uint8 prev, res, new;


 ___nrf_read_command( 0b00000000  |  0x05 , 1, &prev);


 new = (~ res) & 0b01111111;
 ___nrf_send_command( 0b00100000  |  0x05 , 1, &new);


 ___nrf_read_command( 0b00000000  |  0x05 , 1, &res);
 res = (res == new ? 1 : 0);


 ___nrf_send_command( 0b00100000  |  0x05 , 1, &prev);

 return res;
}
#line 1 "d:/git/cigna-scoreboard/rx/source/18f27j53_eepromemulation.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 19 "d:/git/cigna-scoreboard/rx/source/18f27j53_eepromemulation.h"
void emu_eeprom_init ();
void emu_eeprom_load ();
void emu_eeprom_commit ();
void emu_eeprom_wr (uint16 address, uint8 byte_data, uint8 commit_change);
uint8 emu_eeprom_rd (uint16 address);

const int16 ___EMU_EEPROM_SIZE = 1024;
const int32 ___EMU_EEPROM_START_ADDRESS = 0x10000;

uint8 ___EMU_EEPROM_MEM [___EMU_EEPROM_SIZE];

code uint8 ___EMU_EEPROM_RESERVED[___EMU_EEPROM_SIZE] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
absolute ___EMU_EEPROM_START_ADDRESS;

void emu_eeprom_init()
{
 uint8 c;

 c = ___EMU_EEPROM_RESERVED[0];
 while (c.B0) c --;
 c = ___EMU_EEPROM_MEM[0];
 while (c.B0) c --;

 emu_eeprom_load();
}

void emu_eeprom_load()
{
 FLASH_Read_N_Bytes(___EMU_EEPROM_START_ADDRESS, ___EMU_EEPROM_MEM, ___EMU_EEPROM_SIZE);
}

void emu_eeprom_save()
{
 FLASH_Erase_Write_1024(___EMU_EEPROM_START_ADDRESS, ___EMU_EEPROM_MEM);
}

void emu_eeprom_wr(uint16 address, uint8 byte_data, uint8 commit_change)
{
 ___EMU_EEPROM_MEM[address] = byte_data;

 if (commit_change)
 emu_eeprom_save();
}

uint8 emu_eeprom_rd(uint16 address)
{
 return ___EMU_EEPROM_MEM[address];
}
#line 1 "d:/git/cigna-scoreboard/rx/source/inneradt.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 10 "d:/git/cigna-scoreboard/rx/source/inneradt.h"
const int16 TEAMS_MAX_POINTS = 199;
const int16 TEAMS_MAX_SETS = 9;
const int16 TEAMS_MAX_TIME = (99*60);



typedef struct t_timespanStruct
{
 uint8 min;
 uint8 sec;

} t_timespan;

typedef struct t_teamdataStruct
{
 uint8 points;
 uint8 sets;

 uint8 flags;





} t_teamdata;

typedef enum t_lightflags
{
 lfP7F = 1,
 lfP1 = 2,
 lfP2 = 4

} t_lightflags;

typedef struct t_tab_data_struct
{
 t_teamdata locals;
 t_teamdata guests;
 t_timespan time;

} t_tab_data;



void tabdata_new (t_tab_data* instance);


void tabdata_clear_time (t_tab_data* instance);
void tabdata_clear_team (t_teamdata* instance);

void tabdata_add_sec (t_timespan* instance, int8 toAdd);
void tabdata_add_min (t_timespan* instance, int8 toAdd);
short tabdata_time_is_not_null (t_timespan* instance);

void tabdata_add_points (t_teamdata* instance, int8 toAdd);
void tabdata_add_sets (t_teamdata* instance, int8 toAdd);
void tabdata_toggle_flag (t_teamdata* instance, t_lightflags flag);
void tabdata_add_pp (t_teamdata* instance);
void tabdata_sub_pp (t_teamdata* instance);
void tabdata_add_flag_seq (t_teamdata* instance);
void tabdata_sub_flag_seq (t_teamdata* instance);
void tabdata_swap (t_tab_data* instance);



void tabdata_new(t_tab_data* instance)
{
 tabdata_clear_time(instance);
 tabdata_clear_team(&(instance -> locals));
 tabdata_clear_team(&(instance -> guests));
}

void tabdata_clear_time(t_tab_data* instance)
{
 instance -> time.min = 0;
 instance -> time.sec = 0;
}

void tabdata_clear_team(t_teamdata* instance)
{
 instance -> points = 0;
 instance -> sets = 0;
 instance -> flags = 0;
}

void tabdata_add_sec(t_timespan* instance, int8 toAdd)
{
 int16 act_timespan;
 act_timespan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);

 if (toAdd > 0)
 {
 if (act_timespan == TEAMS_MAX_TIME) act_timespan = 0;
 else
 {
 act_timespan += toAdd;
 if (act_timespan > TEAMS_MAX_TIME) act_timespan = TEAMS_MAX_TIME;
 }
 }
 else
 {
 if (act_timespan == 0) act_timespan = TEAMS_MAX_TIME;
 else
 {
 act_timespan += toAdd;
 if (act_timespan < 0) act_timespan = 0;
 }
 }

 instance -> min = act_timespan / 60;
 instance -> sec = act_timespan % 60;
}

void tabdata_add_min(t_timespan* instance, int8 toAdd)
{
 int16 act_timespan;
 act_timespan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);

 if (toAdd > 0)
 {
 if (act_timespan == TEAMS_MAX_TIME) act_timespan = 0;
 else
 {
 act_timespan += toAdd * 60;
 if (act_timespan > TEAMS_MAX_TIME) act_timespan = TEAMS_MAX_TIME;
 }
 }
 else
 {
 if (act_timespan == 0) act_timespan = TEAMS_MAX_TIME;
 else
 {
 act_timespan += toAdd * 60;
 if (act_timespan < 0) act_timespan = 0;
 }
 }

 instance -> min = act_timespan / 60;
 instance -> sec = act_timespan % 60;
}

int8 tabdata_time_is_not_null(t_timespan* instance)
{
 return ((instance -> min > 0) || (instance -> sec > 0));
}

void tabdata_add_points(t_teamdata* instance, int8 toAdd)
{
 int16 newPoints = (int16)(instance -> points);

 if (toAdd > 0)
 {
 if (newPoints == TEAMS_MAX_POINTS) newPoints = 0;
 else
 {
 newPoints += toAdd;
 if (newPoints > TEAMS_MAX_POINTS) newPoints = TEAMS_MAX_POINTS;
 }
 }
 else
 {
 if (newPoints == 0) newPoints = TEAMS_MAX_POINTS;
 else
 {
 newPoints += toAdd;
 if (newPoints < 0) newPoints = 0;
 }
 }

 instance -> points =  ((char *)&newPoints)[0] ;
}

void tabdata_add_sets(t_teamdata* instance, int8 toAdd)
{
 int16 newSets = (int16)(instance -> sets);

 if (toAdd > 0)
 {
 if (newSets == TEAMS_MAX_SETS) newSets = 0;
 else
 {
 newSets += toAdd;
 if (newSets > TEAMS_MAX_SETS) newSets = TEAMS_MAX_SETS;
 }
 }
 else
 {
 if (newSets == 0) newSets = TEAMS_MAX_SETS;
 else
 {
 newSets += toAdd;
 if (newSets < 0) newSets = 0;
 }
 }

 instance -> sets =  ((char *)&newSets)[0] ;
}

void tabdata_toggle_flag(t_teamdata* instance, t_lightflags flag)
{
 if (instance -> flags & flag) instance -> flags -= flag;
 else instance -> flags |= flag;
}

void tabdata_swap(t_tab_data* instance)
{
 t_teamdata swapInst;
 swapInst.points = instance -> locals -> points;
 swapInst.sets = instance -> locals -> sets;
 swapInst.flags = instance -> locals -> flags;

 instance -> locals.points = instance -> guests -> points;
 instance -> locals.sets = instance -> guests -> sets;
 instance -> locals.flags = instance -> guests -> flags;

 instance -> guests.points = swapInst.points;
 instance -> guests.sets = swapInst.sets;
 instance -> guests.flags = swapInst.flags;
}

void tabdata_add_pp(t_teamdata* instance)
{
 if (instance -> points < 15)
 instance -> points = 15;
 else if (instance -> points < 30)
 instance -> points = 30;
 else if (instance -> points < 40)
 instance -> points = 40;
 else
 {
 instance -> points = 0;
 tabdata_add_sets(instance, 1);
 }
}

void tabdata_sub_pp(t_teamdata* instance)
{
 if (instance -> points == 0)
 {
 tabdata_add_sets(instance, -1);
 instance -> points = 40;
 }
 else if (instance -> points < 15)
 instance -> points = 0;
 else if (instance -> points == 15)
 instance -> points = 0;
 else if (instance -> points <= 30)
 instance -> points = 15;
 else
 instance -> points = 30;
}

void tabdata_add_flag_seq(t_teamdata* instance)
{
 if (instance ->  flags.B2 )
 {
 instance ->  flags.B1  = 0;
 instance ->  flags.B2  = 0;
 instance ->  flags.B0  = 0;
 }
 else if (instance ->  flags.B1 ) instance ->  flags.B2  = 1;
 else if (instance ->  flags.B0 ) instance ->  flags.B1  = 1;
 else instance ->  flags.B0  = 1;
}

void tabdata_sub_flag_seq(t_teamdata* instance)
{
 if (instance ->  flags.B2 ) instance ->  flags.B2  = 0;
 else if (instance ->  flags.B1 ) instance ->  flags.B1  = 0;
 else if (instance ->  flags.B0 ) instance ->  flags.B0  = 0;
 else
 {
 instance ->  flags.B1  = 1;
 instance ->  flags.B2  = 1;
 instance ->  flags.B0  = 1;
 }
}
#line 1 "d:/git/cigna-scoreboard/rx/source/config.h"
#line 12 "d:/git/cigna-scoreboard/rx/source/config.h"
typedef struct t_config_struct
{
 uint8 persistentFlags0;



} t_config;

typedef t_config * t_configInstance;



void config_new (t_configInstance instance);
void config_save (t_configInstance instance);
int8 config_load (t_configInstance instance);



void config_new(t_configInstance instance)
{
 instance -> persistentFlags0 = 0;
}

void config_save(t_configInstance instance)
{
 emu_eeprom_wr( 0x0010 , instance -> persistentFlags0,  0 );
 emu_eeprom_wr( 0x0000 ,  18 ,  1 );
}

short config_load(t_configInstance instance)
{
 if (emu_eeprom_rd( 0x0000 ) !=  18 ) return 0;
 instance -> persistentFlags0 = emu_eeprom_rd( 0x0010 );
 return 1;
}
#line 1 "d:/git/cigna-scoreboard/rx/source/flags.h"





typedef struct t_flags_struct
{
 uint8 flags0;








} t_flags;

typedef t_flags * t_flagsInstance;



typedef enum t_changed_flags_enum
{
 tcfNone = 0,
 tcfLocals = 1,
 tcfGuests = 2,
 tcfTime = 4,
 tcfAll = 7

} t_changed_flags;

typedef enum t_action_enum
{
 taNone = 0,
 taNotifyClaxon = 1,
 taTryClaxon = 2,
 taTimeEnded = 4,
 taClear = 8

} t_action;



void flags_new(t_flagsInstance instance);



void flags_new(t_flagsInstance instance)
{
 instance -> flags0 = 0;
}
#line 1 "d:/git/cigna-scoreboard/rx/source/datamgr.h"
#line 62 "d:/git/cigna-scoreboard/rx/source/datamgr.h"
typedef uint8 t_cmd;
typedef t_changed_flags t_cmdfnc;
typedef t_cmdfnc(*t_cmdfnc_ptr)();



t_cmdfnc ApplyCmd(t_cmd cmd);

t_cmdfnc CmdApply_None ();
t_cmdfnc CmdApply_INC_PT_LOC ();
t_cmdfnc CmdApply_INC_PLLP_LOC ();
t_cmdfnc CmdApply_DEC_PT_LOC ();
t_cmdfnc CmdApply_DEC_PLLP_LOC ();
t_cmdfnc CmdApply_INC_PT_OSP ();
t_cmdfnc CmdApply_INC_PLLP_OSP ();
t_cmdfnc CmdApply_DEC_PT_OSP ();
t_cmdfnc CmdApply_DEC_PLLP_OSP ();
t_cmdfnc CmdApply_INC_SET_LOC ();
t_cmdfnc CmdApply_DEC_SET_LOC ();
t_cmdfnc CmdApply_INC_SET_OSP ();
t_cmdfnc CmdApply_DEC_SET_OSP ();
t_cmdfnc CmdApply_INC_LED_LOC ();
t_cmdfnc CmdApply_DEC_LED_LOC ();
t_cmdfnc CmdApply_INC_LED_OSP ();
t_cmdfnc CmdApply_DEC_LED_OSP ();
t_cmdfnc CmdApply_START ();
t_cmdfnc CmdApply_DEBUG_MODE ();
t_cmdfnc CmdApply_PAUSE ();
t_cmdfnc CmdApply_STANDBY_TELC ();
t_cmdfnc CmdApply_TIME_RESET ();
t_cmdfnc CmdApply_CHANNEL_TEST ();
t_cmdfnc CmdApply_TIME_SET ();
t_cmdfnc CmdApply_CLAXON_ALT ();
t_cmdfnc CmdApply_RES_PT_LOC ();
t_cmdfnc CmdApply_RESET ();
t_cmdfnc CmdApply_RES_PT_OSP ();
t_cmdfnc CmdApply_HARD_RESET ();
t_cmdfnc CmdApply_STANDBY ();
t_cmdfnc CmdApply_SALVASCHERMO ();
t_cmdfnc CmdApply_INVERTI ();
t_cmdfnc CmdApply_CLAXON ();
t_cmdfnc CmdApply_PROVA_CLAXON ();
t_cmdfnc CmdApply_AUM_10M ();
t_cmdfnc CmdApply_DIM_10M ();
t_cmdfnc CmdApply_AUM_1M ();
t_cmdfnc CmdApply_DIM_1M ();
t_cmdfnc CmdApply_AUM_10S ();
t_cmdfnc CmdApply_DIM_10S ();
t_cmdfnc CmdApply_AUM_1S ();
t_cmdfnc CmdApply_DIM_1S ();
t_cmdfnc CmdApply_7F_LOC ();
t_cmdfnc CmdApply_7F_OSP ();
t_cmdfnc CmdApply_P1_LOC ();
t_cmdfnc CmdApply_P1_OSP ();
t_cmdfnc CmdApply_P2_LOC ();
t_cmdfnc CmdApply_P2_OSP ();

t_cmdfnc_ptr ___datamgr_function_array[] =
{
 CmdApply_None,
 CmdApply_None,
 CmdApply_INC_PT_LOC,
 CmdApply_INC_PLLP_LOC,
 CmdApply_DEC_PT_LOC,
 CmdApply_DEC_PLLP_LOC,
 CmdApply_INC_PT_OSP,
 CmdApply_INC_PLLP_OSP,
 CmdApply_DEC_PT_OSP,
 CmdApply_DEC_PLLP_OSP,
 CmdApply_INC_SET_LOC,
 CmdApply_None,
 CmdApply_DEC_SET_LOC,
 CmdApply_None,
 CmdApply_INC_SET_OSP,
 CmdApply_None,
 CmdApply_DEC_SET_OSP,
 CmdApply_None,
 CmdApply_INC_LED_LOC,
 CmdApply_None,
 CmdApply_DEC_LED_LOC,
 CmdApply_None,
 CmdApply_INC_LED_OSP,
 CmdApply_None,
 CmdApply_DEC_LED_OSP,
 CmdApply_None,
 CmdApply_START,
 CmdApply_DEBUG_MODE,
 CmdApply_PAUSE,
 CmdApply_STANDBY_TELC,
 CmdApply_TIME_RESET,
 CmdApply_CHANNEL_TEST,
 CmdApply_TIME_SET,
 CmdApply_CLAXON_ALT,
 CmdApply_RES_PT_LOC,
 CmdApply_RESET,
 CmdApply_RES_PT_OSP,
 CmdApply_HARD_RESET,
 CmdApply_STANDBY,
 CmdApply_SALVASCHERMO,
 CmdApply_INVERTI,
 CmdApply_None,
 CmdApply_CLAXON,
 CmdApply_PROVA_CLAXON,
 CmdApply_AUM_10M,
 CmdApply_DIM_10M,
 CmdApply_AUM_1M,
 CmdApply_DIM_1M,
 CmdApply_AUM_10S,
 CmdApply_DIM_10S,
 CmdApply_AUM_1S,
 CmdApply_DIM_1S,
 CmdApply_7F_LOC,
 CmdApply_None,
 CmdApply_7F_OSP,
 CmdApply_None,
 CmdApply_P1_LOC,
 CmdApply_None,
 CmdApply_P1_OSP,
 CmdApply_None,
 CmdApply_P2_LOC,
 CmdApply_None,
 CmdApply_P2_OSP,
 CmdApply_None
};
#line 1 "d:/git/cigna-scoreboard/rx/source/radioadt.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 10 "d:/git/cigna-scoreboard/rx/source/radioadt.h"
const uint8 NRF_PACKET_NUM_CMD_BYTES =  3 ;
const uint8 NRF_PACKET_NUM_ID_BYTES =  4 ;



typedef struct t_nrf_packet_Struct
{
 uint8 raw_cmd_bytes[NRF_PACKET_NUM_CMD_BYTES];
 t_cmd cmd;
 uint8 id_bytes[NRF_PACKET_NUM_ID_BYTES];

} t_nrf_packet;



void nrfpacket_from_raw_buffer (t_nrf_packet* instance, uint8* buffer);
uint8 nrfpacket_compare_id (t_nrf_packet* instance, uint8* id);
void nrfpacket_copy_id (t_nrf_packet* instance, uint8* dest_id);



void nrfpacket_from_raw_buffer(t_nrf_packet* instance, uint8* buffer)
{

 memcpy(&(instance -> id_bytes), buffer, NRF_PACKET_NUM_ID_BYTES);
 memcpy(&(instance -> raw_cmd_bytes), buffer + NRF_PACKET_NUM_ID_BYTES, NRF_PACKET_NUM_CMD_BYTES);


 if (buffer[NRF_PACKET_NUM_ID_BYTES] == buffer[NRF_PACKET_NUM_ID_BYTES + 1] ||
 buffer[NRF_PACKET_NUM_ID_BYTES] == buffer[NRF_PACKET_NUM_ID_BYTES + 2])
 {
 instance -> cmd = buffer[NRF_PACKET_NUM_ID_BYTES];
 }
 else if (buffer[NRF_PACKET_NUM_ID_BYTES + 1] == buffer[NRF_PACKET_NUM_ID_BYTES + 2])
 {
 instance -> cmd = buffer[NRF_PACKET_NUM_ID_BYTES];
 }
 else
 instance -> cmd =  0 ;
}

uint8 nrfpacket_compare_id(t_nrf_packet* instance, uint8* compare_id)
{
 uint8 i;
 for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
 {
 if (instance -> id_bytes[i] != compare_id[i]) return 0;
 }
 return 1;
}

void nrfpacket_copy_id(t_nrf_packet* instance, uint8* dest_id)
{
 uint8 i;
 for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
 dest_id[i] = instance -> id_bytes[i];
}
#line 1 "d:/git/cigna-scoreboard/rx/source/datainstances.h"





t_config configuration;
t_flags flags;
t_tab_data tab_data;

t_reset_reason whyRestarted;

t_changed_flags whatsChanged;
t_action pendingActions;
uint8 ClockTicksPending;
t_cmd CmdPending;
t_nrf_packet packet;
uint8 packet_last_id_bytes[ 4 ];

uint16 SyncedDelayCounter;



void variables_init ();



void variables_init()
{
 tabdata_new(&tab_data);
 flags_new(&flags);
 config_new(&configuration);

 whatsChanged = tcfAll;
 whyRestarted = hw_get_reset_reason();
 ClockTicksPending = 0;
 CmdPending =  0 ;
 pendingActions = taNone;
 SyncedDelayCounter = 0;
}
#line 1 "d:/git/cigna-scoreboard/rx/source/datamgrroutines.h"





t_cmdfnc ApplyCmd(t_cmd cmd)
{
 t_cmdfnc_ptr fptr;
 if (cmd > 63) return tcfNone;
 fptr = ___datamgr_function_array[cmd];
 return fptr();
}

t_cmdfnc CmdApply_None ()
{
 return tcfNone;
}

t_cmdfnc CmdApply_INC_PT_LOC ()
{
 if (flags. flags0.B1 ) return CmdApply_AUM_10M();
 tabdata_add_points(&(tab_data.locals), 1);
 return tcfLocals;
}
t_cmdfnc CmdApply_INC_PLLP_LOC ()
{
 tabdata_add_pp(&(tab_data.locals));
 return tcfLocals;
}
t_cmdfnc CmdApply_DEC_PT_LOC ()
{
 if (flags. flags0.B1 ) return CmdApply_DIM_10M();
 tabdata_add_points(&(tab_data.locals), -1);
 return tcfLocals;
}
t_cmdfnc CmdApply_DEC_PLLP_LOC ()
{
 tabdata_sub_pp(&(tab_data.locals));
 return tcfLocals;
}
t_cmdfnc CmdApply_INC_PT_OSP ()
{
 if (flags. flags0.B1 ) return CmdApply_AUM_1S();
 tabdata_add_points(&(tab_data.guests), 1);
 return tcfGuests;
}
t_cmdfnc CmdApply_INC_PLLP_OSP ()
{
 tabdata_add_pp(&(tab_data.guests));
 return tcfGuests;
}
t_cmdfnc CmdApply_DEC_PT_OSP ()
{
 if (flags. flags0.B1 ) return CmdApply_DIM_1S();
 tabdata_add_points(&(tab_data.guests), -1);
 return tcfGuests;
}
t_cmdfnc CmdApply_DEC_PLLP_OSP ()
{
 tabdata_sub_pp(&(tab_data.guests));
 return tcfGuests;
}
t_cmdfnc CmdApply_INC_SET_LOC ()
{
 if (flags. flags0.B1 ) return CmdApply_AUM_1M();
 tabdata_add_sets(&(tab_data.locals), 1);
 return tcfLocals;
}
t_cmdfnc CmdApply_DEC_SET_LOC ()
{
 if (flags. flags0.B1 ) return CmdApply_DIM_1M();
 tabdata_add_sets(&(tab_data.locals), -1);
 return tcfLocals;
}
t_cmdfnc CmdApply_INC_SET_OSP ()
{
 if (flags. flags0.B1 ) return CmdApply_AUM_10S();
 tabdata_add_sets(&(tab_data.guests), 1);
 return tcfGuests;
}
t_cmdfnc CmdApply_DEC_SET_OSP ()
{
 if (flags. flags0.B1 ) return CmdApply_DIM_10S();
 tabdata_add_sets(&(tab_data.guests), -1);
 return tcfGuests;
}
t_cmdfnc CmdApply_INC_LED_LOC ()
{
 tabdata_add_flag_seq(&(tab_data.locals));
 return tcfLocals;
}
t_cmdfnc CmdApply_DEC_LED_LOC ()
{
 tabdata_sub_flag_seq(&(tab_data.locals));
 return tcfLocals;
}
t_cmdfnc CmdApply_INC_LED_OSP ()
{
 tabdata_add_flag_seq(&(tab_data.guests));
 return tcfGuests;
}
t_cmdfnc CmdApply_DEC_LED_OSP ()
{
 tabdata_sub_flag_seq(&(tab_data.guests));
 return tcfGuests;
}
t_cmdfnc CmdApply_START ()
{
 if (flags. flags0.B1 )
 flags. flags0.B1  = 0;

 if (tabdata_time_is_not_null(&(tab_data.time)))
 flags. flags0.B0  = 1;

 return tcfTime;
}
t_cmdfnc CmdApply_PAUSE ()
{
 if (flags. flags0.B1 ) return tcfNone;
 flags. flags0.B0  = 0;
 return tcfTime;
}
t_cmdfnc CmdApply_TIME_RESET ()
{
 flags. flags0.B0  = 0;
 tabdata_clear_time(&tab_data);

 return tcfTime;
}
t_cmdfnc CmdApply_TIME_SET ()
{
 if (flags. flags0.B1 )
 flags. flags0.B1  = 0;
 else
 {
 flags. flags0.B0  = 0;
 flags. flags0.B1  = 1;
 }
 return tcfTime;
}
t_cmdfnc CmdApply_RES_PT_LOC ()
{
 tabdata_clear_team(&(tab_data.locals));
 return tcfLocals;
}
t_cmdfnc CmdApply_RES_PT_OSP ()
{
 tabdata_clear_team(&(tab_data.guests));
 return tcfGuests;
}
t_cmdfnc CmdApply_RESET ()
{
 if (flags. flags0.B1 ) return tcfNone;

 flags. flags0.B0  = 0;
  tabdata_new(&tab_data); ;

 return tcfAll;
}
t_cmdfnc CmdApply_HARD_RESET ()
{
 asm RESET;
 return tcfAll;
}
t_cmdfnc CmdApply_SALVASCHERMO ()
{
 return CmdApply_STANDBY();
}
t_cmdfnc CmdApply_STANDBY ()
{
 flags. flags0.B0  = 0;
 flags. flags0.B2  = 1;
 pendingActions |= taClear;

 return tcfAll;
}
t_cmdfnc CmdApply_STANDBY_TELC ()
{
 return CmdApply_STANDBY();
}
t_cmdfnc CmdApply_INVERTI ()
{
 tabdata_swap(&tab_data);
 return tcfLocals & tcfGuests;
}
t_cmdfnc CmdApply_CLAXON ()
{
 configuration. persistentFlags0.B0  = ! configuration. persistentFlags0.B0 ;
 flags. flags0.B5  = 1;
 pendingActions |= taNotifyClaxon;
 return tcfNone;
}
t_cmdfnc CmdApply_CLAXON_ALT ()
{
 return CmdApply_CLAXON();
}
t_cmdfnc CmdApply_PROVA_CLAXON ()
{
 pendingActions |= taTryClaxon;
 return tcfNone;
}
t_cmdfnc CmdApply_7F_LOC ()
{
 tabdata_toggle_flag(&(tab_data.locals), lfP7F);
 return tcfLocals;
}
t_cmdfnc CmdApply_7F_OSP ()
{
 tabdata_toggle_flag(&(tab_data.guests), lfP7F);
 return tcfGuests;
}
t_cmdfnc CmdApply_P1_LOC ()
{
 tabdata_toggle_flag(&(tab_data.locals), lfP1);
 return tcfLocals;
}
t_cmdfnc CmdApply_P1_OSP ()
{
 tabdata_toggle_flag(&(tab_data.guests), lfP1);
 return tcfGuests;
}
t_cmdfnc CmdApply_P2_LOC ()
{
 tabdata_toggle_flag(&(tab_data.locals), lfP2);
 return tcfLocals;
}
t_cmdfnc CmdApply_P2_OSP ()
{
 tabdata_toggle_flag(&(tab_data.guests), lfP2);
 return tcfGuests;
}
t_cmdfnc CmdApply_AUM_10M ()
{
 tabdata_add_min(&(tab_data.time), 10);
 return tcfTime;
}
t_cmdfnc CmdApply_DIM_10M ()
{
 tabdata_add_min(&(tab_data.time), -10);
 return tcfTime;
}
t_cmdfnc CmdApply_AUM_1M ()
{
 tabdata_add_min(&(tab_data.time), 1);
 return tcfTime;
}
t_cmdfnc CmdApply_DIM_1M ()
{
 tabdata_add_min(&(tab_data.time), -1);
 return tcfTime;
}
t_cmdfnc CmdApply_AUM_10S ()
{
 tabdata_add_sec(&(tab_data.time), 10);
 return tcfTime;
}
t_cmdfnc CmdApply_DIM_10S ()
{
 tabdata_add_sec(&(tab_data.time), -10);
 return tcfTime;
}
t_cmdfnc CmdApply_AUM_1S ()
{
 tabdata_add_sec(&(tab_data.time), 1);
 return tcfTime;
}
t_cmdfnc CmdApply_DIM_1S ()
{
 tabdata_add_sec(&(tab_data.time), -1);
 return tcfTime;
}
t_cmdfnc CmdApply_CHANNEL_TEST ()
{
 return tcfNone;
}
t_cmdfnc CmdApply_DEBUG_MODE ()
{
 return tcfNone;
}
#line 1 "d:/git/cigna-scoreboard/rx/source/tabinterface.h"





const uint32 TAB_TIME_BIT_SETTING_US = 100;
const uint32 TAB_TIME_CLOCK_ACTIVE_US = 100;
const uint32 TAB_TIME_CLOCK_OFF_US = 100;
const uint32 TAB_TIME_STROBE_ACTIVE_US = 100;
const uint32 TAB_TIME_STROBE_OFF_US = 100;



const uint8 ___TAB_CHARMAP[] =
{
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
 0x00, 0x0A, 0x22, 0x7E,
 0x6D, 0x52, 0x7F, 0x02,
 0x39, 0x0F, 0x63, 0x46,
 0x0C, 0x40, 0x08, 0x52,
 0x3f, 0x06, 0x5b, 0x4f,
 0x66, 0x6d, 0x7d, 0x07,
 0x7f, 0x6f, 0x06, 0x0E,
 0x58, 0x48, 0x4C, 0x4B,
 0x7B, 0x77, 0x7f, 0x39,
 0x5e, 0x79, 0x71, 0x3d,
 0x76, 0x06, 0x0e, 0x76,
 0x38, 0x37, 0x37, 0x3F,
 0x73, 0x7F, 0x77, 0x6D,
 0x07, 0x3E, 0x3E, 0x3E,
 0x76, 0x66, 0x5B, 0x39,
 0x64, 0x0F, 0x23, 0x08,
 0x01, 0x77, 0x7c, 0x58,
 0x5e, 0x7b, 0x71, 0x6f,
 0x74, 0x06, 0x0E, 0x76,
 0x38, 0x54, 0x54, 0x5C,
 0x73, 0x67, 0x50, 0x6D,
 0x31, 0x1C, 0x1C, 0x1C,
 0x76, 0x66, 0x5B, 0x39,
 0x06, 0x0F, 0x40,  0x40 ,
 0x79, 0x00, 0x0C, 0x71,
 0x0C, 0x08,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 , 0x02, 0x02, 0x22,
 0x22, 0x40, 0x40, 0x40,
 0x01,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 , 0x06, 0x6D,
 0x01,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
  0x40 , 0x72,  0x40 ,  0x40 ,
 0x08,  0x40 ,  0x40 ,  0x40 ,
  0x40 ,  0x40 ,  0x40 ,  0x40 ,
 0x77, 0x77, 0x77, 0x77,
 0x77, 0x77, 0x79, 0x39,
 0x79, 0x79, 0x79, 0x79,
 0x06, 0x06, 0x06, 0x06,
 0x5E, 0x37, 0x3F, 0x3F,
 0x3F, 0x3F, 0x3F,  0x40 ,
 0x3F, 0x3E, 0x3E, 0x3E,
 0x3E, 0x66,  0x40 , 0x7C,
 0x5F, 0x5F, 0x5F, 0x5F,
 0x5F, 0x5F, 0x5F, 0x58,
 0x7B, 0x7B, 0x7B, 0x7B,
 0x06, 0x06, 0x06, 0x06,
  0x40 , 0x54, 0x5C, 0x5C,
 0x5C, 0x5C, 0x5C,  0x40 ,
 0x5C, 0x1C, 0x1C, 0x1C,
 0x1C, 0x66,  0x40 , 0x66
};



void tab_init ();
void tab_send_string (uint8* string, uint8 num);
void tab_send_num (uint8 num);

void tab_strobe_locals ();
void tab_strobe_guests ();
void tab_strobe_time ();

void tab_send_byte (uint8 byteToSend);




void tab_display_msg (char* string, uint8 num);
void tab_refresh_locals ();
void tab_refresh_guests ();
void tab_refresh_time ();
void ___tab_refresh_teamdata(t_teamdata* instance);
#line 111 "d:/git/cigna-scoreboard/rx/source/tabinterface.h"
void tab_init()
{
 pinDato = 0;
 pinClock = 0;
 pinLocali = 0;
 pinTempo = 0;
 pinOspiti = 0;
 pinClaxon = 0;

 pinDato_dir =  0 ;
 pinClock_dir =  0 ;
 pinLocali_dir =  0 ;
 pinTempo_dir =  0 ;
 pinOspiti_dir =  0 ;
 pinClaxon_dir =  0 ;


 debug_uart_init();
 debug_uart_send_text("uart debug ON");

}

void tab_send_byte(uint8 byteToSend)
{
 uint8 i;

 for (i = 0; i < 8; i ++)
 {
 pinDato = ! byteToSend.B7;
 Delay_us(TAB_TIME_BIT_SETTING_US);

 pinClock = 1;
 Delay_us(TAB_TIME_CLOCK_ACTIVE_US);
 pinClock = 0;
 Delay_us(TAB_TIME_CLOCK_OFF_US);

 byteToSend = byteToSend << 1;
 }

 pinDato = 0;
}

void tab_send_num(uint8 num)
{
 tab_send_byte( ___TAB_CHARMAP[num + '0'] );
}

void tab_display_msg(char* string, uint8 num)
{
 uint8 len;

 tab_send_string("    ", 4);
 tab_strobe_locals();
 tab_strobe_guests();

 len = num;
 while (len++ < 4) tab_send_byte(0x00);
 tab_send_string(string, num);
  { pinTempo = 1; Delay_us(TAB_TIME_STROBE_ACTIVE_US); pinTempo = 0; Delay_us(TAB_TIME_STROBE_OFF_US); } ;
}

void tab_send_string(uint8* string, uint8 num)
{
 uint8 counter = 0;


  { sprinti(___debug_line, "str '%s'", string); debug_uart_send_text(___debug_line); } ;


 while (num --)
 {
 tab_send_byte( ___TAB_CHARMAP[string[counter ++]] );
 }
}

void tab_strobe_locals()
{

  debug_uart_send_text("strobe loc") ;

  { pinLocali = 1; Delay_us(TAB_TIME_STROBE_ACTIVE_US); pinLocali = 0; Delay_us(TAB_TIME_STROBE_OFF_US); } ;
}

void tab_strobe_guests()
{

  debug_uart_send_text("strobe osp") ;

  { pinOspiti = 1; Delay_us(TAB_TIME_STROBE_ACTIVE_US); pinOspiti = 0; Delay_us(TAB_TIME_STROBE_OFF_US); } ;
}

void tab_strobe_time()
{

  debug_uart_send_text("strobe time") ;

  { pinTempo = 1; Delay_us(TAB_TIME_STROBE_ACTIVE_US); pinTempo = 0; Delay_us(TAB_TIME_STROBE_OFF_US); } ;
}

void tab_refresh_locals()
{
 ___tab_refresh_teamdata(&(tab_data.locals));
 tab_strobe_locals();
}

void tab_refresh_guests()
{
 ___tab_refresh_teamdata(&(tab_data.guests));
 tab_strobe_guests();
}

void tab_refresh_time()
{
 char txt6[6];

 sprinti(txt6, "%2i%02i", (int16)tab_data.time.min, (int16)tab_data.time.sec);
 tab_send_string(txt6, 4);
 tab_strobe_time();
}

void ___tab_refresh_teamdata(t_teamdata* instance)
{
 uint8 refr_dato;
 char txt4[4];

 tab_send_num(instance -> sets);
 refr_dato = 0x00;
 if (instance -> points >= 100) refr_dato = 0x06;
 refr_dato.B5 = instance ->  flags.B0 ;
 refr_dato.B4 = instance ->  flags.B1 ;
 refr_dato.B3 = instance ->  flags.B2 ;
 tab_send_byte(refr_dato);
 sprinti(txt4, "%3i", (int16)instance -> points);
 tab_send_string(txt4 + 1, 2);
}
#line 1 "d:/git/cigna-scoreboard/rx/source/test.h"





void test_launch();
void debug_write_tab_data();



void test_refresh();

void test_launch()
{


 while (1) { test_refresh(); Delay_ms(3000); }
}

void test_refresh()
{
 debug_write_tab_data();
}

void debug_write_tab_data()
{
 char line[100];
 sprinti(line, "(%i %3i) (%2i:%02i) (%3i %i)",
 (int16)tab_data.locals.sets, (int16)tab_data.locals.points,
 (int16)tab_data.time.min, (int16)tab_data.time.sec,
 (int16)tab_data.guests.sets, (int16)tab_data.guests.points
 );
  debug_uart_send_text(line) ;
}
#line 3 "D:/Git/cigna-scoreboard/RX/source/tab rx 1.c"
void init();
uint8 main_nrf_init();

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

  nrf_set_power( 1 ) ;
 nrf_rx_start_listening();

 while (1)
 {
 if (flags. flags0.B4 )
 ProcessRxCmd(&CmdPending);

 if (ClockTicksPending)
 ProcessPendingTicks(&ClockTicksPending);

 if (pendingActions != taNone)
 ProcessPendingActions(&pendingActions);

 ProcessDisplay();
 CheckRFInput();
 }
}

void CheckRFInput()
{
 uint8 buffer[ 7 ];
 uint8 debug_i;

 if (flags. flags0.B4 ) return;
 if (! nrf_rx_packet_ready()) return;


  nrf_read_payload( 7 , buffer) ;
 nrf_clear_interrupts( 0b001 );
 nrfpacket_from_raw_buffer(&packet, buffer);

 for (debug_i = 0; debug_i <  7 ; debug_i ++)
 {
  { sprinti(___debug_line, "byte %i is %i", (int16)(debug_i),(int16)(buffer[debug_i])); debug_uart_send_text(___debug_line); } ;
 }


 if (nrfpacket_compare_id(&packet, packet_last_id_bytes) == 1)
 {


  { sprinti(___debug_line, "RX PACK DISC %i", (int16)(packet.cmd)); debug_uart_send_text(___debug_line); } ;

 }
 else
 {
 nrfpacket_copy_id(&packet, packet_last_id_bytes);

  { sprinti(___debug_line, "RX PACK OK %i", (int16)(packet.cmd)); debug_uart_send_text(___debug_line); } ;


 CmdPending = packet.cmd;
 flags. flags0.B4  = 1;
 }
 nrf_rx_start_listening();
}

void ProcessDisplay()
{
 if (! flags. flags0.B2 )
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

 if (! flags. flags0.B6 ) return;
 flags. flags0.B6  = 0;

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


  { sprinti(___debug_line, "ProcessRxCmd %i", (int16)(*cmd)); debug_uart_send_text(___debug_line); } ;


 localCmd = *cmd;
 *cmd =  0 ;

 flags. flags0.B4  = 0;

 if (!flags. flags0.B2 )
 whatsChanged |= ApplyCmd(localCmd);
 else
 {
 flags. flags0.B2  = 0;
 whatsChanged |= tcfAll;
 }
}

void ProcessPendingTicks(uint8 * ticks)
{
 uint8 localTicks;


  { sprinti(___debug_line, "ProcessTicks %i", (int16)(*ticks)); debug_uart_send_text(___debug_line); } ;


 localTicks = *ticks;
 *ticks = 0;

 if (!flags. flags0.B2 )
 {
 whatsChanged |= tcfTime;
 tabdata_add_sec(&(tab_data.time), -((int8)localTicks));

 if (tab_data.time.min == 0 && tab_data.time.sec == 0)
 {
 flags. flags0.B0  = 0;
 pendingActions |= taTimeEnded;
 }
 }
}

void ProcessPendingActions(t_action * actions)
{
 t_action localActions;
 int8 i8;
 char txt5[5];


  { sprinti(___debug_line, "ProcessPendingActions %i", (int16)(*actions)); debug_uart_send_text(___debug_line); } ;


 localActions = *actions;
 *actions = 0;

 if (flags. flags0.B2 ) return;

 if (localActions & taNotifyClaxon)
 {
 if (configuration. persistentFlags0.B0 )
 tab_display_msg("COFF", 4);
 else
 tab_display_msg("C ON", 4);

 SyncedDelay(1000);
 whatsChanged |= tcfAll;
 }

 if (localActions & taTryClaxon)
 {
 for (i8 = 3; i8 > 0; i8 --)
 {
 sprinti(txt5, "%i...", (int16)i8);
 tab_display_msg(txt5, 4);
 }

 TriggerAlarm(750);
 whatsChanged |= tcfAll;
 }

 if (localActions & taTimeEnded)
 {
 TriggerAlarm(1500);
 tab_display_msg("----", 4);
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

 INTCON.T0IF = 0;
 TMR0L += 69;

 flags. flags0.B6  = 1;
 if (SyncedDelayCounter > 0) SyncedDelayCounter = 0;


 PIN_DBG_0 = ! PIN_DBG_0;

 }
}

void InterruptHigh() iv 0x0008 ics ICS_AUTO
{
 if (PIR1.TMR1IF)
 {

 TMR1H = 0x80;
 TMR1L = 0x00;
 PIR1.TMR1IF = 0;


 if ((flags. flags0.B0 ) && (!flags. flags0.B2 ) && (!ClockTicksPending.B7))
 ClockTicksPending ++;
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

 if (whyRestarted == SelfReset)
 {
 tab_display_msg("----", 4);
 Delay_ms(1000);
 }

 if (! main_nrf_init())
 {
 tab_display_msg("E 01", 4);
 Delay_ms(5000);


 while (1)
 {
  debug_uart_send_text("tab err") ;
 Delay_ms(1000);
 }

 }


 Delay_ms(1000);
  debug_uart_send_text("init end") ;


 hw_int_enable();
}

void SyncedDelay(uint16 ms)
{
 SyncedDelayCounter = ms;
 while (SyncedDelayCounter > 0) ;
}

void TriggerAlarm(uint16 time)
{
 pinClaxon = 1;
 SyncedDelay(time);
 pinClaxon = 0;
 SyncedDelay(250);
}

uint8 main_nrf_init()
{
 uint8 res;
 uint8 addr[ 5 ] = { 0, 1, 2, 3, 4 };

 nrf_init();
 nrf_set_output_power ( 0b11 );
 nrf_set_crc ( 0b010 );
 nrf_set_channel ( 2 );
 nrf_set_interrupts ( 0b000 );
 nrf_set_direction ( 1 );
 nrf_enable_auto_acks ( 1  ? 0b000001 : 0b000000);
 nrf_enable_data_pipes (0b000001);
 nrf_set_data_rate ( 0b00 );
 nrf_set_rx_pipe (0,  5 , addr,  7 );

 return nrf_test();
}
