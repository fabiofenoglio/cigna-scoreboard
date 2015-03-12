#ifndef _incl_hardware_h
#define _incl_hardware_h

/* Tipi di dato ============================================================= */
/* Costanti ================================================================= */

sbit NRF_CE            at LATC2_Bit;
sbit NRF_CE_DIR        at TRISC2_Bit;
sbit NRF_CSN           at LATA0_Bit;
sbit NRF_CSN_DIR       at TRISA0_Bit;
sbit NRF_IRQ           at PORTA.B5;
sbit NRF_IRQ_DIR       at TRISA5_Bit;

/* Prototipi ================================================================ */

void            hw_init();

/* Implementazioni ========================================================== */

void hw_init()
{
    // Analogs ==========================
    // All analog modules OFF
    ANCON0 = 0xFF;
    ANCON1 = 0x1F;
    
    // Remappable peripherals
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
}

#endif