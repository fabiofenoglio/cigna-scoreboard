#ifndef _incl_radioADT_h
#define _incl_radioADT_h

/* Dipendenze =============================================================== */

#include <built_in.h>

/* Costanti ================================================================= */

#define NRFPACKET_SPECIAL_LOW_BATT 0x01

/* Tipi di dato ============================================================= */

uint8 ___packet_build_buffer[CFG_PAYLOAD_SIZE];

/* Prototipi ================================================================ */

void nrfpacket_init         ();
void nrfpacket_set_cmd      (uint8 cmd);
uint8* nrfpacket_get_buffer ();
void nrfpacket_set_special  (uint8 pdata);

/* Implementazioni ========================================================== */

uint8* nrfpacket_get_buffer()
{
    return ___packet_build_buffer;
}

void nrfpacket_init()
{
    uint8 i;
    for (i = 0; i < CFG_NUM_ID_BYTES; i ++)
        ___packet_build_buffer[i] = 0;
}

void nrfpacket_set_cmd(uint8 cmd)
{
    uint8 i;
    
    // set cmd
    for (i = CFG_NUM_ID_BYTES;
         i < CFG_NUM_ID_BYTES + CFG_NUM_CMD_BYTES;
         i ++)
    {
        ___packet_build_buffer[i] = cmd;
    }
    
    // increase id
    for (i = 0; i < CFG_NUM_ID_BYTES; i ++)
    {
        if ((++ ___packet_build_buffer[i]) != 0) break;
    }
    
    // avoid "0" code on rollover
    if (i == CFG_NUM_ID_BYTES)
        ___packet_build_buffer[0] = 1;
}

void nrfpacket_set_special(uint8 pdata)
{
    uint8 i;

    // set cmd
    ___packet_build_buffer[CFG_NUM_ID_BYTES] = 0;
    
    for (i = CFG_NUM_ID_BYTES + 1;
         i < CFG_NUM_ID_BYTES + CFG_NUM_CMD_BYTES;
         i ++)
    {
        ___packet_build_buffer[i] = pdata;
    }

    // increase id
    for (i = 0; i < CFG_NUM_ID_BYTES; i ++)
    {
        if ((++ ___packet_build_buffer[i]) != 0) break;
    }

    // avoid "0" code on rollover
    if (i == CFG_NUM_ID_BYTES)
        ___packet_build_buffer[0] = 1;
}

#endif