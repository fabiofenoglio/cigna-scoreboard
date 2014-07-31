#ifndef _incl_flags_h
#define _incl_flags_h

/* Tipi di dato ============================================================= */

typedef struct TFlags_struct
{
    uint8 flags0;

    #define timeStarted               flags0.B0
    #define timeSetting               flags0.B1
    #define inStandby                 flags0.B2
    #define rxCmdPending              flags0.B4
    #define EEPROMSavePending         flags0.B5
    #define timedRoutinePending       flags0.B6

} TFlags;

typedef TFlags * TFlagsInstance;

/* Costanti ================================================================= */

typedef enum TChangedFlags_enum
{
    tcfNone          = 0,
    tcfLocals        = 1,
    tcfGuests        = 2,
    tcfTime          = 4,
    tcfAll           = 7

} TChangedFlags;

typedef enum TAction_enum
{
    taNone         = 0,
    taNotifyClaxon = 1,
    taTryClaxon    = 2,
    taTimeEnded    = 4,
    taClear        = 8

} TAction;

/* Prototipi ================================================================ */

void flags_new(TFlagsInstance instance);

/* Implementazioni ========================================================== */

void flags_new(TFlagsInstance instance)
{
    instance -> flags0 = 0;
}

#endif