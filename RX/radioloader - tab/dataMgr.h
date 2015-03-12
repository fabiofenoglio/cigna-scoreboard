#ifndef _incl_datamgr_h
#define _incl_datamgr_h

/* Costanti ================================================================= */

/* Codici dei comandi (usati nel programma per alcune verifiche):
 * (Comandi liberi:
 * 0, 1, 11, 13, 15, 17, 19, 21, 23, 25, 41, 53, 55, 57, 59, 61, 63)
 */

#define CmdCode_None                 0
#define CmdCode_INC_PT_LOC           2
#define CmdCode_INC_PLLP_LOC         3
#define CmdCode_DEC_PT_LOC           4
#define CmdCode_DEC_PLLP_LOC         5
#define CmdCode_INC_PT_OSP           6
#define CmdCode_INC_PLLP_OSP         7
#define CmdCode_DEC_PT_OSP           8
#define CmdCode_DEC_PLLP_OSP         9
#define CmdCode_INC_SET_LOC          10
#define CmdCode_DEC_SET_LOC          12
#define CmdCode_INC_SET_OSP          14
#define CmdCode_DEC_SET_OSP          16
#define CmdCode_INC_LED_LOC          18
#define CmdCode_DEC_LED_LOC          20
#define CmdCode_INC_LED_OSP          22
#define CmdCode_DEC_LED_OSP          24
#define CmdCode_START                26
#define CmdCode_DEBUG_MODE           27
#define CmdCode_PAUSE                28
#define CmdCode_STANDBY_TELC         29
#define CmdCode_TIME_RESET           30
#define CmdCode_CHANNEL_TEST         31
#define CmdCode_TIME_SET             32
#define CmdCode_CLAXON_ALT           33
#define CmdCode_RES_PT_LOC           34
#define CmdCode_RESET                35
#define CmdCode_RES_PT_OSP           36
#define CmdCode_HARD_RESET           37
#define CmdCode_STANDBY              38
#define CmdCode_SALVASCHERMO         39
#define CmdCode_INVERTI              40
#define CmdCode_CLAXON               42
#define CmdCode_PROVA_CLAXON         43
#define CmdCode_AUM_10M              44
#define CmdCode_DIM_10M              45
#define CmdCode_AUM_1M               46
#define CmdCode_DIM_1M               47
#define CmdCode_AUM_10S              48
#define CmdCode_DIM_10S              49
#define CmdCode_AUM_1S               50
#define CmdCode_DIM_1S               51
#define CmdCode_7F_LOC               52
#define CmdCode_7F_OSP               54
#define CmdCode_P1_LOC               56
#define CmdCode_P1_OSP               58
#define CmdCode_P2_LOC               60
#define CmdCode_P2_OSP               62

/* Tipi di dato ============================================================= */

typedef uint8 t_cmd;
typedef t_changed_flags t_cmdfnc;
typedef t_cmdfnc(*t_cmdfnc_ptr)();

/* Prototipi ================================================================ */

t_cmdfnc ApplyCmd(t_cmd cmd);

t_cmdfnc CmdApply_None               ();
t_cmdfnc CmdApply_INC_PT_LOC         ();
t_cmdfnc CmdApply_INC_PLLP_LOC       ();
t_cmdfnc CmdApply_DEC_PT_LOC         ();
t_cmdfnc CmdApply_DEC_PLLP_LOC       ();
t_cmdfnc CmdApply_INC_PT_OSP         ();
t_cmdfnc CmdApply_INC_PLLP_OSP       ();
t_cmdfnc CmdApply_DEC_PT_OSP         ();
t_cmdfnc CmdApply_DEC_PLLP_OSP       ();
t_cmdfnc CmdApply_INC_SET_LOC        ();
t_cmdfnc CmdApply_DEC_SET_LOC        ();
t_cmdfnc CmdApply_INC_SET_OSP        ();
t_cmdfnc CmdApply_DEC_SET_OSP        ();
t_cmdfnc CmdApply_INC_LED_LOC        ();
t_cmdfnc CmdApply_DEC_LED_LOC        ();
t_cmdfnc CmdApply_INC_LED_OSP        ();
t_cmdfnc CmdApply_DEC_LED_OSP        ();
t_cmdfnc CmdApply_START              ();
t_cmdfnc CmdApply_DEBUG_MODE         ();
t_cmdfnc CmdApply_PAUSE              ();
t_cmdfnc CmdApply_STANDBY_TELC       ();
t_cmdfnc CmdApply_TIME_RESET         ();
t_cmdfnc CmdApply_CHANNEL_TEST       ();
t_cmdfnc CmdApply_TIME_SET           ();
t_cmdfnc CmdApply_CLAXON_ALT         ();
t_cmdfnc CmdApply_RES_PT_LOC         ();
t_cmdfnc CmdApply_RESET              ();
t_cmdfnc CmdApply_RES_PT_OSP         ();
t_cmdfnc CmdApply_HARD_RESET         ();
t_cmdfnc CmdApply_STANDBY            ();
t_cmdfnc CmdApply_SALVASCHERMO       ();
t_cmdfnc CmdApply_INVERTI            ();
t_cmdfnc CmdApply_CLAXON             ();
t_cmdfnc CmdApply_PROVA_CLAXON       ();
t_cmdfnc CmdApply_AUM_10M            ();
t_cmdfnc CmdApply_DIM_10M            ();
t_cmdfnc CmdApply_AUM_1M             ();
t_cmdfnc CmdApply_DIM_1M             ();
t_cmdfnc CmdApply_AUM_10S            ();
t_cmdfnc CmdApply_DIM_10S            ();
t_cmdfnc CmdApply_AUM_1S             ();
t_cmdfnc CmdApply_DIM_1S             ();
t_cmdfnc CmdApply_7F_LOC             ();
t_cmdfnc CmdApply_7F_OSP             ();
t_cmdfnc CmdApply_P1_LOC             ();
t_cmdfnc CmdApply_P1_OSP             ();
t_cmdfnc CmdApply_P2_LOC             ();
t_cmdfnc CmdApply_P2_OSP             ();

t_cmdfnc_ptr ___datamgr_function_array[] =
{
    /*  0 */ CmdApply_None,
    /*  1 */ CmdApply_None,
    /*  2 */ CmdApply_INC_PT_LOC,
    /*  3 */ CmdApply_INC_PLLP_LOC,
    /*  4 */ CmdApply_DEC_PT_LOC,
    /*  5 */ CmdApply_DEC_PLLP_LOC,
    /*  6 */ CmdApply_INC_PT_OSP,
    /*  7 */ CmdApply_INC_PLLP_OSP,
    /*  8 */ CmdApply_DEC_PT_OSP,
    /*  9 */ CmdApply_DEC_PLLP_OSP,
    /* 10 */ CmdApply_INC_SET_LOC,
    /* 11 */ CmdApply_None,
    /* 12 */ CmdApply_DEC_SET_LOC,
    /* 13 */ CmdApply_None,
    /* 14 */ CmdApply_INC_SET_OSP,
    /* 15 */ CmdApply_None,
    /* 16 */ CmdApply_DEC_SET_OSP,
    /* 17 */ CmdApply_None,
    /* 18 */ CmdApply_INC_LED_LOC,
    /* 19 */ CmdApply_None,
    /* 20 */ CmdApply_DEC_LED_LOC,
    /* 21 */ CmdApply_None,
    /* 22 */ CmdApply_INC_LED_OSP,
    /* 23 */ CmdApply_None,
    /* 24 */ CmdApply_DEC_LED_OSP,
    /* 25 */ CmdApply_None,
    /* 26 */ CmdApply_START,
    /* 27 */ CmdApply_DEBUG_MODE,
    /* 28 */ CmdApply_PAUSE,
    /* 29 */ CmdApply_STANDBY_TELC,
    /* 30 */ CmdApply_TIME_RESET,
    /* 31 */ CmdApply_CHANNEL_TEST,
    /* 32 */ CmdApply_TIME_SET,
    /* 33 */ CmdApply_CLAXON_ALT,
    /* 34 */ CmdApply_RES_PT_LOC,
    /* 35 */ CmdApply_RESET,
    /* 36 */ CmdApply_RES_PT_OSP,
    /* 37 */ CmdApply_HARD_RESET,
    /* 38 */ CmdApply_STANDBY,
    /* 39 */ CmdApply_SALVASCHERMO,
    /* 40 */ CmdApply_INVERTI,
    /* 41 */ CmdApply_None,
    /* 42 */ CmdApply_CLAXON,
    /* 43 */ CmdApply_PROVA_CLAXON,
    /* 44 */ CmdApply_AUM_10M,
    /* 45 */ CmdApply_DIM_10M,
    /* 46 */ CmdApply_AUM_1M,
    /* 47 */ CmdApply_DIM_1M,
    /* 48 */ CmdApply_AUM_10S,
    /* 49 */ CmdApply_DIM_10S,
    /* 50 */ CmdApply_AUM_1S,
    /* 51 */ CmdApply_DIM_1S,
    /* 52 */ CmdApply_7F_LOC,
    /* 53 */ CmdApply_None,
    /* 54 */ CmdApply_7F_OSP,
    /* 55 */ CmdApply_None,
    /* 56 */ CmdApply_P1_LOC,
    /* 57 */ CmdApply_None,
    /* 58 */ CmdApply_P1_OSP,
    /* 59 */ CmdApply_None,
    /* 60 */ CmdApply_P2_LOC,
    /* 61 */ CmdApply_None,
    /* 62 */ CmdApply_P2_OSP,
    /* 63 */ CmdApply_None
};

#endif