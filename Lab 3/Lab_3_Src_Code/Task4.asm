;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2021-10-17
; Author:
;	 Melat Haile
;	 Philomina Ejegi Ede
; Lab number: 3
; Title: Task 4
;
; Hardware: <STK600, CPU ATmega2560>
;
; Function: Add functions to the previous task for simulating stop lights when braking.
;			 Use a button for the braking.
;			1. Brake and no turning
;			   Turn ON all LEDs (0-7).
;			2. Brake and turn right
;			   LED 4 – 7 is ON, LED 0 – 3 is blinking as a Ring counter to the right..
;			3. Brake and turn left
;			   LED 0 – 3 is ON, LED 4 – 7 is blinking as a Ring counter to the left..
;
; Input ports: <PORTD>
;
; Output ports: <PORTB>
;
; Subroutines: start, main, leds, delay
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
.org 0x00				; setup interrupts
rjmp start
.org INT0addr
rjmp interrupt_0
.org INT2addr
rjmp interrupt_2
.org INT3addr
rjmp interrupt_3
.org 0x72
start:
ldi r16, 0b00001101		; enable 0, 2, 3
out EIMSK, r16
ldi r16, 0b00000000		
sts EICRA, r16
ldi r16 , 0x00			; PORTD set as input
out DDRD, r16
sei						; Enable interrupts
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
on:
ser r22				; Loads $FF
ser r23				
ser r24				
clr r25				; Clear
ldi r16,0xFF				
out DDRB, r16
ldi r16, 0b00111100		; Lit LED 0,1,6,7
out PORTB, r16
rjmp on
turnRight:
	clr r22
	ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
	out SPH,R20				; SPH = high part of RAMEND address
	ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
	out SPL,R20				; SPL = low part of RAMEND address
	ldi r16 , 0xFF
	out DDRB, r16
RingCounter:
start1:
	ldi r17, 0b00110111 ; LED7,6 and 3 lit
	out PORTB, r17
	rcall delay
		ldi r16,	 0b0000_1100
Loop:
	eor r17, r16				; exclusive or between r16 and r17
	out PORTB,r17
	lsr r16					; Shift the bits to the right
	cpi r17, 0b0011_1111	
	breq RingCounter		; Go to RingCounter if equal
	rcall delay
	rjmp Loop				; Jump to Loop
turnLeft:
	clr r23
	ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
	out SPH,R20				; SPH = high part of RAMEND address
	ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
	out SPL,R20				; SPL = low part of RAMEND address
	ldi r16 , 0xFF
	out DDRB, r16
RingCounter2:
start2:
	ldi r17, 0b1110_1100	; Lit LED4,1 and 0
	out PORTB, r17
	rcall delay
	ldi r16,	 0b0011_0000
Loop2:
	eor r17, r16				
	out PORTB,r17
	lsl r16					; Shift the bits to the left
	cpi r17, 0b1111_1100
	breq RingCounter2		; Go to RingCounter2 if equal
	rcall delay
	rjmp Loop2			
breakWhenOn:
clr r24					
ser r25						; set to xFF
  ldi r16,0xFF
  out DDRB, r16				
  out PORTB, r24			; All LEDS turn on
  rjmp breakWhenOn
turnLeftBreak:
clr r25					; Clear
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
ldi r16 , 0xFF
out DDRB, r16
RingWithBreak1:			; ring couter that starts at led 4 and goes left
start3:
	ldi r17, 0b1110_0000
	out PORTB, r17
	rcall delay
	ldi r16,	 0b0011_0000
Loop3:
	eor r17, r16			; exclusive or between r17 and  r16
	out PORTB,r17
	lsl r16				; shift bits to the left
	cpi r17, 0b1111_0000	
	breq RingWithBreak1
	rcall delay
	rjmp Loop3
TurnRightBreak:
	clr r25
	ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
	out SPH,R20				; SPH = high part of RAMEND address
	ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
	out SPL,R20				; SPL = low part of RAMEND address
	ldi r16 , 0xFF
	out DDRB, r16
RingWithBreak2:
start4:
	ldi r17, 0b0000_0111
	out PORTB, r17
	rcall delay
	ldi r16,	 0b0000_1100
Loop4:
	eor r17, r16			
	out PORTB,r17
	lsr r16
	cpi r17, 0b0000_1111
	breq RingWithBreak2
	rcall delay
	rjmp Loop4
interrupt_0:			; When SW0 is pressed
	sei
	cpi r25, 0xff
	breq TurnRightBreak
	cpi r22, 0xff
	breq TurnRightHelper
	brne idle
interrupt_2:			; When SW2 is pressed
	sei
	cpi r24 ,0xff
	breq breakWhenOn
	brne idle
interrupt_3:			; When SW3 is pressed
	sei
	cpi r25, 0xff
	breq turnLeftBreak
	cpi r23, 0xff
	breq TurnLeftHelper
	brne idle
TurnRightHelper:			
	rjmp turnRight
TurnLeftHelper:			
	rjmp turnLeft
idle:					
	rjmp on
delay:
ldi  r18, 5
ldi  r19, 15
ldi  r20, 242
	L1: dec  r20
	brne L1
	dec  r19
	brne L1
	dec  r18
	brne L1
ret