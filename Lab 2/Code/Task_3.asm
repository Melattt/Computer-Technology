;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;    Date: 2021-10-12
;
; Author:
;	Philomina Ejegi Ede
;	Melat Haile
;
;   Lab number:  2
;   Title:       Task 3
;   
;   Hardware:   STK600, CPU ATmega2560
;
;   Function:	A program that is able to count the number of changes on a switch. As a change we count 
;				when the switch SW0 goes from 0 to 1 or from 1 to 0, we therefore expect positive and negative 
;				edges. We calculate the changes in a byte variable and display its value on PORTB.
;
;   Input ports:	PORTD
;
;   Output ports:   PORTB
;
;   Subroutines:    Activated, main
;
;   Included files:   m2560def.inc
;
;   Other information:  Ring counter with a delay of 500ms
;
;   Changes in program:  (Description and date)
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"

; Initialize
ldi r20, 0b0000_0000 
out DDRA, r20 
ldi r20, 0b1111_1111  
out DDRB, r20
ldi r25, 0b0000_0000 

;Move to main subroutine check switch
main:
	cpi r24, 0b1111_1110 
	breq activated 
rjmp main 

activated:
	inc r25
	com r25 
	out PORTB, r25 
	com r25 

loop:  
	in r24, PINA 
	cpi r24, 0b1111_1111  
	brne loop 
	
	inc r25
	com r25  
	out PORTB, r25 
	com r25
rjmp main 