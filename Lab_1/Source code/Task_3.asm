;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-09-28
; Author:
; Philomina Ejegi Ede
; Melat Haile
;
; Lab number: 1
; Title: Task 3
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Program to only light-up the LED 0 when switch 5
; is pressed. Nothing will happen, if any other switch is pressed.
; Input ports: PortD will be used as an input port.
;
; Output ports: PortB is used as an output port
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;
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