#ifndef _incl_config_h
#define _incl_config_h

/* Costanti ================================================================= */

#define ___CONFIG_CELL_VALID_DATA 0x0000
#define ___CONFIG_CELL_D0 0x0010
#define ___CONFIG_VALID_CODE 18

/* Tipi di dato ============================================================= */

typedef struct TConfig_struct
{
    uint8 persistentFlags0;

    #define UseClaxon      persistentFlags0.B0

} TConfig;

typedef TConfig * TConfigInstance;

/* Prototipi ================================================================ */

void  config_new     (TConfigInstance instance);
void  config_save    (TConfigInstance instance);
int8  config_load    (TConfigInstance instance);

/* Implementazioni ========================================================== */

void config_new(TConfigInstance instance)
{
    instance -> persistentFlags0 = 0;
}

void config_save(TConfigInstance instance)
{
    emu_eeprom_wr(___CONFIG_CELL_D0, instance -> persistentFlags0, EMU_EEPROM_DO_NOT_COMMIT);
    emu_eeprom_wr(___CONFIG_CELL_VALID_DATA, ___CONFIG_VALID_CODE, EMU_EEPROM_COMMIT);
}

short config_load(TConfigInstance instance)
{
    if (emu_eeprom_rd(___CONFIG_CELL_VALID_DATA) != ___CONFIG_VALID_CODE) return 0;
    instance -> persistentFlags0 = emu_eeprom_rd(___CONFIG_CELL_D0);
}

#endif