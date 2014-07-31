#line 1 "D:/Cloud/Dropbox/d/tabellone strickes back/source/Trasmettitore/tab tx 1.c"
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/header.h"
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/common_pic18.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 22 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/common_pic18.h"
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
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/debug.h"
#line 12 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/debug.h"
 void debug_uart_init()
 {
 Soft_uart_init(&PORTA, 6, 2, 9600, 0);
 }

 void debug_uart_send_text(char* text)
 {
 unsigned short inten;
 unsigned short i;

 inten = INTCON & 0b11000000;
 INTCON &= 0b00111111;

 for (i = 0; text[i] != '\0'; i ++)
 Soft_uart_write(text[i]);

 Soft_uart_write(0);

 INTCON = inten;
 Delay_ms(10);
 }

 char ___debug_line[128];
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/hardware.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 8 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/hardware.h"
typedef enum TLedEnum
{
 Green,
 Red,
 Off
}
t_led;

const uint8 HW_LED_BLINK_FOREVER = 0;



sbit NRF_CE at LATC2_Bit;
sbit NRF_CE_DIR at TRISC2_Bit;
sbit NRF_CSN at LATA0_Bit;
sbit NRF_CSN_DIR at TRISA0_Bit;
sbit NRF_IRQ at PORTA.B5;
sbit NRF_IRQ_DIR at TRISA5_Bit;

sbit LED_R at LATA6_Bit;
sbit LED_R_DIR at TRISA6_Bit;
sbit LED_G at LATA7_Bit;
sbit LED_G_DIR at TRISA7_Bit;

sbit KP_OUT_1 at LATB2_Bit;
sbit KP_OUT_2 at LATB1_Bit;
sbit KP_OUT_3 at LATB0_Bit;
sbit KP_OUT_4 at LATC7_Bit;
sbit KP_OUT_5 at LATC6_Bit;
sbit KP_OUT_6 at LATA3_Bit;
sbit KP_OUT_1_DIR at TRISB2_Bit;
sbit KP_OUT_2_DIR at TRISB1_Bit;
sbit KP_OUT_3_DIR at TRISB0_Bit;
sbit KP_OUT_4_DIR at TRISC7_Bit;
sbit KP_OUT_5_DIR at TRISC6_Bit;
sbit KP_OUT_6_DIR at TRISA3_Bit;

sbit KP_IN_1 at PORTB.B7;
sbit KP_IN_2 at PORTB.B6;
sbit KP_IN_3 at PORTB.B5;
sbit KP_IN_4 at PORTB.B4;
sbit KP_IN_5 at PORTB.B3;
sbit KP_IN_1_DIR at TRISB7_Bit;
sbit KP_IN_2_DIR at TRISB6_Bit;
sbit KP_IN_3_DIR at TRISB5_Bit;
sbit KP_IN_4_DIR at TRISB4_Bit;
sbit KP_IN_5_DIR at TRISB3_Bit;



void hw_init ();
void hw_led_set (t_led status);
void hw_sleep_delay (uint32 ms);
t_bool hw_is_low_voltage ();
void hw_led_blink (t_led s1, t_led s2, uint16 time_s1, uint16 time_s2, uint8 times);
#line 85 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/hardware.h"
void hw_init()
{


 ANCON0 = 0xFF;
 ANCON1 = 0x1F;


 Unlock_IOLOCK();
 PPS_Mapping_NoLock(11, _INPUT, _SDI2);
 PPS_Mapping_NoLock(12, _OUTPUT, _SCK2);
 PPS_Mapping_NoLock(1, _OUTPUT, _SDO2);
 PPS_Mapping_NoLock(2, _INPUT, _INT1);
 Lock_IOLOCK();

 SPI_Remappable_Init_Advanced(
 _SPI_REMAPPABLE_MASTER_OSC_DIV16,
 _SPI_REMAPPABLE_DATA_SAMPLE_MIDDLE,
 _SPI_REMAPPABLE_CLK_IDLE_LOW,
 _SPI_REMAPPABLE_LOW_2_HIGH
 );


 LED_R = 0;
 LED_G = 0;
 LED_R_DIR =  0 ;
 LED_G_DIR =  0 ;

 KP_OUT_1 = 0;
 KP_OUT_2 = 0;
 KP_OUT_3 = 0;
 KP_OUT_4 = 0;
 KP_OUT_5 = 0;
 KP_OUT_6 = 0;

 KP_OUT_1_DIR =  0 ;
 KP_OUT_2_DIR =  0 ;
 KP_OUT_3_DIR =  0 ;
 KP_OUT_4_DIR =  0 ;
 KP_OUT_5_DIR =  0 ;
 KP_OUT_6_DIR =  0 ;

 KP_IN_1_DIR =  1 ;
 KP_IN_2_DIR =  1 ;
 KP_IN_3_DIR =  1 ;
 KP_IN_4_DIR =  1 ;
 KP_IN_5_DIR =  1 ;


 WDTCON.REGSLP = 1;
 WDTCON.VBGOE = 0;
 WDTCON.ULPEN = 0;
 WDTCON.ULPSINK = 0;
 WDTCON.SWDTEN = 0;


 INTCON2.INTEDG1 = 0;


 HLVDCON.HLVDEN = 0;

 HLVDL3_bit = 1;
 HLVDL2_bit = 0;
 HLVDL1_bit = 0;
 HLVDL0_bit = 1;
 HLVDCON.VDIRMAG = 0;


 RCON.IPEN = 0;
 INTCON2.RBIP =  0 ;
 INTCON3.INT1IP =  0 ;


  {INTCON.GIEL = 0; INTCON.GIEH = 0;} ;
}

t_bool hw_is_low_voltage()
{

 t_bool result;

 HLVDCON.HLVDEN = 1;
 while (! HLVDCON.BGVST) ;
 while (! HLVDCON.IRVST) ;
 Delay_us(100);

 if (PIR2.HLVDIF)
 {
 PIR2.HLVDIF = 0;
 result = TRUE;
 }
 else
 result = FALSE;

 HLVDCON.HLVDEN = 0;

 return result;
}

void hw_sleep_delay(uint32 ms)
{
 uint16 iterations;
 uint8 int_state;

 if (ms < 1) return;

 int_state.B7 = INTCON.B7;
 int_state.B6 = INTCON.B6;

 iterations = ms / ( 4  *  4 );
 if (iterations < 1) iterations = 1;

 while (iterations > 0)
 {
 asm CLRWDT;
 WDTCON.SWDTEN = 1;
  {IDLEN_bit = 0; asm sleep; } ;
 WDTCON.SWDTEN = 0;
 asm CLRWDT;

 iterations --;
 }

 INTCON.B6 = int_state.B6;
 INTCON.B7 = int_state.B7;
}

void hw_led_set(t_led status)
{
 switch (status)
 {
 case Green:
 LED_R = 0;
 LED_G = 1;
 break;

 case Red:
 LED_G = 0;
 LED_R = 1;
 break;

 default:
 LED_G = 0;
 LED_R = 0;
 break;
 }
}

void hw_led_blink(t_led s1, t_led s2, uint16 time_s1, uint16 time_s2, uint8 times)
{
 uint8 i;

 if (times == HW_LED_BLINK_FOREVER)
 {
 while (1)
 {
 hw_led_set(s1);
 hw_sleep_delay(time_s1);
 hw_led_set(s2);
 hw_sleep_delay(time_s2);
 }
 }

 for (i = 0; i < times; i ++)
 {
 hw_led_set(s1);
 hw_sleep_delay(time_s1);
 hw_led_set(s2);
 hw_sleep_delay(time_s2);
 }
}
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/keypad.h"
#line 62 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/keypad.h"
uint8 keypad_read();
t_bool keypad_something_pressed();
void keypad_set_columns(uint8 state, t_bool delay);
void ___keypad_delay_columns_settling();



void ___keypad_delay_columns_settling()
{
 Delay_us(200);
}

void keypad_set_columns(uint8 state, t_bool delay)
{
 KP_OUT_1 = state;
 KP_OUT_2 = state;
 KP_OUT_3 = state;
 KP_OUT_4 = state;
 KP_OUT_5 = state;
 KP_OUT_6 = state;
 if (delay) ___keypad_delay_columns_settling();
}

t_bool keypad_something_pressed()
{
 uint8 res;

 keypad_set_columns( 1 , TRUE);

 res = (KP_IN_1 || KP_IN_2 || KP_IN_3 || KP_IN_4 || KP_IN_5) ? TRUE : FALSE;

 keypad_set_columns( 0 , FALSE);

 return res;
}

uint8 ___wrapped_keypad_read()
{
 t_bool function_pressed;
 if (! keypad_something_pressed()) return  0 ;


 function_pressed = FALSE;

 KP_OUT_2 =  0 ;
 KP_OUT_3 =  0 ;
 KP_OUT_4 =  0 ;
 KP_OUT_5 =  0 ;
 KP_OUT_6 =  0 ;
 KP_OUT_1 =  1 ;
 ___keypad_delay_columns_settling();
 if (KP_IN_1 ==  1 ) return 1 + function_pressed;
 if (KP_IN_2 ==  1 ) return 3 + function_pressed;
 if (KP_IN_3 ==  1 ) return 5 + function_pressed;
 if (KP_IN_4 ==  1 ) return 7 + function_pressed;
 if (KP_IN_5 ==  1 ) return 9 + function_pressed;

 KP_OUT_1 =  0 ;
 KP_OUT_2 =  1 ;
 ___keypad_delay_columns_settling();
 if (KP_IN_1 ==  1 ) return 11 + function_pressed;
 if (KP_IN_2 ==  1 ) return 13 + function_pressed;
 if (KP_IN_3 ==  1 ) return 15 + function_pressed;
 if (KP_IN_4 ==  1 ) return 17 + function_pressed;
 if (KP_IN_5 ==  1 ) return 19 + function_pressed;

 KP_OUT_2 =  0 ;
 KP_OUT_3 =  1 ;
 ___keypad_delay_columns_settling();
 if (KP_IN_1 ==  1 ) return 21 + function_pressed;
 if (KP_IN_2 ==  1 ) return 23 + function_pressed;
 if (KP_IN_3 ==  1 ) return 25 + function_pressed;
 if (KP_IN_4 ==  1 ) return 27 + function_pressed;
 if (KP_IN_5 ==  1 ) return 29 + function_pressed;

 KP_OUT_3 =  0 ;
 KP_OUT_4 =  1 ;
 ___keypad_delay_columns_settling();
 if (KP_IN_1 ==  1 ) return 31 + function_pressed;
 if (KP_IN_2 ==  1 ) return 33 + function_pressed;
 if (KP_IN_3 ==  1 ) return 35 + function_pressed;
 if (KP_IN_4 ==  1 ) return 37 + function_pressed;
 if (KP_IN_5 ==  1 ) return 39 + function_pressed;

 KP_OUT_4 =  0 ;
 KP_OUT_5 =  1 ;
 ___keypad_delay_columns_settling();
 if (KP_IN_1 ==  1 ) return 41 + function_pressed;
 if (KP_IN_2 ==  1 ) return 43 + function_pressed;
 if (KP_IN_3 ==  1 ) return 45 + function_pressed;
 if (KP_IN_4 ==  1 ) return 47 + function_pressed;
 if (KP_IN_5 ==  1 ) return 49 + function_pressed;

 KP_OUT_5 =  0 ;
 KP_OUT_6 =  1 ;
 ___keypad_delay_columns_settling();
 if (KP_IN_1 ==  1 ) return 51 + function_pressed;
 if (KP_IN_2 ==  1 ) return 53 + function_pressed;
 if (KP_IN_3 ==  1 ) return 55 + function_pressed;
 if (KP_IN_4 ==  1 ) return 57 + function_pressed;
 if (KP_IN_5 ==  1 ) return 59 + function_pressed;

 KP_OUT_6 =  0 ;

 return  0 ;
}

uint8 keypad_read()
{
 uint8 res = ___wrapped_keypad_read();
 keypad_set_columns( 0 , FALSE);
 return res;
}
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/fsm.h"







typedef struct t_status_struct
{
 uint8 id;
 t_operation (*execute_first) ();
 struct t_status_struct *
 (*execute) ();
 t_operation (*execute_last) ();


 char* name;

}
t_status;



t_status * fsm_current_status =  0 ;
t_status * fsm_next_status =  0 ;

void fsm_init (t_status * first_instance);
t_status * fsm_status_new (t_status * instance);
void fsm_set_next_status (t_status * status);
void fsm_loop ();



void fsm_loop()
{
 if (fsm_next_status != fsm_current_status)
 {
 if (fsm_current_status !=  0  &&
 fsm_current_status -> execute_last !=  0 )
 fsm_current_status -> execute_last();

 if (fsm_next_status !=  0  &&
 fsm_next_status -> execute_first !=  0 )
 fsm_next_status -> execute_first();
 }

 fsm_current_status = fsm_next_status;

 if (fsm_current_status !=  0  &&
 fsm_current_status -> execute !=  0 )
 {
 fsm_set_next_status(fsm_current_status -> execute());
 }
}

void fsm_init(t_status * first_instance)
{
 fsm_current_status =  0 ;
 fsm_set_next_status(first_instance);
}

t_status * fsm_status_new(t_status * instance)
{
 static status_id = 0;

 instance -> id = status_id ++ ;
 instance -> execute_first =  0 ;
 instance -> execute =  0 ;
 instance -> execute_last =  0 ;

 return instance;
}

void fsm_set_next_status(t_status * status)
{
 fsm_next_status = status;
}
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/nrf_cfg.h"
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/radioadt.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 14 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/radioadt.h"
uint8 ___packet_build_buffer[ ( 3  + 4 ) ];



void nrfpacket_init ();
void nrfpacket_set_cmd (uint8 cmd);
uint8* nrfpacket_get_buffer ();
void nrfpacket_set_special (uint8 pdata);



uint8* nrfpacket_get_buffer()
{
 return ___packet_build_buffer;
}

void nrfpacket_init()
{
 uint8 i;
 for (i = 0; i <  4 ; i ++)
 ___packet_build_buffer[i] = 0;
}

void nrfpacket_set_cmd(uint8 cmd)
{
 uint8 i;


 for (i =  4 ;
 i <  4  +  3 ;
 i ++)
 {
 ___packet_build_buffer[i] = cmd;
 }


 for (i = 0; i <  4 ; i ++)
 {
 if ((++ ___packet_build_buffer[i]) != 0) break;
 }


 if (i ==  4 )
 ___packet_build_buffer[0] = 1;
}

void nrfpacket_set_special(uint8 pdata)
{
 uint8 i;


 ___packet_build_buffer[ 4 ] = 0;

 for (i =  4  + 1;
 i <  4  +  3 ;
 i ++)
 {
 ___packet_build_buffer[i] = pdata;
 }


 for (i = 0; i <  4 ; i ++)
 {
 if ((++ ___packet_build_buffer[i]) != 0) break;
 }


 if (i ==  4 )
 ___packet_build_buffer[0] = 1;
}
#line 1 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/f_nrf24l01p.h"
#line 1 "c:/program files (x86)/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 8 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/f_nrf24l01p.h"
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
#line 139 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/f_nrf24l01p.h"
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
#line 22 "d:/cloud/dropbox/d/tabellone strickes back/source/trasmettitore/header.h"
typedef enum error_code_enum
{
 ERRORCODE_NONE = 0,
 ERRORCODE_NRF_INIT_ERROR = 1,
 ERRORCODE_GENERIC_BOOT_ERROR = 2,
 ERRORCODE_UNKNOWN_INTERRUPT_CAUGHT = 3
}
error_code;
#line 3 "D:/Cloud/Dropbox/d/tabellone strickes back/source/Trasmettitore/tab tx 1.c"
void init ();
t_operation init_nrf ();
void init_fsm ();
void signal_error (error_code ecode);

t_status status_idle,
 status_button_pressed,
 status_send,
 status_signal,
 status_unpress
 ;

uint8 rb_status =  0  * 0xFF;

uint8 cmd =  0 ;
t_bool cmd_sent;

t_bool battery_low = FALSE;
t_bool low_batt_sent;

uint16 sent_signal_time;
const uint16 sent_signal_time_max = 100;
const uint16 sent_signal_time_min = 25;
const uint16 sent_signal_time_step = 15;

error_code pending_error = ERRORCODE_NONE;

t_status* sfnc_idle_execute()
{

 sent_signal_time = sent_signal_time_max;


 keypad_set_columns( 1 , TRUE);


  { INTCON.RBIF  = 0; INTCON.RBIE  = 1;} ;
  {INTCON.GIEL = 1; INTCON.GIEH = 1;} ;


  {IDLEN_bit = 0; asm sleep; } ;

 return &status_button_pressed;
}

t_status* sfnc_button_pressed_execute()
{

  { INTCON.RBIF  = 0; INTCON.RBIE  = 0;} ;
  {INTCON.GIEL = 0; INTCON.GIEH = 0;} ;


 cmd = keypad_read();


 if (cmd ==  0 )
 {

 hw_sleep_delay(50);
 return &status_idle;
 }


 return &status_send;
}

t_status* sfnc_send_execute()
{

  nrf_set_power( 1 ) ;
 hw_sleep_delay(10);


 nrfpacket_set_cmd(cmd);


  { INTCON3.INT1IF  = 0; INTCON3.INT1IE  = 1;} ;
  nrf_tx_send_packet( ( 3  + 4 ) , nrfpacket_get_buffer(), 0) ;
  {INTCON.GIEL = 1; INTCON.GIEH = 1;} ;


  {IDLEN_bit = 0; asm sleep; } ;


 cmd_sent = nrf_tx_packet_sent() ? TRUE : FALSE;
 nrf_clear_interrupts( 0b111 );


 battery_low = hw_is_low_voltage();

 if (battery_low)
 {

 nrfpacket_set_special( 0x01 );
  { INTCON3.INT1IF  = 0; INTCON3.INT1IE  = 1;} ;
  nrf_tx_send_packet( ( 3  + 4 ) , nrfpacket_get_buffer(), 0) ;
  {INTCON.GIEL = 1; INTCON.GIEH = 1;} ;
  {IDLEN_bit = 0; asm sleep; } ;

 low_batt_sent = nrf_tx_packet_sent() ? TRUE : FALSE;
 nrf_clear_interrupts( 0b111 );
 }


  {INTCON.GIEL = 0; INTCON.GIEH = 0;} ;
  nrf_set_power( 0 ) ;
  { INTCON3.INT1IF  = 0; INTCON3.INT1IE  = 0;} ;

 return &status_signal;
}

t_status* sfnc_signal_execute()
{

 if (battery_low)
 {

 if (low_batt_sent)
 hw_led_blink(Red, Off, 100, 200, 4);

 else
 hw_led_blink(Red, Off, 100, 200, 8);
 }
 else
 {

 if (cmd_sent)
 hw_led_blink(Green, Off, sent_signal_time, 0, 1);

 else
 hw_led_blink(Red, Off, 250, 150, 2);


 sent_signal_time -= sent_signal_time_step;
 if (sent_signal_time < sent_signal_time_min)
 sent_signal_time = sent_signal_time_min;
 }

 return &status_unpress;
}

t_status* sfnc_unpress_execute()
{




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

 if ( INTCON3.INT1IF )
 {
  INTCON3.INT1IF  = 0;
 served = TRUE;
 }

 if ( INTCON.RBIF )
 {
 rb_status = PORTB;
  INTCON.RBIF  = 0;
 served = TRUE;
 }

 if (served != TRUE)
 pending_error = ERRORCODE_UNKNOWN_INTERRUPT_CAUGHT;
}

void init()
{
 t_operation result = SUCCESS;


 debug_uart_init();
  debug_uart_send_text("boot started") ;


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

  debug_uart_send_text("boot completed") ;
 hw_led_blink(Green, Off, 1000, 0, 1);
}

void init_fsm()
{
 fsm_status_new(&status_idle);
 fsm_status_new(&status_button_pressed);
 fsm_status_new(&status_send);
 fsm_status_new(&status_signal);
 fsm_status_new(&status_unpress);

 status_idle.execute = sfnc_idle_execute;
 status_button_pressed.execute = sfnc_button_pressed_execute;
 status_send.execute = sfnc_send_execute;
 status_signal.execute = sfnc_signal_execute;
 status_unpress.execute = sfnc_unpress_execute;


 status_idle.name = "idle";
 status_button_pressed.name = "bpress";
 status_send.name = "send";
 status_signal.name = "signal";
 status_unpress.name = "unpress";


 fsm_init(&status_idle);
}

t_operation init_nrf()
{
 uint8 addr[ 5 ] = { 0, 1, 2, 3, 4 };

 nrf_init();
 nrf_set_crc ( 0b010 );
 nrf_set_channel ( 2 );
 nrf_set_interrupts ( 0b111 );
 nrf_set_direction ( 0 );
 nrf_enable_auto_acks ( 1  ? 0b000001 : 0b000000);
 nrf_enable_data_pipes (0b000001);
 nrf_set_retransmit_delay ( 6 );
 nrf_set_max_retransmit ( 15 );
 nrf_set_data_rate ( 0b00 );
 nrf_set_output_power ( 0b11 );
 nrf_set_rx_address (0,  5 , addr);
 nrf_set_tx_address ( 5 , addr);
 nrf_set_payload_size (0,  ( 3  + 4 ) );

 return (nrf_test() ? SUCCESS : ERROR);
}

void signal_error(error_code ecode)
{
 uint32 delay = 2000;
 const uint32 signal_error_max_delay = 3600000;

  {INTCON.GIEL = 0; INTCON.GIEH = 0;} ;

 while (1)
 {
  { sprinti(___debug_line, "[E] error %i", (int16)ecode); debug_uart_send_text(___debug_line); } ;

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
