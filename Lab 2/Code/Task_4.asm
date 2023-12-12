;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2021-10-12
;   Author: 
;	Philomina Ejegi Ede
;	Melat Haile
;
;   Lab number:   2
;   Title:        Task 4
;
;   Hardware:   STK600, CPU ATmega2560
;
;   Function:   Modify the program in task 5 in Lab 1 to a general delay routine that can be called from 
;				other programs. It should be named wait_milliseconds. The number of milliseconds should
;				be transferred to register pair R24, R25.
;
;   Input ports:
;
;   Output ports:  PORTB
;
;   Subroutines:   delay, wait_miliseconds
;
;   Included files: m2560def.inc
;
;   Other information:  
;
;   Changes in program:  (Description and date)
;				
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.EQU Seconds = 500	;ms 

; Initialize Stack
ldi r18, HIGH (RAMEND)
out SPH, r18
ldi r18, LOW (RAMEND)
out SPL, r18

; Set DDRB as output
ldi r17, 0b1111_1111
out DDRB, r17

ldi r16, 0b1111_1111			

main:
	ring:
		ldi r24, LOW(Seconds)		; value for the register pair
		ldi r25, HIGH(Seconds) 
		cpi r16, 0b1111_1111   
		breq again

		out PORTB, r16

		com r16
		lsl r16				; shift the bits to the left
		com r16

		rcall wait_milliseconds	; call the subroutine with r25:24	
    rjmp ring

	again:
	ldi r16, 0b1111_1110	; this is used when the counter has reached the end

rjmp main

wait_milliseconds:


delay:						

    ldi  r18, 2
    ldi  r19, 75
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1


	sbiw r25:r24,1		; subtract 1 from r25:24 and if not equal branch to delay
	brne delay

RET