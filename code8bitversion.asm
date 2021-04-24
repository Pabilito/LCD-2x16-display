;INITIALIZATION ----------------------------
	CALL delay_start	
	
; NAMING PINS
	LCD_RS EQU P3.0
	LCD_E EQU P3.1
	LCD_BUS EQU P1

; FUNCTION SET
	CLR LCD_RS
	CLR P1.7		
	CLR P1.6		
	SETB P1.5		
	SETB P1.4
	SETB P1.3		; 2 line mode
	CLR P1.2		; display off for now
	;we don't care about P1.1 and P1.0
	SETB LCD_E
	CLR LCD_E
	CALL delay_short	


; DISPLAY ON/OFF CONTROL
; the display is turned on, the cursor is turned on and blinking is turned on		
	CLR P1.5		
	CLR P1.4
	SETB P1.2		; display on
	SETB P1.1		; cursor on
	SETB P1.0		; blink on - just to know that sth is going on

	SETB LCD_E
	CLR LCD_E
	CALL delay_short		

;DISPLAY CLEAR
	CLR P1.3
	CLR P1.2
	CLR P1.1
	
	SETB LCD_E
	CLR LCD_E
	CALL delay_long

; ENTRY MODE SET
; set to increment with no shift
	SETB P1.2	
	SETB P1.1
	
	SETB LCD_E
	CLR LCD_E	
	CALL delay_short
	
;END OF INITIALIZATION --------------------

; SEND DATA
	MOV LCD_BUS, #'P'	
	CALL send_data
	CALL delay_short
	CALL infinite_loop

send_command:
	CLR LCD_RS
	SETB LCD_E
	CLR LCD_E
	RET

send_data:
	SETB LCD_RS
	SETB LCD_E
	CLR LCD_E
	RET

infinite_loop:
	JMP infinite_loop

delay_long:				;1.53ms is around 1410
	MOV R0, 0x3			;3*240*2 = 1440 
	loop_delay:		
		MOV R1, 0xF0	;240
		DJNZ R1, $
		DJNZ R0, loop_delay
	RET
	
delay_short:		;39us should be around 36 cycles
	MOV R0, 0x14	;20 in decimal (some more cycles just in case)
	DJNZ R0, $		;takes 2 cycles
	RET
	
delay_start:		;30ms is around 20x1.53ms
	MOV R0, 0x14	;20
	CALL delay_long
	DJNZ R0, $
	RET

	