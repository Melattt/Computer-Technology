;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-09-28
; Author:
; Philomina Ejegi Ede
; Melat Haile
;
; Lab number:1 Task1
; Title: Assembly language program to light LED 2.
;
; Hardware: STK600, CPU ATmega2560
;
; Function:A program in Assembly language to light LED 2. 
;
; Input ports: N/A
;
; Output ports: LEDs are connected to PORTB on the board.
;
; Subroutines: N/A
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16, 0xFF     ;Set data direction registers.
out DDRB , r16    ;Set B port as output ports

; Turn on LED2 on PORTB
ldi r16, 0xFB
out PORTB, r16


