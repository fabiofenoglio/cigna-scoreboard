#ifndef _incl_header_h
#define _incl_header_h

/* Dipendenze =============================================================== */

#define DEBUG 1

#include "debug.h"

#include "common_pic18.h"             // Configurazione comune alla serie 18F
#include "hardware.h"                 // Configurazione hardware
#include "nrf_cfg.h"                  // configurazione del modulo radio NRF24L01P
#include "f_nrf24l01p.h"              // libreria di gestione del modulo radio NRF24L01P
#include "18F27J53_EEpromEmulation.h" // emulazione EEprom onboard

#include "innerADT.h"                 // definizione degli AbstractDataTypes specifici
#include "config.h"                   // configurazione persistente in EEPROM
#include "flags.h"                    // flag di segnalazione interni
#include "dataMgr.h"                  // gestore dei dati del programma
#include "radioADT.h"                 // definizione dei dati radio
#include "dataInstances.h"            // dati e variabili instanziate
#include "dataMgrRoutines.h"          // gestore dei dati del programma (routines)
#include "tabInterface.h"             // routine di interfacciamento con il tabellone

#include "test.h"                     // modulo di test pre-release

#endif