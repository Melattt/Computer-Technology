;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-21 
; Author:
;	Melat Haile
;	Philomina Ejegi Ede
;
; Lab number: 4
; Title: Task 4
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Modify the program in task 3 to obtain an echo, which means that the received character should also
;			be sent back to the terminal. This could be used as a confirmation in the terminal, to ensure that the 
;			character has been transferred correctly. 
;
; Input ports: PORT0 (RS232) VGA
;
; Output ports: PORTB turns on/off the light (LEDs)
;
; Subroutines: Timer Interrupt Subroutine
; Included files: m2560def.inc
;
; Other information:
;The code for this exercice was taken from the lecture.
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.org 0x00
rjmp start

.org 0x72


start:
	ldi r16,0xFF	
	out DDRB, r16

	out PORTB,r16	

	ldi r16, 12		
	sts UBRR1L , r16	
	ldi r16, (1<<RXEN1 | 1<<TXEN1)
	sts UCSR1B, r16

GetChar:	
	lds r16, UCSR1A	
	sbrs r16,RXC1	
	rjmp GetChar	
	lds r18,UDR1	

Port_output:	
	com r18
	out PORTB,r18	
	com r18

PutChar:	
	lds r16, UCSR1A	
	sbrs r16, UDRE1	
	rjmp PutChar	
	sts UDR1,r18	
	rjmp GetChar	