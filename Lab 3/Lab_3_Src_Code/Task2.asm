;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-14
; Author:
; Melat Haile
; Philomina Ejegi Ede 
;
; Lab number: 3
; Title: <Task 2>
;
; Hardware: <STK600, CPU ATmega2560>
;
; Function: <A program that uses a switch to flash 8 LEDs either in the form of a 
; ring counter or a Johnson counter.It uses the switch SW0 connected to PORTD to 
; switch between the two counters. Each time the button is pressed, a shift between the two 
; counters takes place>
;
; Input ports: <PORTD>
;
; Output ports: <PORTB>
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information: <n/a>
;
; Changes in program: <Description and date>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.org 0x00 ;This is the location that the program will start executing from
rjmp start

.org INT0addr
rjmp interrupt

.org 0x72
start:
	; Initialize SP, Stack Pointer
	ldi r16, HIGH(RAMEND) ; R20 = high part of RAMEND address
	out SPH,r16 ; SPH = high part of RAMEND address
	ldi r16, low(RAMEND) ; R20 = low part of RAMEND address
	out SPL,r16 ; SPL = low part of RAMEND address



	; Main 
	ldi r16, 0xFF 
	out DDRB, r16		;DDRB set as output


	ldi r17, 0b00000001 ;INT0
	out EIMSK, r17		;Toggle 


	ldi r17, 0b00000010 ;Activate the interrupt
	sts EICRA, r17		

	sei					;Enable interrupts

ldi r25, 0b11111111 

ldi r16, 0b11111111		
ldi r22, 0b00000000 

main_program:
	cp r25, r16			;Compare r25 with r16
	breq ring_counter	;If equal go to ring_counter
rjmp main_program

;Normal ring_counter
ring_counter:
	ldi r18, 0b11111110

	cp r25, r22				;Compare r25 with r22
	breq johnson_counter	;if equal go to johnson_counter
	

ring_loop:
	out PORTB, r18		;PORTB turns light on
	call Delay
	com r18
	LSL r18
	com r18

	ldi r24,0xFF
	cp r24, r18
	breq ring_counter

	cp r25, r22			;Compare r25 with r22
	breq johnson_counter ;If equal, go to johnson_counter
	
rjmp ring_loop

johnson_counter :
	ldi r19, 0b11111110	;Sw0 turns light on

	cp r25, r16			;Compare r25 with r16
	breq ring_counter	;If equal go to ring_counter
	
	ldi r22, 0b00000000 ;load 0b0000 0000 to r22

johnson_loop:
	out PORTB, r19
	LSL r19
	call Delay
	cp r19, r22
	breq johnson

	cp r25, r16			;Compare r25 with r16
	breq ring_counter	;If equal it goes to ring_counter
	
	rjmp johnson_loop


johnson :
	out PORTB, r22
	ldi r22, 0b11111111
	call Delay
	ldi r19,0b10000000

	more_john :
		out PORTB, r19
		ASR r19
		call Delay
		cp r19, r22
		breq johnson_counter

		cp r25, r16
		breq ring_counter

	rjmp more_john

 interrupt:
	com r25			
reti

Delay :
; Generated by delay loop calculator at http://www.bretmulvey.com/avrdelay.html

	ldi  r21, 5
    ldi  r23, 20
    ldi  r24, 175
L1: dec  r24
    brne L1
    dec  r23
    brne L1
    dec  r21
    brne L1
	ret