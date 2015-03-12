#ifndef _incl_header_h
#define _incl_header_h

/* Imports ================================================================== */

#define DEBUG 1

#include "common_pic18.h"             // Configurazione comune alla serie 18F
#include "hardware.h"                 // Configurazione hardware
#include "nrf_cfg.h"                  // configurazione del modulo radio NRF24L01P
#include "f_nrf24l01p.h"              // libreria di gestione del modulo radio NRF24L01P
#include "tabInterface.h"             // routine di interfacciamento con il tabellone
#include "protocol.h"

#if DEBUG
    #include "debug.h"
#endif

/* Validation =============================================================== */
#if BYTES_PER_PACKET != CFG_PAYLOAD_SIZE
    #error BYTES_PER_PACKET and CFG_PAYLOAD_SIZE should be the same
#endif

#if DATA_BYTES_PER_PACKET > FLASH_WRITE_BLOCK_SIZE
 #error "wrong data bytes / flash write buffer size"
#endif

#endif