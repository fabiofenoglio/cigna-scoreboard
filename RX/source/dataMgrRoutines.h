#ifndef _incl_datamgrroutines_h
#define _incl_datamgrroutines_h

/* Implementazioni ========================================================== */

CmdFunctionType ApplyCmd(TCmd cmd)
{
    CmdFunctionPointer fptr;
    if (cmd > 63) return tcfNone;
    fptr = ___datamgr_function_array[cmd];
    return fptr();
}

CmdFunctionType CmdApply_None ()
{
    return tcfNone;
}

CmdFunctionType CmdApply_INC_PT_LOC ()
{
    if (flags.timeSetting) return CmdApply_AUM_10M();
    tabdata_add_points(&(tab_data.locals), 1);
    return tcfLocals;
}
CmdFunctionType CmdApply_INC_PLLP_LOC ()
{
    tabdata_add_pp(&(tab_data.locals));
    return tcfLocals;
}
CmdFunctionType CmdApply_DEC_PT_LOC ()
{
    if (flags.timeSetting) return CmdApply_DIM_10M();
    tabdata_add_points(&(tab_data.locals), -1);
    return tcfLocals;
}
CmdFunctionType CmdApply_DEC_PLLP_LOC ()
{
    tabdata_sub_pp(&(tab_data.locals));
    return tcfLocals;
}
CmdFunctionType CmdApply_INC_PT_OSP ()
{
    if (flags.timeSetting) return CmdApply_AUM_1S();
    tabdata_add_points(&(tab_data.guests), 1);
    return tcfGuests;
}
CmdFunctionType CmdApply_INC_PLLP_OSP ()
{
    tabdata_add_pp(&(tab_data.guests));
    return tcfGuests;
}
CmdFunctionType CmdApply_DEC_PT_OSP ()
{
    if (flags.timeSetting) return CmdApply_DIM_1S();
    tabdata_add_points(&(tab_data.guests), -1);
    return tcfGuests;
}
CmdFunctionType CmdApply_DEC_PLLP_OSP ()
{
    tabdata_sub_pp(&(tab_data.guests));
    return tcfGuests;
}
CmdFunctionType CmdApply_INC_SET_LOC ()
{
    if (flags.timeSetting) return CmdApply_AUM_1M();
    tabdata_add_sets(&(tab_data.locals), 1);
    return tcfLocals;
}
CmdFunctionType CmdApply_DEC_SET_LOC ()
{
    if (flags.timeSetting) return CmdApply_DIM_1M();
    tabdata_add_sets(&(tab_data.locals), -1);
    return tcfLocals;
}
CmdFunctionType CmdApply_INC_SET_OSP ()
{
    if (flags.timeSetting) return CmdApply_AUM_10S();
    tabdata_add_sets(&(tab_data.guests), 1);
    return tcfGuests;
}
CmdFunctionType CmdApply_DEC_SET_OSP ()
{
    if (flags.timeSetting) return CmdApply_DIM_10S();
    tabdata_add_sets(&(tab_data.guests), -1);
    return tcfGuests;
}
CmdFunctionType CmdApply_INC_LED_LOC ()
{
    tabdata_add_flag_seq(&(tab_data.locals));
    return tcfLocals;
}
CmdFunctionType CmdApply_DEC_LED_LOC ()
{
    tabdata_sub_flag_seq(&(tab_data.locals));
    return tcfLocals;
}
CmdFunctionType CmdApply_INC_LED_OSP ()
{
    tabdata_add_flag_seq(&(tab_data.guests));
    return tcfGuests;
}
CmdFunctionType CmdApply_DEC_LED_OSP ()
{
    tabdata_sub_flag_seq(&(tab_data.guests));
    return tcfGuests;
}
CmdFunctionType CmdApply_START ()
{
    if (flags.timeSetting)
        flags.timeSetting = 0;
        
    if (tabdata_time_is_not_null(&(tab_data.time)))
        flags.timeStarted = 1;
    
    return tcfTime;
}
CmdFunctionType CmdApply_PAUSE ()
{
    if (flags.timeSetting) return tcfNone;
    flags.timeStarted = 0;
    return tcfTime;
}
CmdFunctionType CmdApply_TIME_RESET ()
{
    flags.timeStarted = 0;
    tabdata_clear_time(&tab_data);
    
    return tcfTime;
}
CmdFunctionType CmdApply_TIME_SET ()
{
    if (flags.timeSetting)
        flags.timeSetting = 0;
    else 
    {
        flags.timeStarted = 0;
        flags.timeSetting = 1;
    }
    return tcfTime;
}
CmdFunctionType CmdApply_RES_PT_LOC ()
{
    tabdata_clear_team(&(tab_data.locals));
    return tcfLocals;
}
CmdFunctionType CmdApply_RES_PT_OSP ()
{
    tabdata_clear_team(&(tab_data.guests));
    return tcfGuests;
}
CmdFunctionType CmdApply_RESET ()
{
    if (flags.timeSetting) return tcfNone;

    flags.timeStarted = 0;
    tabdata_clear(&tab_data);

    return tcfAll;
}
CmdFunctionType CmdApply_HARD_RESET ()
{
    asm RESET;
    return tcfAll;
}
CmdFunctionType CmdApply_SALVASCHERMO ()
{
    return CmdApply_STANDBY();
}
CmdFunctionType CmdApply_STANDBY ()
{
    flags.timeStarted = 0;
    flags.inStandby = 1;
    pendingActions |= taClear;

    return tcfAll;
}
CmdFunctionType CmdApply_STANDBY_TELC ()
{
    return CmdApply_STANDBY();
}
CmdFunctionType CmdApply_INVERTI ()
{
    tabdata_swap(&tab_data);
    return tcfLocals & tcfGuests;
}
CmdFunctionType CmdApply_CLAXON ()
{
    configuration.UseClaxon = ! configuration.UseClaxon;
    flags.EEPROMSavePending = 1;
    pendingActions |= taNotifyClaxon;
    return tcfNone;
}
CmdFunctionType CmdApply_CLAXON_ALT ()
{
    return CmdApply_CLAXON();
}
CmdFunctionType CmdApply_PROVA_CLAXON ()
{
    pendingActions |= taTryClaxon;
    return tcfNone;
}
CmdFunctionType CmdApply_7F_LOC ()
{
    tabdata_toggle_flag(&(tab_data.locals), lfP7F);
    return tcfLocals;
}
CmdFunctionType CmdApply_7F_OSP ()
{
    tabdata_toggle_flag(&(tab_data.guests), lfP7F);
    return tcfGuests;
}
CmdFunctionType CmdApply_P1_LOC ()
{
    tabdata_toggle_flag(&(tab_data.locals), lfP1);
    return tcfLocals;
}
CmdFunctionType CmdApply_P1_OSP ()
{
    tabdata_toggle_flag(&(tab_data.guests), lfP1);
    return tcfGuests;
}
CmdFunctionType CmdApply_P2_LOC ()
{
    tabdata_toggle_flag(&(tab_data.locals), lfP2);
    return tcfLocals;
}
CmdFunctionType CmdApply_P2_OSP ()
{
    tabdata_toggle_flag(&(tab_data.guests), lfP2);
    return tcfGuests;
}
CmdFunctionType CmdApply_AUM_10M ()
{
    tabdata_add_min(&(tab_data.time), 10);
    return tcfTime;
}
CmdFunctionType CmdApply_DIM_10M ()
{
    tabdata_add_min(&(tab_data.time), -10);
    return tcfTime;
}
CmdFunctionType CmdApply_AUM_1M ()
{
    tabdata_add_min(&(tab_data.time), 1);
    return tcfTime;
}
CmdFunctionType CmdApply_DIM_1M ()
{
    tabdata_add_min(&(tab_data.time), -1);
    return tcfTime;
}
CmdFunctionType CmdApply_AUM_10S ()
{
    tabdata_add_sec(&(tab_data.time), 10);
    return tcfTime;
}
CmdFunctionType CmdApply_DIM_10S ()
{
    tabdata_add_sec(&(tab_data.time), -10);
    return tcfTime;
}
CmdFunctionType CmdApply_AUM_1S ()
{
    tabdata_add_sec(&(tab_data.time), 1);
    return tcfTime;
}
CmdFunctionType CmdApply_DIM_1S ()
{
    tabdata_add_sec(&(tab_data.time), -1);
    return tcfTime;
}
CmdFunctionType CmdApply_CHANNEL_TEST ()
{
    return tcfNone;
}
CmdFunctionType CmdApply_DEBUG_MODE ()
{
    return tcfNone;
}

#endif