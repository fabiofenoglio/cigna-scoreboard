#ifndef _incl_flags_h
#define _incl_flags_h

/* Tipi di dato ============================================================= */

typedef struct t_flags_struct
{
    uint8 flags0;

    #define timeStarted               flags0.B0
    #define timeSetting               flags0.B1
    #define inStandby                 flags0.B2
    #define rxCmdPending              flags0.B4
    #define EEPROMSavePending         flags0.B5
    #define timedRoutinePending       flags0.B6

} t_flags;

typedef t_flags * t_flagsInstance;

/* Costanti ================================================================= */

typedef enum t_changed_flags_enum
{
    tcfNone          = 0,
    tcfLocals        = 1,
    tcfGuests        = 2,
    tcfTime          = 4,
    tcfAll           = 7

} t_changed_flags;

typedef enum t_action_enum
{
    taNone         = 0,
    taNotifyClaxon = 1,
    taTryClaxon    = 2,
    taTimeEnded    = 4,
    taClear        = 8

} t_action;

/* Prototipi ================================================================ */

void flags_new(t_flagsInstance instance);

/* Implementazioni ========================================================== */

void flags_new(t_flagsInstance instance)
{
    instance -> flags0 = 0;
}

#endif