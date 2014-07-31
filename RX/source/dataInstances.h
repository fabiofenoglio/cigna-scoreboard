#ifndef _incl_datainstances_h
#define _incl_datainstances_h

/* Variabili ================================================================ */

t_config        configuration;
t_flags         flags;
t_tab_data      tab_data;

t_reset_reason  whyRestarted;

t_changed_flags whatsChanged;
t_action        pendingActions;
uint8           ClockTicksPending;
t_cmd           CmdPending;
t_nrf_packet    packet;
uint8           packet_last_id_bytes[CFG_NUM_ID_BYTES];

uint16          SyncedDelayCounter;

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