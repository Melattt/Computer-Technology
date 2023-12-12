;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-09-28
; Author:
; Philomina Ejegi Ede
; Melat Haile
;
; Lab number: 1
; Title: Task 2
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Program to light up the LED correponding to the switch.
; (eg. Switch 5 should light up LED 5)
; Input ports: PortD is used as input to get the information from the
; switches
;
; Output ports: The portB is used as an output port to control the LEDs
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16, 0xFF		;Load 0b11111111 to r16
out DDRB, r16		;Set port B as output

ldi r16, 0x00		;Setting up the data direction for Port D
out DDRD, r16		;Set Port D as output

my_loop:			
	in r17, PIND	
	out portB, r17	;Light up the corresponding LED
rjmp my_loop