#ifndef _incl_hardware_h
#define _incl_hardware_h

/* Tipi di dato ============================================================= */

#define INPUT   1
#define OUTPUT  0

#define YES     1
#define NO      0

#define TRUE    1
#define FALSE   0

#define INTERRUPT_PRIORITY_HIGH 1
#define INTERRUPT_PRIORITY_LOW 0

typedef unsigned short      uint8;
typedef   signed short      int8;
typedef unsigned int        uint16;
typedef   signed int        int16;
typedef unsigned long       uint32;
typedef   signed long       int32;
typedef unsigned long long  uint64;
typedef   signed long long  int64;

/* Costanti ================================================================= */

sbit pinDato           at LATB7_Bit;
sbit pinClock          at LATB6_Bit;
sbit pinLocali         at LATC6_Bit;
sbit pinTempo          at LATB4_Bit;
sbit pinOspiti         at LATB5_Bit;
sbit pinClaxon         at LATA1_Bit;

sbit pinDato_dir       at TRISB7_Bit;
sbit pinClock_dir      at TRISB6_Bit;
sbit pinLocali_dir     at TRISC6_Bit;
sbit pinTempo_dir      at TRISB4_Bit;
sbit pinOspiti_dir     at TRISB5_Bit;
sbit pinClaxon_dir     at TRISA1_Bit;

sbit NRF_CE            at LATB3_Bit;
sbit NRF_CE_DIR        at TRISB3_Bit;
sbit NRF_CSN           at LATC2_Bit;
sbit NRF_CSN_DIR       at TRISC2_Bit;
sbit NRF_IRQ           at LATB0_Bit;
sbit NRF_IRQ_DIR       at TRISB0_Bit;

#if DEBUG
sbit PIN_DBG_0         at LATA0_Bit;
sbit PIN_DBG_0_Dir     at TRISA0_Bit;
#endif

typedef enum TResetReason_enum
{
     NormalReset,
     SelfReset,
     WDTReset,
     PowerDownReset,
     BrownOutReset
     
} TResetReason;

/* Prototipi ================================================================ */

void            hw_init();
void            hw_int_enable();
void            hw_int_disable();
TResetReason    hw_get_reset_reason();

/* Implementazioni ========================================================== */

void hw_init()
{
    // Analogs ==========================
    // All analog modules OFF
    ANCON0 = 0xFF;
    ANCON1 = 0x1F;

    // Timers ===========================
    // Timer1
    // Ext clock, Presc. 1:1, crystal driver ON
    // don't sync, read in 16 bit mode
    T1CON = 0b10001111;

    // Timer0
    // 8 bit timer, internal clock, high to low
    // prescaler on at 1:64
    T0CON = 0b11010101;

    // Interrupts =======================
    // interrupt priorities enabled
    RCON.IPEN = 1;
    
    IPR1.TMR1IP = INTERRUPT_PRIORITY_HIGH;
    PIR1.TMR1IF = 0;
    PIE1.TMR1IE = 1;
    
    INTCON2.TMR0IP = INTERRUPT_PRIORITY_LOW;
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 1;
    
    // Remappable peripherals
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

    #if DEBUG
    PIN_DBG_0 = 0;
    PIN_DBG_0_Dir = OUTPUT;
    #endif
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

TResetReason hw_get_reset_reason()
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

#endif