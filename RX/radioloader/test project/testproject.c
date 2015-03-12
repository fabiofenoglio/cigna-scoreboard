// BOOTLOADER REQUIRED =========================================================
#pragma orgall 0x2C00
const unsigned char reservedpage[1024-8] = {0} absolute 0x1FC00;

void Vectors() org 0x2C00;
void bootloaderInit();
// =============================================================================

char ___debug_line[128];

#define debug_print(text) debug_uart_send_text(text)
#define debug_sprinti_1(format, a1) { sprinti(___debug_line, format, a1); debug_uart_send_text(___debug_line); }
#define debug_sprinti_2(format, a1,a2) { sprinti(___debug_line, format, a1,a2); debug_uart_send_text(___debug_line); }
#define debug_sprinti_3(format, a1,a2,a3) { sprinti(___debug_line, format, a1,a2,a3); debug_uart_send_text(___debug_line); }
#define debug_sprinti_4(format, a1,a2,a3,a4) { sprinti(___debug_line, format, a1,a2,a3,a4); debug_uart_send_text(___debug_line); }
#define debug_sprinti_5(format, a1,a2,a3,a4,a5) { sprinti(___debug_line, format, a1,a2,a3,a4,a5); debug_uart_send_text(___debug_line); }
#define debug_sprinti_6(format, a1,a2,a3,a4,a5,a6) { sprinti(___debug_line, format, a1,a2,a3,a4,a5,a6); debug_uart_send_text(___debug_line); }

#define ___DEBUG_PORT &PORTB
#define ___DEBUG_PIN_RX 6
#define ___DEBUG_PIN_TX 7
#define ___DEBUG_BAUDRATE 9600

//Declare needed functions
void main();
void debug_uart_send_text(char* text);

void interrupt() 
{
    asm NOP;
}

void interrupt_low() 
{
    asm NOP;
}

void main() 
{
    bootloaderInit();

    CM1CON.CON = 0;
    CM2CON.CON = 0;
    CM3CON.CON = 0;

    Soft_UART_Init(___DEBUG_PORT, ___DEBUG_PIN_RX, ___DEBUG_PIN_TX, ___DEBUG_BAUDRATE, 0);

    while (1) 
    {
        debug_print("User app is running !");
        Delay_ms(250);
    }
}

void debug_uart_send_text(char* text)
{
    unsigned short inten;
    unsigned short i;

    inten = INTCON & 0b11000000;
    INTCON &= 0b00111111;

    for (i = 0; text[i] != '\0'; i ++)
        Soft_uart_write(text[i]);
    Soft_uart_write(13);
    Soft_uart_write(10);

    INTCON = inten;
    Delay_ms(1);
}

// BOOTLOADER REQUIRED =========================================================
void Vectors() org 0x2C00
{
    int i;
    asm {
        goto   _main                   //0x2C00
        nop
        nop
        goto   _interrupt              //0x2C08
        nop
        nop
        nop
        nop
        nop
        nop
        goto   _interrupt_low          //0x2C18
    }
    for (i = 0; i < 100; i ++) PORTA = reservedpage[i];
}

void bootloaderInit()
{
    asm { goto SkipVectors }
    Vectors();
    asm { SkipVectors: }
}
// =============================================================================