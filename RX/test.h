#ifndef _incl_test_h
#define _incl_test_h

/* Prototipi ================================================================ */

void test_launch();
void debug_write_tab_data();

/* Implementazioni ========================================================== */

void test_refresh();

void test_launch()
{
    //hw_int_disable();

    while (1) { test_refresh(); Delay_ms(3000); }
}

void test_refresh()
{
    debug_write_tab_data();
}

void debug_write_tab_data()
{
    char line[100];
    sprinti(line, "(%i %3i) (%2i:%02i) (%3i %i)",
                  (int16)tab_data.locals.sets, (int16)tab_data.locals.points,
                  (int16)tab_data.time.min, (int16)tab_data.time.sec,
                  (int16)tab_data.guests.sets, (int16)tab_data.guests.points
    );
    debug_print(line);
}


#endif