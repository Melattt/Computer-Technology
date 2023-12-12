/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2022-10-25
; Author:
;		Philomina Ejegi Ede
;		Melat Haile
;
; Lab number: 6
; Title: Task 1: Convert assembly to C
;		 Task 2: Implement a logging 
;		 Task 3: Implement a protocol
;
; Hardware: <E.g STK600, CPU ATmega2560>
;
; Function: This application receives a text using USART serial communication and
;			 displays it on an LCD screen. The text will be shifted to the second line after five seconds. 
;			 Five tasks can be carried out by the application by issuing commands via the terminal: 
;			 1: Show text on either the first line(0) or the second line(1) 
;			 2: Activate the logging message 
;			 3: Disable the logging message
;			 4: Send the temperature from the ADC that was read to the terminal. 
;			 5: Outputs the temperature on the LCD display after sending it to the controller.
;
; Input ports: -
;
; Output ports: LCD display connected to PORTA
;
; Subroutines: -
; Included files: m2560def.inc
;
; Other information: <If any>.
;
; Changes in program: <Description and date>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
#define F_CPU 16000000
#include <avr/interrupt.h>
#include <avr/cpufunc.h>
#include <util/delay.h>
#include <stdbool.h>
#include <stdio.h>
#include "ADC.h"
#define BUF_SIZE 100
#define FOSC (16000000)
#define BAUD 9600
#define ubrr (FOSC/16/BAUD-1)
volatile char str_buffer[BUF_SIZE];
int list_index = 0;
char recieved[16];
int starter = 1;
int logger = 0;
/*
	Read temp.
	Don't forget to call ADC_init() before calling this function.
*/
double lm35_read_temp()
{	
	return ADC_read_voltage() / 0.01;
}

void send_log_msg(char *str)
{
	while(*str != NULL)
	{
		UDR0 = *str;
		str ++;
	}
}
ISR(USART0_RX_vect)
{	
	
	while (! (UCSR0A & (1<<RXC1)))
	{	
	}
	int data =  UDR0;
	if (data =='\n')
	{
		list_index = 0;
	}else{
		Looper(data);
	}
	
}
void Looper(char data)
{
		recieved[list_index] = data; 
		list_index++;
}
	
void Write_cmd(char data) 
{
	PORTC = PORTC & ~ (1<<PC0);
	write(data);
	
}
void write_char(char data){
	PORTC = PORTC | (1<<PC0);
	write(data);
	
}
void write(char data)
{
	PORTC = PORTC & ~ (1<<PC1);
	PORTA = data;
	trigger_cmd();
}
void trigger_cmd()
{
	PORTC = PORTC | (1<<PC2);
	PORTC = PORTC & ~ (1<<PC2);
}
int main(void)
{	
	// Connect PORTF pin 0, i.e ADC0, to temp sensor.
	// See pinout on page 2 and MUX table on page 290. 
	ADC_init(0b00000);
		
	// Init USART here
		/* Set baud rate */
	UBRR0H = (ubrr>>8);
	UBRR0L = ubrr;
	/* Enable Rx complete interrupt, data register empty interrupt, receiver and transmitter */
	UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0);
	/* Set frame format: 8data, 1stop bit */
	UCSR0C = (0<<USBS0)|(1<<UCSZ01)|(1<<UCSZ00);
	
	// Note! There are C examples in the ATmega2560 manual!
	 
	DDRA = 0b11111111;
	DDRC = 0b111;
	Write_cmd(0b00001110);
	sei();
	char helloMessage[16] = "microchip is on!";
	int *x = NULL;
	x = &helloMessage;
	send_log_msg(x);
	UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0);
			
    /* Replace with your application code */
    while (1)
    {	
		
		int check_index = 0;
		for(int j = 0; j < 16; j++)
		{
			if(recieved[j] != NULL)
			{
				check_index++;
			}
		}
		
		// Task 1
		if(check_index == 16)
		{
			if (logger == 1)
			{
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0);
				send_log_msg(" Message started ");
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0);
			}
			Write_cmd(0b00000001);  
			for(int k = 0; k < 16; k++)
			{
				write_char(recieved[k]);
			}
			if (logger == 1)
			{
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0);
				send_log_msg(" Message done ");
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0);
			}
			check_index = 0;
			PORTC = PORTC & ~ (1<<PC0);
			PORTC = PORTC & ~ (1<<PC2);
			_delay_ms(5000);
			Write_cmd(0b00000001); 
			Write_cmd(0b10000000|0x40); 
			if (logger == 1)
			{
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0);
				send_log_msg(" Message started ");
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0);
			}
			
			for(int k = 0; k < 16; k++)
			{
				write_char(recieved[k]);
			}
			if (logger == 1)
			{
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0);
				send_log_msg(" Message done ");
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0);
			}
			
			for( int i = 0; i < 16; i++)
			{
				recieved[i] = NULL;
			}
			Write_cmd(0b00000010);  
			
		} 
		else if (check_index == 1 ){
			
			// Task 2
			if (recieved[0]==0b00110010)
			{
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); // enable transmitter
				char logon[16] = " logg msgs on ";
				int *y = NULL;
				y = &logon;
				send_log_msg(y);  // send logging message on to the terminal
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); // disable transmitter
				recieved[0] = NULL; // clear char list
				logger = 1;  // when logger = 1, the logging message is on
			}
			
			// 3
			if (recieved[0]==0b00110011)
			{
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); 
				char Logoff[16] = " logg msgs off ";
				int *z = NULL;
				z = &Logoff;
				send_log_msg(z); 
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); 
				recieved[0] = NULL; // clear char list
				logger = 0; 
			}
			
			// 4
			if (recieved[0]==0b00110100)
			{
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); 
				double t = lm35_read_temp();
				sprintf(str_buffer, "%f ", t);
				send_log_msg(str_buffer);  
				UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); 
				recieved[0] = NULL; // clear char list
			}
			
			// 5
			if (recieved[0]==0b00110101)
			{
				
				PORTC = PORTC & ~ (1<<PC0);
				PORTC = PORTC & ~ (1<<PC2);
				Write_cmd(0b00000001); 
				Write_cmd(0b00000010); 
				double t = lm35_read_temp();
				sprintf(str_buffer, "%f ", t);
			
				if (logger == 1)
				{
					UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); 
					send_log_msg(" Message started ");
					UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); 
				}
				
				for(int i = 0; i < 16; i++)
				{
					recieved[i] = str_buffer[i];
					write_char(recieved[i]);
				}
				
				if (logger == 1)
				{
					UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); 
					send_log_msg(" Message done ");
					UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); 
				}
				
				
				for( int i = 0; i < 16; i++)
				{
					recieved[i] = NULL;
				}
				Write_cmd(0b00000010);
				
			}
			
		}
		
		else if (check_index > 0 )
		{
			
			if (recieved[0]==0b00110001)  
			{
				if (recieved[1]==0b00110000) 
				{
					Write_cmd(0b00000001); 
					Write_cmd(0b00000010); 
					_delay_ms(1000);
					if (logger == 1)
					{
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); // enable transmitter
						send_log_msg(" Message started ");
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); // disable transmitter
					}
					for(int j = 2; j < 16; j++)
					{
						write_char(recieved[j]);
					}
					if (logger == 1)
					{
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); // enable transmitter
						send_log_msg(" Message done ");
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); // disable transmitter
					}
					
					
					for( int i = 0; i < 16; i++)
					{
						recieved[i] = NULL;
					}
				}else if (recieved[1]==0b00110001) 
				{
					Write_cmd(0b00000001); 
					_delay_ms(1000);
					Write_cmd(0b10000000|0x40); 
					if (logger == 1)
					{
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); 
						send_log_msg(" Message started ");
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); 
					}
					for(int k = 2; k < 16; k++)
					{
						write_char(recieved[k]);
					}
					if (logger == 1)
					{
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0); 
						send_log_msg(" Message done ");
						UCSR0B = (1<<RXCIE0)|(1<<UDRIE0)|(1<<RXEN0)|(0<<TXEN0); 
					}
					// clear char list
					for( int i = 0; i < 16; i++)
					{
						recieved[i] = NULL;
					}
					Write_cmd(0b00000010);  
				}
			}
		}
    }
}

