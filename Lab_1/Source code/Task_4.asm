;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	1DT301, Computer Technology 1
;	Date: 2021-09-28
;	Authors:
;	Philomina Ejegi Ede
;   Melat Haile
;
;	Lab number 2
;	Title:	Task 4
;
;	Hardware: STK600, CPU ATmega 2560
;
;	Function: Running task 3 in simulator
;
;	Input ports: PORTD is used for the switches
;
;	Output ports: PORTB is used for LEDS
;
;	Subroutines: None
;	Included files: m2560def.inc
;
;	Other information: None
;
;	Changes in program:
;	
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
ldi r16, 0xFF			;Set r16 for Port B
out DDRB, r16			;Set port B as output

ldi r16, 0x00			;Set r16 for Port D
out DDRD, r16			;Set Port D as output

ldi r16, 0xFF			;Turn off all LEDs
out portB, r16

ldi r18, 0b11011111		;Binary code for Switch 5
ldi r19, 0b11111110		;Binary code to light up LED 0
my_loop:
	in r17, PIND		
	cp r17, r18			;Compares info with the desired switch
	breq light			;If r17=r18, light on
rjmp my_loop
light: out portB,r19	;Turns LED 0 on




