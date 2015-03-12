#ifndef _incl_datamgrroutines_h
#define _incl_datamgrroutines_h

/* Implementazioni ========================================================== */

t_cmdfnc ApplyCmd(t_cmd cmd)
{
    t_cmdfnc_ptr fptr;
    if (cmd > 63) return tcfNone;
    fptr = ___datamgr_function_array[cmd];
    return fptr();
}

t_cmdfnc CmdApply_None ()
{
    return tcfNone;
}

t_cmdfnc CmdApply_INC_PT_LOC ()
{
    if (flags.timeSetting) return CmdApply_AUM_10M();
    tabdata_add_points(&(tab_data.locals), 1);
    return tcfLocals;
}
t_cmdfnc CmdApply_INC_PLLP_LOC ()
{
    tabdata_add_pp(&(tab_data.locals));
    return tcfLocals;
}
t_cmdfnc CmdApply_DEC_PT_LOC ()
{
    if (flags.timeSetting) return CmdApply_DIM_10M();
    tabdata_add_points(&(tab_data.locals), -1);
    return tcfLocals;
}
t_cmdfnc CmdApply_DEC_PLLP_LOC ()
{
    tabdata_sub_pp(&(tab_data.locals));
    return tcfLocals;
}
t_cmdfnc CmdApply_INC_PT_OSP ()
{
    if (flags.timeSetting) return CmdApply_AUM_1S();
    tabdata_add_points(&(tab_data.guests), 1);
    return tcfGuests;
}
t_cmdfnc CmdApply_INC_PLLP_OSP ()
{
    tabdata_add_pp(&(tab_data.guests));
    return tcfGuests;
}
t_cmdfnc CmdApply_DEC_PT_OSP ()
{
    if (flags.timeSetting) return CmdApply_DIM_1S();
    tabdata_add_points(&(tab_data.guests), -1);
    return tcfGuests;
}
t_cmdfnc CmdApply_DEC_PLLP_OSP ()
{
    tabdata_sub_pp(&(tab_data.guests));
    return tcfGuests;
}
t_cmdfnc CmdApply_INC_SET_LOC ()
{
    if (flags.timeSetting) return CmdApply_AUM_1M();
    tabdata_add_sets(&(tab_data.locals), 1);
    return tcfLocals;
}
t_cmdfnc CmdApply_DEC_SET_LOC ()
{
    if (flags.timeSetting) return CmdApply_DIM_1M();
    tabdata_add_sets(&(tab_data.locals), -1);
    return tcfLocals;
}
t_cmdfnc CmdApply_INC_SET_OSP ()
{
    if (flags.timeSetting) return CmdApply_AUM_10S();
    tabdata_add_sets(&(tab_data.guests), 1);
    return tcfGuests;
}
t_cmdfnc CmdApply_DEC_SET_OSP ()
{
    if (flags.timeSetting) return CmdApply_DIM_10S();
    tabdata_add_sets(&(tab_data.guests), -1);
    return tcfGuests;
}
t_cmdfnc CmdApply_INC_LED_LOC ()
{
    tabdata_add_flag_seq(&(tab_data.locals));
    return tcfLocals;
}
t_cmdfnc CmdApply_DEC_LED_LOC ()
{
    tabdata_sub_flag_seq(&(tab_data.locals));
    return tcfLocals;
}
t_cmdfnc CmdApply_INC_LED_OSP ()
{
    tabdata_add_flag_seq(&(tab_data.guests));
    return tcfGuests;
}
t_cmdfnc CmdApply_DEC_LED_OSP ()
{
    tabdata_sub_flag_seq(&(tab_data.guests));
    return tcfGuests;
}
t_cmdfnc CmdApply_START ()
{
    if (flags.timeSetting)
        flags.timeSetting = 0;
        
    if (tabdata_time_is_not_null(&(tab_data.time)))
        flags.timeStarted = 1;
    
    return tcfTime;
}
t_cmdfnc CmdApply_PAUSE ()
{
    if (flags.timeSetting) return tcfNone;
    flags.timeStarted = 0;
    return tcfTime;
}
t_cmdfnc CmdApply_TIME_RESET ()
{
    flags.timeStarted = 0;
    tabdata_clear_time(&tab_data);
    
    return tcfTime;
}
t_cmdfnc CmdApply_TIME_SET ()
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
t_cmdfnc CmdApply_RES_PT_LOC ()
{
    tabdata_clear_team(&(tab_data.locals));
    return tcfLocals;
}
t_cmdfnc CmdApply_RES_PT_OSP ()
{
    tabdata_clear_team(&(tab_data.guests));
    return tcfGuests;
}
t_cmdfnc CmdApply_RESET ()
{
    if (flags.timeSetting) return tcfNone;

    flags.timeStarted = 0;
    tabdata_clear(&tab_data);

    return tcfAll;
}
t_cmdfnc CmdApply_HARD_RESET ()
{
    asm RESET;
    return tcfAll;
}
t_cmdfnc CmdApply_SALVASCHERMO ()
{
    return CmdApply_STANDBY();
}
t_cmdfnc CmdApply_STANDBY ()
{
    flags.timeStarted = 0;
    flags.inStandby = 1;
    pendingActions |= taClear;

    return tcfAll;
}
t_cmdfnc CmdApply_STANDBY_TELC ()
{
    return CmdApply_STANDBY();
}
t_cmdfnc CmdApply_INVERTI ()
{
    tabdata_swap(&tab_data);
    return tcfLocals & tcfGuests;
}
t_cmdfnc CmdApply_CLAXON ()
{
    configuration.UseClaxon = ! configuration.UseClaxon;
    flags.EEPROMSavePending = 1;
    pendingActions |= taNotifyClaxon;
    return tcfNone;
}
t_cmdfnc CmdApply_CLAXON_ALT ()
{
    return CmdApply_CLAXON();
}
t_cmdfnc CmdApply_PROVA_CLAXON ()
{
    pendingActions |= taTryClaxon;
    return tcfNone;
}
t_cmdfnc CmdApply_7F_LOC ()
{
    tabdata_toggle_flag(&(tab_data.locals), lfP7F);
    return tcfLocals;
}
t_cmdfnc CmdApply_7F_OSP ()
{
    tabdata_toggle_flag(&(tab_data.guests), lfP7F);
    return tcfGuests;
}
t_cmdfnc CmdApply_P1_LOC ()
{
    tabdata_toggle_flag(&(tab_data.locals), lfP1);
    return tcfLocals;
}
t_cmdfnc CmdApply_P1_OSP ()
{
    tabdata_toggle_flag(&(tab_data.guests), lfP1);
    return tcfGuests;
}
t_cmdfnc CmdApply_P2_LOC ()
{
    tabdata_toggle_flag(&(tab_data.locals), lfP2);
    return tcfLocals;
}
t_cmdfnc CmdApply_P2_OSP ()
{
    tabdata_toggle_flag(&(tab_data.guests), lfP2);
    return tcfGuests;
}
t_cmdfnc CmdApply_AUM_10M ()
{
    tabdata_add_min(&(tab_data.time), 10);
    return tcfTime;
}
t_cmdfnc CmdApply_DIM_10M ()
{
    tabdata_add_min(&(tab_data.time), -10);
    return tcfTime;
}
t_cmdfnc CmdApply_AUM_1M ()
{
    tabdata_add_min(&(tab_data.time), 1);
    return tcfTime;
}
t_cmdfnc CmdApply_DIM_1M ()
{
    tabdata_add_min(&(tab_data.time), -1);
    return tcfTime;
}
t_cmdfnc CmdApply_AUM_10S ()
{
    tabdata_add_sec(&(tab_data.time), 10);
    return tcfTime;
}
t_cmdfnc CmdApply_DIM_10S ()
{
    tabdata_add_sec(&(tab_data.time), -10);
    return tcfTime;
}
t_cmdfnc CmdApply_AUM_1S ()
{
    tabdata_add_sec(&(tab_data.time), 1);
    return tcfTime;
}
t_cmdfnc CmdApply_DIM_1S ()
{
    tabdata_add_sec(&(tab_data.time), -1);
    return tcfTime;
}
t_cmdfnc CmdApply_CHANNEL_TEST ()
{
    return tcfNone;
}
t_cmdfnc CmdApply_DEBUG_MODE ()
{
    return tcfNone;
}

#endif