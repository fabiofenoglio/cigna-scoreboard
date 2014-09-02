#ifndef _incl_hardware_h
#define _incl_hardware_h

#include <built_in.h>

/* Tipi di dato ============================================================= */

typedef enum TLedEnum
{
    Green,
    Red,
    Off
}
t_led;

const uint8 HW_LED_BLINK_FOREVER = 0;

/* Costanti ================================================================= */

sbit NRF_CE            at LATC2_Bit;
sbit NRF_CE_DIR        at TRISC2_Bit;
sbit NRF_CSN           at LATA0_Bit;
sbit NRF_CSN_DIR       at TRISA0_Bit;
sbit NRF_IRQ           at PORTA.B5;
sbit NRF_IRQ_DIR       at TRISA5_Bit;

sbit LED_R             at LATA6_Bit;
sbit LED_R_DIR         at TRISA6_Bit;
sbit LED_G             at LATA7_Bit;
sbit LED_G_DIR         at TRISA7_Bit;

sbit KP_OUT_1          at LATB2_Bit;
sbit KP_OUT_2          at LATB1_Bit;
sbit KP_OUT_3          at LATB0_Bit;
sbit KP_OUT_4          at LATC7_Bit;
sbit KP_OUT_5          at LATC6_Bit;
sbit KP_OUT_6          at LATA3_Bit;
sbit KP_OUT_1_DIR      at TRISB2_Bit;
sbit KP_OUT_2_DIR      at TRISB1_Bit;
sbit KP_OUT_3_DIR      at TRISB0_Bit;
sbit KP_OUT_4_DIR      at TRISC7_Bit;
sbit KP_OUT_5_DIR      at TRISC6_Bit;
sbit KP_OUT_6_DIR      at TRISA3_Bit;

sbit KP_IN_1           at PORTB.B7;
sbit KP_IN_2           at PORTB.B6;
sbit KP_IN_3           at PORTB.B5;
sbit KP_IN_4           at PORTB.B4;
sbit KP_IN_5           at PORTB.B3;
sbit KP_IN_1_DIR       at TRISB7_Bit;
sbit KP_IN_2_DIR       at TRISB6_Bit;
sbit KP_IN_3_DIR       at TRISB5_Bit;
sbit KP_IN_4_DIR       at TRISB4_Bit;
sbit KP_IN_5_DIR       at TRISB3_Bit;

/* Prototipi ================================================================ */

void      hw_init               ();
void      hw_led_set            (t_led status);
void      hw_sleep_delay        (uint32 ms);
t_bool    hw_is_low_voltage     ();
void      hw_led_blink          (t_led s1, t_led s2, uint16 time_s1, uint16 time_s2, uint8 times);

/* Implementazioni ========================================================== */

#define HW_WDT_POSTSCALER 4
#define HW_WDT_TIMEOUT_MS 4

#define hw_int1_flag             INTCON3.INT1IF
#define hw_int1_flag_enable      INTCON3.INT1IE
#define hw_int1_enable()         {hw_int1_flag = 0; hw_int1_flag_enable = 1;}
#define hw_int1_disable()        {hw_int1_flag = 0; hw_int1_flag_enable = 0;}

#define hw_rbpc_int_flag         INTCON.RBIF
#define hw_rbpc_int_flag_enable  INTCON.RBIE
#define hw_rbpc_int_enable()     {hw_rbpc_int_flag = 0; hw_rbpc_int_flag_enable = 1;}
#define hw_rbpc_int_disable()    {hw_rbpc_int_flag = 0; hw_rbpc_int_flag_enable = 0;}

#define hw_int_enable()          {INTCON.GIEL = 1; INTCON.GIEH = 1;}
#define hw_int_disable()         {INTCON.GIEL = 0; INTCON.GIEH = 0;}

#define hw_powermode_sleep()     {IDLEN_bit = 0; asm sleep; }
#define hw_powermode_idle()      {IDLEN_bit = 1; asm sleep; }

void hw_init()
{
    // Analogs ==========================
    // All analog modules OFF
    ANCON0 = 0xFF;
    ANCON1 = 0x1F;

    // Remappable peripherals
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

    // GPIO pins
    LED_R = 0;
    LED_G = 0;
    LED_R_DIR = OUTPUT;
    LED_G_DIR = OUTPUT;
    
    KP_OUT_1 = 0;
    KP_OUT_2 = 0;
    KP_OUT_3 = 0;
    KP_OUT_4 = 0;
    KP_OUT_5 = 0;
    KP_OUT_6 = 0;
    
    KP_OUT_1_DIR = OUTPUT;
    KP_OUT_2_DIR = OUTPUT;
    KP_OUT_3_DIR = OUTPUT;
    KP_OUT_4_DIR = OUTPUT;
    KP_OUT_5_DIR = OUTPUT;
    KP_OUT_6_DIR = OUTPUT;
    
    KP_IN_1_DIR = INPUT;
    KP_IN_2_DIR = INPUT;
    KP_IN_3_DIR = INPUT;
    KP_IN_4_DIR = INPUT;
    KP_IN_5_DIR = INPUT;
    
    // WDT
    WDTCON.REGSLP = 1;
    WDTCON.VBGOE = 0;
    WDTCON.ULPEN = 0;
    WDTCON.ULPSINK = 0;
    WDTCON.SWDTEN = 0;

    // External interrupt 1
    INTCON2.INTEDG1 =  0;
    
    // High low voltage detect
    HLVDCON.HLVDEN = 0;
    // Transition at 2.57 V
    HLVDL3_bit = 1;
    HLVDL2_bit = 0;
    HLVDL1_bit = 0;
    HLVDL0_bit = 1;
    HLVDCON.VDIRMAG = 0;

    // Interrupt priorities
    RCON.IPEN = 0;
    INTCON2.RBIP =     INTERRUPT_PRIORITY_LOW;
    INTCON3.INT1IP =   INTERRUPT_PRIORITY_LOW;
    
    // All interrupts disabled at startup
    hw_int_disable();
}

t_bool hw_is_low_voltage()
{
    // Execution time: about 600 us @ 4 MHz
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
    
    iterations = ms / (HW_WDT_POSTSCALER * HW_WDT_TIMEOUT_MS);
    if (iterations < 1) iterations = 1;

    while (iterations > 0)
    {
        asm CLRWDT;
        WDTCON.SWDTEN = 1;
        hw_powermode_sleep();
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

#endif