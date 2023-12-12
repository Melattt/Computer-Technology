;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-14
; Author:
; Melat Haile
; Philomina Ejegi Ede	
;
; Lab number: 3
; Title: <Task 1>
;
; Hardware: <STK600, CPU ATmega2560>
;
; Function: A program that turns ON and OFF when we push SW0, using interrupts.
;
; Input ports: PORTD checks if we pressed the button
;
; Output ports: PORTB turns on/off the light (LEDs)
;
; Subroutines: <If applicable>
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.org 0x00				;Program starts execution from this location
rjmp start

.org INT0addr			;INT0
rjmp interrupt 

.org 0x72
start:
	; Initialize SP, Stack Pointer
	ldi r16, HIGH(RAMEND) ; R20 = high part of RAMEND address
	out SPH,r16 ; SPH = high part of RAMEND address
	ldi r16, low(RAMEND) ; R20 = low part of RAMEND address
	out SPL,r16 ; SPL = low part of RAMEND address



	;Main 
	
	ldi r16, 0b00000001
	out DDRB, r16		;DDRB set as output

	ldi r17, 0b00000001	;0b00000001 set to activate INT0
	out EIMSK, r17		;Toggle 
	

	ldi r17, 0b00000010 
	sts EICRA, r17 
	sei					;enable interrupts

main_program:
nop 
rjmp main_program		

interrupt:
	com r16				;reverse 
	out portB, r16		
reti					