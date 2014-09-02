#ifndef _incl_header_h
#define _incl_header_h

/* TODO
  faster spi when slower clock
*/

/* Dipendenze =============================================================== */

#define DEBUG 1

#include "common_pic18.h"
#include "debug.h"
#include "hardware.h"       // Configurazione hardware
#include "keypad.h"         // gestione della tastiera
#include "fsm.h"            // gestione della macchina a stati

#include "nrf_cfg.h"        // configurazione del modulo radio NRF24L01P
#include "radioADT.h"       // definizione dei dati radio
#include "f_nrf24l01p.h"    // libreria di gestione del modulo radio NRF24L01P

typedef enum error_code_enum
{
    ERRORCODE_NONE =                     0,
    ERRORCODE_NRF_INIT_ERROR =           1,
    ERRORCODE_GENERIC_BOOT_ERROR =       2,
    ERRORCODE_UNKNOWN_INTERRUPT_CAUGHT = 3
} 
error_code;

/* Fixed control ============================================================ */
#if (0)
     #error generic header control error
#endif

#endif