;Load P to memeory
	MOV 30H, #'P'

; DEFINE
	LCD_RS EQU P3.0
	LCD_E EQU P3.1

; FUNCTION SET
	CLR LCD_RS	
	CLR P1.7		
	CLR P1.6		
	SETB P1.5		
	CLR P1.4		
	
	SETB LCD_E		
	CLR LCD_E		
	
	CALL onlydelay		
	
	SETB LCD_E		;according to manual we have to send it twice
	CLR LCD_E		
	
	SETB P1.7
	
	SETB LCD_E		
	CLR LCD_E		
	
	CALL onlydelay	


; ENTRY MODE SET

	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		
	;increment with no shift

	SETB LCD_E		
	CLR LCD_E		

	SETB P1.6		
	SETB P1.5		

	SETB LCD_E		
	CLR LCD_E		

	CALL onlydelay		


; DISPLAY on/off CONTROL
; display on, cursor on, blinking on
	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		

	SETB LCD_E		
	CLR LCD_E		

	SETB P1.7		
	SETB P1.6		
	SETB P1.5		
	SETB P1.4		

	SETB LCD_E		
	CLR LCD_E		

	CALL onlydelay		

;SEND DATA
send_data:
	SETB LCD_RS	
	MOV R1, #30H	; data to be sent to LCD is stored in 8051 RAM, starting at location 30H
	MOV A, @R1		; move data to A
	CALL sendCharacter	; send data to the screen
	JMP infinite_loop	;do nothing, just display 

infinite_loop:
	JMP infinite_loop


sendCharacter:
	MOV C, ACC.7	
	MOV P1.7, C		
	MOV C, ACC.6	
	MOV P1.6, C		
	MOV C, ACC.5
	MOV P1.5, C		
	MOV C, ACC.4	
	MOV P1.4, C		

	SETB LCD_E		
	CLR LCD_E	

	MOV C, ACC.3	
	MOV P1.7, C		
	MOV C, ACC.2	
	MOV P1.6, C		
	MOV C, ACC.1	
	MOV P1.5, C		
	MOV C, ACC.0	
	MOV P1.4, C		

	SETB LCD_E	
	CLR LCD_E		

	CALL onlydelay		

onlydelay:			;39us should be around 36 cycles
	MOV R0, 0x14	;20 should be more than enough
	DJNZ R0, $
	RET
