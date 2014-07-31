
_debug_uart_init:

;debug.h,6 :: 		void debug_uart_init()
;debug.h,8 :: 		Soft_uart_init(&PORTB, 6, 7, 9600, 0);
	MOVLW       PORTB+0
	MOVWF       FARG_Soft_UART_Init_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Soft_UART_Init_port+1 
	MOVLW       6
	MOVWF       FARG_Soft_UART_Init_rx_pin+0 
	MOVLW       7
	MOVWF       FARG_Soft_UART_Init_tx_pin+0 
	MOVLW       128
	MOVWF       FARG_Soft_UART_Init_baud_rate+0 
	MOVLW       37
	MOVWF       FARG_Soft_UART_Init_baud_rate+1 
	MOVLW       0
	MOVWF       FARG_Soft_UART_Init_baud_rate+2 
	MOVWF       FARG_Soft_UART_Init_baud_rate+3 
	CLRF        FARG_Soft_UART_Init_inverted+0 
	CALL        _Soft_UART_Init+0, 0
;debug.h,9 :: 		}
L_end_debug_uart_init:
	RETURN      0
; end of _debug_uart_init

_debug_uart_send_text:

;debug.h,11 :: 		void debug_uart_send_text(char* text)
;debug.h,16 :: 		inten = INTCON & 0b11000000;
	MOVLW       192
	ANDWF       INTCON+0, 0 
	MOVWF       debug_uart_send_text_inten_L0+0 
;debug.h,17 :: 		INTCON &= 0b00111111;
	MOVLW       63
	ANDWF       INTCON+0, 1 
;debug.h,19 :: 		for (i = 0; i < 20; i ++) Soft_uart_write('-');
	CLRF        debug_uart_send_text_i_L0+0 
L_debug_uart_send_text0:
	MOVLW       20
	SUBWF       debug_uart_send_text_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_debug_uart_send_text1
	MOVLW       45
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
	INCF        debug_uart_send_text_i_L0+0, 1 
	GOTO        L_debug_uart_send_text0
L_debug_uart_send_text1:
;debug.h,21 :: 		for (i = 0; text[i] != '\0'; i ++)
	CLRF        debug_uart_send_text_i_L0+0 
L_debug_uart_send_text3:
	MOVF        debug_uart_send_text_i_L0+0, 0 
	ADDWF       FARG_debug_uart_send_text_text+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_debug_uart_send_text_text+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_debug_uart_send_text4
;debug.h,22 :: 		Soft_uart_write(text[i]);
	MOVF        debug_uart_send_text_i_L0+0, 0 
	ADDWF       FARG_debug_uart_send_text_text+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_debug_uart_send_text_text+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;debug.h,21 :: 		for (i = 0; text[i] != '\0'; i ++)
	INCF        debug_uart_send_text_i_L0+0, 1 
;debug.h,22 :: 		Soft_uart_write(text[i]);
	GOTO        L_debug_uart_send_text3
L_debug_uart_send_text4:
;debug.h,23 :: 		Soft_uart_write(13);
	MOVLW       13
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;debug.h,24 :: 		Soft_uart_write(10);
	MOVLW       10
	MOVWF       FARG_Soft_UART_Write_udata+0 
	CALL        _Soft_UART_Write+0, 0
;debug.h,26 :: 		INTCON = inten;
	MOVF        debug_uart_send_text_inten_L0+0, 0 
	MOVWF       INTCON+0 
;debug.h,27 :: 		Delay_ms(10);
	MOVLW       156
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_debug_uart_send_text6:
	DECFSZ      R13, 1, 1
	BRA         L_debug_uart_send_text6
	DECFSZ      R12, 1, 1
	BRA         L_debug_uart_send_text6
;debug.h,28 :: 		}
L_end_debug_uart_send_text:
	RETURN      0
; end of _debug_uart_send_text

_hw_init:

;hardware.h,74 :: 		void hw_init()
;hardware.h,78 :: 		ANCON0 = 0xFF;
	MOVLW       255
	MOVWF       ANCON0+0 
;hardware.h,79 :: 		ANCON1 = 0x1F;
	MOVLW       31
	MOVWF       ANCON1+0 
;hardware.h,85 :: 		T1CON = 0b10001111;
	MOVLW       143
	MOVWF       T1CON+0 
;hardware.h,90 :: 		T0CON = 0b11010101;
	MOVLW       213
	MOVWF       T0CON+0 
;hardware.h,94 :: 		RCON.IPEN = 1;
	BSF         RCON+0, 7 
;hardware.h,96 :: 		IPR1.TMR1IP = INTERRUPT_PRIORITY_HIGH;
	BSF         IPR1+0, 0 
;hardware.h,97 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;hardware.h,98 :: 		PIE1.TMR1IE = 1;
	BSF         PIE1+0, 0 
;hardware.h,100 :: 		INTCON2.TMR0IP = INTERRUPT_PRIORITY_LOW;
	BCF         INTCON2+0, 2 
;hardware.h,101 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;hardware.h,102 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;hardware.h,105 :: 		Unlock_IOLOCK();
	CALL        _Unlock_IOLOCK+0, 0
;hardware.h,106 :: 		PPS_Mapping_NoLock(4, _INPUT, _SDI2);
	MOVLW       4
	MOVWF       FARG_PPS_Mapping_NoLock_rp_num+0 
	MOVLW       1
	MOVWF       FARG_PPS_Mapping_NoLock_input_output+0 
	MOVLW       14
	MOVWF       FARG_PPS_Mapping_NoLock_funct_name+0 
	CALL        _PPS_Mapping_NoLock+0, 0
;hardware.h,107 :: 		PPS_Mapping_NoLock(5, _OUTPUT, _SCK2);
	MOVLW       5
	MOVWF       FARG_PPS_Mapping_NoLock_rp_num+0 
	CLRF        FARG_PPS_Mapping_NoLock_input_output+0 
	MOVLW       11
	MOVWF       FARG_PPS_Mapping_NoLock_funct_name+0 
	CALL        _PPS_Mapping_NoLock+0, 0
;hardware.h,108 :: 		PPS_Mapping_NoLock(18, _OUTPUT, _SDO2);
	MOVLW       18
	MOVWF       FARG_PPS_Mapping_NoLock_rp_num+0 
	CLRF        FARG_PPS_Mapping_NoLock_input_output+0 
	MOVLW       10
	MOVWF       FARG_PPS_Mapping_NoLock_funct_name+0 
	CALL        _PPS_Mapping_NoLock+0, 0
;hardware.h,109 :: 		Lock_IOLOCK();
	CALL        _Lock_IOLOCK+0, 0
;hardware.h,112 :: 		_SPI_REMAPPABLE_MASTER_OSC_DIV16,
	MOVLW       1
	MOVWF       FARG_SPI_Remappable_Init_Advanced_master+0 
;hardware.h,113 :: 		_SPI_REMAPPABLE_DATA_SAMPLE_MIDDLE,
	CLRF        FARG_SPI_Remappable_Init_Advanced_data_sample+0 
;hardware.h,114 :: 		_SPI_REMAPPABLE_CLK_IDLE_LOW,
	CLRF        FARG_SPI_Remappable_Init_Advanced_clock_idle+0 
;hardware.h,115 :: 		_SPI_REMAPPABLE_LOW_2_HIGH
	MOVLW       1
	MOVWF       FARG_SPI_Remappable_Init_Advanced_transmit_edge+0 
	CALL        _SPI_Remappable_Init_Advanced+0, 0
;hardware.h,119 :: 		PIN_DBG_0 = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;hardware.h,120 :: 		PIN_DBG_0_Dir = OUTPUT;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;hardware.h,122 :: 		}
L_end_hw_init:
	RETURN      0
; end of _hw_init

_hw_int_enable:

;hardware.h,124 :: 		void hw_int_enable()
;hardware.h,126 :: 		INTCON.GIEH = 1;
	BSF         INTCON+0, 7 
;hardware.h,127 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;hardware.h,128 :: 		}
L_end_hw_int_enable:
	RETURN      0
; end of _hw_int_enable

_hw_int_disable:

;hardware.h,130 :: 		void hw_int_disable()
;hardware.h,132 :: 		INTCON.GIEH = 0;
	BCF         INTCON+0, 7 
;hardware.h,133 :: 		INTCON.GIEL = 0;
	BCF         INTCON+0, 6 
;hardware.h,134 :: 		}
L_end_hw_int_disable:
	RETURN      0
; end of _hw_int_disable

_hw_get_reset_reason:

;hardware.h,136 :: 		TResetReason hw_get_reset_reason()
;hardware.h,138 :: 		if (! RCON.TO_) return WDTReset;
	BTFSC       RCON+0, 3 
	GOTO        L_hw_get_reset_reason7
	MOVLW       2
	MOVWF       R0 
	GOTO        L_end_hw_get_reset_reason
L_hw_get_reset_reason7:
;hardware.h,139 :: 		if (! RCON.PD) return PowerDownReset;
	BTFSC       RCON+0, 2 
	GOTO        L_hw_get_reset_reason8
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_hw_get_reset_reason
L_hw_get_reset_reason8:
;hardware.h,141 :: 		if (! RCON.RI)
	BTFSC       RCON+0, 4 
	GOTO        L_hw_get_reset_reason9
;hardware.h,143 :: 		RCON.RI = 1;
	BSF         RCON+0, 4 
;hardware.h,144 :: 		return SelfReset;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_hw_get_reset_reason
;hardware.h,145 :: 		}
L_hw_get_reset_reason9:
;hardware.h,147 :: 		if (! RCON.BOR)
	BTFSC       RCON+0, 0 
	GOTO        L_hw_get_reset_reason10
;hardware.h,149 :: 		RCON.BOR = 1;
	BSF         RCON+0, 0 
;hardware.h,150 :: 		if (RCON.POR) return BrownOutReset;
	BTFSS       RCON+0, 1 
	GOTO        L_hw_get_reset_reason11
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_hw_get_reset_reason
L_hw_get_reset_reason11:
;hardware.h,151 :: 		}
L_hw_get_reset_reason10:
;hardware.h,153 :: 		if (! RCON.POR) RCON.POR = 1;
	BTFSC       RCON+0, 1 
	GOTO        L_hw_get_reset_reason12
	BSF         RCON+0, 1 
L_hw_get_reset_reason12:
;hardware.h,154 :: 		return NormalReset;
	CLRF        R0 
;hardware.h,155 :: 		}
L_end_hw_get_reset_reason:
	RETURN      0
; end of _hw_get_reset_reason

_nrf_init:

;f_nrf24l01p.h,199 :: 		void nrf_init()
;f_nrf24l01p.h,201 :: 		NRF_IRQ_DIR = 1;
	BSF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
;f_nrf24l01p.h,203 :: 		NRF_CE = 0;
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;f_nrf24l01p.h,204 :: 		NRF_CE_DIR =  0;
	BCF         TRISB3_bit+0, BitPos(TRISB3_bit+0) 
;f_nrf24l01p.h,206 :: 		NRF_CSN = 1;
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;f_nrf24l01p.h,207 :: 		NRF_CSN_DIR = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;f_nrf24l01p.h,209 :: 		___nrf_delay_poweron();
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       79
	MOVWF       R12, 0
	MOVLW       25
	MOVWF       R13, 0
L_nrf_init13:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_init13
	DECFSZ      R12, 1, 1
	BRA         L_nrf_init13
	DECFSZ      R11, 1, 1
	BRA         L_nrf_init13
	NOP
	NOP
;f_nrf24l01p.h,210 :: 		nrf_set_power(NRFCFG_POWER_DOWN);
	CLRF        FARG_nrf_set_power_power+0 
	CALL        _nrf_set_power+0, 0
;f_nrf24l01p.h,211 :: 		nrf_flush_tx();
	CALL        _nrf_flush_tx+0, 0
;f_nrf24l01p.h,212 :: 		nrf_flush_rx();
	CALL        _nrf_flush_rx+0, 0
;f_nrf24l01p.h,213 :: 		}
L_end_nrf_init:
	RETURN      0
; end of _nrf_init

_nrf_tx_send_packet:

;f_nrf24l01p.h,215 :: 		uint8 nrf_tx_send_packet(uint8 size, uint8 * buffer, uint8 wait)
;f_nrf24l01p.h,217 :: 		nrf_write_payload(size, buffer);
	MOVF        FARG_nrf_tx_send_packet_size+0, 0 
	MOVWF       FARG_nrf_write_payload_size+0 
	MOVF        FARG_nrf_tx_send_packet_buffer+0, 0 
	MOVWF       FARG_nrf_write_payload_buffer+0 
	MOVF        FARG_nrf_tx_send_packet_buffer+1, 0 
	MOVWF       FARG_nrf_write_payload_buffer+1 
	CALL        _nrf_write_payload+0, 0
;f_nrf24l01p.h,218 :: 		return nrf_tx_send_current(wait);
	MOVF        FARG_nrf_tx_send_packet_wait+0, 0 
	MOVWF       FARG_nrf_tx_send_current_wait+0 
	CALL        _nrf_tx_send_current+0, 0
;f_nrf24l01p.h,219 :: 		}
L_end_nrf_tx_send_packet:
	RETURN      0
; end of _nrf_tx_send_packet

_nrf_tx_send_current:

;f_nrf24l01p.h,221 :: 		uint8 nrf_tx_send_current(uint8 wait)
;f_nrf24l01p.h,225 :: 		___nrf_ce_pulse();
	BSF         LATB3_bit+0, BitPos(LATB3_bit+0) 
	MOVLW       47
	MOVWF       R13, 0
L_nrf_tx_send_current14:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_tx_send_current14
	NOP
	NOP
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;f_nrf24l01p.h,226 :: 		if (! wait) return 1;
	MOVF        FARG_nrf_tx_send_current_wait+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_nrf_tx_send_current15
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_nrf_tx_send_current
L_nrf_tx_send_current15:
;f_nrf24l01p.h,228 :: 		while (1)
L_nrf_tx_send_current16:
;f_nrf24l01p.h,230 :: 		status = ___nrf_read_command(NRFCMD_NOP, 0, 0);
	MOVLW       255
	MOVWF       FARG____nrf_read_command_cmd+0 
	CLRF        FARG____nrf_read_command_numbytes+0 
	CLRF        FARG____nrf_read_command_buffer+0 
	CLRF        FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
	MOVF        R0, 0 
	MOVWF       nrf_tx_send_current_status_L0+0 
;f_nrf24l01p.h,231 :: 		if (status.B5)
	BTFSS       nrf_tx_send_current_status_L0+0, 5 
	GOTO        L_nrf_tx_send_current18
;f_nrf24l01p.h,233 :: 		nrf_clear_interrupts(NRFCFG_TX_INTERRUPT);
	MOVLW       2
	MOVWF       FARG_nrf_clear_interrupts_interrupts+0 
	CALL        _nrf_clear_interrupts+0, 0
;f_nrf24l01p.h,234 :: 		status = 1;
	MOVLW       1
	MOVWF       nrf_tx_send_current_status_L0+0 
;f_nrf24l01p.h,235 :: 		break;
	GOTO        L_nrf_tx_send_current17
;f_nrf24l01p.h,236 :: 		}
L_nrf_tx_send_current18:
;f_nrf24l01p.h,237 :: 		if (status.B4)
	BTFSS       nrf_tx_send_current_status_L0+0, 4 
	GOTO        L_nrf_tx_send_current19
;f_nrf24l01p.h,239 :: 		nrf_clear_interrupts(NRFCFG_MAXRETRIES_INTERRUPT);
	MOVLW       4
	MOVWF       FARG_nrf_clear_interrupts_interrupts+0 
	CALL        _nrf_clear_interrupts+0, 0
;f_nrf24l01p.h,240 :: 		status = 0;
	CLRF        nrf_tx_send_current_status_L0+0 
;f_nrf24l01p.h,241 :: 		break;
	GOTO        L_nrf_tx_send_current17
;f_nrf24l01p.h,242 :: 		}
L_nrf_tx_send_current19:
;f_nrf24l01p.h,243 :: 		}
	GOTO        L_nrf_tx_send_current16
L_nrf_tx_send_current17:
;f_nrf24l01p.h,244 :: 		return status;
	MOVF        nrf_tx_send_current_status_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,245 :: 		}
L_end_nrf_tx_send_current:
	RETURN      0
; end of _nrf_tx_send_current

_nrf_tx_packet_failed:

;f_nrf24l01p.h,247 :: 		uint8 nrf_tx_packet_failed()
;f_nrf24l01p.h,249 :: 		uint8 status = ___nrf_read_command(NRFCMD_NOP, 0, 0);
	MOVLW       255
	MOVWF       FARG____nrf_read_command_cmd+0 
	CLRF        FARG____nrf_read_command_numbytes+0 
	CLRF        FARG____nrf_read_command_buffer+0 
	CLRF        FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
	MOVF        R0, 0 
	MOVWF       nrf_tx_packet_failed_status_L0+0 
;f_nrf24l01p.h,250 :: 		if (status.B4)
	BTFSS       nrf_tx_packet_failed_status_L0+0, 4 
	GOTO        L_nrf_tx_packet_failed20
;f_nrf24l01p.h,252 :: 		nrf_clear_interrupts(NRFCFG_MAXRETRIES_INTERRUPT);
	MOVLW       4
	MOVWF       FARG_nrf_clear_interrupts_interrupts+0 
	CALL        _nrf_clear_interrupts+0, 0
;f_nrf24l01p.h,253 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_nrf_tx_packet_failed
;f_nrf24l01p.h,254 :: 		}
L_nrf_tx_packet_failed20:
;f_nrf24l01p.h,255 :: 		return 0;
	CLRF        R0 
;f_nrf24l01p.h,256 :: 		}
L_end_nrf_tx_packet_failed:
	RETURN      0
; end of _nrf_tx_packet_failed

_nrf_tx_packet_sent:

;f_nrf24l01p.h,258 :: 		uint8 nrf_tx_packet_sent()
;f_nrf24l01p.h,260 :: 		uint8 status = ___nrf_read_command(NRFCMD_NOP, 0, 0);
	MOVLW       255
	MOVWF       FARG____nrf_read_command_cmd+0 
	CLRF        FARG____nrf_read_command_numbytes+0 
	CLRF        FARG____nrf_read_command_buffer+0 
	CLRF        FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
	MOVF        R0, 0 
	MOVWF       nrf_tx_packet_sent_status_L0+0 
;f_nrf24l01p.h,261 :: 		if (status.B5)
	BTFSS       nrf_tx_packet_sent_status_L0+0, 5 
	GOTO        L_nrf_tx_packet_sent21
;f_nrf24l01p.h,263 :: 		nrf_clear_interrupts(NRFCFG_TX_INTERRUPT);
	MOVLW       2
	MOVWF       FARG_nrf_clear_interrupts_interrupts+0 
	CALL        _nrf_clear_interrupts+0, 0
;f_nrf24l01p.h,264 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_nrf_tx_packet_sent
;f_nrf24l01p.h,265 :: 		}
L_nrf_tx_packet_sent21:
;f_nrf24l01p.h,266 :: 		return 0;
	CLRF        R0 
;f_nrf24l01p.h,267 :: 		}
L_end_nrf_tx_packet_sent:
	RETURN      0
; end of _nrf_tx_packet_sent

_nrf_rx_get_sender_pipe:

;f_nrf24l01p.h,269 :: 		uint8 nrf_rx_get_sender_pipe()
;f_nrf24l01p.h,271 :: 		return ((___nrf_read_command(NRFCMD_NOP, 0, 0) & 0b00001110) >> 1);
	MOVLW       255
	MOVWF       FARG____nrf_read_command_cmd+0 
	CLRF        FARG____nrf_read_command_numbytes+0 
	CLRF        FARG____nrf_read_command_buffer+0 
	CLRF        FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
	MOVLW       14
	ANDWF       R0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
;f_nrf24l01p.h,272 :: 		}
L_end_nrf_rx_get_sender_pipe:
	RETURN      0
; end of _nrf_rx_get_sender_pipe

_nrf_rx_packet_ready:

;f_nrf24l01p.h,274 :: 		uint8 nrf_rx_packet_ready()
;f_nrf24l01p.h,276 :: 		uint8 fifo = 0;
	CLRF        nrf_rx_packet_ready_fifo_L0+0 
;f_nrf24l01p.h,277 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_FIFO_STATUS, 1, &fifo);
	MOVLW       23
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_rx_packet_ready_fifo_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_rx_packet_ready_fifo_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,278 :: 		return (! fifo.B0);
	BTFSC       nrf_rx_packet_ready_fifo_L0+0, 0 
	GOTO        L__nrf_rx_packet_ready305
	BSF         4056, 0 
	GOTO        L__nrf_rx_packet_ready306
L__nrf_rx_packet_ready305:
	BCF         4056, 0 
L__nrf_rx_packet_ready306:
	MOVLW       0
	BTFSC       4056, 0 
	MOVLW       1
	MOVWF       R0 
;f_nrf24l01p.h,279 :: 		}
L_end_nrf_rx_packet_ready:
	RETURN      0
; end of _nrf_rx_packet_ready

_nrf_rx_start_listening:

;f_nrf24l01p.h,281 :: 		void nrf_rx_start_listening()
;f_nrf24l01p.h,283 :: 		___nrf_ce_on();
	BSF         LATB3_bit+0, BitPos(LATB3_bit+0) 
	MOVLW       23
	MOVWF       R13, 0
L_nrf_rx_start_listening22:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_rx_start_listening22
	NOP
	NOP
;f_nrf24l01p.h,284 :: 		___nrf_delay_stby2a();
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_nrf_rx_start_listening23:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_rx_start_listening23
	DECFSZ      R12, 1, 1
	BRA         L_nrf_rx_start_listening23
;f_nrf24l01p.h,285 :: 		}
L_end_nrf_rx_start_listening:
	RETURN      0
; end of _nrf_rx_start_listening

_nrf_rx_stop_listening:

;f_nrf24l01p.h,287 :: 		void nrf_rx_stop_listening()
;f_nrf24l01p.h,289 :: 		___nrf_ce_off();
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;f_nrf24l01p.h,290 :: 		}
L_end_nrf_rx_stop_listening:
	RETURN      0
; end of _nrf_rx_stop_listening

_nrf_set_rx_pipe:

;f_nrf24l01p.h,292 :: 		uint8 nrf_set_rx_pipe(uint8 pipenum, uint8 num, uint8 * buffer, uint8 packet_size)
;f_nrf24l01p.h,294 :: 		nrf_set_rx_address(pipenum, num, buffer);
	MOVF        FARG_nrf_set_rx_pipe_pipenum+0, 0 
	MOVWF       FARG_nrf_set_rx_address_pipenum+0 
	MOVF        FARG_nrf_set_rx_pipe_num+0, 0 
	MOVWF       FARG_nrf_set_rx_address_num+0 
	MOVF        FARG_nrf_set_rx_pipe_buffer+0, 0 
	MOVWF       FARG_nrf_set_rx_address_buffer+0 
	MOVF        FARG_nrf_set_rx_pipe_buffer+1, 0 
	MOVWF       FARG_nrf_set_rx_address_buffer+1 
	CALL        _nrf_set_rx_address+0, 0
;f_nrf24l01p.h,295 :: 		return nrf_set_payload_size(pipenum, packet_size);
	MOVF        FARG_nrf_set_rx_pipe_pipenum+0, 0 
	MOVWF       FARG_nrf_set_payload_size_pipenum+0 
	MOVF        FARG_nrf_set_rx_pipe_packet_size+0, 0 
	MOVWF       FARG_nrf_set_payload_size_size+0 
	CALL        _nrf_set_payload_size+0, 0
;f_nrf24l01p.h,296 :: 		}
L_end_nrf_set_rx_pipe:
	RETURN      0
; end of _nrf_set_rx_pipe

_nrf_clear_interrupts:

;f_nrf24l01p.h,298 :: 		uint8 nrf_clear_interrupts(uint8 interrupts)
;f_nrf24l01p.h,300 :: 		uint8 actual = ___nrf_read_command(NRFCMD_NOP, 0, 0);
	MOVLW       255
	MOVWF       FARG____nrf_read_command_cmd+0 
	CLRF        FARG____nrf_read_command_numbytes+0 
	CLRF        FARG____nrf_read_command_buffer+0 
	CLRF        FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
	MOVF        R0, 0 
	MOVWF       nrf_clear_interrupts_actual_L0+0 
;f_nrf24l01p.h,302 :: 		actual.B6 = (interrupts & NRFCFG_RX_INTERRUPT ? 1 : 0);
	BTFSS       FARG_nrf_clear_interrupts_interrupts+0, 0 
	GOTO        L_nrf_clear_interrupts24
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_clear_interrupts25
L_nrf_clear_interrupts24:
	CLRF        R0 
L_nrf_clear_interrupts25:
	BTFSC       R0, 0 
	GOTO        L__nrf_clear_interrupts311
	BCF         nrf_clear_interrupts_actual_L0+0, 6 
	GOTO        L__nrf_clear_interrupts312
L__nrf_clear_interrupts311:
	BSF         nrf_clear_interrupts_actual_L0+0, 6 
L__nrf_clear_interrupts312:
;f_nrf24l01p.h,303 :: 		actual.B5 = (interrupts & NRFCFG_TX_INTERRUPT ? 1 : 0);
	BTFSS       FARG_nrf_clear_interrupts_interrupts+0, 1 
	GOTO        L_nrf_clear_interrupts26
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_clear_interrupts27
L_nrf_clear_interrupts26:
	CLRF        R0 
L_nrf_clear_interrupts27:
	BTFSC       R0, 0 
	GOTO        L__nrf_clear_interrupts313
	BCF         nrf_clear_interrupts_actual_L0+0, 5 
	GOTO        L__nrf_clear_interrupts314
L__nrf_clear_interrupts313:
	BSF         nrf_clear_interrupts_actual_L0+0, 5 
L__nrf_clear_interrupts314:
;f_nrf24l01p.h,304 :: 		actual.B4 = (interrupts & NRFCFG_MAXRETRIES_INTERRUPT ? 1 : 0);
	BTFSS       FARG_nrf_clear_interrupts_interrupts+0, 2 
	GOTO        L_nrf_clear_interrupts28
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_clear_interrupts29
L_nrf_clear_interrupts28:
	CLRF        R0 
L_nrf_clear_interrupts29:
	BTFSC       R0, 0 
	GOTO        L__nrf_clear_interrupts315
	BCF         nrf_clear_interrupts_actual_L0+0, 4 
	GOTO        L__nrf_clear_interrupts316
L__nrf_clear_interrupts315:
	BSF         nrf_clear_interrupts_actual_L0+0, 4 
L__nrf_clear_interrupts316:
;f_nrf24l01p.h,306 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_STATUS, 1, &actual);
	MOVLW       39
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_clear_interrupts_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_clear_interrupts_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,307 :: 		}
L_end_nrf_clear_interrupts:
	RETURN      0
; end of _nrf_clear_interrupts

_nrf_reuse_tx_payload:

;f_nrf24l01p.h,309 :: 		uint8 nrf_reuse_tx_payload()
;f_nrf24l01p.h,311 :: 		return ___nrf_send_command(NRFCMD_REUSE_TX_PL, 0, 0);
	MOVLW       227
	MOVWF       FARG____nrf_send_command_cmd+0 
	CLRF        FARG____nrf_send_command_numbytes+0 
	CLRF        FARG____nrf_send_command_buffer+0 
	CLRF        FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,312 :: 		}
L_end_nrf_reuse_tx_payload:
	RETURN      0
; end of _nrf_reuse_tx_payload

_nrf_flush_rx:

;f_nrf24l01p.h,314 :: 		uint8 nrf_flush_rx()
;f_nrf24l01p.h,316 :: 		return ___nrf_send_command(NRFCMD_FLUSH_RX, 0, 0);
	MOVLW       226
	MOVWF       FARG____nrf_send_command_cmd+0 
	CLRF        FARG____nrf_send_command_numbytes+0 
	CLRF        FARG____nrf_send_command_buffer+0 
	CLRF        FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,317 :: 		}
L_end_nrf_flush_rx:
	RETURN      0
; end of _nrf_flush_rx

_nrf_flush_tx:

;f_nrf24l01p.h,319 :: 		uint8 nrf_flush_tx()
;f_nrf24l01p.h,321 :: 		return ___nrf_send_command(NRFCMD_FLUSH_TX, 0, 0);
	MOVLW       225
	MOVWF       FARG____nrf_send_command_cmd+0 
	CLRF        FARG____nrf_send_command_numbytes+0 
	CLRF        FARG____nrf_send_command_buffer+0 
	CLRF        FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,322 :: 		}
L_end_nrf_flush_tx:
	RETURN      0
; end of _nrf_flush_tx

_nrf_write_payload:

;f_nrf24l01p.h,324 :: 		uint8 nrf_write_payload(uint8 size, uint8 * buffer)
;f_nrf24l01p.h,327 :: 		if (size < 1) size = 1;
	MOVLW       1
	SUBWF       FARG_nrf_write_payload_size+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_write_payload30
	MOVLW       1
	MOVWF       FARG_nrf_write_payload_size+0 
L_nrf_write_payload30:
;f_nrf24l01p.h,328 :: 		if (size > 32) size = 32;
	MOVF        FARG_nrf_write_payload_size+0, 0 
	SUBLW       32
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_write_payload31
	MOVLW       32
	MOVWF       FARG_nrf_write_payload_size+0 
L_nrf_write_payload31:
;f_nrf24l01p.h,330 :: 		___nrf_select();
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L_nrf_write_payload32:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_write_payload32
	NOP
	NOP
;f_nrf24l01p.h,331 :: 		status = ___nrf_send(NRFCMD_W_TX_PAYLOAD);
	MOVLW       160
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
	MOVF        R0, 0 
	MOVWF       nrf_write_payload_status_L0+0 
;f_nrf24l01p.h,332 :: 		for (i = 0; i < size; i ++) ___nrf_send(buffer[i]);
	CLRF        nrf_write_payload_i_L0+0 
L_nrf_write_payload33:
	MOVF        FARG_nrf_write_payload_size+0, 0 
	SUBWF       nrf_write_payload_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_write_payload34
	MOVF        nrf_write_payload_i_L0+0, 0 
	ADDWF       FARG_nrf_write_payload_buffer+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_nrf_write_payload_buffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
	INCF        nrf_write_payload_i_L0+0, 1 
	GOTO        L_nrf_write_payload33
L_nrf_write_payload34:
;f_nrf24l01p.h,333 :: 		___nrf_deselect();
	MOVLW       39
	MOVWF       R13, 0
L_nrf_write_payload36:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_write_payload36
	NOP
	NOP
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;f_nrf24l01p.h,335 :: 		return status;
	MOVF        nrf_write_payload_status_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,336 :: 		}
L_end_nrf_write_payload:
	RETURN      0
; end of _nrf_write_payload

_nrf_read_payload:

;f_nrf24l01p.h,338 :: 		uint8 nrf_read_payload(uint8 size, uint8 * buffer)
;f_nrf24l01p.h,341 :: 		___nrf_select();
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L_nrf_read_payload37:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_read_payload37
	NOP
	NOP
;f_nrf24l01p.h,342 :: 		if (size == NRF_BUFFERSIZE_DYNAMIC || size > 32)
	MOVF        FARG_nrf_read_payload_size+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__nrf_read_payload288
	MOVF        FARG_nrf_read_payload_size+0, 0 
	SUBLW       32
	BTFSS       STATUS+0, 0 
	GOTO        L__nrf_read_payload288
	GOTO        L_nrf_read_payload40
L__nrf_read_payload288:
;f_nrf24l01p.h,344 :: 		___nrf_send(NRFCMD_R_RX_PL_WID);
	MOVLW       96
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
;f_nrf24l01p.h,345 :: 		size = ___nrf_send(NRFCMD_NOP);
	MOVLW       255
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_nrf_read_payload_size+0 
;f_nrf24l01p.h,347 :: 		if (size > 32)
	MOVF        R0, 0 
	SUBLW       32
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_read_payload41
;f_nrf24l01p.h,349 :: 		___nrf_send(NRFCMD_FLUSH_RX);
	MOVLW       226
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
;f_nrf24l01p.h,350 :: 		___nrf_deselect();
	MOVLW       39
	MOVWF       R13, 0
L_nrf_read_payload42:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_read_payload42
	NOP
	NOP
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;f_nrf24l01p.h,351 :: 		return 0;
	CLRF        R0 
	GOTO        L_end_nrf_read_payload
;f_nrf24l01p.h,352 :: 		}
L_nrf_read_payload41:
;f_nrf24l01p.h,353 :: 		}
L_nrf_read_payload40:
;f_nrf24l01p.h,355 :: 		___nrf_send(NRFCMD_R_RX_PAYLOAD);
	MOVLW       97
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
;f_nrf24l01p.h,356 :: 		for (i = 0; i < size; i ++)
	CLRF        nrf_read_payload_i_L0+0 
L_nrf_read_payload43:
	MOVF        FARG_nrf_read_payload_size+0, 0 
	SUBWF       nrf_read_payload_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_read_payload44
;f_nrf24l01p.h,357 :: 		buffer[i] = ___nrf_send(NRFCMD_NOP);
	MOVF        nrf_read_payload_i_L0+0, 0 
	ADDWF       FARG_nrf_read_payload_buffer+0, 0 
	MOVWF       FLOC__nrf_read_payload+0 
	MOVLW       0
	ADDWFC      FARG_nrf_read_payload_buffer+1, 0 
	MOVWF       FLOC__nrf_read_payload+1 
	MOVLW       255
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
	MOVFF       FLOC__nrf_read_payload+0, FSR1
	MOVFF       FLOC__nrf_read_payload+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,356 :: 		for (i = 0; i < size; i ++)
	INCF        nrf_read_payload_i_L0+0, 1 
;f_nrf24l01p.h,357 :: 		buffer[i] = ___nrf_send(NRFCMD_NOP);
	GOTO        L_nrf_read_payload43
L_nrf_read_payload44:
;f_nrf24l01p.h,359 :: 		___nrf_deselect();
	MOVLW       39
	MOVWF       R13, 0
L_nrf_read_payload46:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_read_payload46
	NOP
	NOP
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;f_nrf24l01p.h,360 :: 		return size;
	MOVF        FARG_nrf_read_payload_size+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,361 :: 		}
L_end_nrf_read_payload:
	RETURN      0
; end of _nrf_read_payload

_nrf_enable_no_ack_command:

;f_nrf24l01p.h,363 :: 		uint8 nrf_enable_no_ack_command(uint8 enable)
;f_nrf24l01p.h,365 :: 		uint8 actual = 0;
	CLRF        nrf_enable_no_ack_command_actual_L0+0 
;f_nrf24l01p.h,366 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_FEATURE, 1, &actual);
	MOVLW       29
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_enable_no_ack_command_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_enable_no_ack_command_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,367 :: 		actual.B0 = enable ? 1 : 0;
	MOVF        FARG_nrf_enable_no_ack_command_enable+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_enable_no_ack_command47
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_enable_no_ack_command48
L_nrf_enable_no_ack_command47:
	CLRF        R0 
L_nrf_enable_no_ack_command48:
	BTFSC       R0, 0 
	GOTO        L__nrf_enable_no_ack_command323
	BCF         nrf_enable_no_ack_command_actual_L0+0, 0 
	GOTO        L__nrf_enable_no_ack_command324
L__nrf_enable_no_ack_command323:
	BSF         nrf_enable_no_ack_command_actual_L0+0, 0 
L__nrf_enable_no_ack_command324:
;f_nrf24l01p.h,368 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_FEATURE, 1, &actual);
	MOVLW       61
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_enable_no_ack_command_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_enable_no_ack_command_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,369 :: 		}
L_end_nrf_enable_no_ack_command:
	RETURN      0
; end of _nrf_enable_no_ack_command

_nrf_enable_ack_payload:

;f_nrf24l01p.h,371 :: 		uint8 nrf_enable_ack_payload(uint8 enable)
;f_nrf24l01p.h,373 :: 		uint8 actual = 0;
	CLRF        nrf_enable_ack_payload_actual_L0+0 
;f_nrf24l01p.h,374 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_FEATURE, 1, &actual);
	MOVLW       29
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_enable_ack_payload_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_enable_ack_payload_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,375 :: 		actual.B1 = enable ? 1 : 0;
	MOVF        FARG_nrf_enable_ack_payload_enable+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_enable_ack_payload49
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_enable_ack_payload50
L_nrf_enable_ack_payload49:
	CLRF        R0 
L_nrf_enable_ack_payload50:
	BTFSC       R0, 0 
	GOTO        L__nrf_enable_ack_payload326
	BCF         nrf_enable_ack_payload_actual_L0+0, 1 
	GOTO        L__nrf_enable_ack_payload327
L__nrf_enable_ack_payload326:
	BSF         nrf_enable_ack_payload_actual_L0+0, 1 
L__nrf_enable_ack_payload327:
;f_nrf24l01p.h,376 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_FEATURE, 1, &actual);
	MOVLW       61
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_enable_ack_payload_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_enable_ack_payload_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,377 :: 		}
L_end_nrf_enable_ack_payload:
	RETURN      0
; end of _nrf_enable_ack_payload

_nrf_enable_dynamic_payload_length:

;f_nrf24l01p.h,379 :: 		uint8 nrf_enable_dynamic_payload_length(uint8 enable)
;f_nrf24l01p.h,381 :: 		uint8 actual = 0;
	CLRF        nrf_enable_dynamic_payload_length_actual_L0+0 
;f_nrf24l01p.h,382 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_FEATURE, 1, &actual);
	MOVLW       29
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_enable_dynamic_payload_length_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_enable_dynamic_payload_length_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,383 :: 		actual.B2 = enable ? 1 : 0;
	MOVF        FARG_nrf_enable_dynamic_payload_length_enable+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_enable_dynamic_payload_length51
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_enable_dynamic_payload_length52
L_nrf_enable_dynamic_payload_length51:
	CLRF        R0 
L_nrf_enable_dynamic_payload_length52:
	BTFSC       R0, 0 
	GOTO        L__nrf_enable_dynamic_payload_length329
	BCF         nrf_enable_dynamic_payload_length_actual_L0+0, 2 
	GOTO        L__nrf_enable_dynamic_payload_length330
L__nrf_enable_dynamic_payload_length329:
	BSF         nrf_enable_dynamic_payload_length_actual_L0+0, 2 
L__nrf_enable_dynamic_payload_length330:
;f_nrf24l01p.h,384 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_FEATURE, 1, &actual);
	MOVLW       61
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_enable_dynamic_payload_length_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_enable_dynamic_payload_length_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,385 :: 		}
L_end_nrf_enable_dynamic_payload_length:
	RETURN      0
; end of _nrf_enable_dynamic_payload_length

_nrf_enable_dynamic_payload:

;f_nrf24l01p.h,387 :: 		uint8 nrf_enable_dynamic_payload(uint8 channels)
;f_nrf24l01p.h,389 :: 		channels &= 0b00111111;
	MOVLW       63
	ANDWF       FARG_nrf_enable_dynamic_payload_channels+0, 1 
;f_nrf24l01p.h,390 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_DYNPD, 1, &channels);
	MOVLW       60
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       FARG_nrf_enable_dynamic_payload_channels+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(FARG_nrf_enable_dynamic_payload_channels+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,391 :: 		}
L_end_nrf_enable_dynamic_payload:
	RETURN      0
; end of _nrf_enable_dynamic_payload

_nrf_get_fifo_status:

;f_nrf24l01p.h,393 :: 		uint8 nrf_get_fifo_status(nrf_fifo_status * dest)
;f_nrf24l01p.h,395 :: 		uint8 fstat = 0;
	CLRF        nrf_get_fifo_status_fstat_L0+0 
;f_nrf24l01p.h,396 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_FIFO_STATUS, 1, &fstat);
	MOVLW       23
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_get_fifo_status_fstat_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_get_fifo_status_fstat_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,398 :: 		if (dest)
	MOVF        FARG_nrf_get_fifo_status_dest+0, 0 
	IORWF       FARG_nrf_get_fifo_status_dest+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_get_fifo_status53
;f_nrf24l01p.h,400 :: 		dest -> tx_reuse = fstat.B6;
	MOVFF       FARG_nrf_get_fifo_status_dest+0, FSR1
	MOVFF       FARG_nrf_get_fifo_status_dest+1, FSR1H
	MOVLW       0
	BTFSC       nrf_get_fifo_status_fstat_L0+0, 6 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,401 :: 		dest -> tx_full = fstat.B5;
	MOVLW       1
	ADDWF       FARG_nrf_get_fifo_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_fifo_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       nrf_get_fifo_status_fstat_L0+0, 5 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,402 :: 		dest -> tx_empty = fstat.B4;
	MOVLW       2
	ADDWF       FARG_nrf_get_fifo_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_fifo_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       nrf_get_fifo_status_fstat_L0+0, 4 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,403 :: 		dest -> rx_full = fstat.B1;
	MOVLW       3
	ADDWF       FARG_nrf_get_fifo_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_fifo_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       nrf_get_fifo_status_fstat_L0+0, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,404 :: 		dest -> rx_empty = fstat.B0;
	MOVLW       4
	ADDWF       FARG_nrf_get_fifo_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_fifo_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       nrf_get_fifo_status_fstat_L0+0, 0 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,405 :: 		}
L_nrf_get_fifo_status53:
;f_nrf24l01p.h,406 :: 		return fstat;
	MOVF        nrf_get_fifo_status_fstat_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,407 :: 		}
L_end_nrf_get_fifo_status:
	RETURN      0
; end of _nrf_get_fifo_status

_nrf_set_payload_size:

;f_nrf24l01p.h,409 :: 		uint8 nrf_set_payload_size(uint8 pipenum, uint8 size)
;f_nrf24l01p.h,411 :: 		if (pipenum > 5) pipenum = 5;
	MOVF        FARG_nrf_set_payload_size_pipenum+0, 0 
	SUBLW       5
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_payload_size54
	MOVLW       5
	MOVWF       FARG_nrf_set_payload_size_pipenum+0 
L_nrf_set_payload_size54:
;f_nrf24l01p.h,412 :: 		if (size < 1) size = 1;
	MOVLW       1
	SUBWF       FARG_nrf_set_payload_size_size+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_payload_size55
	MOVLW       1
	MOVWF       FARG_nrf_set_payload_size_size+0 
L_nrf_set_payload_size55:
;f_nrf24l01p.h,413 :: 		if (size > 32) size = 32;
	MOVF        FARG_nrf_set_payload_size_size+0, 0 
	SUBLW       32
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_payload_size56
	MOVLW       32
	MOVWF       FARG_nrf_set_payload_size_size+0 
L_nrf_set_payload_size56:
;f_nrf24l01p.h,415 :: 		size &= 0b00111111;
	MOVLW       63
	ANDWF       FARG_nrf_set_payload_size_size+0, 1 
;f_nrf24l01p.h,416 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | (NRFREG_RX_PW_P0 + pipenum), 1, &size);
	MOVF        FARG_nrf_set_payload_size_pipenum+0, 0 
	ADDLW       17
	MOVWF       R0 
	MOVLW       32
	IORWF       R0, 0 
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       FARG_nrf_set_payload_size_size+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(FARG_nrf_set_payload_size_size+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,417 :: 		}
L_end_nrf_set_payload_size:
	RETURN      0
; end of _nrf_set_payload_size

_nrf_set_tx_address:

;f_nrf24l01p.h,419 :: 		uint8 nrf_set_tx_address(uint8 num, uint8 * buffer)
;f_nrf24l01p.h,421 :: 		if (num < 3) num = 3;
	MOVLW       3
	SUBWF       FARG_nrf_set_tx_address_num+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_tx_address57
	MOVLW       3
	MOVWF       FARG_nrf_set_tx_address_num+0 
L_nrf_set_tx_address57:
;f_nrf24l01p.h,422 :: 		if (num > 5) num = 5;
	MOVF        FARG_nrf_set_tx_address_num+0, 0 
	SUBLW       5
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_tx_address58
	MOVLW       5
	MOVWF       FARG_nrf_set_tx_address_num+0 
L_nrf_set_tx_address58:
;f_nrf24l01p.h,423 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_TX_ADDR, num, buffer);
	MOVLW       48
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVF        FARG_nrf_set_tx_address_num+0, 0 
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVF        FARG_nrf_set_tx_address_buffer+0, 0 
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVF        FARG_nrf_set_tx_address_buffer+1, 0 
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,424 :: 		}
L_end_nrf_set_tx_address:
	RETURN      0
; end of _nrf_set_tx_address

_nrf_set_rx_address:

;f_nrf24l01p.h,426 :: 		uint8 nrf_set_rx_address(uint8 pipenum, uint8 num, uint8 * buffer)
;f_nrf24l01p.h,428 :: 		if (pipenum > 5) pipenum = 5;
	MOVF        FARG_nrf_set_rx_address_pipenum+0, 0 
	SUBLW       5
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_rx_address59
	MOVLW       5
	MOVWF       FARG_nrf_set_rx_address_pipenum+0 
L_nrf_set_rx_address59:
;f_nrf24l01p.h,429 :: 		if (pipenum < 2)
	MOVLW       2
	SUBWF       FARG_nrf_set_rx_address_pipenum+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_rx_address60
;f_nrf24l01p.h,431 :: 		if (num < 3) num = 3;
	MOVLW       3
	SUBWF       FARG_nrf_set_rx_address_num+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_rx_address61
	MOVLW       3
	MOVWF       FARG_nrf_set_rx_address_num+0 
L_nrf_set_rx_address61:
;f_nrf24l01p.h,432 :: 		if (num > 5) num = 5;
	MOVF        FARG_nrf_set_rx_address_num+0, 0 
	SUBLW       5
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_rx_address62
	MOVLW       5
	MOVWF       FARG_nrf_set_rx_address_num+0 
L_nrf_set_rx_address62:
;f_nrf24l01p.h,433 :: 		}
	GOTO        L_nrf_set_rx_address63
L_nrf_set_rx_address60:
;f_nrf24l01p.h,434 :: 		else num = 1;
	MOVLW       1
	MOVWF       FARG_nrf_set_rx_address_num+0 
L_nrf_set_rx_address63:
;f_nrf24l01p.h,436 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | (NRFREG_RX_ADDR_P0 + pipenum), num, buffer);
	MOVF        FARG_nrf_set_rx_address_pipenum+0, 0 
	ADDLW       10
	MOVWF       R0 
	MOVLW       32
	IORWF       R0, 0 
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVF        FARG_nrf_set_rx_address_num+0, 0 
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVF        FARG_nrf_set_rx_address_buffer+0, 0 
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVF        FARG_nrf_set_rx_address_buffer+1, 0 
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,437 :: 		}
L_end_nrf_set_rx_address:
	RETURN      0
; end of _nrf_set_rx_address

_nrf_signal_detected:

;f_nrf24l01p.h,439 :: 		uint8 nrf_signal_detected()
;f_nrf24l01p.h,441 :: 		uint8 actual = 0;
	CLRF        nrf_signal_detected_actual_L0+0 
;f_nrf24l01p.h,442 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_RPD, 1, &actual);
	MOVLW       9
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_signal_detected_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_signal_detected_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,443 :: 		return actual.B0;
	MOVLW       0
	BTFSC       nrf_signal_detected_actual_L0+0, 0 
	MOVLW       1
	MOVWF       R0 
;f_nrf24l01p.h,444 :: 		}
L_end_nrf_signal_detected:
	RETURN      0
; end of _nrf_signal_detected

_nrf_get_total_retransmit_count:

;f_nrf24l01p.h,446 :: 		uint8 nrf_get_total_retransmit_count()
;f_nrf24l01p.h,448 :: 		uint8 actual = 0;
	CLRF        nrf_get_total_retransmit_count_actual_L0+0 
;f_nrf24l01p.h,449 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_OBSERVE_TX, 1, &actual);
	MOVLW       8
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_get_total_retransmit_count_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_get_total_retransmit_count_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,450 :: 		return actual >> 4;
	MOVF        nrf_get_total_retransmit_count_actual_L0+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
;f_nrf24l01p.h,451 :: 		}
L_end_nrf_get_total_retransmit_count:
	RETURN      0
; end of _nrf_get_total_retransmit_count

_nrf_get_current_retransmit_count:

;f_nrf24l01p.h,453 :: 		uint8 nrf_get_current_retransmit_count()
;f_nrf24l01p.h,455 :: 		uint8 actual = 0;
	CLRF        nrf_get_current_retransmit_count_actual_L0+0 
;f_nrf24l01p.h,456 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_OBSERVE_TX, 1, &actual);
	MOVLW       8
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_get_current_retransmit_count_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_get_current_retransmit_count_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,457 :: 		return actual & 0b00001111;
	MOVLW       15
	ANDWF       nrf_get_current_retransmit_count_actual_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,458 :: 		}
L_end_nrf_get_current_retransmit_count:
	RETURN      0
; end of _nrf_get_current_retransmit_count

_nrf_get_status:

;f_nrf24l01p.h,460 :: 		uint8 nrf_get_status(nrf_status * dest)
;f_nrf24l01p.h,462 :: 		uint8 status = ___nrf_read_command(NRFCMD_NOP, 0, 0);
	MOVLW       255
	MOVWF       FARG____nrf_read_command_cmd+0 
	CLRF        FARG____nrf_read_command_numbytes+0 
	CLRF        FARG____nrf_read_command_buffer+0 
	CLRF        FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
	MOVF        R0, 0 
	MOVWF       nrf_get_status_status_L0+0 
;f_nrf24l01p.h,464 :: 		if (dest)
	MOVF        FARG_nrf_get_status_dest+0, 0 
	IORWF       FARG_nrf_get_status_dest+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_get_status64
;f_nrf24l01p.h,466 :: 		dest -> rx_data_ready = status.B6;
	MOVFF       FARG_nrf_get_status_dest+0, FSR1
	MOVFF       FARG_nrf_get_status_dest+1, FSR1H
	MOVLW       0
	BTFSC       nrf_get_status_status_L0+0, 6 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,467 :: 		dest -> tx_data_sent = status.B5;
	MOVLW       1
	ADDWF       FARG_nrf_get_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       nrf_get_status_status_L0+0, 5 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,468 :: 		dest -> max_retries_reached = status.B4;
	MOVLW       2
	ADDWF       FARG_nrf_get_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       nrf_get_status_status_L0+0, 4 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,470 :: 		dest -> available_pipe = (status & 0b00001110) >> 1;
	MOVLW       3
	ADDWF       FARG_nrf_get_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       14
	ANDWF       nrf_get_status_status_L0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,471 :: 		dest -> tx_full = status.B0;
	MOVLW       4
	ADDWF       FARG_nrf_get_status_dest+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_status_dest+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       nrf_get_status_status_L0+0, 0 
	MOVLW       1
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,472 :: 		dest -> rx_empty = (dest -> available_pipe == 0b111 ? 1 : 0);
	MOVLW       5
	ADDWF       FARG_nrf_get_status_dest+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_nrf_get_status_dest+1, 0 
	MOVWF       R2 
	MOVLW       3
	ADDWF       FARG_nrf_get_status_dest+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_nrf_get_status_dest+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L_nrf_get_status65
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_get_status66
L_nrf_get_status65:
	CLRF        R0 
L_nrf_get_status66:
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,473 :: 		}
L_nrf_get_status64:
;f_nrf24l01p.h,474 :: 		return status;
	MOVF        nrf_get_status_status_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,475 :: 		}
L_end_nrf_get_status:
	RETURN      0
; end of _nrf_get_status

_nrf_set_output_power:

;f_nrf24l01p.h,477 :: 		uint8 nrf_set_output_power(uint8 power)
;f_nrf24l01p.h,479 :: 		uint8 actual = 0;
	CLRF        nrf_set_output_power_actual_L0+0 
;f_nrf24l01p.h,480 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_RF_SETUP, 1, &actual);
	MOVLW       6
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_output_power_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_output_power_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,482 :: 		switch (power)
	GOTO        L_nrf_set_output_power67
;f_nrf24l01p.h,484 :: 		case NRFCFG_POWER_0dbm:
L_nrf_set_output_power69:
;f_nrf24l01p.h,485 :: 		actual.B2 = 1;
	BSF         nrf_set_output_power_actual_L0+0, 2 
;f_nrf24l01p.h,486 :: 		actual.B1 = 1;
	BSF         nrf_set_output_power_actual_L0+0, 1 
;f_nrf24l01p.h,487 :: 		break;
	GOTO        L_nrf_set_output_power68
;f_nrf24l01p.h,489 :: 		case NRFCFG_POWER_m6dbm:
L_nrf_set_output_power70:
;f_nrf24l01p.h,490 :: 		actual.B2 = 1;
	BSF         nrf_set_output_power_actual_L0+0, 2 
;f_nrf24l01p.h,491 :: 		actual.B1 = 0;
	BCF         nrf_set_output_power_actual_L0+0, 1 
;f_nrf24l01p.h,492 :: 		break;
	GOTO        L_nrf_set_output_power68
;f_nrf24l01p.h,494 :: 		case NRFCFG_POWER_m12dbm:
L_nrf_set_output_power71:
;f_nrf24l01p.h,495 :: 		actual.B2 = 0;
	BCF         nrf_set_output_power_actual_L0+0, 2 
;f_nrf24l01p.h,496 :: 		actual.B1 = 1;
	BSF         nrf_set_output_power_actual_L0+0, 1 
;f_nrf24l01p.h,497 :: 		break;
	GOTO        L_nrf_set_output_power68
;f_nrf24l01p.h,499 :: 		default:
L_nrf_set_output_power72:
;f_nrf24l01p.h,500 :: 		actual.B2 = 0;
	BCF         nrf_set_output_power_actual_L0+0, 2 
;f_nrf24l01p.h,501 :: 		actual.B1 = 0;
	BCF         nrf_set_output_power_actual_L0+0, 1 
;f_nrf24l01p.h,502 :: 		}
	GOTO        L_nrf_set_output_power68
L_nrf_set_output_power67:
	MOVF        FARG_nrf_set_output_power_power+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_output_power69
	MOVF        FARG_nrf_set_output_power_power+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_output_power70
	MOVF        FARG_nrf_set_output_power_power+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_output_power71
	GOTO        L_nrf_set_output_power72
L_nrf_set_output_power68:
;f_nrf24l01p.h,504 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_RF_SETUP, 1, &actual);
	MOVLW       38
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_output_power_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_output_power_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,505 :: 		}
L_end_nrf_set_output_power:
	RETURN      0
; end of _nrf_set_output_power

_nrf_set_data_rate:

;f_nrf24l01p.h,507 :: 		uint8 nrf_set_data_rate(uint8 datarate)
;f_nrf24l01p.h,509 :: 		uint8 actual = 0;
	CLRF        nrf_set_data_rate_actual_L0+0 
;f_nrf24l01p.h,510 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_RF_SETUP, 1, &actual);
	MOVLW       6
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_data_rate_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_data_rate_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,512 :: 		switch (datarate)
	GOTO        L_nrf_set_data_rate73
;f_nrf24l01p.h,514 :: 		case NRFCFG_DATARATE_2M:
L_nrf_set_data_rate75:
;f_nrf24l01p.h,515 :: 		actual.B3 = 1;
	BSF         nrf_set_data_rate_actual_L0+0, 3 
;f_nrf24l01p.h,516 :: 		actual.B5 = 0;
	BCF         nrf_set_data_rate_actual_L0+0, 5 
;f_nrf24l01p.h,517 :: 		break;
	GOTO        L_nrf_set_data_rate74
;f_nrf24l01p.h,519 :: 		case NRFCFG_DATARATE_1M:
L_nrf_set_data_rate76:
;f_nrf24l01p.h,520 :: 		actual.B3 = 0;
	BCF         nrf_set_data_rate_actual_L0+0, 3 
;f_nrf24l01p.h,521 :: 		actual.B5 = 0;
	BCF         nrf_set_data_rate_actual_L0+0, 5 
;f_nrf24l01p.h,522 :: 		break;
	GOTO        L_nrf_set_data_rate74
;f_nrf24l01p.h,524 :: 		default:
L_nrf_set_data_rate77:
;f_nrf24l01p.h,525 :: 		actual.B3 = 0;
	BCF         nrf_set_data_rate_actual_L0+0, 3 
;f_nrf24l01p.h,526 :: 		actual.B5 = 1;
	BSF         nrf_set_data_rate_actual_L0+0, 5 
;f_nrf24l01p.h,527 :: 		}
	GOTO        L_nrf_set_data_rate74
L_nrf_set_data_rate73:
	MOVF        FARG_nrf_set_data_rate_datarate+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_data_rate75
	MOVF        FARG_nrf_set_data_rate_datarate+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_data_rate76
	GOTO        L_nrf_set_data_rate77
L_nrf_set_data_rate74:
;f_nrf24l01p.h,529 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_RF_SETUP, 1, &actual);
	MOVLW       38
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_data_rate_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_data_rate_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,530 :: 		}
L_end_nrf_set_data_rate:
	RETURN      0
; end of _nrf_set_data_rate

_nrf_set_channel:

;f_nrf24l01p.h,532 :: 		uint8 nrf_set_channel(uint8 channel)
;f_nrf24l01p.h,534 :: 		if (channel > 127) channel = 127;
	MOVF        FARG_nrf_set_channel_channel+0, 0 
	SUBLW       127
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_channel78
	MOVLW       127
	MOVWF       FARG_nrf_set_channel_channel+0 
L_nrf_set_channel78:
;f_nrf24l01p.h,535 :: 		channel &= 0b01111111;
	MOVLW       127
	ANDWF       FARG_nrf_set_channel_channel+0, 1 
;f_nrf24l01p.h,536 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_RF_CH, 1, &channel);
	MOVLW       37
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       FARG_nrf_set_channel_channel+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(FARG_nrf_set_channel_channel+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,537 :: 		}
L_end_nrf_set_channel:
	RETURN      0
; end of _nrf_set_channel

_nrf_set_max_retransmit:

;f_nrf24l01p.h,539 :: 		uint8 nrf_set_max_retransmit(uint8 maxattempts)
;f_nrf24l01p.h,541 :: 		uint8 actual = 0;
	CLRF        nrf_set_max_retransmit_actual_L0+0 
;f_nrf24l01p.h,542 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_SETUP_RETR, 1, &actual);
	MOVLW       4
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_max_retransmit_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_max_retransmit_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,544 :: 		actual &= 0b11110000;
	MOVLW       240
	ANDWF       nrf_set_max_retransmit_actual_L0+0, 1 
;f_nrf24l01p.h,545 :: 		if (maxattempts > 15) maxattempts = 15;
	MOVF        FARG_nrf_set_max_retransmit_maxattempts+0, 0 
	SUBLW       15
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_max_retransmit79
	MOVLW       15
	MOVWF       FARG_nrf_set_max_retransmit_maxattempts+0 
L_nrf_set_max_retransmit79:
;f_nrf24l01p.h,546 :: 		actual |= maxattempts;
	MOVF        FARG_nrf_set_max_retransmit_maxattempts+0, 0 
	IORWF       nrf_set_max_retransmit_actual_L0+0, 1 
;f_nrf24l01p.h,548 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_SETUP_RETR, 1, &actual);
	MOVLW       36
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_max_retransmit_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_max_retransmit_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,549 :: 		}
L_end_nrf_set_max_retransmit:
	RETURN      0
; end of _nrf_set_max_retransmit

_nrf_set_retransmit_delay:

;f_nrf24l01p.h,551 :: 		uint8 nrf_set_retransmit_delay(uint8 delayPer250us)
;f_nrf24l01p.h,553 :: 		uint8 actual = 0;
	CLRF        nrf_set_retransmit_delay_actual_L0+0 
;f_nrf24l01p.h,555 :: 		if (delayPer250us < 1)  delayPer250us = 1;
	MOVLW       1
	SUBWF       FARG_nrf_set_retransmit_delay_delayPer250us+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_retransmit_delay80
	MOVLW       1
	MOVWF       FARG_nrf_set_retransmit_delay_delayPer250us+0 
L_nrf_set_retransmit_delay80:
;f_nrf24l01p.h,556 :: 		if (delayPer250us > 16) delayPer250us = 16;
	MOVF        FARG_nrf_set_retransmit_delay_delayPer250us+0, 0 
	SUBLW       16
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_retransmit_delay81
	MOVLW       16
	MOVWF       FARG_nrf_set_retransmit_delay_delayPer250us+0 
L_nrf_set_retransmit_delay81:
;f_nrf24l01p.h,558 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_SETUP_RETR, 1, &actual);
	MOVLW       4
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_retransmit_delay_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_retransmit_delay_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,560 :: 		actual &= 0b00001111;
	MOVLW       15
	ANDWF       nrf_set_retransmit_delay_actual_L0+0, 1 
;f_nrf24l01p.h,561 :: 		actual |= ((delayPer250us - 1) << 4);
	DECF        FARG_nrf_set_retransmit_delay_delayPer250us+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	IORWF       nrf_set_retransmit_delay_actual_L0+0, 1 
;f_nrf24l01p.h,563 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_SETUP_RETR, 1, &actual);
	MOVLW       36
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_retransmit_delay_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_retransmit_delay_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,564 :: 		}
L_end_nrf_set_retransmit_delay:
	RETURN      0
; end of _nrf_set_retransmit_delay

_nrf_set_address_width:

;f_nrf24l01p.h,566 :: 		uint8 nrf_set_address_width(uint8 numbytes)
;f_nrf24l01p.h,568 :: 		if (numbytes < 3) numbytes = 3;
	MOVLW       3
	SUBWF       FARG_nrf_set_address_width_numbytes+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_address_width82
	MOVLW       3
	MOVWF       FARG_nrf_set_address_width_numbytes+0 
L_nrf_set_address_width82:
;f_nrf24l01p.h,569 :: 		if (numbytes > 5) numbytes = 5;
	MOVF        FARG_nrf_set_address_width_numbytes+0, 0 
	SUBLW       5
	BTFSC       STATUS+0, 0 
	GOTO        L_nrf_set_address_width83
	MOVLW       5
	MOVWF       FARG_nrf_set_address_width_numbytes+0 
L_nrf_set_address_width83:
;f_nrf24l01p.h,571 :: 		numbytes = ((numbytes - 2) & 0b00000011);
	MOVLW       2
	SUBWF       FARG_nrf_set_address_width_numbytes+0, 1 
	MOVLW       3
	ANDWF       FARG_nrf_set_address_width_numbytes+0, 1 
;f_nrf24l01p.h,572 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_SETUP_AW, 1, &numbytes);
	MOVLW       35
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       FARG_nrf_set_address_width_numbytes+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(FARG_nrf_set_address_width_numbytes+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,573 :: 		}
L_end_nrf_set_address_width:
	RETURN      0
; end of _nrf_set_address_width

_nrf_enable_data_pipes:

;f_nrf24l01p.h,575 :: 		uint8 nrf_enable_data_pipes(uint8 channels)
;f_nrf24l01p.h,577 :: 		channels &= 0b00111111;
	MOVLW       63
	ANDWF       FARG_nrf_enable_data_pipes_channels+0, 1 
;f_nrf24l01p.h,578 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_EN_RXADDR, 1, &channels);
	MOVLW       34
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       FARG_nrf_enable_data_pipes_channels+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(FARG_nrf_enable_data_pipes_channels+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,579 :: 		}
L_end_nrf_enable_data_pipes:
	RETURN      0
; end of _nrf_enable_data_pipes

_nrf_enable_auto_acks:

;f_nrf24l01p.h,581 :: 		uint8 nrf_enable_auto_acks(uint8 channels)
;f_nrf24l01p.h,583 :: 		channels &= 0b00111111;
	MOVLW       63
	ANDWF       FARG_nrf_enable_auto_acks_channels+0, 1 
;f_nrf24l01p.h,584 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_EN_AA, 1, &channels);
	MOVLW       33
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       FARG_nrf_enable_auto_acks_channels+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(FARG_nrf_enable_auto_acks_channels+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,585 :: 		}
L_end_nrf_enable_auto_acks:
	RETURN      0
; end of _nrf_enable_auto_acks

_nrf_set_direction:

;f_nrf24l01p.h,587 :: 		uint8 nrf_set_direction(uint8 direction)
;f_nrf24l01p.h,589 :: 		uint8 actual = 0;
	CLRF        nrf_set_direction_actual_L0+0 
;f_nrf24l01p.h,590 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_CONFIG, 1, &actual);
	CLRF        FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_direction_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_direction_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,591 :: 		actual.B0 = (direction ? 1 : 0);
	MOVF        FARG_nrf_set_direction_direction+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_direction84
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_set_direction85
L_nrf_set_direction84:
	CLRF        R0 
L_nrf_set_direction85:
	BTFSC       R0, 0 
	GOTO        L__nrf_set_direction349
	BCF         nrf_set_direction_actual_L0+0, 0 
	GOTO        L__nrf_set_direction350
L__nrf_set_direction349:
	BSF         nrf_set_direction_actual_L0+0, 0 
L__nrf_set_direction350:
;f_nrf24l01p.h,592 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_CONFIG, 1, &actual);
	MOVLW       32
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_direction_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_direction_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,593 :: 		}
L_end_nrf_set_direction:
	RETURN      0
; end of _nrf_set_direction

_nrf_set_power:

;f_nrf24l01p.h,595 :: 		uint8 nrf_set_power(uint8 power)
;f_nrf24l01p.h,597 :: 		uint8 actual = 0;
	CLRF        nrf_set_power_actual_L0+0 
;f_nrf24l01p.h,600 :: 		___nrf_ce_off();
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;f_nrf24l01p.h,602 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_CONFIG, 1, &actual);
	CLRF        FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_power_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_power_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,603 :: 		actual.B1 = (power ? 1 : 0);
	MOVF        FARG_nrf_set_power_power+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_power86
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_set_power87
L_nrf_set_power86:
	CLRF        R0 
L_nrf_set_power87:
	BTFSC       R0, 0 
	GOTO        L__nrf_set_power352
	BCF         nrf_set_power_actual_L0+0, 1 
	GOTO        L__nrf_set_power353
L__nrf_set_power352:
	BSF         nrf_set_power_actual_L0+0, 1 
L__nrf_set_power353:
;f_nrf24l01p.h,604 :: 		result = ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_CONFIG, 1, &actual);
	MOVLW       32
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_power_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_power_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
	MOVF        R0, 0 
	MOVWF       nrf_set_power_result_L0+0 
;f_nrf24l01p.h,605 :: 		if (power) ___nrf_delay_pd2stby();
	MOVF        FARG_nrf_set_power_power+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrf_set_power88
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_nrf_set_power89:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_set_power89
	DECFSZ      R12, 1, 1
	BRA         L_nrf_set_power89
	GOTO        L_nrf_set_power90
L_nrf_set_power88:
;f_nrf24l01p.h,606 :: 		else       ___nrf_delay_active2pd();
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_nrf_set_power91:
	DECFSZ      R13, 1, 1
	BRA         L_nrf_set_power91
	DECFSZ      R12, 1, 1
	BRA         L_nrf_set_power91
	NOP
	NOP
L_nrf_set_power90:
;f_nrf24l01p.h,607 :: 		return result;
	MOVF        nrf_set_power_result_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,608 :: 		}
L_end_nrf_set_power:
	RETURN      0
; end of _nrf_set_power

_nrf_set_crc:

;f_nrf24l01p.h,610 :: 		uint8 nrf_set_crc(uint8 crc)
;f_nrf24l01p.h,612 :: 		uint8 actual = 0;
	CLRF        nrf_set_crc_actual_L0+0 
;f_nrf24l01p.h,613 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_CONFIG, 1, &actual);
	CLRF        FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_crc_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_crc_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,615 :: 		if (crc & NRFCFG_NO_CRC)        actual.B3 = 0;
	BTFSS       FARG_nrf_set_crc_crc+0, 0 
	GOTO        L_nrf_set_crc92
	BCF         nrf_set_crc_actual_L0+0, 3 
	GOTO        L_nrf_set_crc93
L_nrf_set_crc92:
;f_nrf24l01p.h,616 :: 		else if (crc & NRFCFG_CRC_1B) { actual.B3 = 1; actual.B2 = 0; }
	BTFSS       FARG_nrf_set_crc_crc+0, 1 
	GOTO        L_nrf_set_crc94
	BSF         nrf_set_crc_actual_L0+0, 3 
	BCF         nrf_set_crc_actual_L0+0, 2 
	GOTO        L_nrf_set_crc95
L_nrf_set_crc94:
;f_nrf24l01p.h,617 :: 		else                          { actual.B3 = 1; actual.B2 = 1; }
	BSF         nrf_set_crc_actual_L0+0, 3 
	BSF         nrf_set_crc_actual_L0+0, 2 
L_nrf_set_crc95:
L_nrf_set_crc93:
;f_nrf24l01p.h,619 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_CONFIG, 1, &actual);
	MOVLW       32
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_crc_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_crc_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,620 :: 		}
L_end_nrf_set_crc:
	RETURN      0
; end of _nrf_set_crc

_nrf_set_interrupts:

;f_nrf24l01p.h,622 :: 		uint8 nrf_set_interrupts(uint8 interrupts)
;f_nrf24l01p.h,624 :: 		uint8 actual = 0;
	CLRF        nrf_set_interrupts_actual_L0+0 
;f_nrf24l01p.h,625 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_CONFIG, 1, &actual);
	CLRF        FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_set_interrupts_actual_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_set_interrupts_actual_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,627 :: 		actual.B6 = (interrupts & NRFCFG_RX_INTERRUPT) ? 0 : 1;
	BTFSS       FARG_nrf_set_interrupts_interrupts+0, 0 
	GOTO        L_nrf_set_interrupts96
	CLRF        R0 
	GOTO        L_nrf_set_interrupts97
L_nrf_set_interrupts96:
	MOVLW       1
	MOVWF       R0 
L_nrf_set_interrupts97:
	BTFSC       R0, 0 
	GOTO        L__nrf_set_interrupts356
	BCF         nrf_set_interrupts_actual_L0+0, 6 
	GOTO        L__nrf_set_interrupts357
L__nrf_set_interrupts356:
	BSF         nrf_set_interrupts_actual_L0+0, 6 
L__nrf_set_interrupts357:
;f_nrf24l01p.h,628 :: 		actual.B5 = (interrupts & NRFCFG_TX_INTERRUPT) ? 0 : 1;
	BTFSS       FARG_nrf_set_interrupts_interrupts+0, 1 
	GOTO        L_nrf_set_interrupts98
	CLRF        R0 
	GOTO        L_nrf_set_interrupts99
L_nrf_set_interrupts98:
	MOVLW       1
	MOVWF       R0 
L_nrf_set_interrupts99:
	BTFSC       R0, 0 
	GOTO        L__nrf_set_interrupts358
	BCF         nrf_set_interrupts_actual_L0+0, 5 
	GOTO        L__nrf_set_interrupts359
L__nrf_set_interrupts358:
	BSF         nrf_set_interrupts_actual_L0+0, 5 
L__nrf_set_interrupts359:
;f_nrf24l01p.h,629 :: 		actual.B4 = (interrupts & NRFCFG_MAXRETRIES_INTERRUPT) ? 0 : 1;
	BTFSS       FARG_nrf_set_interrupts_interrupts+0, 2 
	GOTO        L_nrf_set_interrupts100
	CLRF        R0 
	GOTO        L_nrf_set_interrupts101
L_nrf_set_interrupts100:
	MOVLW       1
	MOVWF       R0 
L_nrf_set_interrupts101:
	BTFSC       R0, 0 
	GOTO        L__nrf_set_interrupts360
	BCF         nrf_set_interrupts_actual_L0+0, 4 
	GOTO        L__nrf_set_interrupts361
L__nrf_set_interrupts360:
	BSF         nrf_set_interrupts_actual_L0+0, 4 
L__nrf_set_interrupts361:
;f_nrf24l01p.h,631 :: 		return ___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_CONFIG, 1, &actual);
	MOVLW       32
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_set_interrupts_actual_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_set_interrupts_actual_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,632 :: 		}
L_end_nrf_set_interrupts:
	RETURN      0
; end of _nrf_set_interrupts

____nrf_send_command:

;f_nrf24l01p.h,634 :: 		uint8 ___nrf_send_command(uint8 cmd, uint8 numbytes, uint8 * buffer)
;f_nrf24l01p.h,638 :: 		___nrf_select();
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L____nrf_send_command102:
	DECFSZ      R13, 1, 1
	BRA         L____nrf_send_command102
	NOP
	NOP
;f_nrf24l01p.h,639 :: 		status = ___nrf_send(cmd);
	MOVF        FARG____nrf_send_command_cmd+0, 0 
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
	MOVF        R0, 0 
	MOVWF       ___nrf_send_command_status_L0+0 
;f_nrf24l01p.h,641 :: 		for (i = 0; i < numbytes; i ++)
	CLRF        ___nrf_send_command_i_L0+0 
L____nrf_send_command103:
	MOVF        FARG____nrf_send_command_numbytes+0, 0 
	SUBWF       ___nrf_send_command_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L____nrf_send_command104
;f_nrf24l01p.h,642 :: 		___nrf_send(buffer[i]);
	MOVF        ___nrf_send_command_i_L0+0, 0 
	ADDWF       FARG____nrf_send_command_buffer+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG____nrf_send_command_buffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
;f_nrf24l01p.h,641 :: 		for (i = 0; i < numbytes; i ++)
	INCF        ___nrf_send_command_i_L0+0, 1 
;f_nrf24l01p.h,642 :: 		___nrf_send(buffer[i]);
	GOTO        L____nrf_send_command103
L____nrf_send_command104:
;f_nrf24l01p.h,644 :: 		___nrf_deselect();
	MOVLW       39
	MOVWF       R13, 0
L____nrf_send_command106:
	DECFSZ      R13, 1, 1
	BRA         L____nrf_send_command106
	NOP
	NOP
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;f_nrf24l01p.h,646 :: 		return status;
	MOVF        ___nrf_send_command_status_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,647 :: 		}
L_end____nrf_send_command:
	RETURN      0
; end of ____nrf_send_command

____nrf_read_command:

;f_nrf24l01p.h,649 :: 		uint8 ___nrf_read_command(uint8 cmd, uint8 numbytes, uint8 * buffer)
;f_nrf24l01p.h,653 :: 		___nrf_select();
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L____nrf_read_command107:
	DECFSZ      R13, 1, 1
	BRA         L____nrf_read_command107
	NOP
	NOP
;f_nrf24l01p.h,654 :: 		status = ___nrf_send(cmd);
	MOVF        FARG____nrf_read_command_cmd+0, 0 
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
	MOVF        R0, 0 
	MOVWF       ___nrf_read_command_status_L0+0 
;f_nrf24l01p.h,656 :: 		for (i = 0; i < numbytes; i ++)
	CLRF        ___nrf_read_command_i_L0+0 
L____nrf_read_command108:
	MOVF        FARG____nrf_read_command_numbytes+0, 0 
	SUBWF       ___nrf_read_command_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L____nrf_read_command109
;f_nrf24l01p.h,657 :: 		buffer[i] = ___nrf_send(NRFCMD_NOP);
	MOVF        ___nrf_read_command_i_L0+0, 0 
	ADDWF       FARG____nrf_read_command_buffer+0, 0 
	MOVWF       FLOC_____nrf_read_command+0 
	MOVLW       0
	ADDWFC      FARG____nrf_read_command_buffer+1, 0 
	MOVWF       FLOC_____nrf_read_command+1 
	MOVLW       255
	MOVWF       FARG____nrf_send_value+0 
	CALL        ____nrf_send+0, 0
	MOVFF       FLOC_____nrf_read_command+0, FSR1
	MOVFF       FLOC_____nrf_read_command+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;f_nrf24l01p.h,656 :: 		for (i = 0; i < numbytes; i ++)
	INCF        ___nrf_read_command_i_L0+0, 1 
;f_nrf24l01p.h,657 :: 		buffer[i] = ___nrf_send(NRFCMD_NOP);
	GOTO        L____nrf_read_command108
L____nrf_read_command109:
;f_nrf24l01p.h,659 :: 		___nrf_deselect();
	MOVLW       39
	MOVWF       R13, 0
L____nrf_read_command111:
	DECFSZ      R13, 1, 1
	BRA         L____nrf_read_command111
	NOP
	NOP
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;f_nrf24l01p.h,661 :: 		return status;
	MOVF        ___nrf_read_command_status_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,662 :: 		}
L_end____nrf_read_command:
	RETURN      0
; end of ____nrf_read_command

____nrf_send:

;f_nrf24l01p.h,664 :: 		uint8 ___nrf_send(uint8 value)
;f_nrf24l01p.h,666 :: 		uint8 result = SPI_NRF_FUNCTION(value);
	MOVF        FARG____nrf_send_value+0, 0 
	MOVWF       FARG_SPI_Remappable_Read_buffer+0 
	CALL        _SPI_Remappable_Read+0, 0
	MOVF        R0, 0 
	MOVWF       ___nrf_send_result_L0+0 
;f_nrf24l01p.h,667 :: 		___nrf_delay_post_cmd();
	MOVLW       39
	MOVWF       R13, 0
L____nrf_send112:
	DECFSZ      R13, 1, 1
	BRA         L____nrf_send112
	NOP
	NOP
;f_nrf24l01p.h,668 :: 		return result;
	MOVF        ___nrf_send_result_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,669 :: 		}
L_end____nrf_send:
	RETURN      0
; end of ____nrf_send

_nrf_test:

;f_nrf24l01p.h,671 :: 		uint8 nrf_test()
;f_nrf24l01p.h,676 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_RF_CH, 1, &prev);
	MOVLW       5
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_test_prev_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_test_prev_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,679 :: 		new = (~ res) & 0b01111111;
	COMF        nrf_test_res_L0+0, 0 
	MOVWF       nrf_test_new_L0+0 
	MOVLW       127
	ANDWF       nrf_test_new_L0+0, 1 
;f_nrf24l01p.h,680 :: 		___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_RF_CH, 1, &new);
	MOVLW       37
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_test_new_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_test_new_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,683 :: 		___nrf_read_command(NRFCMD_R_REGISTER | NRFREG_RF_CH, 1, &res);
	MOVLW       5
	MOVWF       FARG____nrf_read_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_read_command_numbytes+0 
	MOVLW       nrf_test_res_L0+0
	MOVWF       FARG____nrf_read_command_buffer+0 
	MOVLW       hi_addr(nrf_test_res_L0+0)
	MOVWF       FARG____nrf_read_command_buffer+1 
	CALL        ____nrf_read_command+0, 0
;f_nrf24l01p.h,684 :: 		res = (res == new ? 1 : 0);
	MOVF        nrf_test_res_L0+0, 0 
	XORWF       nrf_test_new_L0+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_nrf_test113
	MOVLW       1
	MOVWF       R0 
	GOTO        L_nrf_test114
L_nrf_test113:
	CLRF        R0 
L_nrf_test114:
	MOVF        R0, 0 
	MOVWF       nrf_test_res_L0+0 
;f_nrf24l01p.h,687 :: 		___nrf_send_command(NRFCMD_W_REGISTER | NRFREG_RF_CH, 1, &prev);
	MOVLW       37
	MOVWF       FARG____nrf_send_command_cmd+0 
	MOVLW       1
	MOVWF       FARG____nrf_send_command_numbytes+0 
	MOVLW       nrf_test_prev_L0+0
	MOVWF       FARG____nrf_send_command_buffer+0 
	MOVLW       hi_addr(nrf_test_prev_L0+0)
	MOVWF       FARG____nrf_send_command_buffer+1 
	CALL        ____nrf_send_command+0, 0
;f_nrf24l01p.h,689 :: 		return res;
	MOVF        nrf_test_res_L0+0, 0 
	MOVWF       R0 
;f_nrf24l01p.h,690 :: 		}
L_end_nrf_test:
	RETURN      0
; end of _nrf_test

_emu_eeprom_init:

;18f27j53_eepromemulation.h,53 :: 		void emu_eeprom_init()
;18f27j53_eepromemulation.h,57 :: 		c = ___EMU_EEPROM_RESERVED[0];
	CLRF        emu_eeprom_init_c_L0+0 
;18f27j53_eepromemulation.h,58 :: 		while (c.B0) c --;
L_emu_eeprom_init115:
	BTFSS       emu_eeprom_init_c_L0+0, 0 
	GOTO        L_emu_eeprom_init116
	DECF        emu_eeprom_init_c_L0+0, 1 
	GOTO        L_emu_eeprom_init115
L_emu_eeprom_init116:
;18f27j53_eepromemulation.h,59 :: 		c = ___EMU_EEPROM_MEM[0];
	MOVF        ____EMU_EEPROM_MEM+0, 0 
	MOVWF       emu_eeprom_init_c_L0+0 
;18f27j53_eepromemulation.h,60 :: 		while (c.B0) c --;
L_emu_eeprom_init117:
	BTFSS       emu_eeprom_init_c_L0+0, 0 
	GOTO        L_emu_eeprom_init118
	DECF        emu_eeprom_init_c_L0+0, 1 
	GOTO        L_emu_eeprom_init117
L_emu_eeprom_init118:
;18f27j53_eepromemulation.h,62 :: 		emu_eeprom_load();
	CALL        _emu_eeprom_load+0, 0
;18f27j53_eepromemulation.h,63 :: 		}
L_end_emu_eeprom_init:
	RETURN      0
; end of _emu_eeprom_init

_emu_eeprom_load:

;18f27j53_eepromemulation.h,65 :: 		void emu_eeprom_load()
;18f27j53_eepromemulation.h,67 :: 		FLASH_Read_N_Bytes(___EMU_EEPROM_START_ADDRESS, ___EMU_EEPROM_MEM, ___EMU_EEPROM_SIZE);
	MOVLW       0
	MOVWF       FARG_FLASH_Read_N_Bytes_address+0 
	MOVLW       0
	MOVWF       FARG_FLASH_Read_N_Bytes_address+1 
	MOVLW       1
	MOVWF       FARG_FLASH_Read_N_Bytes_address+2 
	MOVLW       0
	MOVWF       FARG_FLASH_Read_N_Bytes_address+3 
	MOVLW       ____EMU_EEPROM_MEM+0
	MOVWF       FARG_FLASH_Read_N_Bytes_data_+0 
	MOVLW       hi_addr(____EMU_EEPROM_MEM+0)
	MOVWF       FARG_FLASH_Read_N_Bytes_data_+1 
	MOVLW       0
	MOVWF       FARG_FLASH_Read_N_Bytes_N+0 
	MOVLW       4
	MOVWF       FARG_FLASH_Read_N_Bytes_N+1 
	CALL        _FLASH_Read_N_Bytes+0, 0
;18f27j53_eepromemulation.h,68 :: 		}
L_end_emu_eeprom_load:
	RETURN      0
; end of _emu_eeprom_load

_emu_eeprom_save:

;18f27j53_eepromemulation.h,70 :: 		void emu_eeprom_save()
;18f27j53_eepromemulation.h,72 :: 		FLASH_Erase_Write_1024(___EMU_EEPROM_START_ADDRESS, ___EMU_EEPROM_MEM);
	MOVLW       0
	MOVWF       FARG_FLASH_Erase_Write_1024_address+0 
	MOVLW       0
	MOVWF       FARG_FLASH_Erase_Write_1024_address+1 
	MOVLW       1
	MOVWF       FARG_FLASH_Erase_Write_1024_address+2 
	MOVLW       0
	MOVWF       FARG_FLASH_Erase_Write_1024_address+3 
	MOVLW       ____EMU_EEPROM_MEM+0
	MOVWF       FARG_FLASH_Erase_Write_1024_data_+0 
	MOVLW       hi_addr(____EMU_EEPROM_MEM+0)
	MOVWF       FARG_FLASH_Erase_Write_1024_data_+1 
	CALL        _FLASH_Erase_Write_1024+0, 0
;18f27j53_eepromemulation.h,73 :: 		}
L_end_emu_eeprom_save:
	RETURN      0
; end of _emu_eeprom_save

_emu_eeprom_wr:

;18f27j53_eepromemulation.h,75 :: 		void emu_eeprom_wr(uint16 address, uint8 byte_data, uint8 commit_change)
;18f27j53_eepromemulation.h,77 :: 		___EMU_EEPROM_MEM[address] = byte_data;
	MOVLW       ____EMU_EEPROM_MEM+0
	ADDWF       FARG_emu_eeprom_wr_address+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(____EMU_EEPROM_MEM+0)
	ADDWFC      FARG_emu_eeprom_wr_address+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_emu_eeprom_wr_byte_data+0, 0 
	MOVWF       POSTINC1+0 
;18f27j53_eepromemulation.h,79 :: 		if (commit_change)
	MOVF        FARG_emu_eeprom_wr_commit_change+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_emu_eeprom_wr119
;18f27j53_eepromemulation.h,80 :: 		emu_eeprom_save();
	CALL        _emu_eeprom_save+0, 0
L_emu_eeprom_wr119:
;18f27j53_eepromemulation.h,81 :: 		}
L_end_emu_eeprom_wr:
	RETURN      0
; end of _emu_eeprom_wr

_emu_eeprom_rd:

;18f27j53_eepromemulation.h,83 :: 		uint8 emu_eeprom_rd(uint16 address)
;18f27j53_eepromemulation.h,85 :: 		return ___EMU_EEPROM_MEM[address];
	MOVLW       ____EMU_EEPROM_MEM+0
	ADDWF       FARG_emu_eeprom_rd_address+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(____EMU_EEPROM_MEM+0)
	ADDWFC      FARG_emu_eeprom_rd_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
;18f27j53_eepromemulation.h,86 :: 		}
L_end_emu_eeprom_rd:
	RETURN      0
; end of _emu_eeprom_rd

_tabdata_new:

;inneradt.h,75 :: 		void tabdata_new(TTabData* instance)
;inneradt.h,77 :: 		tabdata_clear_time(instance);
	MOVF        FARG_tabdata_new_instance+0, 0 
	MOVWF       FARG_tabdata_clear_time_instance+0 
	MOVF        FARG_tabdata_new_instance+1, 0 
	MOVWF       FARG_tabdata_clear_time_instance+1 
	CALL        _tabdata_clear_time+0, 0
;inneradt.h,78 :: 		tabdata_clear_team(&(instance -> locals));
	MOVF        FARG_tabdata_new_instance+0, 0 
	MOVWF       FARG_tabdata_clear_team_instance+0 
	MOVF        FARG_tabdata_new_instance+1, 0 
	MOVWF       FARG_tabdata_clear_team_instance+1 
	CALL        _tabdata_clear_team+0, 0
;inneradt.h,79 :: 		tabdata_clear_team(&(instance -> guests));
	MOVLW       3
	ADDWF       FARG_tabdata_new_instance+0, 0 
	MOVWF       FARG_tabdata_clear_team_instance+0 
	MOVLW       0
	ADDWFC      FARG_tabdata_new_instance+1, 0 
	MOVWF       FARG_tabdata_clear_team_instance+1 
	CALL        _tabdata_clear_team+0, 0
;inneradt.h,80 :: 		}
L_end_tabdata_new:
	RETURN      0
; end of _tabdata_new

_tabdata_clear_time:

;inneradt.h,82 :: 		void tabdata_clear_time(TTabData* instance)
;inneradt.h,84 :: 		instance -> time.min = 0;
	MOVLW       6
	ADDWF       FARG_tabdata_clear_time_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_clear_time_instance+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;inneradt.h,85 :: 		instance -> time.sec = 0;
	MOVLW       6
	ADDWF       FARG_tabdata_clear_time_instance+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_tabdata_clear_time_instance+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;inneradt.h,86 :: 		}
L_end_tabdata_clear_time:
	RETURN      0
; end of _tabdata_clear_time

_tabdata_clear_team:

;inneradt.h,88 :: 		void tabdata_clear_team(TTeamData* instance)
;inneradt.h,90 :: 		instance -> points = 0;
	MOVFF       FARG_tabdata_clear_team_instance+0, FSR1
	MOVFF       FARG_tabdata_clear_team_instance+1, FSR1H
	CLRF        POSTINC1+0 
;inneradt.h,91 :: 		instance -> sets = 0;
	MOVLW       1
	ADDWF       FARG_tabdata_clear_team_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_clear_team_instance+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;inneradt.h,92 :: 		instance -> flags = 0;
	MOVLW       2
	ADDWF       FARG_tabdata_clear_team_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_clear_team_instance+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;inneradt.h,93 :: 		}
L_end_tabdata_clear_team:
	RETURN      0
; end of _tabdata_clear_team

_tabdata_add_sec:

;inneradt.h,95 :: 		void tabdata_add_sec(TTimeSpan* instance, int8 toAdd)
;inneradt.h,98 :: 		acTTimeSpan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);
	MOVFF       FARG_tabdata_add_sec_instance+0, FSR0
	MOVFF       FARG_tabdata_add_sec_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       1
	ADDWF       FARG_tabdata_add_sec_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_sec_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+1 
;inneradt.h,100 :: 		if (toAdd > 0)
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_tabdata_add_sec_toAdd+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_sec120
;inneradt.h,102 :: 		if (acTTimeSpan == TEAMS_MAX_TIME) acTTimeSpan = 0;
	MOVF        tabdata_add_sec_acTTimeSpan_L0+1, 0 
	XORLW       23
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sec375
	MOVLW       52
	XORWF       tabdata_add_sec_acTTimeSpan_L0+0, 0 
L__tabdata_add_sec375:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_sec121
	CLRF        tabdata_add_sec_acTTimeSpan_L0+0 
	CLRF        tabdata_add_sec_acTTimeSpan_L0+1 
	GOTO        L_tabdata_add_sec122
L_tabdata_add_sec121:
;inneradt.h,105 :: 		acTTimeSpan += toAdd;
	MOVF        FARG_tabdata_add_sec_toAdd+0, 0 
	ADDWF       tabdata_add_sec_acTTimeSpan_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_tabdata_add_sec_toAdd+0, 7 
	MOVLW       255
	ADDWFC      tabdata_add_sec_acTTimeSpan_L0+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+0 
	MOVF        R2, 0 
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+1 
;inneradt.h,106 :: 		if (acTTimeSpan > TEAMS_MAX_TIME) acTTimeSpan = TEAMS_MAX_TIME;
	MOVLW       128
	XORLW       23
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sec376
	MOVF        R1, 0 
	SUBLW       52
L__tabdata_add_sec376:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_sec123
	MOVLW       52
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+0 
	MOVLW       23
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+1 
L_tabdata_add_sec123:
;inneradt.h,107 :: 		}
L_tabdata_add_sec122:
;inneradt.h,108 :: 		}
	GOTO        L_tabdata_add_sec124
L_tabdata_add_sec120:
;inneradt.h,111 :: 		if (acTTimeSpan == 0) acTTimeSpan = TEAMS_MAX_TIME;
	MOVLW       0
	XORWF       tabdata_add_sec_acTTimeSpan_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sec377
	MOVLW       0
	XORWF       tabdata_add_sec_acTTimeSpan_L0+0, 0 
L__tabdata_add_sec377:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_sec125
	MOVLW       52
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+0 
	MOVLW       23
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+1 
	GOTO        L_tabdata_add_sec126
L_tabdata_add_sec125:
;inneradt.h,114 :: 		acTTimeSpan += toAdd;
	MOVF        FARG_tabdata_add_sec_toAdd+0, 0 
	ADDWF       tabdata_add_sec_acTTimeSpan_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_tabdata_add_sec_toAdd+0, 7 
	MOVLW       255
	ADDWFC      tabdata_add_sec_acTTimeSpan_L0+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+0 
	MOVF        R2, 0 
	MOVWF       tabdata_add_sec_acTTimeSpan_L0+1 
;inneradt.h,115 :: 		if (acTTimeSpan < 0) acTTimeSpan = 0;
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sec378
	MOVLW       0
	SUBWF       R1, 0 
L__tabdata_add_sec378:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_sec127
	CLRF        tabdata_add_sec_acTTimeSpan_L0+0 
	CLRF        tabdata_add_sec_acTTimeSpan_L0+1 
L_tabdata_add_sec127:
;inneradt.h,116 :: 		}
L_tabdata_add_sec126:
;inneradt.h,117 :: 		}
L_tabdata_add_sec124:
;inneradt.h,119 :: 		instance -> min = acTTimeSpan / 60;
	MOVF        FARG_tabdata_add_sec_instance+0, 0 
	MOVWF       FLOC__tabdata_add_sec+0 
	MOVF        FARG_tabdata_add_sec_instance+1, 0 
	MOVWF       FLOC__tabdata_add_sec+1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        tabdata_add_sec_acTTimeSpan_L0+0, 0 
	MOVWF       R0 
	MOVF        tabdata_add_sec_acTTimeSpan_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVFF       FLOC__tabdata_add_sec+0, FSR1
	MOVFF       FLOC__tabdata_add_sec+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,120 :: 		instance -> sec = acTTimeSpan % 60;
	MOVLW       1
	ADDWF       FARG_tabdata_add_sec_instance+0, 0 
	MOVWF       FLOC__tabdata_add_sec+0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_sec_instance+1, 0 
	MOVWF       FLOC__tabdata_add_sec+1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        tabdata_add_sec_acTTimeSpan_L0+0, 0 
	MOVWF       R0 
	MOVF        tabdata_add_sec_acTTimeSpan_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVFF       FLOC__tabdata_add_sec+0, FSR1
	MOVFF       FLOC__tabdata_add_sec+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,121 :: 		}
L_end_tabdata_add_sec:
	RETURN      0
; end of _tabdata_add_sec

_tabdata_add_min:

;inneradt.h,123 :: 		void tabdata_add_min(TTimeSpan* instance, int8 toAdd)
;inneradt.h,126 :: 		acTTimeSpan = (int16)(instance -> min) * 60 + (int16)(instance -> sec);
	MOVFF       FARG_tabdata_add_min_instance+0, FSR0
	MOVFF       FARG_tabdata_add_min_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       1
	ADDWF       FARG_tabdata_add_min_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_min_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       tabdata_add_min_acTTimeSpan_L0+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       tabdata_add_min_acTTimeSpan_L0+1 
;inneradt.h,128 :: 		if (toAdd > 0)
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_tabdata_add_min_toAdd+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_min128
;inneradt.h,130 :: 		if (acTTimeSpan == TEAMS_MAX_TIME) acTTimeSpan = 0;
	MOVF        tabdata_add_min_acTTimeSpan_L0+1, 0 
	XORLW       23
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_min380
	MOVLW       52
	XORWF       tabdata_add_min_acTTimeSpan_L0+0, 0 
L__tabdata_add_min380:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_min129
	CLRF        tabdata_add_min_acTTimeSpan_L0+0 
	CLRF        tabdata_add_min_acTTimeSpan_L0+1 
	GOTO        L_tabdata_add_min130
L_tabdata_add_min129:
;inneradt.h,133 :: 		acTTimeSpan += toAdd * 60;
	MOVF        FARG_tabdata_add_min_toAdd+0, 0 
	MOVWF       R0 
	MOVLW       60
	MOVWF       R4 
	CALL        _Mul_8x8_S+0, 0
	MOVF        R0, 0 
	ADDWF       tabdata_add_min_acTTimeSpan_L0+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	ADDWFC      tabdata_add_min_acTTimeSpan_L0+1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       tabdata_add_min_acTTimeSpan_L0+0 
	MOVF        R3, 0 
	MOVWF       tabdata_add_min_acTTimeSpan_L0+1 
;inneradt.h,134 :: 		if (acTTimeSpan > TEAMS_MAX_TIME) acTTimeSpan = TEAMS_MAX_TIME;
	MOVLW       128
	XORLW       23
	MOVWF       R0 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_min381
	MOVF        R2, 0 
	SUBLW       52
L__tabdata_add_min381:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_min131
	MOVLW       52
	MOVWF       tabdata_add_min_acTTimeSpan_L0+0 
	MOVLW       23
	MOVWF       tabdata_add_min_acTTimeSpan_L0+1 
L_tabdata_add_min131:
;inneradt.h,135 :: 		}
L_tabdata_add_min130:
;inneradt.h,136 :: 		}
	GOTO        L_tabdata_add_min132
L_tabdata_add_min128:
;inneradt.h,139 :: 		if (acTTimeSpan == 0) acTTimeSpan = TEAMS_MAX_TIME;
	MOVLW       0
	XORWF       tabdata_add_min_acTTimeSpan_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_min382
	MOVLW       0
	XORWF       tabdata_add_min_acTTimeSpan_L0+0, 0 
L__tabdata_add_min382:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_min133
	MOVLW       52
	MOVWF       tabdata_add_min_acTTimeSpan_L0+0 
	MOVLW       23
	MOVWF       tabdata_add_min_acTTimeSpan_L0+1 
	GOTO        L_tabdata_add_min134
L_tabdata_add_min133:
;inneradt.h,142 :: 		acTTimeSpan += toAdd * 60;
	MOVF        FARG_tabdata_add_min_toAdd+0, 0 
	MOVWF       R0 
	MOVLW       60
	MOVWF       R4 
	CALL        _Mul_8x8_S+0, 0
	MOVF        R0, 0 
	ADDWF       tabdata_add_min_acTTimeSpan_L0+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	ADDWFC      tabdata_add_min_acTTimeSpan_L0+1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       tabdata_add_min_acTTimeSpan_L0+0 
	MOVF        R3, 0 
	MOVWF       tabdata_add_min_acTTimeSpan_L0+1 
;inneradt.h,143 :: 		if (acTTimeSpan < 0) acTTimeSpan = 0;
	MOVLW       128
	XORWF       R3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_min383
	MOVLW       0
	SUBWF       R2, 0 
L__tabdata_add_min383:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_min135
	CLRF        tabdata_add_min_acTTimeSpan_L0+0 
	CLRF        tabdata_add_min_acTTimeSpan_L0+1 
L_tabdata_add_min135:
;inneradt.h,144 :: 		}
L_tabdata_add_min134:
;inneradt.h,145 :: 		}
L_tabdata_add_min132:
;inneradt.h,147 :: 		instance -> min = acTTimeSpan / 60;
	MOVF        FARG_tabdata_add_min_instance+0, 0 
	MOVWF       FLOC__tabdata_add_min+0 
	MOVF        FARG_tabdata_add_min_instance+1, 0 
	MOVWF       FLOC__tabdata_add_min+1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        tabdata_add_min_acTTimeSpan_L0+0, 0 
	MOVWF       R0 
	MOVF        tabdata_add_min_acTTimeSpan_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVFF       FLOC__tabdata_add_min+0, FSR1
	MOVFF       FLOC__tabdata_add_min+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,148 :: 		instance -> sec = acTTimeSpan % 60;
	MOVLW       1
	ADDWF       FARG_tabdata_add_min_instance+0, 0 
	MOVWF       FLOC__tabdata_add_min+0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_min_instance+1, 0 
	MOVWF       FLOC__tabdata_add_min+1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        tabdata_add_min_acTTimeSpan_L0+0, 0 
	MOVWF       R0 
	MOVF        tabdata_add_min_acTTimeSpan_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVFF       FLOC__tabdata_add_min+0, FSR1
	MOVFF       FLOC__tabdata_add_min+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,149 :: 		}
L_end_tabdata_add_min:
	RETURN      0
; end of _tabdata_add_min

_tabdata_time_is_not_null:

;inneradt.h,151 :: 		int8 tabdata_time_is_not_null(TTimeSpan* instance)
;inneradt.h,153 :: 		return ((instance -> min > 0) || (instance -> sec > 0));
	MOVFF       FARG_tabdata_time_is_not_null_instance+0, FSR0
	MOVFF       FARG_tabdata_time_is_not_null_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 0 
	GOTO        L_tabdata_time_is_not_null137
	MOVLW       1
	ADDWF       FARG_tabdata_time_is_not_null_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_time_is_not_null_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       0
	BTFSS       STATUS+0, 0 
	GOTO        L_tabdata_time_is_not_null137
	CLRF        R0 
	GOTO        L_tabdata_time_is_not_null136
L_tabdata_time_is_not_null137:
	MOVLW       1
	MOVWF       R0 
L_tabdata_time_is_not_null136:
;inneradt.h,154 :: 		}
L_end_tabdata_time_is_not_null:
	RETURN      0
; end of _tabdata_time_is_not_null

_tabdata_add_points:

;inneradt.h,156 :: 		void tabdata_add_points(TTeamData* instance, int8 toAdd)
;inneradt.h,158 :: 		int16 newPoints = (int16)(instance -> points);
	MOVFF       FARG_tabdata_add_points_instance+0, FSR0
	MOVFF       FARG_tabdata_add_points_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;inneradt.h,160 :: 		if (toAdd > 0)
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_tabdata_add_points_toAdd+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_points138
;inneradt.h,162 :: 		if (newPoints == TEAMS_MAX_POINTS) newPoints = 0;
	MOVF        R4, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_points386
	MOVLW       199
	XORWF       R3, 0 
L__tabdata_add_points386:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_points139
	CLRF        R3 
	CLRF        R4 
	GOTO        L_tabdata_add_points140
L_tabdata_add_points139:
;inneradt.h,165 :: 		newPoints += toAdd;
	MOVF        FARG_tabdata_add_points_toAdd+0, 0 
	ADDWF       R3, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_tabdata_add_points_toAdd+0, 7 
	MOVLW       255
	ADDWFC      R4, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       R4 
;inneradt.h,166 :: 		if (newPoints > TEAMS_MAX_POINTS) newPoints = TEAMS_MAX_POINTS;
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_points387
	MOVF        R1, 0 
	SUBLW       199
L__tabdata_add_points387:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_points141
	MOVLW       199
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
L_tabdata_add_points141:
;inneradt.h,167 :: 		}
L_tabdata_add_points140:
;inneradt.h,168 :: 		}
	GOTO        L_tabdata_add_points142
L_tabdata_add_points138:
;inneradt.h,171 :: 		if (newPoints == 0) newPoints = TEAMS_MAX_POINTS;
	MOVLW       0
	XORWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_points388
	MOVLW       0
	XORWF       R3, 0 
L__tabdata_add_points388:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_points143
	MOVLW       199
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	GOTO        L_tabdata_add_points144
L_tabdata_add_points143:
;inneradt.h,174 :: 		newPoints += toAdd;
	MOVF        FARG_tabdata_add_points_toAdd+0, 0 
	ADDWF       R3, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_tabdata_add_points_toAdd+0, 7 
	MOVLW       255
	ADDWFC      R4, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       R4 
;inneradt.h,175 :: 		if (newPoints < 0) newPoints = 0;
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_points389
	MOVLW       0
	SUBWF       R1, 0 
L__tabdata_add_points389:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_points145
	CLRF        R3 
	CLRF        R4 
L_tabdata_add_points145:
;inneradt.h,176 :: 		}
L_tabdata_add_points144:
;inneradt.h,177 :: 		}
L_tabdata_add_points142:
;inneradt.h,179 :: 		instance -> points = Lo(newPoints);
	MOVFF       FARG_tabdata_add_points_instance+0, FSR1
	MOVFF       FARG_tabdata_add_points_instance+1, FSR1H
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,180 :: 		}
L_end_tabdata_add_points:
	RETURN      0
; end of _tabdata_add_points

_tabdata_add_sets:

;inneradt.h,182 :: 		void tabdata_add_sets(TTeamData* instance, int8 toAdd)
;inneradt.h,184 :: 		int16 newSets = (int16)(instance -> sets);
	MOVLW       1
	ADDWF       FARG_tabdata_add_sets_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_sets_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;inneradt.h,186 :: 		if (toAdd > 0)
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_tabdata_add_sets_toAdd+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_sets146
;inneradt.h,188 :: 		if (newSets == TEAMS_MAX_SETS) newSets = 0;
	MOVF        R4, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sets391
	MOVLW       9
	XORWF       R3, 0 
L__tabdata_add_sets391:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_sets147
	CLRF        R3 
	CLRF        R4 
	GOTO        L_tabdata_add_sets148
L_tabdata_add_sets147:
;inneradt.h,191 :: 		newSets += toAdd;
	MOVF        FARG_tabdata_add_sets_toAdd+0, 0 
	ADDWF       R3, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_tabdata_add_sets_toAdd+0, 7 
	MOVLW       255
	ADDWFC      R4, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       R4 
;inneradt.h,192 :: 		if (newSets > TEAMS_MAX_SETS) newSets = TEAMS_MAX_SETS;
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sets392
	MOVF        R1, 0 
	SUBLW       9
L__tabdata_add_sets392:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_sets149
	MOVLW       9
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
L_tabdata_add_sets149:
;inneradt.h,193 :: 		}
L_tabdata_add_sets148:
;inneradt.h,194 :: 		}
	GOTO        L_tabdata_add_sets150
L_tabdata_add_sets146:
;inneradt.h,197 :: 		if (newSets == 0) newSets = TEAMS_MAX_SETS;
	MOVLW       0
	XORWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sets393
	MOVLW       0
	XORWF       R3, 0 
L__tabdata_add_sets393:
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_add_sets151
	MOVLW       9
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	GOTO        L_tabdata_add_sets152
L_tabdata_add_sets151:
;inneradt.h,200 :: 		newSets += toAdd;
	MOVF        FARG_tabdata_add_sets_toAdd+0, 0 
	ADDWF       R3, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_tabdata_add_sets_toAdd+0, 7 
	MOVLW       255
	ADDWFC      R4, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       R4 
;inneradt.h,201 :: 		if (newSets < 0) newSets = 0;
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tabdata_add_sets394
	MOVLW       0
	SUBWF       R1, 0 
L__tabdata_add_sets394:
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_sets153
	CLRF        R3 
	CLRF        R4 
L_tabdata_add_sets153:
;inneradt.h,202 :: 		}
L_tabdata_add_sets152:
;inneradt.h,203 :: 		}
L_tabdata_add_sets150:
;inneradt.h,205 :: 		instance -> sets = Lo(newSets);
	MOVLW       1
	ADDWF       FARG_tabdata_add_sets_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_sets_instance+1, 0 
	MOVWF       FSR1H 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,206 :: 		}
L_end_tabdata_add_sets:
	RETURN      0
; end of _tabdata_add_sets

_tabdata_toggle_flag:

;inneradt.h,208 :: 		void tabdata_toggle_flag(TTeamData* instance, TLightFlags flag)
;inneradt.h,210 :: 		if (instance -> flags & flag) instance -> flags -= flag;
	MOVLW       2
	ADDWF       FARG_tabdata_toggle_flag_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_toggle_flag_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        FARG_tabdata_toggle_flag_flag+0, 0 
	ANDWF       POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       STATUS+0, 2 
	GOTO        L_tabdata_toggle_flag154
	MOVLW       2
	ADDWF       FARG_tabdata_toggle_flag_instance+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_tabdata_toggle_flag_instance+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        FARG_tabdata_toggle_flag_flag+0, 0 
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_tabdata_toggle_flag155
L_tabdata_toggle_flag154:
;inneradt.h,211 :: 		else instance -> flags |= flag;
	MOVLW       2
	ADDWF       FARG_tabdata_toggle_flag_instance+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_tabdata_toggle_flag_instance+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        FARG_tabdata_toggle_flag_flag+0, 0 
	IORWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
L_tabdata_toggle_flag155:
;inneradt.h,212 :: 		}
L_end_tabdata_toggle_flag:
	RETURN      0
; end of _tabdata_toggle_flag

_tabdata_swap:

;inneradt.h,214 :: 		void tabdata_swap(TTabData* instance)
;inneradt.h,217 :: 		swapInst.points = instance -> locals -> points;
	MOVFF       FARG_tabdata_swap_instance+0, FSR0
	MOVFF       FARG_tabdata_swap_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       R2 
;inneradt.h,218 :: 		swapInst.sets = instance -> locals -> sets;
	MOVLW       1
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
;inneradt.h,219 :: 		swapInst.flags = instance -> locals -> flags;
	MOVLW       2
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
;inneradt.h,221 :: 		instance -> locals.points = instance -> guests -> points;
	MOVLW       3
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       FARG_tabdata_swap_instance+0, FSR1
	MOVFF       FARG_tabdata_swap_instance+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,222 :: 		instance -> locals.sets = instance -> guests -> sets;
	MOVLW       1
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       FSR1H 
	MOVLW       3
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,223 :: 		instance -> locals.flags = instance -> guests -> flags;
	MOVLW       2
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       FSR1H 
	MOVLW       3
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,225 :: 		instance -> guests.points = swapInst.points;
	MOVLW       3
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       FSR1H 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,226 :: 		instance -> guests.sets = swapInst.sets;
	MOVLW       3
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       R1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,227 :: 		instance -> guests.flags = swapInst.flags;
	MOVLW       3
	ADDWF       FARG_tabdata_swap_instance+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_tabdata_swap_instance+1, 0 
	MOVWF       R1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        R4, 0 
	MOVWF       POSTINC1+0 
;inneradt.h,228 :: 		}
L_end_tabdata_swap:
	RETURN      0
; end of _tabdata_swap

_tabdata_add_pp:

;inneradt.h,230 :: 		void tabdata_add_pp(TTeamData* instance)
;inneradt.h,232 :: 		if      (instance -> points < 15)
	MOVFF       FARG_tabdata_add_pp_instance+0, FSR0
	MOVFF       FARG_tabdata_add_pp_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       15
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_pp156
;inneradt.h,233 :: 		instance -> points = 15;
	MOVFF       FARG_tabdata_add_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_add_pp_instance+1, FSR1H
	MOVLW       15
	MOVWF       POSTINC1+0 
	GOTO        L_tabdata_add_pp157
L_tabdata_add_pp156:
;inneradt.h,234 :: 		else if (instance -> points < 30)
	MOVFF       FARG_tabdata_add_pp_instance+0, FSR0
	MOVFF       FARG_tabdata_add_pp_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       30
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_pp158
;inneradt.h,235 :: 		instance -> points = 30;
	MOVFF       FARG_tabdata_add_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_add_pp_instance+1, FSR1H
	MOVLW       30
	MOVWF       POSTINC1+0 
	GOTO        L_tabdata_add_pp159
L_tabdata_add_pp158:
;inneradt.h,236 :: 		else if (instance -> points < 40)
	MOVFF       FARG_tabdata_add_pp_instance+0, FSR0
	MOVFF       FARG_tabdata_add_pp_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       40
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_add_pp160
;inneradt.h,237 :: 		instance -> points = 40;
	MOVFF       FARG_tabdata_add_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_add_pp_instance+1, FSR1H
	MOVLW       40
	MOVWF       POSTINC1+0 
	GOTO        L_tabdata_add_pp161
L_tabdata_add_pp160:
;inneradt.h,240 :: 		instance -> points = 0;
	MOVFF       FARG_tabdata_add_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_add_pp_instance+1, FSR1H
	CLRF        POSTINC1+0 
;inneradt.h,241 :: 		tabdata_add_sets(instance, 1);
	MOVF        FARG_tabdata_add_pp_instance+0, 0 
	MOVWF       FARG_tabdata_add_sets_instance+0 
	MOVF        FARG_tabdata_add_pp_instance+1, 0 
	MOVWF       FARG_tabdata_add_sets_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_add_sets_toAdd+0 
	CALL        _tabdata_add_sets+0, 0
;inneradt.h,242 :: 		}
L_tabdata_add_pp161:
L_tabdata_add_pp159:
L_tabdata_add_pp157:
;inneradt.h,243 :: 		}
L_end_tabdata_add_pp:
	RETURN      0
; end of _tabdata_add_pp

_tabdata_sub_pp:

;inneradt.h,245 :: 		void tabdata_sub_pp(TTeamData* instance)
;inneradt.h,247 :: 		if      (instance -> points == 0)
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR0
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_sub_pp162
;inneradt.h,249 :: 		tabdata_add_sets(instance, -1);
	MOVF        FARG_tabdata_sub_pp_instance+0, 0 
	MOVWF       FARG_tabdata_add_sets_instance+0 
	MOVF        FARG_tabdata_sub_pp_instance+1, 0 
	MOVWF       FARG_tabdata_add_sets_instance+1 
	MOVLW       255
	MOVWF       FARG_tabdata_add_sets_toAdd+0 
	CALL        _tabdata_add_sets+0, 0
;inneradt.h,250 :: 		instance -> points = 40;
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR1H
	MOVLW       40
	MOVWF       POSTINC1+0 
;inneradt.h,251 :: 		}
	GOTO        L_tabdata_sub_pp163
L_tabdata_sub_pp162:
;inneradt.h,252 :: 		else if (instance -> points < 15)
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR0
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       15
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tabdata_sub_pp164
;inneradt.h,253 :: 		instance -> points = 0;
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR1H
	CLRF        POSTINC1+0 
	GOTO        L_tabdata_sub_pp165
L_tabdata_sub_pp164:
;inneradt.h,254 :: 		else if (instance -> points == 15)
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR0
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       15
	BTFSS       STATUS+0, 2 
	GOTO        L_tabdata_sub_pp166
;inneradt.h,255 :: 		instance -> points = 0;
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR1H
	CLRF        POSTINC1+0 
	GOTO        L_tabdata_sub_pp167
L_tabdata_sub_pp166:
;inneradt.h,256 :: 		else if (instance -> points <= 30)
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR0
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBLW       30
	BTFSS       STATUS+0, 0 
	GOTO        L_tabdata_sub_pp168
;inneradt.h,257 :: 		instance -> points = 15;
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR1H
	MOVLW       15
	MOVWF       POSTINC1+0 
	GOTO        L_tabdata_sub_pp169
L_tabdata_sub_pp168:
;inneradt.h,259 :: 		instance -> points = 30;
	MOVFF       FARG_tabdata_sub_pp_instance+0, FSR1
	MOVFF       FARG_tabdata_sub_pp_instance+1, FSR1H
	MOVLW       30
	MOVWF       POSTINC1+0 
L_tabdata_sub_pp169:
L_tabdata_sub_pp167:
L_tabdata_sub_pp165:
L_tabdata_sub_pp163:
;inneradt.h,260 :: 		}
L_end_tabdata_sub_pp:
	RETURN      0
; end of _tabdata_sub_pp

_tabdata_add_flag_seq:

;inneradt.h,262 :: 		void tabdata_add_flag_seq(TTeamData* instance)
;inneradt.h,264 :: 		if (instance -> P2)
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSS       R0, 2 
	GOTO        L_tabdata_add_flag_seq170
;inneradt.h,266 :: 		instance -> P1 = 0;
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 1 
;inneradt.h,267 :: 		instance -> P2 = 0;
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 2 
;inneradt.h,268 :: 		instance -> P7F = 0;
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 0 
;inneradt.h,269 :: 		}
	GOTO        L_tabdata_add_flag_seq171
L_tabdata_add_flag_seq170:
;inneradt.h,270 :: 		else if (instance -> P1) instance -> P2 = 1;
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSS       R0, 1 
	GOTO        L_tabdata_add_flag_seq172
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 2 
	GOTO        L_tabdata_add_flag_seq173
L_tabdata_add_flag_seq172:
;inneradt.h,271 :: 		else if (instance -> P7F) instance -> P1 = 1;
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSS       R0, 0 
	GOTO        L_tabdata_add_flag_seq174
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 1 
	GOTO        L_tabdata_add_flag_seq175
L_tabdata_add_flag_seq174:
;inneradt.h,272 :: 		else instance -> P7F = 1;
	MOVLW       2
	ADDWF       FARG_tabdata_add_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_add_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 0 
L_tabdata_add_flag_seq175:
L_tabdata_add_flag_seq173:
L_tabdata_add_flag_seq171:
;inneradt.h,273 :: 		}
L_end_tabdata_add_flag_seq:
	RETURN      0
; end of _tabdata_add_flag_seq

_tabdata_sub_flag_seq:

;inneradt.h,275 :: 		void tabdata_sub_flag_seq(TTeamData* instance)
;inneradt.h,277 :: 		if (instance -> P2) instance -> P2 = 0;
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSS       R0, 2 
	GOTO        L_tabdata_sub_flag_seq176
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 2 
	GOTO        L_tabdata_sub_flag_seq177
L_tabdata_sub_flag_seq176:
;inneradt.h,278 :: 		else if (instance -> P1) instance -> P1 = 0;
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSS       R0, 1 
	GOTO        L_tabdata_sub_flag_seq178
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 1 
	GOTO        L_tabdata_sub_flag_seq179
L_tabdata_sub_flag_seq178:
;inneradt.h,279 :: 		else if (instance -> P7F) instance -> P7F = 0;
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSS       R0, 0 
	GOTO        L_tabdata_sub_flag_seq180
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BCF         POSTINC1+0, 0 
	GOTO        L_tabdata_sub_flag_seq181
L_tabdata_sub_flag_seq180:
;inneradt.h,282 :: 		instance -> P1 = 1;
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 1 
;inneradt.h,283 :: 		instance -> P2 = 1;
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 2 
;inneradt.h,284 :: 		instance -> P7F = 1;
	MOVLW       2
	ADDWF       FARG_tabdata_sub_flag_seq_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_tabdata_sub_flag_seq_instance+1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 0 
;inneradt.h,285 :: 		}
L_tabdata_sub_flag_seq181:
L_tabdata_sub_flag_seq179:
L_tabdata_sub_flag_seq177:
;inneradt.h,286 :: 		}
L_end_tabdata_sub_flag_seq:
	RETURN      0
; end of _tabdata_sub_flag_seq

_config_new:

;config.h,30 :: 		void config_new(TConfigInstance instance)
;config.h,32 :: 		instance -> persistentFlags0 = 0;
	MOVFF       FARG_config_new_instance+0, FSR1
	MOVFF       FARG_config_new_instance+1, FSR1H
	CLRF        POSTINC1+0 
;config.h,33 :: 		}
L_end_config_new:
	RETURN      0
; end of _config_new

_config_save:

;config.h,35 :: 		void config_save(TConfigInstance instance)
;config.h,37 :: 		emu_eeprom_wr(___CONFIG_CELL_D0, instance -> persistentFlags0, EMU_EEPROM_DO_NOT_COMMIT);
	MOVLW       16
	MOVWF       FARG_emu_eeprom_wr_address+0 
	MOVLW       0
	MOVWF       FARG_emu_eeprom_wr_address+1 
	MOVFF       FARG_config_save_instance+0, FSR0
	MOVFF       FARG_config_save_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_emu_eeprom_wr_byte_data+0 
	CLRF        FARG_emu_eeprom_wr_commit_change+0 
	CALL        _emu_eeprom_wr+0, 0
;config.h,38 :: 		emu_eeprom_wr(___CONFIG_CELL_VALID_DATA, ___CONFIG_VALID_CODE, EMU_EEPROM_COMMIT);
	CLRF        FARG_emu_eeprom_wr_address+0 
	CLRF        FARG_emu_eeprom_wr_address+1 
	MOVLW       18
	MOVWF       FARG_emu_eeprom_wr_byte_data+0 
	MOVLW       1
	MOVWF       FARG_emu_eeprom_wr_commit_change+0 
	CALL        _emu_eeprom_wr+0, 0
;config.h,39 :: 		}
L_end_config_save:
	RETURN      0
; end of _config_save

_config_load:

;config.h,41 :: 		short config_load(TConfigInstance instance)
;config.h,43 :: 		if (emu_eeprom_rd(___CONFIG_CELL_VALID_DATA) != ___CONFIG_VALID_CODE) return 0;
	CLRF        FARG_emu_eeprom_rd_address+0 
	CLRF        FARG_emu_eeprom_rd_address+1 
	CALL        _emu_eeprom_rd+0, 0
	MOVF        R0, 0 
	XORLW       18
	BTFSC       STATUS+0, 2 
	GOTO        L_config_load182
	CLRF        R0 
	GOTO        L_end_config_load
L_config_load182:
;config.h,44 :: 		instance -> persistentFlags0 = emu_eeprom_rd(___CONFIG_CELL_D0);
	MOVF        FARG_config_load_instance+0, 0 
	MOVWF       FLOC__config_load+0 
	MOVF        FARG_config_load_instance+1, 0 
	MOVWF       FLOC__config_load+1 
	MOVLW       16
	MOVWF       FARG_emu_eeprom_rd_address+0 
	MOVLW       0
	MOVWF       FARG_emu_eeprom_rd_address+1 
	CALL        _emu_eeprom_rd+0, 0
	MOVFF       FLOC__config_load+0, FSR1
	MOVFF       FLOC__config_load+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;config.h,45 :: 		}
L_end_config_load:
	RETURN      0
; end of _config_load

_flags_new:

;flags.h,49 :: 		void flags_new(TFlagsInstance instance)
;flags.h,51 :: 		instance -> flags0 = 0;
	MOVFF       FARG_flags_new_instance+0, FSR1
	MOVFF       FARG_flags_new_instance+1, FSR1H
	CLRF        POSTINC1+0 
;flags.h,52 :: 		}
L_end_flags_new:
	RETURN      0
; end of _flags_new

_nrfpacket_from_raw_buffer:

;radioadt.h,31 :: 		void nrfpacket_from_raw_buffer(TNrfPacket* instance, uint8* buffer)
;radioadt.h,34 :: 		memcpy(&(instance -> id_bytes), buffer, NRF_PACKET_NUM_ID_BYTES);
	MOVLW       4
	ADDWF       FARG_nrfpacket_from_raw_buffer_instance+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_instance+1, 0 
	MOVWF       FARG_memcpy_d1+1 
	MOVF        FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVF        FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       4
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;radioadt.h,35 :: 		memcpy(&(instance -> raw_cmd_bytes), buffer + NRF_PACKET_NUM_ID_BYTES, NRF_PACKET_NUM_CMD_BYTES);
	MOVF        FARG_nrfpacket_from_raw_buffer_instance+0, 0 
	MOVWF       FARG_memcpy_d1+0 
	MOVF        FARG_nrfpacket_from_raw_buffer_instance+1, 0 
	MOVWF       FARG_memcpy_d1+1 
	MOVLW       4
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FARG_memcpy_s1+0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FARG_memcpy_s1+1 
	MOVLW       3
	MOVWF       FARG_memcpy_n+0 
	MOVLW       0
	MOVWF       FARG_memcpy_n+1 
	CALL        _memcpy+0, 0
;radioadt.h,38 :: 		if (buffer[NRF_PACKET_NUM_ID_BYTES] == buffer[NRF_PACKET_NUM_ID_BYTES + 1] ||
	MOVLW       4
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FSR0H 
	MOVLW       5
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FSR2H 
;radioadt.h,39 :: 		buffer[NRF_PACKET_NUM_ID_BYTES] == buffer[NRF_PACKET_NUM_ID_BYTES + 2])
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__nrfpacket_from_raw_buffer289
	MOVLW       4
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       R2 
	MOVLW       6
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FSR2H 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__nrfpacket_from_raw_buffer289
	GOTO        L_nrfpacket_from_raw_buffer185
L__nrfpacket_from_raw_buffer289:
;radioadt.h,41 :: 		instance -> cmd = buffer[NRF_PACKET_NUM_ID_BYTES];
	MOVLW       3
	ADDWF       FARG_nrfpacket_from_raw_buffer_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_instance+1, 0 
	MOVWF       FSR1H 
	MOVLW       4
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;radioadt.h,42 :: 		}
	GOTO        L_nrfpacket_from_raw_buffer186
L_nrfpacket_from_raw_buffer185:
;radioadt.h,43 :: 		else if (buffer[NRF_PACKET_NUM_ID_BYTES + 1] == buffer[NRF_PACKET_NUM_ID_BYTES + 2])
	MOVLW       5
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FSR0H 
	MOVLW       6
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_nrfpacket_from_raw_buffer187
;radioadt.h,45 :: 		instance -> cmd = buffer[NRF_PACKET_NUM_ID_BYTES];
	MOVLW       3
	ADDWF       FARG_nrfpacket_from_raw_buffer_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_instance+1, 0 
	MOVWF       FSR1H 
	MOVLW       4
	ADDWF       FARG_nrfpacket_from_raw_buffer_buffer+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_buffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;radioadt.h,46 :: 		}
	GOTO        L_nrfpacket_from_raw_buffer188
L_nrfpacket_from_raw_buffer187:
;radioadt.h,48 :: 		instance -> cmd = CmdCode_None;
	MOVLW       3
	ADDWF       FARG_nrfpacket_from_raw_buffer_instance+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_from_raw_buffer_instance+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
L_nrfpacket_from_raw_buffer188:
L_nrfpacket_from_raw_buffer186:
;radioadt.h,49 :: 		}
L_end_nrfpacket_from_raw_buffer:
	RETURN      0
; end of _nrfpacket_from_raw_buffer

_nrfpacket_compare_id:

;radioadt.h,51 :: 		uint8 nrfpacket_compare_id(TNrfPacket* instance, uint8* compare_id)
;radioadt.h,54 :: 		for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
	CLRF        R2 
L_nrfpacket_compare_id189:
	MOVLW       4
	SUBWF       R2, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrfpacket_compare_id190
;radioadt.h,56 :: 		if (instance -> id_bytes[i] != compare_id[i]) return 0;
	MOVLW       4
	ADDWF       FARG_nrfpacket_compare_id_instance+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_compare_id_instance+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        R2, 0 
	ADDWF       FARG_nrfpacket_compare_id_compare_id+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_compare_id_compare_id+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_nrfpacket_compare_id192
	CLRF        R0 
	GOTO        L_end_nrfpacket_compare_id
L_nrfpacket_compare_id192:
;radioadt.h,54 :: 		for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
	INCF        R2, 1 
;radioadt.h,57 :: 		}
	GOTO        L_nrfpacket_compare_id189
L_nrfpacket_compare_id190:
;radioadt.h,58 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
;radioadt.h,59 :: 		}
L_end_nrfpacket_compare_id:
	RETURN      0
; end of _nrfpacket_compare_id

_nrfpacket_copy_id:

;radioadt.h,61 :: 		void nrfpacket_copy_id(TNrfPacket* instance, uint8* dest_id)
;radioadt.h,64 :: 		for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
	CLRF        R2 
L_nrfpacket_copy_id193:
	MOVLW       4
	SUBWF       R2, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_nrfpacket_copy_id194
;radioadt.h,65 :: 		dest_id[i] = instance -> id_bytes[i];
	MOVF        R2, 0 
	ADDWF       FARG_nrfpacket_copy_id_dest_id+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_copy_id_dest_id+1, 0 
	MOVWF       FSR1H 
	MOVLW       4
	ADDWF       FARG_nrfpacket_copy_id_instance+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_nrfpacket_copy_id_instance+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;radioadt.h,64 :: 		for (i = 0; i < NRF_PACKET_NUM_ID_BYTES; i ++)
	INCF        R2, 1 
;radioadt.h,65 :: 		dest_id[i] = instance -> id_bytes[i];
	GOTO        L_nrfpacket_copy_id193
L_nrfpacket_copy_id194:
;radioadt.h,66 :: 		}
L_end_nrfpacket_copy_id:
	RETURN      0
; end of _nrfpacket_copy_id

_variables_init:

;datainstances.h,27 :: 		void variables_init()
;datainstances.h,29 :: 		tabdata_new(&tab_data);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_new_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_new_instance+1 
	CALL        _tabdata_new+0, 0
;datainstances.h,30 :: 		flags_new(&flags);
	MOVLW       _flags+0
	MOVWF       FARG_flags_new_instance+0 
	MOVLW       hi_addr(_flags+0)
	MOVWF       FARG_flags_new_instance+1 
	CALL        _flags_new+0, 0
;datainstances.h,31 :: 		config_new(&configuration);
	MOVLW       _configuration+0
	MOVWF       FARG_config_new_instance+0 
	MOVLW       hi_addr(_configuration+0)
	MOVWF       FARG_config_new_instance+1 
	CALL        _config_new+0, 0
;datainstances.h,33 :: 		whatsChanged = tcfAll;
	MOVLW       7
	MOVWF       _whatsChanged+0 
;datainstances.h,34 :: 		whyRestarted = hw_get_reset_reason();
	CALL        _hw_get_reset_reason+0, 0
	MOVF        R0, 0 
	MOVWF       _whyRestarted+0 
;datainstances.h,35 :: 		ClockTicksPending = 0;
	CLRF        _ClockTicksPending+0 
;datainstances.h,36 :: 		CmdPending = CmdCode_None;
	CLRF        _CmdPending+0 
;datainstances.h,37 :: 		pendingActions = taNone;
	CLRF        _pendingActions+0 
;datainstances.h,38 :: 		SyncedDelayCounter = 0;
	CLRF        _SyncedDelayCounter+0 
	CLRF        _SyncedDelayCounter+1 
;datainstances.h,39 :: 		}
L_end_variables_init:
	RETURN      0
; end of _variables_init

_ApplyCmd:

;datamgrroutines.h,6 :: 		CmdFunctionType ApplyCmd(TCmd cmd)
;datamgrroutines.h,9 :: 		if (cmd > 63) return tcfNone;
	MOVF        FARG_ApplyCmd_cmd+0, 0 
	SUBLW       63
	BTFSC       STATUS+0, 0 
	GOTO        L_ApplyCmd196
	CLRF        R0 
	GOTO        L_end_ApplyCmd
L_ApplyCmd196:
;datamgrroutines.h,10 :: 		fptr = ___datamgr_function_array[cmd];
	MOVF        FARG_ApplyCmd_cmd+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       ____datamgr_function_array+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(____datamgr_function_array+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       ApplyCmd_fptr_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       ApplyCmd_fptr_L0+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       ApplyCmd_fptr_L0+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       ApplyCmd_fptr_L0+3 
;datamgrroutines.h,11 :: 		return fptr();
	MOVF        ApplyCmd_fptr_L0+0, 0 
	MOVWF       R0 
	MOVF        ApplyCmd_fptr_L0+1, 0 
	MOVWF       R1 
	CALL        _____DoIFC+0, 0
;datamgrroutines.h,12 :: 		}
L_end_ApplyCmd:
	RETURN      0
; end of _ApplyCmd

_CmdApply_None:

;datamgrroutines.h,14 :: 		CmdFunctionType CmdApply_None ()
;datamgrroutines.h,16 :: 		return tcfNone;
	CLRF        R0 
;datamgrroutines.h,17 :: 		}
L_end_CmdApply_None:
	RETURN      0
; end of _CmdApply_None

_CmdApply_INC_PT_LOC:

;datamgrroutines.h,19 :: 		CmdFunctionType CmdApply_INC_PT_LOC ()
;datamgrroutines.h,21 :: 		if (flags.timeSetting) return CmdApply_AUM_10M();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_INC_PT_LOC197
	CALL        _CmdApply_AUM_10M+0, 0
	GOTO        L_end_CmdApply_INC_PT_LOC
L_CmdApply_INC_PT_LOC197:
;datamgrroutines.h,22 :: 		tabdata_add_points(&(tab_data.locals), 1);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_add_points_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_add_points_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_add_points_toAdd+0 
	CALL        _tabdata_add_points+0, 0
;datamgrroutines.h,23 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,24 :: 		}
L_end_CmdApply_INC_PT_LOC:
	RETURN      0
; end of _CmdApply_INC_PT_LOC

_CmdApply_INC_PLLP_LOC:

;datamgrroutines.h,25 :: 		CmdFunctionType CmdApply_INC_PLLP_LOC ()
;datamgrroutines.h,27 :: 		tabdata_add_pp(&(tab_data.locals));
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_add_pp_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_add_pp_instance+1 
	CALL        _tabdata_add_pp+0, 0
;datamgrroutines.h,28 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,29 :: 		}
L_end_CmdApply_INC_PLLP_LOC:
	RETURN      0
; end of _CmdApply_INC_PLLP_LOC

_CmdApply_DEC_PT_LOC:

;datamgrroutines.h,30 :: 		CmdFunctionType CmdApply_DEC_PT_LOC ()
;datamgrroutines.h,32 :: 		if (flags.timeSetting) return CmdApply_DIM_10M();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_DEC_PT_LOC198
	CALL        _CmdApply_DIM_10M+0, 0
	GOTO        L_end_CmdApply_DEC_PT_LOC
L_CmdApply_DEC_PT_LOC198:
;datamgrroutines.h,33 :: 		tabdata_add_points(&(tab_data.locals), -1);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_add_points_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_add_points_instance+1 
	MOVLW       255
	MOVWF       FARG_tabdata_add_points_toAdd+0 
	CALL        _tabdata_add_points+0, 0
;datamgrroutines.h,34 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,35 :: 		}
L_end_CmdApply_DEC_PT_LOC:
	RETURN      0
; end of _CmdApply_DEC_PT_LOC

_CmdApply_DEC_PLLP_LOC:

;datamgrroutines.h,36 :: 		CmdFunctionType CmdApply_DEC_PLLP_LOC ()
;datamgrroutines.h,38 :: 		tabdata_sub_pp(&(tab_data.locals));
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_sub_pp_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_sub_pp_instance+1 
	CALL        _tabdata_sub_pp+0, 0
;datamgrroutines.h,39 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,40 :: 		}
L_end_CmdApply_DEC_PLLP_LOC:
	RETURN      0
; end of _CmdApply_DEC_PLLP_LOC

_CmdApply_INC_PT_OSP:

;datamgrroutines.h,41 :: 		CmdFunctionType CmdApply_INC_PT_OSP ()
;datamgrroutines.h,43 :: 		if (flags.timeSetting) return CmdApply_AUM_1S();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_INC_PT_OSP199
	CALL        _CmdApply_AUM_1S+0, 0
	GOTO        L_end_CmdApply_INC_PT_OSP
L_CmdApply_INC_PT_OSP199:
;datamgrroutines.h,44 :: 		tabdata_add_points(&(tab_data.guests), 1);
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_add_points_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_add_points_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_add_points_toAdd+0 
	CALL        _tabdata_add_points+0, 0
;datamgrroutines.h,45 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,46 :: 		}
L_end_CmdApply_INC_PT_OSP:
	RETURN      0
; end of _CmdApply_INC_PT_OSP

_CmdApply_INC_PLLP_OSP:

;datamgrroutines.h,47 :: 		CmdFunctionType CmdApply_INC_PLLP_OSP ()
;datamgrroutines.h,49 :: 		tabdata_add_pp(&(tab_data.guests));
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_add_pp_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_add_pp_instance+1 
	CALL        _tabdata_add_pp+0, 0
;datamgrroutines.h,50 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,51 :: 		}
L_end_CmdApply_INC_PLLP_OSP:
	RETURN      0
; end of _CmdApply_INC_PLLP_OSP

_CmdApply_DEC_PT_OSP:

;datamgrroutines.h,52 :: 		CmdFunctionType CmdApply_DEC_PT_OSP ()
;datamgrroutines.h,54 :: 		if (flags.timeSetting) return CmdApply_DIM_1S();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_DEC_PT_OSP200
	CALL        _CmdApply_DIM_1S+0, 0
	GOTO        L_end_CmdApply_DEC_PT_OSP
L_CmdApply_DEC_PT_OSP200:
;datamgrroutines.h,55 :: 		tabdata_add_points(&(tab_data.guests), -1);
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_add_points_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_add_points_instance+1 
	MOVLW       255
	MOVWF       FARG_tabdata_add_points_toAdd+0 
	CALL        _tabdata_add_points+0, 0
;datamgrroutines.h,56 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,57 :: 		}
L_end_CmdApply_DEC_PT_OSP:
	RETURN      0
; end of _CmdApply_DEC_PT_OSP

_CmdApply_DEC_PLLP_OSP:

;datamgrroutines.h,58 :: 		CmdFunctionType CmdApply_DEC_PLLP_OSP ()
;datamgrroutines.h,60 :: 		tabdata_sub_pp(&(tab_data.guests));
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_sub_pp_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_sub_pp_instance+1 
	CALL        _tabdata_sub_pp+0, 0
;datamgrroutines.h,61 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,62 :: 		}
L_end_CmdApply_DEC_PLLP_OSP:
	RETURN      0
; end of _CmdApply_DEC_PLLP_OSP

_CmdApply_INC_SET_LOC:

;datamgrroutines.h,63 :: 		CmdFunctionType CmdApply_INC_SET_LOC ()
;datamgrroutines.h,65 :: 		if (flags.timeSetting) return CmdApply_AUM_1M();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_INC_SET_LOC201
	CALL        _CmdApply_AUM_1M+0, 0
	GOTO        L_end_CmdApply_INC_SET_LOC
L_CmdApply_INC_SET_LOC201:
;datamgrroutines.h,66 :: 		tabdata_add_sets(&(tab_data.locals), 1);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_add_sets_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_add_sets_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_add_sets_toAdd+0 
	CALL        _tabdata_add_sets+0, 0
;datamgrroutines.h,67 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,68 :: 		}
L_end_CmdApply_INC_SET_LOC:
	RETURN      0
; end of _CmdApply_INC_SET_LOC

_CmdApply_DEC_SET_LOC:

;datamgrroutines.h,69 :: 		CmdFunctionType CmdApply_DEC_SET_LOC ()
;datamgrroutines.h,71 :: 		if (flags.timeSetting) return CmdApply_DIM_1M();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_DEC_SET_LOC202
	CALL        _CmdApply_DIM_1M+0, 0
	GOTO        L_end_CmdApply_DEC_SET_LOC
L_CmdApply_DEC_SET_LOC202:
;datamgrroutines.h,72 :: 		tabdata_add_sets(&(tab_data.locals), -1);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_add_sets_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_add_sets_instance+1 
	MOVLW       255
	MOVWF       FARG_tabdata_add_sets_toAdd+0 
	CALL        _tabdata_add_sets+0, 0
;datamgrroutines.h,73 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,74 :: 		}
L_end_CmdApply_DEC_SET_LOC:
	RETURN      0
; end of _CmdApply_DEC_SET_LOC

_CmdApply_INC_SET_OSP:

;datamgrroutines.h,75 :: 		CmdFunctionType CmdApply_INC_SET_OSP ()
;datamgrroutines.h,77 :: 		if (flags.timeSetting) return CmdApply_AUM_10S();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_INC_SET_OSP203
	CALL        _CmdApply_AUM_10S+0, 0
	GOTO        L_end_CmdApply_INC_SET_OSP
L_CmdApply_INC_SET_OSP203:
;datamgrroutines.h,78 :: 		tabdata_add_sets(&(tab_data.guests), 1);
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_add_sets_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_add_sets_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_add_sets_toAdd+0 
	CALL        _tabdata_add_sets+0, 0
;datamgrroutines.h,79 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,80 :: 		}
L_end_CmdApply_INC_SET_OSP:
	RETURN      0
; end of _CmdApply_INC_SET_OSP

_CmdApply_DEC_SET_OSP:

;datamgrroutines.h,81 :: 		CmdFunctionType CmdApply_DEC_SET_OSP ()
;datamgrroutines.h,83 :: 		if (flags.timeSetting) return CmdApply_DIM_10S();
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_DEC_SET_OSP204
	CALL        _CmdApply_DIM_10S+0, 0
	GOTO        L_end_CmdApply_DEC_SET_OSP
L_CmdApply_DEC_SET_OSP204:
;datamgrroutines.h,84 :: 		tabdata_add_sets(&(tab_data.guests), -1);
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_add_sets_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_add_sets_instance+1 
	MOVLW       255
	MOVWF       FARG_tabdata_add_sets_toAdd+0 
	CALL        _tabdata_add_sets+0, 0
;datamgrroutines.h,85 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,86 :: 		}
L_end_CmdApply_DEC_SET_OSP:
	RETURN      0
; end of _CmdApply_DEC_SET_OSP

_CmdApply_INC_LED_LOC:

;datamgrroutines.h,87 :: 		CmdFunctionType CmdApply_INC_LED_LOC ()
;datamgrroutines.h,89 :: 		tabdata_add_flag_seq(&(tab_data.locals));
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_add_flag_seq_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_add_flag_seq_instance+1 
	CALL        _tabdata_add_flag_seq+0, 0
;datamgrroutines.h,90 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,91 :: 		}
L_end_CmdApply_INC_LED_LOC:
	RETURN      0
; end of _CmdApply_INC_LED_LOC

_CmdApply_DEC_LED_LOC:

;datamgrroutines.h,92 :: 		CmdFunctionType CmdApply_DEC_LED_LOC ()
;datamgrroutines.h,94 :: 		tabdata_sub_flag_seq(&(tab_data.locals));
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_sub_flag_seq_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_sub_flag_seq_instance+1 
	CALL        _tabdata_sub_flag_seq+0, 0
;datamgrroutines.h,95 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,96 :: 		}
L_end_CmdApply_DEC_LED_LOC:
	RETURN      0
; end of _CmdApply_DEC_LED_LOC

_CmdApply_INC_LED_OSP:

;datamgrroutines.h,97 :: 		CmdFunctionType CmdApply_INC_LED_OSP ()
;datamgrroutines.h,99 :: 		tabdata_add_flag_seq(&(tab_data.guests));
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_add_flag_seq_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_add_flag_seq_instance+1 
	CALL        _tabdata_add_flag_seq+0, 0
;datamgrroutines.h,100 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,101 :: 		}
L_end_CmdApply_INC_LED_OSP:
	RETURN      0
; end of _CmdApply_INC_LED_OSP

_CmdApply_DEC_LED_OSP:

;datamgrroutines.h,102 :: 		CmdFunctionType CmdApply_DEC_LED_OSP ()
;datamgrroutines.h,104 :: 		tabdata_sub_flag_seq(&(tab_data.guests));
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_sub_flag_seq_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_sub_flag_seq_instance+1 
	CALL        _tabdata_sub_flag_seq+0, 0
;datamgrroutines.h,105 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,106 :: 		}
L_end_CmdApply_DEC_LED_OSP:
	RETURN      0
; end of _CmdApply_DEC_LED_OSP

_CmdApply_START:

;datamgrroutines.h,107 :: 		CmdFunctionType CmdApply_START ()
;datamgrroutines.h,109 :: 		if (flags.timeSetting)
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_START205
;datamgrroutines.h,110 :: 		flags.timeSetting = 0;
	BCF         _flags+0, 1 
L_CmdApply_START205:
;datamgrroutines.h,112 :: 		if (tabdata_time_is_not_null(&(tab_data.time)))
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_time_is_not_null_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_time_is_not_null_instance+1 
	CALL        _tabdata_time_is_not_null+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_CmdApply_START206
;datamgrroutines.h,113 :: 		flags.timeStarted = 1;
	BSF         _flags+0, 0 
L_CmdApply_START206:
;datamgrroutines.h,115 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,116 :: 		}
L_end_CmdApply_START:
	RETURN      0
; end of _CmdApply_START

_CmdApply_PAUSE:

;datamgrroutines.h,117 :: 		CmdFunctionType CmdApply_PAUSE ()
;datamgrroutines.h,119 :: 		if (flags.timeSetting) return tcfNone;
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_PAUSE207
	CLRF        R0 
	GOTO        L_end_CmdApply_PAUSE
L_CmdApply_PAUSE207:
;datamgrroutines.h,120 :: 		flags.timeStarted = 0;
	BCF         _flags+0, 0 
;datamgrroutines.h,121 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,122 :: 		}
L_end_CmdApply_PAUSE:
	RETURN      0
; end of _CmdApply_PAUSE

_CmdApply_TIME_RESET:

;datamgrroutines.h,123 :: 		CmdFunctionType CmdApply_TIME_RESET ()
;datamgrroutines.h,125 :: 		flags.timeStarted = 0;
	BCF         _flags+0, 0 
;datamgrroutines.h,126 :: 		tabdata_clear_time(&tab_data);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_clear_time_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_clear_time_instance+1 
	CALL        _tabdata_clear_time+0, 0
;datamgrroutines.h,128 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,129 :: 		}
L_end_CmdApply_TIME_RESET:
	RETURN      0
; end of _CmdApply_TIME_RESET

_CmdApply_TIME_SET:

;datamgrroutines.h,130 :: 		CmdFunctionType CmdApply_TIME_SET ()
;datamgrroutines.h,132 :: 		if (flags.timeSetting)
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_TIME_SET208
;datamgrroutines.h,133 :: 		flags.timeSetting = 0;
	BCF         _flags+0, 1 
	GOTO        L_CmdApply_TIME_SET209
L_CmdApply_TIME_SET208:
;datamgrroutines.h,136 :: 		flags.timeStarted = 0;
	BCF         _flags+0, 0 
;datamgrroutines.h,137 :: 		flags.timeSetting = 1;
	BSF         _flags+0, 1 
;datamgrroutines.h,138 :: 		}
L_CmdApply_TIME_SET209:
;datamgrroutines.h,139 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,140 :: 		}
L_end_CmdApply_TIME_SET:
	RETURN      0
; end of _CmdApply_TIME_SET

_CmdApply_RES_PT_LOC:

;datamgrroutines.h,141 :: 		CmdFunctionType CmdApply_RES_PT_LOC ()
;datamgrroutines.h,143 :: 		tabdata_clear_team(&(tab_data.locals));
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_clear_team_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_clear_team_instance+1 
	CALL        _tabdata_clear_team+0, 0
;datamgrroutines.h,144 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,145 :: 		}
L_end_CmdApply_RES_PT_LOC:
	RETURN      0
; end of _CmdApply_RES_PT_LOC

_CmdApply_RES_PT_OSP:

;datamgrroutines.h,146 :: 		CmdFunctionType CmdApply_RES_PT_OSP ()
;datamgrroutines.h,148 :: 		tabdata_clear_team(&(tab_data.guests));
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_clear_team_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_clear_team_instance+1 
	CALL        _tabdata_clear_team+0, 0
;datamgrroutines.h,149 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,150 :: 		}
L_end_CmdApply_RES_PT_OSP:
	RETURN      0
; end of _CmdApply_RES_PT_OSP

_CmdApply_RESET:

;datamgrroutines.h,151 :: 		CmdFunctionType CmdApply_RESET ()
;datamgrroutines.h,153 :: 		if (flags.timeSetting) return tcfNone;
	BTFSS       _flags+0, 1 
	GOTO        L_CmdApply_RESET210
	CLRF        R0 
	GOTO        L_end_CmdApply_RESET
L_CmdApply_RESET210:
;datamgrroutines.h,155 :: 		flags.timeStarted = 0;
	BCF         _flags+0, 0 
;datamgrroutines.h,156 :: 		tabdata_clear(&tab_data);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_new_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_new_instance+1 
	CALL        _tabdata_new+0, 0
;datamgrroutines.h,158 :: 		return tcfAll;
	MOVLW       7
	MOVWF       R0 
;datamgrroutines.h,159 :: 		}
L_end_CmdApply_RESET:
	RETURN      0
; end of _CmdApply_RESET

_CmdApply_HARD_RESET:

;datamgrroutines.h,160 :: 		CmdFunctionType CmdApply_HARD_RESET ()
;datamgrroutines.h,162 :: 		asm RESET;
	RESET
;datamgrroutines.h,163 :: 		return tcfAll;
	MOVLW       7
	MOVWF       R0 
;datamgrroutines.h,164 :: 		}
L_end_CmdApply_HARD_RESET:
	RETURN      0
; end of _CmdApply_HARD_RESET

_CmdApply_SALVASCHERMO:

;datamgrroutines.h,165 :: 		CmdFunctionType CmdApply_SALVASCHERMO ()
;datamgrroutines.h,167 :: 		return CmdApply_STANDBY();
	CALL        _CmdApply_STANDBY+0, 0
;datamgrroutines.h,168 :: 		}
L_end_CmdApply_SALVASCHERMO:
	RETURN      0
; end of _CmdApply_SALVASCHERMO

_CmdApply_STANDBY:

;datamgrroutines.h,169 :: 		CmdFunctionType CmdApply_STANDBY ()
;datamgrroutines.h,171 :: 		flags.timeStarted = 0;
	BCF         _flags+0, 0 
;datamgrroutines.h,172 :: 		flags.inStandby = 1;
	BSF         _flags+0, 2 
;datamgrroutines.h,173 :: 		pendingActions |= taClear;
	BSF         _pendingActions+0, 3 
;datamgrroutines.h,175 :: 		return tcfAll;
	MOVLW       7
	MOVWF       R0 
;datamgrroutines.h,176 :: 		}
L_end_CmdApply_STANDBY:
	RETURN      0
; end of _CmdApply_STANDBY

_CmdApply_STANDBY_TELC:

;datamgrroutines.h,177 :: 		CmdFunctionType CmdApply_STANDBY_TELC ()
;datamgrroutines.h,179 :: 		return CmdApply_STANDBY();
	CALL        _CmdApply_STANDBY+0, 0
;datamgrroutines.h,180 :: 		}
L_end_CmdApply_STANDBY_TELC:
	RETURN      0
; end of _CmdApply_STANDBY_TELC

_CmdApply_INVERTI:

;datamgrroutines.h,181 :: 		CmdFunctionType CmdApply_INVERTI ()
;datamgrroutines.h,183 :: 		tabdata_swap(&tab_data);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_swap_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_swap_instance+1 
	CALL        _tabdata_swap+0, 0
;datamgrroutines.h,184 :: 		return tcfLocals & tcfGuests;
	CLRF        R0 
;datamgrroutines.h,185 :: 		}
L_end_CmdApply_INVERTI:
	RETURN      0
; end of _CmdApply_INVERTI

_CmdApply_CLAXON:

;datamgrroutines.h,186 :: 		CmdFunctionType CmdApply_CLAXON ()
;datamgrroutines.h,188 :: 		configuration.UseClaxon = ! configuration.UseClaxon;
	BTG         _configuration+0, 0 
;datamgrroutines.h,189 :: 		flags.EEPROMSavePending = 1;
	BSF         _flags+0, 5 
;datamgrroutines.h,190 :: 		pendingActions |= taNotifyClaxon;
	BSF         _pendingActions+0, 0 
;datamgrroutines.h,191 :: 		return tcfNone;
	CLRF        R0 
;datamgrroutines.h,192 :: 		}
L_end_CmdApply_CLAXON:
	RETURN      0
; end of _CmdApply_CLAXON

_CmdApply_CLAXON_ALT:

;datamgrroutines.h,193 :: 		CmdFunctionType CmdApply_CLAXON_ALT ()
;datamgrroutines.h,195 :: 		return CmdApply_CLAXON();
	CALL        _CmdApply_CLAXON+0, 0
;datamgrroutines.h,196 :: 		}
L_end_CmdApply_CLAXON_ALT:
	RETURN      0
; end of _CmdApply_CLAXON_ALT

_CmdApply_PROVA_CLAXON:

;datamgrroutines.h,197 :: 		CmdFunctionType CmdApply_PROVA_CLAXON ()
;datamgrroutines.h,199 :: 		pendingActions |= taTryClaxon;
	BSF         _pendingActions+0, 1 
;datamgrroutines.h,200 :: 		return tcfNone;
	CLRF        R0 
;datamgrroutines.h,201 :: 		}
L_end_CmdApply_PROVA_CLAXON:
	RETURN      0
; end of _CmdApply_PROVA_CLAXON

_CmdApply_7F_LOC:

;datamgrroutines.h,202 :: 		CmdFunctionType CmdApply_7F_LOC ()
;datamgrroutines.h,204 :: 		tabdata_toggle_flag(&(tab_data.locals), lfP7F);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_toggle_flag_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_toggle_flag_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_toggle_flag_flag+0 
	CALL        _tabdata_toggle_flag+0, 0
;datamgrroutines.h,205 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,206 :: 		}
L_end_CmdApply_7F_LOC:
	RETURN      0
; end of _CmdApply_7F_LOC

_CmdApply_7F_OSP:

;datamgrroutines.h,207 :: 		CmdFunctionType CmdApply_7F_OSP ()
;datamgrroutines.h,209 :: 		tabdata_toggle_flag(&(tab_data.guests), lfP7F);
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_toggle_flag_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_toggle_flag_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_toggle_flag_flag+0 
	CALL        _tabdata_toggle_flag+0, 0
;datamgrroutines.h,210 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,211 :: 		}
L_end_CmdApply_7F_OSP:
	RETURN      0
; end of _CmdApply_7F_OSP

_CmdApply_P1_LOC:

;datamgrroutines.h,212 :: 		CmdFunctionType CmdApply_P1_LOC ()
;datamgrroutines.h,214 :: 		tabdata_toggle_flag(&(tab_data.locals), lfP1);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_toggle_flag_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_toggle_flag_instance+1 
	MOVLW       2
	MOVWF       FARG_tabdata_toggle_flag_flag+0 
	CALL        _tabdata_toggle_flag+0, 0
;datamgrroutines.h,215 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,216 :: 		}
L_end_CmdApply_P1_LOC:
	RETURN      0
; end of _CmdApply_P1_LOC

_CmdApply_P1_OSP:

;datamgrroutines.h,217 :: 		CmdFunctionType CmdApply_P1_OSP ()
;datamgrroutines.h,219 :: 		tabdata_toggle_flag(&(tab_data.guests), lfP1);
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_toggle_flag_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_toggle_flag_instance+1 
	MOVLW       2
	MOVWF       FARG_tabdata_toggle_flag_flag+0 
	CALL        _tabdata_toggle_flag+0, 0
;datamgrroutines.h,220 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,221 :: 		}
L_end_CmdApply_P1_OSP:
	RETURN      0
; end of _CmdApply_P1_OSP

_CmdApply_P2_LOC:

;datamgrroutines.h,222 :: 		CmdFunctionType CmdApply_P2_LOC ()
;datamgrroutines.h,224 :: 		tabdata_toggle_flag(&(tab_data.locals), lfP2);
	MOVLW       _tab_data+0
	MOVWF       FARG_tabdata_toggle_flag_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG_tabdata_toggle_flag_instance+1 
	MOVLW       4
	MOVWF       FARG_tabdata_toggle_flag_flag+0 
	CALL        _tabdata_toggle_flag+0, 0
;datamgrroutines.h,225 :: 		return tcfLocals;
	MOVLW       1
	MOVWF       R0 
;datamgrroutines.h,226 :: 		}
L_end_CmdApply_P2_LOC:
	RETURN      0
; end of _CmdApply_P2_LOC

_CmdApply_P2_OSP:

;datamgrroutines.h,227 :: 		CmdFunctionType CmdApply_P2_OSP ()
;datamgrroutines.h,229 :: 		tabdata_toggle_flag(&(tab_data.guests), lfP2);
	MOVLW       _tab_data+3
	MOVWF       FARG_tabdata_toggle_flag_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG_tabdata_toggle_flag_instance+1 
	MOVLW       4
	MOVWF       FARG_tabdata_toggle_flag_flag+0 
	CALL        _tabdata_toggle_flag+0, 0
;datamgrroutines.h,230 :: 		return tcfGuests;
	MOVLW       2
	MOVWF       R0 
;datamgrroutines.h,231 :: 		}
L_end_CmdApply_P2_OSP:
	RETURN      0
; end of _CmdApply_P2_OSP

_CmdApply_AUM_10M:

;datamgrroutines.h,232 :: 		CmdFunctionType CmdApply_AUM_10M ()
;datamgrroutines.h,234 :: 		tabdata_add_min(&(tab_data.time), 10);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_min_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_min_instance+1 
	MOVLW       10
	MOVWF       FARG_tabdata_add_min_toAdd+0 
	CALL        _tabdata_add_min+0, 0
;datamgrroutines.h,235 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,236 :: 		}
L_end_CmdApply_AUM_10M:
	RETURN      0
; end of _CmdApply_AUM_10M

_CmdApply_DIM_10M:

;datamgrroutines.h,237 :: 		CmdFunctionType CmdApply_DIM_10M ()
;datamgrroutines.h,239 :: 		tabdata_add_min(&(tab_data.time), -10);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_min_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_min_instance+1 
	MOVLW       246
	MOVWF       FARG_tabdata_add_min_toAdd+0 
	CALL        _tabdata_add_min+0, 0
;datamgrroutines.h,240 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,241 :: 		}
L_end_CmdApply_DIM_10M:
	RETURN      0
; end of _CmdApply_DIM_10M

_CmdApply_AUM_1M:

;datamgrroutines.h,242 :: 		CmdFunctionType CmdApply_AUM_1M ()
;datamgrroutines.h,244 :: 		tabdata_add_min(&(tab_data.time), 1);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_min_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_min_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_add_min_toAdd+0 
	CALL        _tabdata_add_min+0, 0
;datamgrroutines.h,245 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,246 :: 		}
L_end_CmdApply_AUM_1M:
	RETURN      0
; end of _CmdApply_AUM_1M

_CmdApply_DIM_1M:

;datamgrroutines.h,247 :: 		CmdFunctionType CmdApply_DIM_1M ()
;datamgrroutines.h,249 :: 		tabdata_add_min(&(tab_data.time), -1);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_min_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_min_instance+1 
	MOVLW       255
	MOVWF       FARG_tabdata_add_min_toAdd+0 
	CALL        _tabdata_add_min+0, 0
;datamgrroutines.h,250 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,251 :: 		}
L_end_CmdApply_DIM_1M:
	RETURN      0
; end of _CmdApply_DIM_1M

_CmdApply_AUM_10S:

;datamgrroutines.h,252 :: 		CmdFunctionType CmdApply_AUM_10S ()
;datamgrroutines.h,254 :: 		tabdata_add_sec(&(tab_data.time), 10);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_sec_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_sec_instance+1 
	MOVLW       10
	MOVWF       FARG_tabdata_add_sec_toAdd+0 
	CALL        _tabdata_add_sec+0, 0
;datamgrroutines.h,255 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,256 :: 		}
L_end_CmdApply_AUM_10S:
	RETURN      0
; end of _CmdApply_AUM_10S

_CmdApply_DIM_10S:

;datamgrroutines.h,257 :: 		CmdFunctionType CmdApply_DIM_10S ()
;datamgrroutines.h,259 :: 		tabdata_add_sec(&(tab_data.time), -10);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_sec_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_sec_instance+1 
	MOVLW       246
	MOVWF       FARG_tabdata_add_sec_toAdd+0 
	CALL        _tabdata_add_sec+0, 0
;datamgrroutines.h,260 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,261 :: 		}
L_end_CmdApply_DIM_10S:
	RETURN      0
; end of _CmdApply_DIM_10S

_CmdApply_AUM_1S:

;datamgrroutines.h,262 :: 		CmdFunctionType CmdApply_AUM_1S ()
;datamgrroutines.h,264 :: 		tabdata_add_sec(&(tab_data.time), 1);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_sec_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_sec_instance+1 
	MOVLW       1
	MOVWF       FARG_tabdata_add_sec_toAdd+0 
	CALL        _tabdata_add_sec+0, 0
;datamgrroutines.h,265 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,266 :: 		}
L_end_CmdApply_AUM_1S:
	RETURN      0
; end of _CmdApply_AUM_1S

_CmdApply_DIM_1S:

;datamgrroutines.h,267 :: 		CmdFunctionType CmdApply_DIM_1S ()
;datamgrroutines.h,269 :: 		tabdata_add_sec(&(tab_data.time), -1);
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_sec_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_sec_instance+1 
	MOVLW       255
	MOVWF       FARG_tabdata_add_sec_toAdd+0 
	CALL        _tabdata_add_sec+0, 0
;datamgrroutines.h,270 :: 		return tcfTime;
	MOVLW       4
	MOVWF       R0 
;datamgrroutines.h,271 :: 		}
L_end_CmdApply_DIM_1S:
	RETURN      0
; end of _CmdApply_DIM_1S

_CmdApply_CHANNEL_TEST:

;datamgrroutines.h,272 :: 		CmdFunctionType CmdApply_CHANNEL_TEST ()
;datamgrroutines.h,274 :: 		return tcfNone;
	CLRF        R0 
;datamgrroutines.h,275 :: 		}
L_end_CmdApply_CHANNEL_TEST:
	RETURN      0
; end of _CmdApply_CHANNEL_TEST

_CmdApply_DEBUG_MODE:

;datamgrroutines.h,276 :: 		CmdFunctionType CmdApply_DEBUG_MODE ()
;datamgrroutines.h,278 :: 		return tcfNone;
	CLRF        R0 
;datamgrroutines.h,279 :: 		}
L_end_CmdApply_DEBUG_MODE:
	RETURN      0
; end of _CmdApply_DEBUG_MODE

_tab_init:

;tabinterface.h,111 :: 		void tab_init()
;tabinterface.h,113 :: 		pinDato =    0;
	BCF         LATB7_bit+0, BitPos(LATB7_bit+0) 
;tabinterface.h,114 :: 		pinClock =   0;
	BCF         LATB6_bit+0, BitPos(LATB6_bit+0) 
;tabinterface.h,115 :: 		pinLocali =  0;
	BCF         LATC6_bit+0, BitPos(LATC6_bit+0) 
;tabinterface.h,116 :: 		pinTempo =   0;
	BCF         LATB4_bit+0, BitPos(LATB4_bit+0) 
;tabinterface.h,117 :: 		pinOspiti =  0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;tabinterface.h,118 :: 		pinClaxon =  0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;tabinterface.h,120 :: 		pinDato_dir =    OUTPUT;
	BCF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;tabinterface.h,121 :: 		pinClock_dir =   OUTPUT;
	BCF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;tabinterface.h,122 :: 		pinLocali_dir =  OUTPUT;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;tabinterface.h,123 :: 		pinTempo_dir =   OUTPUT;
	BCF         TRISB4_bit+0, BitPos(TRISB4_bit+0) 
;tabinterface.h,124 :: 		pinOspiti_dir =  OUTPUT;
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;tabinterface.h,125 :: 		pinClaxon_dir =  OUTPUT;
	BCF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;tabinterface.h,128 :: 		debug_uart_init();
	CALL        _debug_uart_init+0, 0
;tabinterface.h,129 :: 		debug_uart_send_text("uart debug ON");
	MOVLW       ?lstr1_tab_32rx_321+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(?lstr1_tab_32rx_321+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tabinterface.h,131 :: 		}
L_end_tab_init:
	RETURN      0
; end of _tab_init

_tab_send_byte:

;tabinterface.h,133 :: 		void tab_send_byte(uint8 byteToSend)
;tabinterface.h,137 :: 		for (i = 0; i < 8; i ++)
	CLRF        R1 
L_tab_send_byte211:
	MOVLW       8
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tab_send_byte212
;tabinterface.h,139 :: 		pinDato = ! byteToSend.B7;
	BTFSC       FARG_tab_send_byte_byteToSend+0, 7 
	GOTO        L__tab_send_byte460
	BSF         LATB7_bit+0, BitPos(LATB7_bit+0) 
	GOTO        L__tab_send_byte461
L__tab_send_byte460:
	BCF         LATB7_bit+0, BitPos(LATB7_bit+0) 
L__tab_send_byte461:
;tabinterface.h,140 :: 		Delay_us(TAB_TIME_BIT_SETTING_US);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_send_byte214:
	DECFSZ      R13, 1, 1
	BRA         L_tab_send_byte214
	DECFSZ      R12, 1, 1
	BRA         L_tab_send_byte214
	NOP
	NOP
;tabinterface.h,142 :: 		pinClock = 1;
	BSF         LATB6_bit+0, BitPos(LATB6_bit+0) 
;tabinterface.h,143 :: 		Delay_us(TAB_TIME_CLOCK_ACTIVE_US);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_send_byte215:
	DECFSZ      R13, 1, 1
	BRA         L_tab_send_byte215
	DECFSZ      R12, 1, 1
	BRA         L_tab_send_byte215
	NOP
	NOP
;tabinterface.h,144 :: 		pinClock = 0;
	BCF         LATB6_bit+0, BitPos(LATB6_bit+0) 
;tabinterface.h,145 :: 		Delay_us(TAB_TIME_CLOCK_OFF_US);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_send_byte216:
	DECFSZ      R13, 1, 1
	BRA         L_tab_send_byte216
	DECFSZ      R12, 1, 1
	BRA         L_tab_send_byte216
	NOP
	NOP
;tabinterface.h,147 :: 		byteToSend = byteToSend << 1;
	RLCF        FARG_tab_send_byte_byteToSend+0, 1 
	BCF         FARG_tab_send_byte_byteToSend+0, 0 
;tabinterface.h,137 :: 		for (i = 0; i < 8; i ++)
	INCF        R1, 1 
;tabinterface.h,148 :: 		}
	GOTO        L_tab_send_byte211
L_tab_send_byte212:
;tabinterface.h,150 :: 		pinDato = 0;
	BCF         LATB7_bit+0, BitPos(LATB7_bit+0) 
;tabinterface.h,151 :: 		}
L_end_tab_send_byte:
	RETURN      0
; end of _tab_send_byte

_tab_send_num:

;tabinterface.h,153 :: 		void tab_send_num(uint8 num)
;tabinterface.h,155 :: 		tab_send_byte(___tab_get_codified_number(num));
	MOVLW       48
	ADDWF       FARG_tab_send_num_num+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       ____TAB_CHARMAP+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(____TAB_CHARMAP+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(____TAB_CHARMAP+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_tab_send_byte_byteToSend+0
	CALL        _tab_send_byte+0, 0
;tabinterface.h,156 :: 		}
L_end_tab_send_num:
	RETURN      0
; end of _tab_send_num

_tab_display_msg:

;tabinterface.h,158 :: 		void tab_display_msg(char* string, uint8 num)
;tabinterface.h,162 :: 		tab_send_string("    ", 4);
	MOVLW       ?lstr2_tab_32rx_321+0
	MOVWF       FARG_tab_send_string_string+0 
	MOVLW       hi_addr(?lstr2_tab_32rx_321+0)
	MOVWF       FARG_tab_send_string_string+1 
	MOVLW       4
	MOVWF       FARG_tab_send_string_num+0 
	CALL        _tab_send_string+0, 0
;tabinterface.h,163 :: 		tab_strobe_locals();
	CALL        _tab_strobe_locals+0, 0
;tabinterface.h,164 :: 		tab_strobe_guests();
	CALL        _tab_strobe_guests+0, 0
;tabinterface.h,166 :: 		len = num;
	MOVF        FARG_tab_display_msg_num+0, 0 
	MOVWF       tab_display_msg_len_L0+0 
;tabinterface.h,167 :: 		while (len++ < 4) tab_send_byte(0x00);
L_tab_display_msg217:
	MOVF        tab_display_msg_len_L0+0, 0 
	MOVWF       R1 
	INCF        tab_display_msg_len_L0+0, 1 
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tab_display_msg218
	CLRF        FARG_tab_send_byte_byteToSend+0 
	CALL        _tab_send_byte+0, 0
	GOTO        L_tab_display_msg217
L_tab_display_msg218:
;tabinterface.h,168 :: 		tab_send_string(string, num);
	MOVF        FARG_tab_display_msg_string+0, 0 
	MOVWF       FARG_tab_send_string_string+0 
	MOVF        FARG_tab_display_msg_string+1, 0 
	MOVWF       FARG_tab_send_string_string+1 
	MOVF        FARG_tab_display_msg_num+0, 0 
	MOVWF       FARG_tab_send_string_num+0 
	CALL        _tab_send_string+0, 0
;tabinterface.h,169 :: 		___tab_strobe(pinTempo);
	BSF         LATB4_bit+0, BitPos(LATB4_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_display_msg219:
	DECFSZ      R13, 1, 1
	BRA         L_tab_display_msg219
	DECFSZ      R12, 1, 1
	BRA         L_tab_display_msg219
	NOP
	NOP
	BCF         LATB4_bit+0, BitPos(LATB4_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_display_msg220:
	DECFSZ      R13, 1, 1
	BRA         L_tab_display_msg220
	DECFSZ      R12, 1, 1
	BRA         L_tab_display_msg220
	NOP
	NOP
;tabinterface.h,170 :: 		}
L_end_tab_display_msg:
	RETURN      0
; end of _tab_display_msg

_tab_send_string:

;tabinterface.h,172 :: 		void tab_send_string(uint8* string, uint8 num)
;tabinterface.h,174 :: 		uint8 counter = 0;
	CLRF        tab_send_string_counter_L0+0 
;tabinterface.h,177 :: 		debug_sprinti_1("str '%s'", string);
	MOVLW       ____debug_line+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_3_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_3_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_3_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVF        FARG_tab_send_string_string+0, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVF        FARG_tab_send_string_string+1, 0 
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
	MOVLW       ____debug_line+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tabinterface.h,180 :: 		while (num --)
L_tab_send_string221:
	MOVF        FARG_tab_send_string_num+0, 0 
	MOVWF       R0 
	DECF        FARG_tab_send_string_num+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tab_send_string222
;tabinterface.h,182 :: 		tab_send_byte(___tab_get_codified_character(string[counter ++]));
	MOVF        tab_send_string_counter_L0+0, 0 
	ADDWF       FARG_tab_send_string_string+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_tab_send_string_string+1, 0 
	MOVWF       FSR2H 
	MOVLW       ____TAB_CHARMAP+0
	ADDWF       POSTINC2+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(____TAB_CHARMAP+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(____TAB_CHARMAP+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_tab_send_byte_byteToSend+0
	CALL        _tab_send_byte+0, 0
	INCF        tab_send_string_counter_L0+0, 1 
;tabinterface.h,183 :: 		}
	GOTO        L_tab_send_string221
L_tab_send_string222:
;tabinterface.h,184 :: 		}
L_end_tab_send_string:
	RETURN      0
; end of _tab_send_string

_tab_strobe_locals:

;tabinterface.h,186 :: 		void tab_strobe_locals()
;tabinterface.h,189 :: 		debug_print("strobe loc");
	MOVLW       ?lstr4_tab_32rx_321+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(?lstr4_tab_32rx_321+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tabinterface.h,191 :: 		___tab_strobe(pinLocali);
	BSF         LATC6_bit+0, BitPos(LATC6_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_strobe_locals223:
	DECFSZ      R13, 1, 1
	BRA         L_tab_strobe_locals223
	DECFSZ      R12, 1, 1
	BRA         L_tab_strobe_locals223
	NOP
	NOP
	BCF         LATC6_bit+0, BitPos(LATC6_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_strobe_locals224:
	DECFSZ      R13, 1, 1
	BRA         L_tab_strobe_locals224
	DECFSZ      R12, 1, 1
	BRA         L_tab_strobe_locals224
	NOP
	NOP
;tabinterface.h,192 :: 		}
L_end_tab_strobe_locals:
	RETURN      0
; end of _tab_strobe_locals

_tab_strobe_guests:

;tabinterface.h,194 :: 		void tab_strobe_guests()
;tabinterface.h,197 :: 		debug_print("strobe osp");
	MOVLW       ?lstr5_tab_32rx_321+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(?lstr5_tab_32rx_321+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tabinterface.h,199 :: 		___tab_strobe(pinOspiti);
	BSF         LATB5_bit+0, BitPos(LATB5_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_strobe_guests225:
	DECFSZ      R13, 1, 1
	BRA         L_tab_strobe_guests225
	DECFSZ      R12, 1, 1
	BRA         L_tab_strobe_guests225
	NOP
	NOP
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_strobe_guests226:
	DECFSZ      R13, 1, 1
	BRA         L_tab_strobe_guests226
	DECFSZ      R12, 1, 1
	BRA         L_tab_strobe_guests226
	NOP
	NOP
;tabinterface.h,200 :: 		}
L_end_tab_strobe_guests:
	RETURN      0
; end of _tab_strobe_guests

_tab_strobe_time:

;tabinterface.h,202 :: 		void tab_strobe_time()
;tabinterface.h,205 :: 		debug_print("strobe time");
	MOVLW       ?lstr6_tab_32rx_321+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(?lstr6_tab_32rx_321+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tabinterface.h,207 :: 		___tab_strobe(pinTempo);
	BSF         LATB4_bit+0, BitPos(LATB4_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_strobe_time227:
	DECFSZ      R13, 1, 1
	BRA         L_tab_strobe_time227
	DECFSZ      R12, 1, 1
	BRA         L_tab_strobe_time227
	NOP
	NOP
	BCF         LATB4_bit+0, BitPos(LATB4_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_tab_strobe_time228:
	DECFSZ      R13, 1, 1
	BRA         L_tab_strobe_time228
	DECFSZ      R12, 1, 1
	BRA         L_tab_strobe_time228
	NOP
	NOP
;tabinterface.h,208 :: 		}
L_end_tab_strobe_time:
	RETURN      0
; end of _tab_strobe_time

_tab_refresh_locals:

;tabinterface.h,210 :: 		void tab_refresh_locals()
;tabinterface.h,212 :: 		___tab_refresh_teamdata(&(tab_data.locals));
	MOVLW       _tab_data+0
	MOVWF       FARG____tab_refresh_teamdata_instance+0 
	MOVLW       hi_addr(_tab_data+0)
	MOVWF       FARG____tab_refresh_teamdata_instance+1 
	CALL        ____tab_refresh_teamdata+0, 0
;tabinterface.h,213 :: 		tab_strobe_locals();
	CALL        _tab_strobe_locals+0, 0
;tabinterface.h,214 :: 		}
L_end_tab_refresh_locals:
	RETURN      0
; end of _tab_refresh_locals

_tab_refresh_guests:

;tabinterface.h,216 :: 		void tab_refresh_guests()
;tabinterface.h,218 :: 		___tab_refresh_teamdata(&(tab_data.guests));
	MOVLW       _tab_data+3
	MOVWF       FARG____tab_refresh_teamdata_instance+0 
	MOVLW       hi_addr(_tab_data+3)
	MOVWF       FARG____tab_refresh_teamdata_instance+1 
	CALL        ____tab_refresh_teamdata+0, 0
;tabinterface.h,219 :: 		tab_strobe_guests();
	CALL        _tab_strobe_guests+0, 0
;tabinterface.h,220 :: 		}
L_end_tab_refresh_guests:
	RETURN      0
; end of _tab_refresh_guests

_tab_refresh_time:

;tabinterface.h,222 :: 		void tab_refresh_time()
;tabinterface.h,226 :: 		sprinti(txt6, "%2i%02i", (int16)tab_data.time.min, (int16)tab_data.time.sec);
	MOVLW       tab_refresh_time_txt6_L0+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(tab_refresh_time_txt6_L0+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_7_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_7_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_7_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVF        _tab_data+6, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	MOVF        _tab_data+7, 0 
	MOVWF       FARG_sprinti_wh+7 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+8 
	CALL        _sprinti+0, 0
;tabinterface.h,227 :: 		tab_send_string(txt6, 4);
	MOVLW       tab_refresh_time_txt6_L0+0
	MOVWF       FARG_tab_send_string_string+0 
	MOVLW       hi_addr(tab_refresh_time_txt6_L0+0)
	MOVWF       FARG_tab_send_string_string+1 
	MOVLW       4
	MOVWF       FARG_tab_send_string_num+0 
	CALL        _tab_send_string+0, 0
;tabinterface.h,228 :: 		tab_strobe_time();
	CALL        _tab_strobe_time+0, 0
;tabinterface.h,229 :: 		}
L_end_tab_refresh_time:
	RETURN      0
; end of _tab_refresh_time

____tab_refresh_teamdata:

;tabinterface.h,231 :: 		void ___tab_refresh_teamdata(TTeamData* instance)
;tabinterface.h,236 :: 		tab_send_num(instance -> sets);
	MOVLW       1
	ADDWF       FARG____tab_refresh_teamdata_instance+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG____tab_refresh_teamdata_instance+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_tab_send_num_num+0 
	CALL        _tab_send_num+0, 0
;tabinterface.h,237 :: 		refr_dato = 0x00;
	CLRF        ___tab_refresh_teamdata_refr_dato_L0+0 
;tabinterface.h,238 :: 		if (instance -> points >= 100) refr_dato = 0x06;
	MOVFF       FARG____tab_refresh_teamdata_instance+0, FSR0
	MOVFF       FARG____tab_refresh_teamdata_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	SUBWF       R1, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L____tab_refresh_teamdata229
	MOVLW       6
	MOVWF       ___tab_refresh_teamdata_refr_dato_L0+0 
L____tab_refresh_teamdata229:
;tabinterface.h,239 :: 		refr_dato.B5 = instance -> P7F;
	MOVLW       2
	ADDWF       FARG____tab_refresh_teamdata_instance+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG____tab_refresh_teamdata_instance+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 0 
	GOTO        L_____tab_refresh_teamdata472
	BCF         ___tab_refresh_teamdata_refr_dato_L0+0, 5 
	GOTO        L_____tab_refresh_teamdata473
L_____tab_refresh_teamdata472:
	BSF         ___tab_refresh_teamdata_refr_dato_L0+0, 5 
L_____tab_refresh_teamdata473:
;tabinterface.h,240 :: 		refr_dato.B4 = instance -> P1;
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 1 
	GOTO        L_____tab_refresh_teamdata474
	BCF         ___tab_refresh_teamdata_refr_dato_L0+0, 4 
	GOTO        L_____tab_refresh_teamdata475
L_____tab_refresh_teamdata474:
	BSF         ___tab_refresh_teamdata_refr_dato_L0+0, 4 
L_____tab_refresh_teamdata475:
;tabinterface.h,241 :: 		refr_dato.B3 = instance -> P2;
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 2 
	GOTO        L_____tab_refresh_teamdata476
	BCF         ___tab_refresh_teamdata_refr_dato_L0+0, 3 
	GOTO        L_____tab_refresh_teamdata477
L_____tab_refresh_teamdata476:
	BSF         ___tab_refresh_teamdata_refr_dato_L0+0, 3 
L_____tab_refresh_teamdata477:
;tabinterface.h,242 :: 		tab_send_byte(refr_dato);
	MOVF        ___tab_refresh_teamdata_refr_dato_L0+0, 0 
	MOVWF       FARG_tab_send_byte_byteToSend+0 
	CALL        _tab_send_byte+0, 0
;tabinterface.h,243 :: 		sprinti(txt4, "%3i", (int16)instance -> points);
	MOVLW       ___tab_refresh_teamdata_txt4_L0+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(___tab_refresh_teamdata_txt4_L0+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_8_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_8_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_8_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVFF       FARG____tab_refresh_teamdata_instance+0, FSR0
	MOVFF       FARG____tab_refresh_teamdata_instance+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
;tabinterface.h,244 :: 		tab_send_string(txt4 + 1, 2);
	MOVLW       ___tab_refresh_teamdata_txt4_L0+1
	MOVWF       FARG_tab_send_string_string+0 
	MOVLW       hi_addr(___tab_refresh_teamdata_txt4_L0+1)
	MOVWF       FARG_tab_send_string_string+1 
	MOVLW       2
	MOVWF       FARG_tab_send_string_num+0 
	CALL        _tab_send_string+0, 0
;tabinterface.h,245 :: 		}
L_end____tab_refresh_teamdata:
	RETURN      0
; end of ____tab_refresh_teamdata

_test_launch:

;test.h,13 :: 		void test_launch()
;test.h,17 :: 		while (1) { test_refresh(); Delay_ms(3000); }
L_test_launch230:
	CALL        _test_refresh+0, 0
	MOVLW       183
	MOVWF       R11, 0
	MOVLW       161
	MOVWF       R12, 0
	MOVLW       195
	MOVWF       R13, 0
L_test_launch232:
	DECFSZ      R13, 1, 1
	BRA         L_test_launch232
	DECFSZ      R12, 1, 1
	BRA         L_test_launch232
	DECFSZ      R11, 1, 1
	BRA         L_test_launch232
	NOP
	NOP
	GOTO        L_test_launch230
;test.h,18 :: 		}
L_end_test_launch:
	RETURN      0
; end of _test_launch

_test_refresh:

;test.h,20 :: 		void test_refresh()
;test.h,22 :: 		debug_write_tab_data();
	CALL        _debug_write_tab_data+0, 0
;test.h,23 :: 		}
L_end_test_refresh:
	RETURN      0
; end of _test_refresh

_debug_write_tab_data:

;test.h,25 :: 		void debug_write_tab_data()
;test.h,28 :: 		sprinti(line, "(%i %3i) (%2i:%02i) (%3i %i)",
	MOVLW       debug_write_tab_data_line_L0+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(debug_write_tab_data_line_L0+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_9_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_9_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_9_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
;test.h,29 :: 		(int16)tab_data.locals.sets, (int16)tab_data.locals.points,
	MOVF        _tab_data+1, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	MOVF        _tab_data+0, 0 
	MOVWF       FARG_sprinti_wh+7 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+8 
;test.h,30 :: 		(int16)tab_data.time.min, (int16)tab_data.time.sec,
	MOVF        _tab_data+6, 0 
	MOVWF       FARG_sprinti_wh+9 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+10 
	MOVF        _tab_data+7, 0 
	MOVWF       FARG_sprinti_wh+11 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+12 
;test.h,31 :: 		(int16)tab_data.guests.sets, (int16)tab_data.guests.points
	MOVF        _tab_data+4, 0 
	MOVWF       FARG_sprinti_wh+13 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+14 
	MOVF        _tab_data+3, 0 
	MOVWF       FARG_sprinti_wh+15 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+16 
	CALL        _sprinti+0, 0
;test.h,33 :: 		debug_print(line);
	MOVLW       debug_write_tab_data_line_L0+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(debug_write_tab_data_line_L0+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;test.h,34 :: 		}
L_end_debug_write_tab_data:
	RETURN      0
; end of _debug_write_tab_data

_main:

;tab rx 1.c,17 :: 		void main()
;tab rx 1.c,19 :: 		init();
	CALL        _init+0, 0
;tab rx 1.c,21 :: 		nrf_powerup();
	MOVLW       1
	MOVWF       FARG_nrf_set_power_power+0 
	CALL        _nrf_set_power+0, 0
;tab rx 1.c,22 :: 		nrf_rx_start_listening();
	CALL        _nrf_rx_start_listening+0, 0
;tab rx 1.c,24 :: 		while (1)
L_main233:
;tab rx 1.c,26 :: 		if (flags.rxCmdPending)
	BTFSS       _flags+0, 4 
	GOTO        L_main235
;tab rx 1.c,27 :: 		ProcessRxCmd(&CmdPending);
	MOVLW       _CmdPending+0
	MOVWF       FARG_ProcessRxCmd_cmd+0 
	MOVLW       hi_addr(_CmdPending+0)
	MOVWF       FARG_ProcessRxCmd_cmd+1 
	CALL        _ProcessRxCmd+0, 0
L_main235:
;tab rx 1.c,29 :: 		if (ClockTicksPending)
	MOVF        _ClockTicksPending+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main236
;tab rx 1.c,30 :: 		ProcessPendingTicks(&ClockTicksPending);
	MOVLW       _ClockTicksPending+0
	MOVWF       FARG_ProcessPendingTicks_ticks+0 
	MOVLW       hi_addr(_ClockTicksPending+0)
	MOVWF       FARG_ProcessPendingTicks_ticks+1 
	CALL        _ProcessPendingTicks+0, 0
L_main236:
;tab rx 1.c,32 :: 		if (pendingActions != taNone)
	MOVF        _pendingActions+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main237
;tab rx 1.c,33 :: 		ProcessPendingActions(&pendingActions);
	MOVLW       _pendingActions+0
	MOVWF       FARG_ProcessPendingActions_actions+0 
	MOVLW       hi_addr(_pendingActions+0)
	MOVWF       FARG_ProcessPendingActions_actions+1 
	CALL        _ProcessPendingActions+0, 0
L_main237:
;tab rx 1.c,35 :: 		ProcessDisplay();
	CALL        _ProcessDisplay+0, 0
;tab rx 1.c,36 :: 		CheckRFInput();
	CALL        _CheckRFInput+0, 0
;tab rx 1.c,37 :: 		}
	GOTO        L_main233
;tab rx 1.c,38 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_CheckRFInput:

;tab rx 1.c,40 :: 		void CheckRFInput()
;tab rx 1.c,45 :: 		if (flags.rxCmdPending) return;
	BTFSS       _flags+0, 4 
	GOTO        L_CheckRFInput238
	GOTO        L_end_CheckRFInput
L_CheckRFInput238:
;tab rx 1.c,46 :: 		if (! nrf_rx_packet_ready()) return;
	CALL        _nrf_rx_packet_ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_CheckRFInput239
	GOTO        L_end_CheckRFInput
L_CheckRFInput239:
;tab rx 1.c,49 :: 		nrf_rx_read_packet(CFG_PAYLOAD_SIZE, buffer);
	MOVLW       7
	MOVWF       FARG_nrf_read_payload_size+0 
	MOVLW       CheckRFInput_buffer_L0+0
	MOVWF       FARG_nrf_read_payload_buffer+0 
	MOVLW       hi_addr(CheckRFInput_buffer_L0+0)
	MOVWF       FARG_nrf_read_payload_buffer+1 
	CALL        _nrf_read_payload+0, 0
;tab rx 1.c,50 :: 		nrf_clear_interrupts(NRFCFG_RX_INTERRUPT);
	MOVLW       1
	MOVWF       FARG_nrf_clear_interrupts_interrupts+0 
	CALL        _nrf_clear_interrupts+0, 0
;tab rx 1.c,51 :: 		nrfpacket_from_raw_buffer(&packet, buffer);
	MOVLW       _packet+0
	MOVWF       FARG_nrfpacket_from_raw_buffer_instance+0 
	MOVLW       hi_addr(_packet+0)
	MOVWF       FARG_nrfpacket_from_raw_buffer_instance+1 
	MOVLW       CheckRFInput_buffer_L0+0
	MOVWF       FARG_nrfpacket_from_raw_buffer_buffer+0 
	MOVLW       hi_addr(CheckRFInput_buffer_L0+0)
	MOVWF       FARG_nrfpacket_from_raw_buffer_buffer+1 
	CALL        _nrfpacket_from_raw_buffer+0, 0
;tab rx 1.c,53 :: 		for (debug_i = 0; debug_i < CFG_PAYLOAD_SIZE; debug_i ++)
	CLRF        CheckRFInput_debug_i_L0+0 
L_CheckRFInput240:
	MOVLW       7
	SUBWF       CheckRFInput_debug_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_CheckRFInput241
;tab rx 1.c,55 :: 		debug_sprinti_2("byte %i is %i", (int16)(debug_i), (int16)(buffer[debug_i]));
	MOVLW       ____debug_line+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_10_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_10_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_10_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVF        CheckRFInput_debug_i_L0+0, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	MOVLW       CheckRFInput_buffer_L0+0
	MOVWF       FSR0 
	MOVLW       hi_addr(CheckRFInput_buffer_L0+0)
	MOVWF       FSR0H 
	MOVF        CheckRFInput_debug_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprinti_wh+7 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+8 
	CALL        _sprinti+0, 0
	MOVLW       ____debug_line+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,53 :: 		for (debug_i = 0; debug_i < CFG_PAYLOAD_SIZE; debug_i ++)
	INCF        CheckRFInput_debug_i_L0+0, 1 
;tab rx 1.c,56 :: 		}
	GOTO        L_CheckRFInput240
L_CheckRFInput241:
;tab rx 1.c,59 :: 		if (nrfpacket_compare_id(&packet, packet_last_id_bytes) == 1)
	MOVLW       _packet+0
	MOVWF       FARG_nrfpacket_compare_id_instance+0 
	MOVLW       hi_addr(_packet+0)
	MOVWF       FARG_nrfpacket_compare_id_instance+1 
	MOVLW       _packet_last_id_bytes+0
	MOVWF       FARG_nrfpacket_compare_id_compare_id+0 
	MOVLW       hi_addr(_packet_last_id_bytes+0)
	MOVWF       FARG_nrfpacket_compare_id_compare_id+1 
	CALL        _nrfpacket_compare_id+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_CheckRFInput243
;tab rx 1.c,63 :: 		debug_sprinti_1("RX PACK DISC %i", (int16)(packet.cmd));
	MOVLW       ____debug_line+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_11_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_11_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_11_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVF        _packet+3, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
	MOVLW       ____debug_line+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,65 :: 		}
	GOTO        L_CheckRFInput244
L_CheckRFInput243:
;tab rx 1.c,68 :: 		nrfpacket_copy_id(&packet, packet_last_id_bytes);
	MOVLW       _packet+0
	MOVWF       FARG_nrfpacket_copy_id_instance+0 
	MOVLW       hi_addr(_packet+0)
	MOVWF       FARG_nrfpacket_copy_id_instance+1 
	MOVLW       _packet_last_id_bytes+0
	MOVWF       FARG_nrfpacket_copy_id_dest_id+0 
	MOVLW       hi_addr(_packet_last_id_bytes+0)
	MOVWF       FARG_nrfpacket_copy_id_dest_id+1 
	CALL        _nrfpacket_copy_id+0, 0
;tab rx 1.c,70 :: 		debug_sprinti_1("RX PACK OK %i", (int16)(packet.cmd));
	MOVLW       ____debug_line+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_12_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_12_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_12_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVF        _packet+3, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
	MOVLW       ____debug_line+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,73 :: 		CmdPending = packet.cmd;
	MOVF        _packet+3, 0 
	MOVWF       _CmdPending+0 
;tab rx 1.c,74 :: 		flags.rxCmdPending = 1;
	BSF         _flags+0, 4 
;tab rx 1.c,75 :: 		}
L_CheckRFInput244:
;tab rx 1.c,76 :: 		nrf_rx_start_listening();
	CALL        _nrf_rx_start_listening+0, 0
;tab rx 1.c,77 :: 		}
L_end_CheckRFInput:
	RETURN      0
; end of _CheckRFInput

_ProcessDisplay:

;tab rx 1.c,79 :: 		void ProcessDisplay()
;tab rx 1.c,81 :: 		if (! flags.inStandby)
	BTFSC       _flags+0, 2 
	GOTO        L_ProcessDisplay245
;tab rx 1.c,83 :: 		if (whatsChanged != tcfNone)
	MOVF        _whatsChanged+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_ProcessDisplay246
;tab rx 1.c,84 :: 		ProcessDisplayOn();
	CALL        _ProcessDisplayOn+0, 0
L_ProcessDisplay246:
;tab rx 1.c,85 :: 		}
	GOTO        L_ProcessDisplay247
L_ProcessDisplay245:
;tab rx 1.c,88 :: 		ProcessDisplayStandby();
	CALL        _ProcessDisplayStandby+0, 0
;tab rx 1.c,89 :: 		}
L_ProcessDisplay247:
;tab rx 1.c,90 :: 		}
L_end_ProcessDisplay:
	RETURN      0
; end of _ProcessDisplay

_ProcessDisplayOn:

;tab rx 1.c,92 :: 		void ProcessDisplayOn()
;tab rx 1.c,96 :: 		localChanged = whatsChanged;
	MOVF        _whatsChanged+0, 0 
	MOVWF       ProcessDisplayOn_localChanged_L0+0 
;tab rx 1.c,97 :: 		whatsChanged = 0;
	CLRF        _whatsChanged+0 
;tab rx 1.c,99 :: 		if (localChanged & tcfLocals)
	BTFSS       ProcessDisplayOn_localChanged_L0+0, 0 
	GOTO        L_ProcessDisplayOn248
;tab rx 1.c,100 :: 		tab_refresh_locals();
	CALL        _tab_refresh_locals+0, 0
L_ProcessDisplayOn248:
;tab rx 1.c,102 :: 		if (localChanged & tcfGuests)
	BTFSS       ProcessDisplayOn_localChanged_L0+0, 1 
	GOTO        L_ProcessDisplayOn249
;tab rx 1.c,103 :: 		tab_refresh_guests();
	CALL        _tab_refresh_guests+0, 0
L_ProcessDisplayOn249:
;tab rx 1.c,105 :: 		if (localChanged & tcfTime)
	BTFSS       ProcessDisplayOn_localChanged_L0+0, 2 
	GOTO        L_ProcessDisplayOn250
;tab rx 1.c,106 :: 		tab_refresh_time();
	CALL        _tab_refresh_time+0, 0
L_ProcessDisplayOn250:
;tab rx 1.c,107 :: 		}
L_end_ProcessDisplayOn:
	RETURN      0
; end of _ProcessDisplayOn

_ProcessDisplayStandby:

;tab rx 1.c,109 :: 		void ProcessDisplayStandby()
;tab rx 1.c,113 :: 		if (! flags.timedRoutinePending) return;
	BTFSC       _flags+0, 6 
	GOTO        L_ProcessDisplayStandby251
	GOTO        L_end_ProcessDisplayStandby
L_ProcessDisplayStandby251:
;tab rx 1.c,114 :: 		flags.timedRoutinePending = 0;
	BCF         _flags+0, 6 
;tab rx 1.c,116 :: 		if (cnt == 0)
	MOVLW       0
	XORWF       ProcessDisplayStandby_cnt_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ProcessDisplayStandby486
	MOVLW       0
	XORWF       ProcessDisplayStandby_cnt_L0+0, 0 
L__ProcessDisplayStandby486:
	BTFSS       STATUS+0, 2 
	GOTO        L_ProcessDisplayStandby252
;tab rx 1.c,118 :: 		tab_send_string(".   ", 4);
	MOVLW       ?lstr13_tab_32rx_321+0
	MOVWF       FARG_tab_send_string_string+0 
	MOVLW       hi_addr(?lstr13_tab_32rx_321+0)
	MOVWF       FARG_tab_send_string_string+1 
	MOVLW       4
	MOVWF       FARG_tab_send_string_num+0 
	CALL        _tab_send_string+0, 0
;tab rx 1.c,119 :: 		tab_strobe_time();
	CALL        _tab_strobe_time+0, 0
;tab rx 1.c,120 :: 		}
L_ProcessDisplayStandby252:
;tab rx 1.c,122 :: 		if (cnt == 1000)
	MOVF        ProcessDisplayStandby_cnt_L0+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__ProcessDisplayStandby487
	MOVLW       232
	XORWF       ProcessDisplayStandby_cnt_L0+0, 0 
L__ProcessDisplayStandby487:
	BTFSS       STATUS+0, 2 
	GOTO        L_ProcessDisplayStandby253
;tab rx 1.c,124 :: 		tab_send_string("    ", 4);
	MOVLW       ?lstr14_tab_32rx_321+0
	MOVWF       FARG_tab_send_string_string+0 
	MOVLW       hi_addr(?lstr14_tab_32rx_321+0)
	MOVWF       FARG_tab_send_string_string+1 
	MOVLW       4
	MOVWF       FARG_tab_send_string_num+0 
	CALL        _tab_send_string+0, 0
;tab rx 1.c,125 :: 		tab_strobe_time();
	CALL        _tab_strobe_time+0, 0
;tab rx 1.c,126 :: 		}
L_ProcessDisplayStandby253:
;tab rx 1.c,128 :: 		if (cnt == 5000) cnt = 0;
	MOVF        ProcessDisplayStandby_cnt_L0+1, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L__ProcessDisplayStandby488
	MOVLW       136
	XORWF       ProcessDisplayStandby_cnt_L0+0, 0 
L__ProcessDisplayStandby488:
	BTFSS       STATUS+0, 2 
	GOTO        L_ProcessDisplayStandby254
	CLRF        ProcessDisplayStandby_cnt_L0+0 
	CLRF        ProcessDisplayStandby_cnt_L0+1 
	GOTO        L_ProcessDisplayStandby255
L_ProcessDisplayStandby254:
;tab rx 1.c,129 :: 		else cnt ++;
	INFSNZ      ProcessDisplayStandby_cnt_L0+0, 1 
	INCF        ProcessDisplayStandby_cnt_L0+1, 1 
L_ProcessDisplayStandby255:
;tab rx 1.c,130 :: 		}
L_end_ProcessDisplayStandby:
	RETURN      0
; end of _ProcessDisplayStandby

_ProcessRxCmd:

;tab rx 1.c,132 :: 		void ProcessRxCmd(TCmd * cmd)
;tab rx 1.c,137 :: 		debug_sprinti_1("ProcessRxCmd %i", (int16)(*cmd));
	MOVLW       ____debug_line+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_15_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_15_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_15_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVFF       FARG_ProcessRxCmd_cmd+0, FSR0
	MOVFF       FARG_ProcessRxCmd_cmd+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
	MOVLW       ____debug_line+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,140 :: 		localCmd = *cmd;
	MOVFF       FARG_ProcessRxCmd_cmd+0, FSR0
	MOVFF       FARG_ProcessRxCmd_cmd+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       ProcessRxCmd_localCmd_L0+0 
;tab rx 1.c,141 :: 		*cmd = CmdCode_None;
	MOVFF       FARG_ProcessRxCmd_cmd+0, FSR1
	MOVFF       FARG_ProcessRxCmd_cmd+1, FSR1H
	CLRF        POSTINC1+0 
;tab rx 1.c,143 :: 		flags.rxCmdPending = 0;
	BCF         _flags+0, 4 
;tab rx 1.c,145 :: 		if (!flags.inStandby)
	BTFSC       _flags+0, 2 
	GOTO        L_ProcessRxCmd256
;tab rx 1.c,146 :: 		whatsChanged |= ApplyCmd(localCmd);
	MOVF        ProcessRxCmd_localCmd_L0+0, 0 
	MOVWF       FARG_ApplyCmd_cmd+0 
	CALL        _ApplyCmd+0, 0
	MOVF        R0, 0 
	IORWF       _whatsChanged+0, 1 
	GOTO        L_ProcessRxCmd257
L_ProcessRxCmd256:
;tab rx 1.c,149 :: 		flags.inStandby = 0;
	BCF         _flags+0, 2 
;tab rx 1.c,150 :: 		whatsChanged |= tcfAll;
	MOVLW       7
	IORWF       _whatsChanged+0, 1 
;tab rx 1.c,151 :: 		}
L_ProcessRxCmd257:
;tab rx 1.c,152 :: 		}
L_end_ProcessRxCmd:
	RETURN      0
; end of _ProcessRxCmd

_ProcessPendingTicks:

;tab rx 1.c,154 :: 		void ProcessPendingTicks(uint8 * ticks)
;tab rx 1.c,159 :: 		debug_sprinti_1("ProcessTicks %i", (int16)(*ticks));
	MOVLW       ____debug_line+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_16_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_16_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_16_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVFF       FARG_ProcessPendingTicks_ticks+0, FSR0
	MOVFF       FARG_ProcessPendingTicks_ticks+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
	MOVLW       ____debug_line+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,162 :: 		localTicks = *ticks;
	MOVFF       FARG_ProcessPendingTicks_ticks+0, FSR0
	MOVFF       FARG_ProcessPendingTicks_ticks+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       ProcessPendingTicks_localTicks_L0+0 
;tab rx 1.c,163 :: 		*ticks = 0;
	MOVFF       FARG_ProcessPendingTicks_ticks+0, FSR1
	MOVFF       FARG_ProcessPendingTicks_ticks+1, FSR1H
	CLRF        POSTINC1+0 
;tab rx 1.c,165 :: 		if (!flags.inStandby)
	BTFSC       _flags+0, 2 
	GOTO        L_ProcessPendingTicks258
;tab rx 1.c,167 :: 		whatsChanged |= tcfTime;
	BSF         _whatsChanged+0, 2 
;tab rx 1.c,168 :: 		tabdata_add_sec(&(tab_data.time), -((int8)localTicks));
	MOVLW       _tab_data+6
	MOVWF       FARG_tabdata_add_sec_instance+0 
	MOVLW       hi_addr(_tab_data+6)
	MOVWF       FARG_tabdata_add_sec_instance+1 
	MOVF        ProcessPendingTicks_localTicks_L0+0, 0 
	SUBLW       0
	MOVWF       FARG_tabdata_add_sec_toAdd+0 
	CALL        _tabdata_add_sec+0, 0
;tab rx 1.c,170 :: 		if (tab_data.time.min == 0 && tab_data.time.sec == 0)
	MOVF        _tab_data+6, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_ProcessPendingTicks261
	MOVF        _tab_data+7, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_ProcessPendingTicks261
L__ProcessPendingTicks290:
;tab rx 1.c,172 :: 		flags.timeStarted = 0;
	BCF         _flags+0, 0 
;tab rx 1.c,173 :: 		pendingActions |= taTimeEnded;
	BSF         _pendingActions+0, 2 
;tab rx 1.c,174 :: 		}
L_ProcessPendingTicks261:
;tab rx 1.c,175 :: 		}
L_ProcessPendingTicks258:
;tab rx 1.c,176 :: 		}
L_end_ProcessPendingTicks:
	RETURN      0
; end of _ProcessPendingTicks

_ProcessPendingActions:

;tab rx 1.c,178 :: 		void ProcessPendingActions(TAction * actions)
;tab rx 1.c,185 :: 		debug_sprinti_1("ProcessPendingActions %i", (int16)(*actions));
	MOVLW       ____debug_line+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_17_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_17_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_17_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVFF       FARG_ProcessPendingActions_actions+0, FSR0
	MOVFF       FARG_ProcessPendingActions_actions+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
	MOVLW       ____debug_line+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(____debug_line+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,188 :: 		localActions = *actions;
	MOVFF       FARG_ProcessPendingActions_actions+0, FSR0
	MOVFF       FARG_ProcessPendingActions_actions+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       ProcessPendingActions_localActions_L0+0 
;tab rx 1.c,189 :: 		*actions = 0;
	MOVFF       FARG_ProcessPendingActions_actions+0, FSR1
	MOVFF       FARG_ProcessPendingActions_actions+1, FSR1H
	CLRF        POSTINC1+0 
;tab rx 1.c,191 :: 		if (flags.inStandby) return;
	BTFSS       _flags+0, 2 
	GOTO        L_ProcessPendingActions262
	GOTO        L_end_ProcessPendingActions
L_ProcessPendingActions262:
;tab rx 1.c,193 :: 		if (localActions & taNotifyClaxon)
	BTFSS       ProcessPendingActions_localActions_L0+0, 0 
	GOTO        L_ProcessPendingActions263
;tab rx 1.c,195 :: 		if (configuration.UseClaxon)
	BTFSS       _configuration+0, 0 
	GOTO        L_ProcessPendingActions264
;tab rx 1.c,196 :: 		tab_display_msg("COFF", 4);
	MOVLW       ?lstr18_tab_32rx_321+0
	MOVWF       FARG_tab_display_msg_string+0 
	MOVLW       hi_addr(?lstr18_tab_32rx_321+0)
	MOVWF       FARG_tab_display_msg_string+1 
	MOVLW       4
	MOVWF       FARG_tab_display_msg_num+0 
	CALL        _tab_display_msg+0, 0
	GOTO        L_ProcessPendingActions265
L_ProcessPendingActions264:
;tab rx 1.c,198 :: 		tab_display_msg("C ON", 4);
	MOVLW       ?lstr19_tab_32rx_321+0
	MOVWF       FARG_tab_display_msg_string+0 
	MOVLW       hi_addr(?lstr19_tab_32rx_321+0)
	MOVWF       FARG_tab_display_msg_string+1 
	MOVLW       4
	MOVWF       FARG_tab_display_msg_num+0 
	CALL        _tab_display_msg+0, 0
L_ProcessPendingActions265:
;tab rx 1.c,200 :: 		SyncedDelay(1000);
	MOVLW       232
	MOVWF       FARG_SyncedDelay_ms+0 
	MOVLW       3
	MOVWF       FARG_SyncedDelay_ms+1 
	CALL        _SyncedDelay+0, 0
;tab rx 1.c,201 :: 		whatsChanged |= tcfAll;
	MOVLW       7
	IORWF       _whatsChanged+0, 1 
;tab rx 1.c,202 :: 		}
L_ProcessPendingActions263:
;tab rx 1.c,204 :: 		if (localActions & taTryClaxon)
	BTFSS       ProcessPendingActions_localActions_L0+0, 1 
	GOTO        L_ProcessPendingActions266
;tab rx 1.c,206 :: 		for (i8 = 3; i8 > 0; i8 --)
	MOVLW       3
	MOVWF       ProcessPendingActions_i8_L0+0 
L_ProcessPendingActions267:
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       ProcessPendingActions_i8_L0+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_ProcessPendingActions268
;tab rx 1.c,208 :: 		sprinti(txt5, "%i...", (int16)i8);
	MOVLW       ProcessPendingActions_txt5_L0+0
	MOVWF       FARG_sprinti_wh+0 
	MOVLW       hi_addr(ProcessPendingActions_txt5_L0+0)
	MOVWF       FARG_sprinti_wh+1 
	MOVLW       ?lstr_20_tab_32rx_321+0
	MOVWF       FARG_sprinti_f+0 
	MOVLW       hi_addr(?lstr_20_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+1 
	MOVLW       higher_addr(?lstr_20_tab_32rx_321+0)
	MOVWF       FARG_sprinti_f+2 
	MOVF        ProcessPendingActions_i8_L0+0, 0 
	MOVWF       FARG_sprinti_wh+5 
	MOVLW       0
	BTFSC       ProcessPendingActions_i8_L0+0, 7 
	MOVLW       255
	MOVWF       FARG_sprinti_wh+6 
	CALL        _sprinti+0, 0
;tab rx 1.c,209 :: 		tab_display_msg(txt5, 4);
	MOVLW       ProcessPendingActions_txt5_L0+0
	MOVWF       FARG_tab_display_msg_string+0 
	MOVLW       hi_addr(ProcessPendingActions_txt5_L0+0)
	MOVWF       FARG_tab_display_msg_string+1 
	MOVLW       4
	MOVWF       FARG_tab_display_msg_num+0 
	CALL        _tab_display_msg+0, 0
;tab rx 1.c,206 :: 		for (i8 = 3; i8 > 0; i8 --)
	DECF        ProcessPendingActions_i8_L0+0, 1 
;tab rx 1.c,210 :: 		}
	GOTO        L_ProcessPendingActions267
L_ProcessPendingActions268:
;tab rx 1.c,212 :: 		TriggerAlarm(750);
	MOVLW       238
	MOVWF       FARG_TriggerAlarm_time+0 
	MOVLW       2
	MOVWF       FARG_TriggerAlarm_time+1 
	CALL        _TriggerAlarm+0, 0
;tab rx 1.c,213 :: 		whatsChanged |= tcfAll;
	MOVLW       7
	IORWF       _whatsChanged+0, 1 
;tab rx 1.c,214 :: 		}
L_ProcessPendingActions266:
;tab rx 1.c,216 :: 		if (localActions & taTimeEnded)
	BTFSS       ProcessPendingActions_localActions_L0+0, 2 
	GOTO        L_ProcessPendingActions270
;tab rx 1.c,218 :: 		TriggerAlarm(1500);
	MOVLW       220
	MOVWF       FARG_TriggerAlarm_time+0 
	MOVLW       5
	MOVWF       FARG_TriggerAlarm_time+1 
	CALL        _TriggerAlarm+0, 0
;tab rx 1.c,219 :: 		tab_display_msg("----", 4);
	MOVLW       ?lstr21_tab_32rx_321+0
	MOVWF       FARG_tab_display_msg_string+0 
	MOVLW       hi_addr(?lstr21_tab_32rx_321+0)
	MOVWF       FARG_tab_display_msg_string+1 
	MOVLW       4
	MOVWF       FARG_tab_display_msg_num+0 
	CALL        _tab_display_msg+0, 0
;tab rx 1.c,220 :: 		whatsChanged |= tcfAll;
	MOVLW       7
	IORWF       _whatsChanged+0, 1 
;tab rx 1.c,221 :: 		}
L_ProcessPendingActions270:
;tab rx 1.c,223 :: 		if (localActions & taClear)
	BTFSS       ProcessPendingActions_localActions_L0+0, 3 
	GOTO        L_ProcessPendingActions271
;tab rx 1.c,225 :: 		tab_send_string("    ", 4);
	MOVLW       ?lstr22_tab_32rx_321+0
	MOVWF       FARG_tab_send_string_string+0 
	MOVLW       hi_addr(?lstr22_tab_32rx_321+0)
	MOVWF       FARG_tab_send_string_string+1 
	MOVLW       4
	MOVWF       FARG_tab_send_string_num+0 
	CALL        _tab_send_string+0, 0
;tab rx 1.c,226 :: 		tab_strobe_time();
	CALL        _tab_strobe_time+0, 0
;tab rx 1.c,227 :: 		tab_strobe_locals();
	CALL        _tab_strobe_locals+0, 0
;tab rx 1.c,228 :: 		tab_strobe_guests();
	CALL        _tab_strobe_guests+0, 0
;tab rx 1.c,229 :: 		whatsChanged |= tcfAll;
	MOVLW       7
	IORWF       _whatsChanged+0, 1 
;tab rx 1.c,230 :: 		}
L_ProcessPendingActions271:
;tab rx 1.c,231 :: 		}
L_end_ProcessPendingActions:
	RETURN      0
; end of _ProcessPendingActions

_InterruptLow:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;tab rx 1.c,233 :: 		void InterruptLow() iv 0x0018 ics ICS_AUTO
;tab rx 1.c,235 :: 		if (INTCON.T0IF)
	BTFSS       INTCON+0, 2 
	GOTO        L_InterruptLow272
;tab rx 1.c,238 :: 		INTCON.T0IF = 0;
	BCF         INTCON+0, 2 
;tab rx 1.c,239 :: 		TMR0L += 69;
	MOVLW       69
	ADDWF       TMR0L+0, 1 
;tab rx 1.c,241 :: 		flags.timedRoutinePending = 1;
	BSF         _flags+0, 6 
;tab rx 1.c,242 :: 		if (SyncedDelayCounter > 0) SyncedDelayCounter = 0;
	MOVLW       0
	MOVWF       R0 
	MOVF        _SyncedDelayCounter+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__InterruptLow494
	MOVF        _SyncedDelayCounter+0, 0 
	SUBLW       0
L__InterruptLow494:
	BTFSC       STATUS+0, 0 
	GOTO        L_InterruptLow273
	CLRF        _SyncedDelayCounter+0 
	CLRF        _SyncedDelayCounter+1 
L_InterruptLow273:
;tab rx 1.c,245 :: 		PIN_DBG_0 = ! PIN_DBG_0;
	BTG         LATA0_bit+0, BitPos(LATA0_bit+0) 
;tab rx 1.c,247 :: 		}
L_InterruptLow272:
;tab rx 1.c,248 :: 		}
L_end_InterruptLow:
L__InterruptLow493:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _InterruptLow

_InterruptHigh:

;tab rx 1.c,250 :: 		void InterruptHigh() iv 0x0008 ics ICS_AUTO
;tab rx 1.c,252 :: 		if (PIR1.TMR1IF)
	BTFSS       PIR1+0, 0 
	GOTO        L_InterruptHigh274
;tab rx 1.c,255 :: 		TMR1H = 0x80;
	MOVLW       128
	MOVWF       TMR1H+0 
;tab rx 1.c,256 :: 		TMR1L = 0x00;
	CLRF        TMR1L+0 
;tab rx 1.c,257 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;tab rx 1.c,260 :: 		if ((flags.timeStarted) && (!flags.inStandby) && (!ClockTicksPending.B7))
	BTFSS       _flags+0, 0 
	GOTO        L_InterruptHigh277
	BTFSC       _flags+0, 2 
	GOTO        L_InterruptHigh277
	BTFSC       _ClockTicksPending+0, 7 
	GOTO        L_InterruptHigh277
L__InterruptHigh291:
;tab rx 1.c,261 :: 		ClockTicksPending ++;
	INCF        _ClockTicksPending+0, 1 
L_InterruptHigh277:
;tab rx 1.c,262 :: 		}
L_InterruptHigh274:
;tab rx 1.c,263 :: 		}
L_end_InterruptHigh:
L__InterruptHigh496:
	RETFIE      1
; end of _InterruptHigh

_init:

;tab rx 1.c,265 :: 		void init()
;tab rx 1.c,267 :: 		hw_init();
	CALL        _hw_init+0, 0
;tab rx 1.c,269 :: 		emu_eeprom_init();
	CALL        _emu_eeprom_init+0, 0
;tab rx 1.c,270 :: 		tab_Init();
	CALL        _tab_init+0, 0
;tab rx 1.c,272 :: 		variables_init();
	CALL        _variables_init+0, 0
;tab rx 1.c,273 :: 		config_load(&configuration);
	MOVLW       _configuration+0
	MOVWF       FARG_config_load_instance+0 
	MOVLW       hi_addr(_configuration+0)
	MOVWF       FARG_config_load_instance+1 
	CALL        _config_load+0, 0
;tab rx 1.c,275 :: 		tab_display_msg("    ", 4);
	MOVLW       ?lstr23_tab_32rx_321+0
	MOVWF       FARG_tab_display_msg_string+0 
	MOVLW       hi_addr(?lstr23_tab_32rx_321+0)
	MOVWF       FARG_tab_display_msg_string+1 
	MOVLW       4
	MOVWF       FARG_tab_display_msg_num+0 
	CALL        _tab_display_msg+0, 0
;tab rx 1.c,277 :: 		if (whyRestarted == SelfReset)
	MOVF        _whyRestarted+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_init278
;tab rx 1.c,279 :: 		tab_display_msg("----", 4);
	MOVLW       ?lstr24_tab_32rx_321+0
	MOVWF       FARG_tab_display_msg_string+0 
	MOVLW       hi_addr(?lstr24_tab_32rx_321+0)
	MOVWF       FARG_tab_display_msg_string+1 
	MOVLW       4
	MOVWF       FARG_tab_display_msg_num+0 
	CALL        _tab_display_msg+0, 0
;tab rx 1.c,280 :: 		Delay_ms(1000);
	MOVLW       61
	MOVWF       R11, 0
	MOVLW       225
	MOVWF       R12, 0
	MOVLW       63
	MOVWF       R13, 0
L_init279:
	DECFSZ      R13, 1, 1
	BRA         L_init279
	DECFSZ      R12, 1, 1
	BRA         L_init279
	DECFSZ      R11, 1, 1
	BRA         L_init279
	NOP
	NOP
;tab rx 1.c,281 :: 		}
L_init278:
;tab rx 1.c,283 :: 		if (! main_nrf_init())
	CALL        _main_nrf_init+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_init280
;tab rx 1.c,285 :: 		tab_display_msg("E 01", 4);
	MOVLW       ?lstr25_tab_32rx_321+0
	MOVWF       FARG_tab_display_msg_string+0 
	MOVLW       hi_addr(?lstr25_tab_32rx_321+0)
	MOVWF       FARG_tab_display_msg_string+1 
	MOVLW       4
	MOVWF       FARG_tab_display_msg_num+0 
	CALL        _tab_display_msg+0, 0
;tab rx 1.c,286 :: 		Delay_ms(5000);
	MOVLW       2
	MOVWF       R10, 0
	MOVLW       49
	MOVWF       R11, 0
	MOVLW       98
	MOVWF       R12, 0
	MOVLW       69
	MOVWF       R13, 0
L_init281:
	DECFSZ      R13, 1, 1
	BRA         L_init281
	DECFSZ      R12, 1, 1
	BRA         L_init281
	DECFSZ      R11, 1, 1
	BRA         L_init281
	DECFSZ      R10, 1, 1
	BRA         L_init281
;tab rx 1.c,289 :: 		while (1)
L_init282:
;tab rx 1.c,291 :: 		debug_print("tab err");
	MOVLW       ?lstr26_tab_32rx_321+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(?lstr26_tab_32rx_321+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,292 :: 		Delay_ms(1000);
	MOVLW       61
	MOVWF       R11, 0
	MOVLW       225
	MOVWF       R12, 0
	MOVLW       63
	MOVWF       R13, 0
L_init284:
	DECFSZ      R13, 1, 1
	BRA         L_init284
	DECFSZ      R12, 1, 1
	BRA         L_init284
	DECFSZ      R11, 1, 1
	BRA         L_init284
	NOP
	NOP
;tab rx 1.c,293 :: 		}
	GOTO        L_init282
;tab rx 1.c,295 :: 		}
L_init280:
;tab rx 1.c,298 :: 		Delay_ms(1000);
	MOVLW       61
	MOVWF       R11, 0
	MOVLW       225
	MOVWF       R12, 0
	MOVLW       63
	MOVWF       R13, 0
L_init285:
	DECFSZ      R13, 1, 1
	BRA         L_init285
	DECFSZ      R12, 1, 1
	BRA         L_init285
	DECFSZ      R11, 1, 1
	BRA         L_init285
	NOP
	NOP
;tab rx 1.c,299 :: 		debug_print("init end");
	MOVLW       ?lstr27_tab_32rx_321+0
	MOVWF       FARG_debug_uart_send_text_text+0 
	MOVLW       hi_addr(?lstr27_tab_32rx_321+0)
	MOVWF       FARG_debug_uart_send_text_text+1 
	CALL        _debug_uart_send_text+0, 0
;tab rx 1.c,302 :: 		hw_int_enable();
	CALL        _hw_int_enable+0, 0
;tab rx 1.c,303 :: 		}
L_end_init:
	RETURN      0
; end of _init

_SyncedDelay:

;tab rx 1.c,305 :: 		void SyncedDelay(uint16 ms)
;tab rx 1.c,307 :: 		SyncedDelayCounter = ms;
	MOVF        FARG_SyncedDelay_ms+0, 0 
	MOVWF       _SyncedDelayCounter+0 
	MOVF        FARG_SyncedDelay_ms+1, 0 
	MOVWF       _SyncedDelayCounter+1 
;tab rx 1.c,308 :: 		while (SyncedDelayCounter > 0) ;
L_SyncedDelay286:
	MOVLW       0
	MOVWF       R0 
	MOVF        _SyncedDelayCounter+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SyncedDelay499
	MOVF        _SyncedDelayCounter+0, 0 
	SUBLW       0
L__SyncedDelay499:
	BTFSC       STATUS+0, 0 
	GOTO        L_SyncedDelay287
	GOTO        L_SyncedDelay286
L_SyncedDelay287:
;tab rx 1.c,309 :: 		}
L_end_SyncedDelay:
	RETURN      0
; end of _SyncedDelay

_TriggerAlarm:

;tab rx 1.c,311 :: 		void TriggerAlarm(uint16 time)
;tab rx 1.c,313 :: 		pinClaxon = 1;
	BSF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;tab rx 1.c,314 :: 		SyncedDelay(time);
	MOVF        FARG_TriggerAlarm_time+0, 0 
	MOVWF       FARG_SyncedDelay_ms+0 
	MOVF        FARG_TriggerAlarm_time+1, 0 
	MOVWF       FARG_SyncedDelay_ms+1 
	CALL        _SyncedDelay+0, 0
;tab rx 1.c,315 :: 		pinClaxon = 0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;tab rx 1.c,316 :: 		SyncedDelay(250);
	MOVLW       250
	MOVWF       FARG_SyncedDelay_ms+0 
	MOVLW       0
	MOVWF       FARG_SyncedDelay_ms+1 
	CALL        _SyncedDelay+0, 0
;tab rx 1.c,317 :: 		}
L_end_TriggerAlarm:
	RETURN      0
; end of _TriggerAlarm

_main_nrf_init:

;tab rx 1.c,319 :: 		uint8 main_nrf_init()
;tab rx 1.c,322 :: 		uint8 addr[CFG_NUM_ADDRESS_BYTES] = {CFG_ADDRESS};
	CLRF        main_nrf_init_addr_L0+0 
	MOVLW       1
	MOVWF       main_nrf_init_addr_L0+1 
	MOVLW       2
	MOVWF       main_nrf_init_addr_L0+2 
	MOVLW       3
	MOVWF       main_nrf_init_addr_L0+3 
	MOVLW       4
	MOVWF       main_nrf_init_addr_L0+4 
;tab rx 1.c,324 :: 		nrf_init();
	CALL        _nrf_init+0, 0
;tab rx 1.c,325 :: 		nrf_set_output_power        (CFG_TX_POWER);
	MOVLW       3
	MOVWF       FARG_nrf_set_output_power_power+0 
	CALL        _nrf_set_output_power+0, 0
;tab rx 1.c,326 :: 		nrf_set_crc                 (CFG_USE_CRC);
	MOVLW       2
	MOVWF       FARG_nrf_set_crc_crc+0 
	CALL        _nrf_set_crc+0, 0
;tab rx 1.c,327 :: 		nrf_set_channel             (CFG_RADIO_CHANNEL);
	MOVLW       2
	MOVWF       FARG_nrf_set_channel_channel+0 
	CALL        _nrf_set_channel+0, 0
;tab rx 1.c,328 :: 		nrf_set_interrupts          (NRFCFG_NO_INTERRUPTS);
	CLRF        FARG_nrf_set_interrupts_interrupts+0 
	CALL        _nrf_set_interrupts+0, 0
;tab rx 1.c,329 :: 		nrf_set_direction           (NRFCFG_DIRECTION_RX);
	MOVLW       1
	MOVWF       FARG_nrf_set_direction_direction+0 
	CALL        _nrf_set_direction+0, 0
;tab rx 1.c,330 :: 		nrf_enable_auto_acks        (CFG_USE_AUTOACK ? 0b000001 : 0b000000);
	MOVLW       1
	MOVWF       FARG_nrf_enable_auto_acks_channels+0 
	CALL        _nrf_enable_auto_acks+0, 0
;tab rx 1.c,331 :: 		nrf_enable_data_pipes       (0b000001);
	MOVLW       1
	MOVWF       FARG_nrf_enable_data_pipes_channels+0 
	CALL        _nrf_enable_data_pipes+0, 0
;tab rx 1.c,332 :: 		nrf_set_data_rate           (CFG_DATARATE);
	CLRF        FARG_nrf_set_data_rate_datarate+0 
	CALL        _nrf_set_data_rate+0, 0
;tab rx 1.c,333 :: 		nrf_set_rx_pipe             (0, CFG_NUM_ADDRESS_BYTES, addr, CFG_PAYLOAD_SIZE);
	CLRF        FARG_nrf_set_rx_pipe_pipenum+0 
	MOVLW       5
	MOVWF       FARG_nrf_set_rx_pipe_num+0 
	MOVLW       main_nrf_init_addr_L0+0
	MOVWF       FARG_nrf_set_rx_pipe_buffer+0 
	MOVLW       hi_addr(main_nrf_init_addr_L0+0)
	MOVWF       FARG_nrf_set_rx_pipe_buffer+1 
	MOVLW       7
	MOVWF       FARG_nrf_set_rx_pipe_packet_size+0 
	CALL        _nrf_set_rx_pipe+0, 0
;tab rx 1.c,335 :: 		return nrf_test();
	CALL        _nrf_test+0, 0
;tab rx 1.c,336 :: 		}
L_end_main_nrf_init:
	RETURN      0
; end of _main_nrf_init
