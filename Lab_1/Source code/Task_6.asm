;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-09-28
; Author:
; Philomina Ejegi Ede
; Melat Haile
;
; Lab number: 1
; Title: Task 6
; Subroutine call.
; Hardware: STK600, CPU ATmega2560
;
; Function:A program that creates a Johnson Counter with a delay
; of 0.5 seconds.
; Input ports: None
; Output ports: The portB is used LEDs
;
; Subroutines: Timer
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
main:
	; Initialize SP, Stack Pointer
	ldi r21, HIGH(RAMEND)        ; R20 = high part of RAMEND address
	out SPH,R21                  ; SPH = high part of RAMEND address
	ldi R21, low(RAMEND)         ; R20 = low part of RAMEND address
	out SPL,R21                  ; SPL = low part of RAMEND address
	CBR r16, 0             ; Clear bit in register
	SBR r17, 255           ; 2^8 = 256
	OUT DDRB, r17
	ldi r16, 8
incloop:
	LSL r17					;Logical shift left
	OUT PORTB, r17
	call timer
	dec r16
    brne incloop			;Branch if not equal
	ldi r16, 8
	rjmp decloop
decloop:
	LSR r17					;Logical shift right
	SBR r17, 128			;(2^8)/2 = 128
	OUT PORTB, r17
	call timer
	dec r16
    brne decloop			;Branch if not equal
	ldi r16, 8
	rjmp incloop
timer:
; Generated by delay loop calculator at http://www.bretmulvey.com/avrdelay.html
	ldi  r18, 5
    ldi  r19, 20
    ldi  r20, 175
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
	ret
