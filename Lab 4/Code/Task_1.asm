;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-21 
; Author:
;	Melat Haile
;	Philomina Ejegi Ede
;
; Lab number: 4
; Title: Task 1
;
; Hardware: STK600, CPU ATmega2560
;
; Function: A program in Assembly that creates a square wave. One LED should be connected and switch 
;			with the frequency 1 Hz. Duty cycle 50%. (On: 0.5 sec, Off: 0.5 sec.) Use the timer function to 
;			create an interrupt with 2 Hz, which change between On and Off in the interrupt subroutine. 
;
; Input ports:
;
; Output ports: PORTB
;
; Subroutines: reset, loop, again, led, timer0_int
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.org 0x00
rjmp reset

.org OVF0addr
rjmp timer0_int

.org 0x72
reset:

; Initialize
ldi r16, LOW(RAMEND)	
out SPL, r16
ldi r16, HIGH(RAMEND)
out SPH, r16

ldi r16, 0x01			
out DDRB, r16

ldi r16, 0x05		
out TCCR0B, r16		

ldi r16, (1<<TOIE0)	
sts TIMSK0, r16		

ldi r16, 5				
out TCNT0, r16			

sei
clr r17			

loop:
	out PORTB, r17
	rjmp loop

timer0_int:
	in r16, SREG	
	push r16

	;Set start value for timer so next interrupt occurs after 250 ms
	ldi r16, 5
	out TCNT0, r16
	inc r18
	cpi r18, 2 			
	breq led				

	rjmp again

	led:
		com r17 		
		clr r18			

	again:
		pop r16			
		out SREG, r16
		reti