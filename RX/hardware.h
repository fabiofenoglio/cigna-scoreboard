#ifndef _incl_hardware_h
#define _incl_hardware_h

/* Tipi di dato ============================================================= */
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

typedef enum t_reset_enum
{
     RESET_NORMAL,
     RESET_SELF,
     RESET_WDT,
     RESET_POWERDOWN,
     RESET_BROWNOUT
     
} t_reset;

/* Prototipi ================================================================ */

void            hw_init();
void            hw_int_enable();
void            hw_int_disable();
t_reset         hw_get_reset_reason();

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

t_reset hw_get_reset_reason()
{
    if (! RCON.TO_) return RESET_WDT;
    if (! RCON.PD) return RESET_POWERDOWN;

    if (! RCON.RI)
    {
        RCON.RI = 1;
        return RESET_SELF;
    }

    if (! RCON.BOR)
    {
        RCON.BOR = 1;
        if (RCON.POR) return RESET_BROWNOUT;
    }
    
    if (! RCON.POR) RCON.POR = 1;
    return RESET_NORMAL;
}

#endif