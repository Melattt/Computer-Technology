;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-27
; Author:
;	Philomina Ejegi Ede
;	Melat Haile
; Lab number: 5
; Title: Task 3
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Program that receives a character on the serial port and displays
; each character on the display JHD202
;
; Input ports: PORT0 (RS232) VGA
;
; Output ports: LCD JHD202 on PORTE and LEDs on PORTB
;
; Subroutines:
; Included files: m2560def.inc
;
; Other information: The program lab5_init_display.asm was used
; task 3 from lab4 was also used
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
.def Temp = r16
.def Data = r17
.def RS = r18
.equ BITMODE4 = 0b00000010 
.equ CLEAR = 0b00000001 
.equ DISPCTRL = 0b00001111 
.cseg
.org 0x0000 
	jmp reset
.org 0x32 
	jmp usart_isr
.org 0x0072
reset:
	ldi Temp, HIGH(RAMEND) 
	out SPH, Temp 
	ldi Temp, LOW(RAMEND) 
	out SPL, Temp 
	ser Temp 
	out DDRE, Temp 
	clr Temp 
	out PORTE, Temp
	rcall init_disp
	ldi R20, 12 
	sts UBRR0L, R20
	ldi R20,(1<<RXEN0)|(1<<RXCIE0)
	sts UCSR0B, R20 
	sei
loop: nop
	rjmp loop 

init_disp:
	rcall power_up_wait 
	ldi Data, BITMODE4 
	rcall write_nibble 
	rcall short_wait 
	ldi Data, DISPCTRL 
	rcall write_cmd 
	rcall short_wait 
clr_disp:
	ldi Data, CLEAR 
	rcall write_cmd 
	rcall long_wait 
	ret

write_char:
	ldi RS, 0b00100000 
	rjmp write
write_cmd:
	clr RS 
write:
	mov Temp, Data 
	andi Data, 0b11110000 
	swap Data 
	or Data, RS 
	rcall write_nibble 
	mov Data, Temp 
	andi Data, 0b00001111 
	or Data, RS 
write_nibble:
	rcall switch_output 
	nop 
	sbi PORTE, 5 
	nop
	nop 
	cbi PORTE, 5 
	nop
	nop 
	ret

short_wait:
	clr zh 
	ldi zl, 30
	rjmp wait_loop
long_wait:
	ldi zh, HIGH(1000) 
	ldi zl, LOW(1000)
	rjmp wait_loop
power_up_wait:
	ldi zh, HIGH(9000) 
	ldi zl, LOW(9000)
wait_loop:
	sbiw z, 1 
	brne wait_loop 
	ret

switch_output:
	push Temp
	clr Temp
	sbrc Data, 0 
	ori Temp, 0b00000100 
	sbrc Data, 1 
	ori Temp, 0b00001000 
	sbrc Data, 2 
	ori Temp, 0b00000001 
	sbrc Data, 3 
	ori Temp, 0b00000010 
	sbrc Data, 4 
	ori Temp, 0b00100000 
	sbrc Data, 5 
	ori Temp, 0b10000000 
	out PORTE, Temp
	pop Temp
	ret
usart_isr:
	lds R20, UCSR0A
	lds Data, UDR0
	rcall write_char
	reti