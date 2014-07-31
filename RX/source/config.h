#ifndef _incl_config_h
#define _incl_config_h

/* Costanti ================================================================= */

#define ___CONFIG_CELL_VALID_DATA 0x0000
#define ___CONFIG_CELL_D0 0x0010
#define ___CONFIG_VALID_CODE 18

/* Tipi di dato ============================================================= */

typedef struct t_config_struct
{
    uint8 persistentFlags0;

    #define UseClaxon      persistentFlags0.B0

} t_config;

typedef t_config * t_configInstance;

/* Prototipi ================================================================ */

void    config_new     (t_configInstance instance);
void    config_save    (t_configInstance instance);
t_bool  config_load    (t_configInstance instance);

/* Implementazioni ========================================================== */

void config_new(t_configInstance instance)
{
    instance -> persistentFlags0 = 0;
}

void config_save(t_configInstance instance)
{
    emu_eeprom_wr(___CONFIG_CELL_D0, instance -> persistentFlags0, EMU_EEPROM_DO_NOT_COMMIT);
    emu_eeprom_wr(___CONFIG_CELL_VALID_DATA, ___CONFIG_VALID_CODE, EMU_EEPROM_COMMIT);
}

t_bool config_load(t_configInstance instance)
{
    if (emu_eeprom_rd(___CONFIG_CELL_VALID_DATA) != ___CONFIG_VALID_CODE) return FALSE;
    instance -> persistentFlags0 = emu_eeprom_rd(___CONFIG_CELL_D0);
    return TRUE;
}

#endif