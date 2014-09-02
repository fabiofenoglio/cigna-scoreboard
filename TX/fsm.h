#ifndef _incl_fsm_h
#define _incl_fsm_h

/* Dipendenze =============================================================== */
/* Costanti ================================================================= */
/* Tipi di dato ============================================================= */

typedef struct t_status_struct
{
    uint8              id;
    t_operation        (*execute_first)   ();
    struct t_status_struct *        
                       (*execute)         ();
    t_operation        (*execute_last)    ();

    #if DEBUG
    char*              name;
    #endif
}
t_status;

/* Prototipi ================================================================ */

t_status * fsm_current_status = NULL;
t_status * fsm_next_status =    NULL;

void       fsm_init            (t_status * first_instance);
t_status * fsm_status_new      (t_status * instance);
void       fsm_set_next_status (t_status * status);
void       fsm_loop            ();

/* Implementazioni ========================================================== */

void fsm_loop()
{
    if (fsm_next_status != fsm_current_status)
    {
        if (fsm_current_status != NULL &&
            fsm_current_status -> execute_last != NULL)
            fsm_current_status -> execute_last();

        if (fsm_next_status != NULL &&
            fsm_next_status -> execute_first != NULL)
            fsm_next_status -> execute_first();
    }

    fsm_current_status = fsm_next_status;

    if (fsm_current_status != NULL &&
        fsm_current_status -> execute != NULL)
    {
        fsm_set_next_status(fsm_current_status -> execute());
    }
}

void fsm_init(t_status * first_instance)
{
    fsm_current_status = NULL;
    fsm_set_next_status(first_instance);
}

t_status * fsm_status_new(t_status * instance)
{
    static status_id = 0;
    
    instance -> id =              status_id ++ ;
    instance -> execute_first =   NULL;
    instance -> execute =         NULL;
    instance -> execute_last =    NULL;
    
    return instance;
}

void fsm_set_next_status(t_status * status)
{
    fsm_next_status = status;
}

#endif