;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-27
; Author: Philomina Ejegi Ede
;		  Melat Haile
;
; Lab number: 5
; Title: Display JHD202
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Program that takes 4 lines of text. Each textline should be
; displayed during 5 seconds, after that the text on line 1 should be moved to
; line 2 and so on. The text is entered from the terminal program PUTTY via serial port
;
; Input ports: PORT0 (RS232) VGA
;
; Output ports: LCD JHD202 on PORTE.
;
; Subroutines:
; Included files: m2560def.inc
;
; Other information: The program lab5_init_display.asm was used
; task 3 from lab4 was also used and task 3 from lab5
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
	ldi YH, HIGH(SRAM_START) 
	ldi YL, LOW(SRAM_START)
	ldi R20, 12 
	sts UBRR0L, R20
	ldi R20,(1<<RXEN0)|(1<<RXCIE0)
	sts UCSR0B, R20 
	sei
loop:
	rcall delay_5sec
	rcall clr_disp
	rcall draw_line
	ldi Data, 0x80
	rcall write_cmd 
rjmp loop 
draw_line:
	clr R20 
	ldi Data, 0xC0
	rcall write_cmd 
	ldi YH, HIGH(SRAM_START) 
	ldi YL, LOW(SRAM_START)
	draw_line_loop:
	cp R20, R19
	breq return_from_draw_line
	ld Data, Y+
	inc R20
	rcall write_char
	rjmp draw_line_loop
	return_from_draw_line:
		ldi YH, HIGH(SRAM_START) 
		ldi YL, LOW(SRAM_START)
		clr R19
		ret
usart_isr:
	lds Data, UDR0
	st Y+, Data
	rcall write_char
	inc R19
	reti
delay_5sec:
	ldi R22, 26
	ldi R23, 94
	ldi R24, 111
L1:
	dec R24
	brne L1
	dec R23
	brne L1
	dec R22
	brne L1
	ret

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