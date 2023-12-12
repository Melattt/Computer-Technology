;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
;  Date: 2021-10-12
; Author:
;	Philomina Ejegi Ede
;	Melat Haile
;
; Lab number: 2
;
; Title: Task 2
;
; Hardware: STK600, CPU ATmega2560
;
; Function: An electronic dice. Think of the LEDs placed as in the picture below. The number 1 
;			to 6 should be generated randomly. You could use the fact that the time you press the
;			button varies in length.

; Input ports: PORTD checks if we pressed the switch 0 (SW0).
;
; Output ports: PORTB turns on/off the light (LEDs)
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

; Initialize SP, Stack Pointer
ldi r21, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,R21 ; SPH = high part of RAMEND address
ldi R21, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R21 ; SPL = low part of RAMEND address

; Initialize
ldi r16, 0xFF 
out DDRB, r16 

ldi r17, 0x00 
out DDRD, r17 


out PORTB, r16

ldi r18, 0b11111110 
;it will allow us to make sure that SW0 is pressed

ldi r20, 1 

ldi r16, 0b11111111 

loop :
	;We check if SW0 is pressed or not
	in r19,PIND 
	cp r19, r18 
	breq listening_loop

rjmp loop 


listening_loop :
	inc r20
	cpi r20, 7 
	breq reset 
	
	in r19, PIND 
	cp r16,r19 
	breq random
rjmp listening_loop 

reset :
	ldi r20, 1 
	rjmp loop

random :

	cpi r20, 1
	breq number_one
	cpi r20, 2
	breq number_two
	cpi r20, 3
	breq number_three
	cpi r20, 4
	breq number_four
	cpi r20, 5
	breq number_five
	cpi r20, 6
	breq number_six


number_one:
	ldi r22, 0b11111101 
	out PORTB, r22 
	rjmp loop 

number_two:
	ldi r22, 0b10111011
	out PORTB, r22
rjmp loop
number_three:
	ldi r22, 0b10101011
	out PORTB, r22
rjmp loop
number_four:
	ldi r22, 0b10011001
	out PORTB, r22
rjmp loop
number_five:
	ldi r22, 0b00100101
	out PORTB, r22
rjmp loop
number_six:
	ldi r22, 0b00010001
	out PORTB, r22
rjmp loop