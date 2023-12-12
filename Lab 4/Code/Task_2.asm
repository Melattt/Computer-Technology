;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-21 
; Author:
;	Melat Haile
;	Philomina Ejegi Ede
;
; Lab number: 4
; Title: Task 2
;
; Hardware: STK600, CPU ATmega2560
;
; Function:Modify the program in Task 1 to obtain Pulse Width Modulation (PWM). The frequency should be 
;		fixed, but the duty cycle should be possible to change. Use two push buttons to change the duty 
;		cycle up and down. Use interrupt for each push button. The duty cycle should be possible to change 
;		from 0 % up to 100 % in steps of 5 %. Connect the output to an oscilloscope, to visualize the 
;		change in duty cycle.
;
; Input ports:
;
; Output ports: PORTB
;
; Subroutines: reset, loop, again, increase, decrease, timer_int
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"


.org 0x00
rjmp start

.org INT1addr
rjmp increase

.org INT2addr
rjmp decrease

.org OVF0addr
jmp timer_int

.org 0x72
start:
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	ldi r16, LOW(RAMEND)
	out SPL, r16

	ldi r16, 0x01			
	out DDRB, r16

	ldi r22, 0x01
	out PORTB, r22		

	ldi r16, 0x01			
	out TCCR0B, r16		

	ldi r16, (1<<TOIE0)	
	sts TIMSK0, r16		

	ldi r16, 205			
	out TCNT0, r16			

	ldi r16, 0b0000_0110	
	out EIMSK, r16

	ldi r16, 0b0011_1100	
	sts EICRA, r16
	sei						

	clr r18
	ldi r17,10

loop:
	rjmp loop

increase:
	cpi r17,20		
	breq retiInc
	inc r17
	retiInc:
	reti

decrease:					
	cpi r17,0
	breq retiDec
	dec r17
	retiDec:
	reti

timer_int:
	push r16		
	in r16, SREG
	push r16

	ldi r16, 205
	out TCNT0, r16

	inc r18

	cp r17, r18	
	brge turn_off
	clr r16
	out PORTB, r16
	rjmp end

	turn_off:
	ser r16			
	out PORTB, r16

	end:				
	cpi r18,20
	brne again
	clr r18

	again:
	pop r16	
	out SREG, r16
	pop r16		


reti