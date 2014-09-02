#ifndef _incl_keypad_h
#define _incl_keypad_h

/* Dipendenze =============================================================== */
/* Costanti ================================================================= */

#define KEYPAD_COLUMN_ENABLED        1
#define KEYPAD_COLUMN_DISABLED       0

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
/* Prototipi ================================================================ */

uint8  keypad_read();
t_bool keypad_something_pressed();
void   keypad_set_columns(uint8 state, t_bool delay);
void   ___keypad_delay_columns_settling();

/* Implementazioni ========================================================== */

void ___keypad_delay_columns_settling()
{
    Delay_us(200);
}

void keypad_set_columns(uint8 state, t_bool delay)
{
    KP_OUT_1 = state;
    KP_OUT_2 = state;
    KP_OUT_3 = state;
    KP_OUT_4 = state;
    KP_OUT_5 = state;
    KP_OUT_6 = state;
    if (delay) ___keypad_delay_columns_settling();
}

t_bool keypad_something_pressed()
{
    uint8 res;
    
    keypad_set_columns(KEYPAD_COLUMN_ENABLED, TRUE);
    
    res = (KP_IN_1 || KP_IN_2 || KP_IN_3 || KP_IN_4 || KP_IN_5) ? TRUE : FALSE;
    
    keypad_set_columns(KEYPAD_COLUMN_DISABLED, FALSE);

    return res;
}

uint8 ___wrapped_keypad_read()
{
    t_bool function_pressed;
    if (! keypad_something_pressed()) return CmdCode_None;
    
    // TODO read function button
    function_pressed = FALSE;
    
    KP_OUT_2 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_3 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_4 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_5 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_6 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_1 = KEYPAD_COLUMN_ENABLED;
    ___keypad_delay_columns_settling();
    if (KP_IN_1 == KEYPAD_COLUMN_ENABLED) return 1 + function_pressed;
    if (KP_IN_2 == KEYPAD_COLUMN_ENABLED) return 3 + function_pressed;
    if (KP_IN_3 == KEYPAD_COLUMN_ENABLED) return 5 + function_pressed;
    if (KP_IN_4 == KEYPAD_COLUMN_ENABLED) return 7 + function_pressed;
    if (KP_IN_5 == KEYPAD_COLUMN_ENABLED) return 9 + function_pressed;

    KP_OUT_1 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_2 = KEYPAD_COLUMN_ENABLED;
    ___keypad_delay_columns_settling();
    if (KP_IN_1 == KEYPAD_COLUMN_ENABLED) return 11 + function_pressed;
    if (KP_IN_2 == KEYPAD_COLUMN_ENABLED) return 13 + function_pressed;
    if (KP_IN_3 == KEYPAD_COLUMN_ENABLED) return 15 + function_pressed;
    if (KP_IN_4 == KEYPAD_COLUMN_ENABLED) return 17 + function_pressed;
    if (KP_IN_5 == KEYPAD_COLUMN_ENABLED) return 19 + function_pressed;
    
    KP_OUT_2 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_3 = KEYPAD_COLUMN_ENABLED;
    ___keypad_delay_columns_settling();
    if (KP_IN_1 == KEYPAD_COLUMN_ENABLED) return 21 + function_pressed;
    if (KP_IN_2 == KEYPAD_COLUMN_ENABLED) return 23 + function_pressed;
    if (KP_IN_3 == KEYPAD_COLUMN_ENABLED) return 25 + function_pressed;
    if (KP_IN_4 == KEYPAD_COLUMN_ENABLED) return 27 + function_pressed;
    if (KP_IN_5 == KEYPAD_COLUMN_ENABLED) return 29 + function_pressed;

    KP_OUT_3 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_4 = KEYPAD_COLUMN_ENABLED;
    ___keypad_delay_columns_settling();
    if (KP_IN_1 == KEYPAD_COLUMN_ENABLED) return 31 + function_pressed;
    if (KP_IN_2 == KEYPAD_COLUMN_ENABLED) return 33 + function_pressed;
    if (KP_IN_3 == KEYPAD_COLUMN_ENABLED) return 35 + function_pressed;
    if (KP_IN_4 == KEYPAD_COLUMN_ENABLED) return 37 + function_pressed;
    if (KP_IN_5 == KEYPAD_COLUMN_ENABLED) return 39 + function_pressed;

    KP_OUT_4 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_5 = KEYPAD_COLUMN_ENABLED;
    ___keypad_delay_columns_settling();
    if (KP_IN_1 == KEYPAD_COLUMN_ENABLED) return 41 + function_pressed;
    if (KP_IN_2 == KEYPAD_COLUMN_ENABLED) return 43 + function_pressed;
    if (KP_IN_3 == KEYPAD_COLUMN_ENABLED) return 45 + function_pressed;
    if (KP_IN_4 == KEYPAD_COLUMN_ENABLED) return 47 + function_pressed;
    if (KP_IN_5 == KEYPAD_COLUMN_ENABLED) return 49 + function_pressed;

    KP_OUT_5 = KEYPAD_COLUMN_DISABLED;
    KP_OUT_6 = KEYPAD_COLUMN_ENABLED;
    ___keypad_delay_columns_settling();
    if (KP_IN_1 == KEYPAD_COLUMN_ENABLED) return 51 + function_pressed;
    if (KP_IN_2 == KEYPAD_COLUMN_ENABLED) return 53 + function_pressed;
    if (KP_IN_3 == KEYPAD_COLUMN_ENABLED) return 55 + function_pressed;
    if (KP_IN_4 == KEYPAD_COLUMN_ENABLED) return 57 + function_pressed;
    if (KP_IN_5 == KEYPAD_COLUMN_ENABLED) return 59 + function_pressed;

    KP_OUT_6 = KEYPAD_COLUMN_DISABLED;
    
    return CmdCode_None;
}

uint8 keypad_read()
{
    uint8 res = ___wrapped_keypad_read();
    keypad_set_columns(KEYPAD_COLUMN_DISABLED, FALSE);
    return res;
}

#endif