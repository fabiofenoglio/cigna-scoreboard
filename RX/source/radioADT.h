#ifndef _incl_radioADT_h
#define _incl_radioADT_h

/* Dipendenze =============================================================== */

#include <built_in.h>

/* Costanti ================================================================= */

const uint8 NRF_PACKET_NUM_CMD_BYTES =  CFG_NUM_CMD_BYTES;
const uint8 NRF_PACKET_NUM_ID_BYTES =   CFG_NUM_ID_BYTES;

/* Tipi di dato ============================================================= */

typedef struct TNrfPacket_Struct
{
    uint8      raw_cmd_bytes[NRF_PACKET_NUM_CMD_BYTES];
    TCmd       cmd;
    uint8      id_bytes[NRF_PACKET_NUM_ID_BYTES];
    
} TNrfPacket;

/* Prototipi ================================================================ */

void    nrfpacket_from_raw_buffer  (TNrfPacket* instance, uint8* buffer);
uint8   nrfpacket_compare_id       (TNrfPacket* instance, uint8* id);
void    nrfpacket_copy_id          (TNrfPacket* instance, uint8* dest_id);

/* Implementazioni ========================================================== */

void nrfpacket_from_raw_buffer(TNrfPacket* instance, uint8* buffer)
{
    // copy raw data
    memcpy(&(instance -> id_bytes), buffer, NRF_PACKET_NUM_ID_BYTES);
    memcpy(&(instance -> raw_cmd_bytes), buffer + NRF_PACKET_NUM_ID_BYTES, NRF_PACKET_NUM_CMD_BYTES);

    // max decisor
    if (buffer[NRF_PACKET_NUM_ID_BYTES] == buffer[NRF_PACKET_NUM_ID_BYTES + 1] || 
        buffer[NRF_PACKET_NUM_ID_BYTES] == buffer[NRF_PACKET_NUM_ID_BYTES + 2])
    {
        instance -> cmd = buffer[NRF_PACKET_NUM_ID_BYTES];
    }
    else if (buffer[NRF_PACKET_NUM_ID_BYTES + 1] == buffer[NRF_PACKET_NUM_ID_BYTES + 2])
    {
        instance -> cmd = buffer[NRF_PACKET_NUM_ID_BYTES];
    }
    else
        instance -> cmd = CmdCode_None;
}

uint8 nrfpacket_compare_id(TNrfPacket* instance, uint8* compare_id)
{
    uint8 i;
    for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
    {
        if (instance -> id_bytes[i] != compare_id[i]) return 0;
    }
    return 1;
}

void nrfpacket_copy_id(TNrfPacket* instance, uint8* dest_id)
{
    uint8 i;
    for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
        dest_id[i] = instance -> id_bytes[i];
}

#endif