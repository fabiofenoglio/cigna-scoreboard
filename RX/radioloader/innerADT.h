#ifndef _incl_innerADT_h
#define _incl_innerADT_h

/* Dipendenze =============================================================== */

#include <built_in.h>

/* Costanti ================================================================= */

const int16 TEAMS_MAX_POINTS = 199;
const int16 TEAMS_MAX_SETS =   9;
const int16 TEAMS_MAX_TIME =   (99*60);

/* Tipi di dato ============================================================= */

typedef struct t_timespanStruct
{
    uint8 min;
    uint8 sec;
    
} t_timespan;

typedef struct t_teamdataStruct
{
    uint8 points;
    uint8 sets;

    uint8 flags;

    #define P7F flags.B0
    #define P1 flags.B1
    #define P2 flags.B2
    
} t_teamdata;

typedef enum t_lightflags
{
    lfP7F = 1,
    lfP1  = 2,
    lfP2  = 4

} t_lightflags;

typedef struct t_tab_data_struct
{
    t_teamdata locals;
    t_teamdata guests;
    t_timespan time;

} t_tab_data;

/* Prototipi ================================================================ */

void    tabdata_new              (t_tab_data* instance);
#define tabdata_clear(instance)  tabdata_new(instance);

void    tabdata_clear_time       (t_tab_data* instance);
void    tabdata_clear_team       (t_teamdata* instance);

void    tabdata_add_sec          (t_timespan* instance, int8 toAdd);
void    tabdata_add_min          (t_timespan* instance, int8 toAdd);
short   tabdata_time_is_not_null (t_timespan* instance);

void    tabdata_add_points       (t_teamdata* instance, int8 toAdd);
void    tabdata_add_sets         (t_teamdata* instance, int8 toAdd);
void    tabdata_toggle_flag      (t_teamdata* instance, t_lightflags flag);
void    tabdata_add_pp           (t_teamdata* instance);
void    tabdata_sub_pp           (t_teamdata* instance);
void    tabdata_add_flag_seq     (t_teamdata* instance);
void    tabdata_sub_flag_seq     (t_teamdata* instance);
void    tabdata_swap             (t_tab_data* instance);

/* Implementazioni ========================================================== */

void tabdata_new(t_tab_data* instance)
{
    tabdata_clear_time(instance);
    tabdata_clear_team(&(instance -> locals));
    tabdata_clear_team(&(instance -> guests));
}

void tabdata_clear_time(t_tab_data* instance)
{
    instance -> time.min = 0;
    instance -> time.sec = 0;
}

void tabdata_clear_team(t_teamdata* instance)
{
    instance -> points = 0;
    instance -> sets = 0;
    instance -> flags = 0;
}

void tabdata_add_sec(t_timespan* instance, int8 toAdd)
{
    int16 act_timespan;
    act_timespan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);
    
    if (toAdd > 0)
    {
        if (act_timespan == TEAMS_MAX_TIME) act_timespan = 0;
        else
        {
            act_timespan += toAdd;
            if (act_timespan > TEAMS_MAX_TIME) act_timespan = TEAMS_MAX_TIME;
        }
    }
    else
    {
        if (act_timespan == 0) act_timespan = TEAMS_MAX_TIME;
        else
        {
            act_timespan += toAdd;
            if (act_timespan < 0) act_timespan = 0;
        }
    }
    
    instance -> min = act_timespan / 60;
    instance -> sec = act_timespan % 60;
}

void tabdata_add_min(t_timespan* instance, int8 toAdd)
{
    int16 act_timespan;
    act_timespan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);
    
    if (toAdd > 0)
    {
        if (act_timespan == TEAMS_MAX_TIME) act_timespan = 0;
        else
        {
            act_timespan += toAdd * 60;
            if (act_timespan > TEAMS_MAX_TIME) act_timespan = TEAMS_MAX_TIME;
        }
    }
    else
    {
        if (act_timespan == 0) act_timespan = TEAMS_MAX_TIME;
        else
        {
            act_timespan += toAdd * 60;
            if (act_timespan < 0) act_timespan = 0;
        }
    }

    instance -> min = act_timespan / 60;
    instance -> sec = act_timespan % 60;
}

int8 tabdata_time_is_not_null(t_timespan* instance)
{
    return ((instance -> min > 0) || (instance -> sec > 0));
}

void tabdata_add_points(t_teamdata* instance, int8 toAdd)
{
    int16 newPoints = (int16)(instance -> points);
    
    if (toAdd > 0)
    {
        if (newPoints == TEAMS_MAX_POINTS) newPoints = 0;
        else
        {
            newPoints += toAdd;
            if (newPoints > TEAMS_MAX_POINTS) newPoints = TEAMS_MAX_POINTS;
        }
    }
    else
    {
        if (newPoints == 0) newPoints = TEAMS_MAX_POINTS;
        else
        {
            newPoints += toAdd;
            if (newPoints < 0) newPoints = 0;
        }
    }

    instance -> points = Lo(newPoints);
}

void tabdata_add_sets(t_teamdata* instance, int8 toAdd)
{
    int16 newSets = (int16)(instance -> sets);

    if (toAdd > 0)
    {
        if (newSets == TEAMS_MAX_SETS) newSets = 0;
        else
        {
            newSets += toAdd;
            if (newSets > TEAMS_MAX_SETS) newSets = TEAMS_MAX_SETS;
        }
    }
    else
    {
        if (newSets == 0) newSets = TEAMS_MAX_SETS;
        else
        {
            newSets += toAdd;
            if (newSets < 0) newSets = 0;
        }
    }

    instance -> sets = Lo(newSets);
}

void tabdata_toggle_flag(t_teamdata* instance, t_lightflags flag)
{
    if (instance -> flags & flag) instance -> flags -= flag;
    else instance -> flags |= flag;
}

void tabdata_swap(t_tab_data* instance)
{
    t_teamdata swapInst;
    swapInst.points = instance -> locals -> points;
    swapInst.sets = instance -> locals -> sets;
    swapInst.flags = instance -> locals -> flags;
    
    instance -> locals.points = instance -> guests -> points;
    instance -> locals.sets = instance -> guests -> sets;
    instance -> locals.flags = instance -> guests -> flags;

    instance -> guests.points = swapInst.points;
    instance -> guests.sets = swapInst.sets;
    instance -> guests.flags = swapInst.flags;
}

void tabdata_add_pp(t_teamdata* instance)
{
    if (instance -> points < 15)
        instance -> points = 15;
    else if (instance -> points < 30)
        instance -> points = 30;
    else if (instance -> points < 40)
        instance -> points = 40;
    else
    {
        instance -> points = 0;
        tabdata_add_sets(instance, 1);
    }
}

void tabdata_sub_pp(t_teamdata* instance)
{
    if (instance -> points == 0)
    {
        tabdata_add_sets(instance, -1);
        instance -> points = 40;
    }
    else if (instance -> points < 15)
        instance -> points = 0;
    else if (instance -> points == 15)
        instance -> points = 0;
    else if (instance -> points <= 30)
        instance -> points = 15;
    else
        instance -> points = 30;
}

void tabdata_add_flag_seq(t_teamdata* instance)
{
    if (instance -> P2)
    {
        instance -> P1 = 0;
        instance -> P2 = 0;
        instance -> P7F = 0;
    }
    else if (instance -> P1) instance -> P2 = 1;
    else if (instance -> P7F) instance -> P1 = 1;
    else instance -> P7F = 1;
}

void tabdata_sub_flag_seq(t_teamdata* instance)
{
    if (instance -> P2) instance -> P2 = 0;
    else if (instance -> P1) instance -> P1 = 0;
    else if (instance -> P7F) instance -> P7F = 0;
    else
    {
        instance -> P1 = 1;
        instance -> P2 = 1;
        instance -> P7F = 1;
    }
}

#endif