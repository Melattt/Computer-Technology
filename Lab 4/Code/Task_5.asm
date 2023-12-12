;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-21 
; Author:
;	Melat Haile
;	Philomina Ejegi Ede
;
; Lab number: 4
; Title: Task 5
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Do task 3 and 4, but use Interrupt instead of polled UART. 
;			(USART, Rx Complete, USART Data Register Empty and USART, Tx Complete)
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

.org URXC1addr	
rjmp GetChar

.org 0x72


start:
	ldi r16,LOW(RAMEND)
	out SPL,r16
	ldi r16,HIGH(RAMEND)
	out SPH,r16

	ldi r16,0xFF	
	out DDRB, r16
	out PORTB,r16	



	ldi r16, 12		
	sts UBRR1L , r16	

	ldi r16, 0b10011000
	sts UCSR1B, r16

	sei	

main_program:
nop		
rjmp main_program

GetChar:	
	lds r16, UCSR1A	
	lds r18,UDR1	

  Port_output:	
  	com r18
  	out PORTB,r18	
  	com r18

  PutChar:
  	lds r16, UCSR1A	
  	sts UDR1,r18	

RETI	