#ifndef _DEBUG_H
#define _DEBUG_H

#if DEBUG

  #define ___DEBUG_PORT &PORTB
  #define ___DEBUG_PIN_RX 6
  #define ___DEBUG_PIN_TX 7
  #define ___DEBUG_BAUDRATE 9600
  
  void debug_uart_init()
  {
      Soft_uart_init(___DEBUG_PORT, 
                     ___DEBUG_PIN_RX,
                     ___DEBUG_PIN_TX,
                     ___DEBUG_BAUDRATE, 0);
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

  char ___debug_line[128];

  #define debug_print(text) debug_uart_send_text(text)
  #define debug_sprinti_1(format, a1) { sprinti(___debug_line, format, a1); debug_uart_send_text(___debug_line); }
  #define debug_sprinti_2(format, a1,a2) { sprinti(___debug_line, format, a1,a2); debug_uart_send_text(___debug_line); }
  #define debug_sprinti_3(format, a1,a2,a3) { sprinti(___debug_line, format, a1,a2,a3); debug_uart_send_text(___debug_line); }
  #define debug_sprinti_4(format, a1,a2,a3,a4) { sprinti(___debug_line, format, a1,a2,a3,a4); debug_uart_send_text(___debug_line); }
  #define debug_sprinti_5(format, a1,a2,a3,a4,a5) { sprinti(___debug_line, format, a1,a2,a3,a4,a5); debug_uart_send_text(___debug_line); }
  #define debug_sprinti_6(format, a1,a2,a3,a4,a5,a6) { sprinti(___debug_line, format, a1,a2,a3,a4,a5,a6); debug_uart_send_text(___debug_line); }

#endif

#endif