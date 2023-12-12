;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-14
; Author:
; Melat Haile
; Philomina Ejegi Ede
;
; Lab number: 3
; Title: Task 3
;
; Hardware: STK600, <CPU ATmega2560>
;
; Function: A program that simulates the rear lights on a car by using 8 LEDs.
;			1. Normal light
;				LED 0,1,6 and 7 is ON.
;			2. Turn right (Press SW0)
;				LED 6 and 7 is ON, LEDs 0-3 blinking as a Ring counter to the right.
;			3. Turn left (Press SW3)
;				LED 0 and 1 is ON, LEDs 4-7 is blinking as a Ring counter to the left.
;
; Input ports: < PORTD >
;
; Output ports: < PORTB >
;
; Subroutines: start, main
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.org 0x00		; constant to "store/load" to EIMSK address /set interrupt_0
rjmp start
.org INT0addr
rjmp interrupt_0
.org INT3addr
rjmp interrupt_3
.org 0x72		; set interrupt_3
start:
	ldi r16, 0b1111_1111		; Load value 0b1111_1111 to r16
	out DDRB, r16				; Output value of r16 to PORTB
	ldi r23, 0b0000_0000		
	ldi r24, 0b0000_0000
	ldi R20, HIGH (RAMEND)
	out SPH, R20
	ldi R20, low (RAMEND)		;Initialize Stack Pointer
	out SPL, R20
	ldi r16, 0b0000_1001
	out EIMSK, r16
	ldi r16, 0b1000_0010		
	sts EICRA, r16				
	sei							;Enables interrupt
Main:
	ldi r22, 0b0011_1100		; Load value to r22
	out PORTB, r22				; Light r21 for "STATE 1"
CheckMain:					
	cpi r23, 0b1111_1111		; If 0b1111_1111 is loaded
	breq Right					; Go to Right
	cpi r24, 0b1111_1111		; If 0b1111_1111 is loaded
	breq Left				
	rjmp CheckMain				
interrupt_0:				
	com r23					; Complement
	clr r24					; Clear r24
	reti					
interrupt_3:				
	com r24				
	clr r23				
	reti
Right:
	ldi r22, 0b1100_0000	; Load 0b0000_0011 to r22
	loadCounter:
		ldi r17, 0b0000_1000
	loopRight:
		cpi r23, 0b0000_0000     ; If 1 is loaded is loaded
		breq Main				 ; Branch to main
		cpi r24, 0b1111_1111
		breq Left
		mov r21, r22             ; Copy the value of r22 to to r21
		add r21, r17             ; Add the values
		com r21					 ; Complement value of r21
		out PORTB, r21
		rcall delay				 ; Delay
		lsr r17
		cpi r17, 0b0000_0000	 ; Shift all bits to the right
		breq loadCounter
		rjmp loopRight
Left:
	ldi r22, 0b0000_0011		;Load value "0b0000_0011" to r22			
	loadCounterL:
		ldi r17, 0b0001_0000
	loopLeft:
		cpi r24, 0x00		
		breq Main				
		cpi r23, 0xFF		
		breq Right			
		mov r21, r22		
		add r21, r17			
		com r21				
		
		out PORTB, r21			
		rcall delay				
		lsl r17					
		cpi r17, 0b0000_0000	
		breq loadCounterL		;Branch to "loadCounter"
		rjmp loopLeft
delay:
	ldi r18, 3
	ldi r19, 138
	ldi r20, 86
L1: dec r20
	brne L1
	dec r19
	brne L1
	dec r18
	brne L1
	rjmp PC+1
ret