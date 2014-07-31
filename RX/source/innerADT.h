#ifndef _incl_innerADT_h
#define _incl_innerADT_h

/* Dipendenze =============================================================== */

#include <built_in.h>

/* Costanti ================================================================= */

const int16 TEAMS_MAX_POINTS = 199;
const int16 TEAMS_MAX_SETS =   9;
const int16 TEAMS_MAX_TIME =   (99*60);

/* Tipi di dato ============================================================= */

typedef struct TTimeSpanStruct
{
    uint8 min;
    uint8 sec;
    
} TTimeSpan;

typedef struct TTeamDataStruct
{
    uint8 points;
    uint8 sets;

    uint8 flags;

    #define P7F flags.B0
    #define P1 flags.B1
    #define P2 flags.B2
    
} TTeamData;

typedef enum TLightFlags
{
    lfP7F = 1,
    lfP1  = 2,
    lfP2  = 4

} TLightFlags;

typedef struct TTabData_struct
{
    TTeamData locals;
    TTeamData guests;
    TTimeSpan time;

} TTabData;

/* Prototipi ================================================================ */

void    tabdata_new              (TTabData* instance);
#define tabdata_clear(instance)  tabdata_new(instance);

void    tabdata_clear_time       (TTabData* instance);
void    tabdata_clear_team       (TTeamData* instance);

void    tabdata_add_sec          (TTimeSpan* instance, int8 toAdd);
void    tabdata_add_min          (TTimeSpan* instance, int8 toAdd);
short   tabdata_time_is_not_null (TTimeSpan* instance);

void    tabdata_add_points       (TTeamData* instance, int8 toAdd);
void    tabdata_add_sets         (TTeamData* instance, int8 toAdd);
void    tabdata_toggle_flag      (TTeamData* instance, TLightFlags flag);
void    tabdata_add_pp           (TTeamData* instance);
void    tabdata_sub_pp           (TTeamData* instance);
void    tabdata_add_flag_seq     (TTeamData* instance);
void    tabdata_sub_flag_seq     (TTeamData* instance);
void    tabdata_swap             (TTabData* instance);

/* Implementazioni ========================================================== */

void tabdata_new(TTabData* instance)
{
    tabdata_clear_time(instance);
    tabdata_clear_team(&(instance -> locals));
    tabdata_clear_team(&(instance -> guests));
}

void tabdata_clear_time(TTabData* instance)
{
    instance -> time.min = 0;
    instance -> time.sec = 0;
}

void tabdata_clear_team(TTeamData* instance)
{
    instance -> points = 0;
    instance -> sets = 0;
    instance -> flags = 0;
}

void tabdata_add_sec(TTimeSpan* instance, int8 toAdd)
{
    int16 acTTimeSpan;
    acTTimeSpan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);
    
    if (toAdd > 0)
    {
        if (acTTimeSpan == TEAMS_MAX_TIME) acTTimeSpan = 0;
        else
        {
            acTTimeSpan += toAdd;
            if (acTTimeSpan > TEAMS_MAX_TIME) acTTimeSpan = TEAMS_MAX_TIME;
        }
    }
    else
    {
        if (acTTimeSpan == 0) acTTimeSpan = TEAMS_MAX_TIME;
        else
        {
            acTTimeSpan += toAdd;
            if (acTTimeSpan < 0) acTTimeSpan = 0;
        }
    }
    
    instance -> min = acTTimeSpan / 60;
    instance -> sec = acTTimeSpan % 60;
}

void tabdata_add_min(TTimeSpan* instance, int8 toAdd)
{
    int16 acTTimeSpan;
    acTTimeSpan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);
    
    if (toAdd > 0)
    {
        if (acTTimeSpan == TEAMS_MAX_TIME) acTTimeSpan = 0;
        else
        {
            acTTimeSpan += toAdd * 60;
            if (acTTimeSpan > TEAMS_MAX_TIME) acTTimeSpan = TEAMS_MAX_TIME;
        }
    }
    else
    {
        if (acTTimeSpan == 0) acTTimeSpan = TEAMS_MAX_TIME;
        else
        {
            acTTimeSpan += toAdd * 60;
            if (acTTimeSpan < 0) acTTimeSpan = 0;
        }
    }

    instance -> min = acTTimeSpan / 60;
    instance -> sec = acTTimeSpan % 60;
}

int8 tabdata_time_is_not_null(TTimeSpan* instance)
{
    return ((instance -> min > 0) || (instance -> sec > 0));
}

void tabdata_add_points(TTeamData* instance, int8 toAdd)
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

void tabdata_add_sets(TTeamData* instance, int8 toAdd)
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

void tabdata_toggle_flag(TTeamData* instance, TLightFlags flag)
{
    if (instance -> flags & flag) instance -> flags -= flag;
    else instance -> flags |= flag;
}

void tabdata_swap(TTabData* instance)
{
    TTeamData swapInst;
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

void tabdata_add_pp(TTeamData* instance)
{
    if      (instance -> points < 15)
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

void tabdata_sub_pp(TTeamData* instance)
{
    if      (instance -> points == 0)
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

void tabdata_add_flag_seq(TTeamData* instance)
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

void tabdata_sub_flag_seq(TTeamData* instance)
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