
; Written by Nicholas Tate      20/11/2019
; BREAK ENABLE is delayed for 3 seconds after power up then a single pulse is generated for every press of the INT KEY.

	list		p=12f675
	#include	<p12f675.inc>

	; set configuration word.
	__CONFIG	_CPD_OFF & _CP_OFF & _BODEN_OFF & _MCLRE_OFF & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT

	errorlevel -302						; Suppress message 302 from list file.

	; global variable declarations.
delay	equ	0x20
delay1	equ	0x21
delay2	equ	0x22
temp	equ	0x23

		org	0x000
		goto	main

main
	; program's main entry point.

init
		bsf		STATUS,RP0				; Bank 1.	
		call	0x3FF					; Read factory oscillator calibration value.
		movwf 	OSCCAL					; Write to OSCCAL register.

										; init GPIO.
		bcf		STATUS,RP0				; Bank 0.
		clrf	GPIO					; clear GPIO output before setting TRIS register.
		movlw 	07h 					; Set GP<2:0> to 
		movwf 	CMCON 					; digital I/O.
		bsf		STATUS,RP0				; Bank 1.
		clrf 	ANSEL 					; Digital I/O.

		bsf		STATUS,RP0				; Bank 1.
		movlw	B'11001100'
		movwf	TRISIO					; configure I/O.
start
		bcf	STATUS,RP0					; Bank 0
		movlw	0xEF					; Set /BREAK_ENABLE pin low. Set INT pin high.
		movwf	GPIO				
		call	long_delay
		call	long_delay		

		movlw	0xFF					; /BREAK_ENABLE pin stays high. Set INT pin high.
		movwf	GPIO
wait_for_key_down
		btfsc	GPIO,2					; Read INT key.
		goto	wait_for_key_down
		movlw	0xDF					; Set INT pin low. BREAK_ENABLE stays high.
		movwf	GPIO
		call	micro_delay				; Delay duration of INT pulse.
		movlw	0xFF					; Set INT pin high. BREAK_ENABLE stays high.
		movwf	GPIO
key_still_down
		btfss	GPIO,2					; Read INT key.
		goto	key_still_down
		goto	wait_for_key_down

long_delay
		movlw	0x08
		movwf	delay2
d_loop2
		call	ms_delay
		decfsz	delay2,F
		goto	d_loop2
		return

ms_delay
		movlw	0xFF
		movwf	delay
		movlw	0xFF
		movwf	delay1
d_loop	decfsz	delay, F
		goto	d_loop
		decfsz	delay1, F
		goto	d_loop
		return

micro_delay
		movlw	0xFF
		movwf	delay
d_loop3	nop
		decfsz	delay, F
		goto	d_loop3
		return

	end