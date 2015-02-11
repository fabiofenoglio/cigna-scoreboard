#ifndef _incl_hardware_h
#define _incl_hardware_h

/* Tipi di dato ============================================================= */
/* Costanti ================================================================= */

sbit pin_dato           at LATB7_Bit;
sbit pin_clock          at LATB6_Bit;
sbit pin_locali         at LATC6_Bit;
sbit pin_tempo          at LATB4_Bit;
sbit pin_ospiti         at LATB5_Bit;
sbit pin_claxon         at LATA1_Bit;

sbit pin_dato_dir       at TRISB7_Bit;
sbit pin_clock_dir      at TRISB6_Bit;
sbit pin_locali_dir     at TRISC6_Bit;
sbit pin_tempo_dir      at TRISB4_Bit;
sbit pin_ospiti_dir     at TRISB5_Bit;
sbit pin_claxon_dir     at TRISA1_Bit;

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