#ifndef _incl_datainstances_h
#define _incl_datainstances_h

/* Variabili ================================================================ */

TConfig      configuration;
TFlags       flags;
TTabData     tab_data;

TResetReason      whyRestarted;

TChangedFlags     whatsChanged;
TAction           pendingActions;
uint8             ClockTicksPending;
TCmd              CmdPending;
TNrfPacket        packet;
uint8             packet_last_id_bytes[CFG_NUM_ID_BYTES];

uint16            SyncedDelayCounter;

/* Prototipi ================================================================ */

void variables_init    ();

/* Implementazioni ========================================================== */

void variables_init()
{
    tabdata_new(&tab_data);
    flags_new(&flags);
    config_new(&configuration);
    
    whatsChanged = tcfAll;
    whyRestarted = hw_get_reset_reason();
    ClockTicksPending = 0;
    CmdPending = CmdCode_None;
    pendingActions = taNone;
    SyncedDelayCounter = 0;
}

#endif