;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-21 
; Author:
;	Melat Haile
;	Philomina Ejegi Ede
;
; Lab number: 4
; Title: Task 3
;
; Hardware: STK600, CPU ATmega2560
;
; Function: a program in Assembly that uses the serial communication port0 (RS232). Connect a 
;			computer to the serial port and use a terminal emulation program. (Ex. Hyper Terminal) The 
;			program should receive characters that are sent from the computer, and show the code on the LEDs.
;			For example, if you send character A, it has the hex code $65, the bit pattern is 0110 0101 and 
;			should be displayed with LEDs On for each ‘one’. Use polled UART, which means that the UART 
;			should be checked regularly by the program.
;
; Input ports: PORT0 (RS232) VGA
;
; Output ports: PORTB turns on/off the light (LEDs)
;
; Subroutines: Timer Interrupt Subroutine
; Included files: m2560def.inc
;
; Other information:
; The code for this exercice was taken from the lecture.
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

	ldi r16, (1<<RXEN1)	

GetChar:	
	lds r16, UCSR1A	
	sbrs r16,RXC1	
	rjmp GetChar	
	lds r18,UDR1	

Port_output:	
	com r18	
	out PORTB,r18	
	com r18	
	rjmp GetChar