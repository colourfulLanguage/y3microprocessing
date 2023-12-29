#include <xc.inc>

global  timer_init, timer_delay_4us, timer_delay_ms, timer_0_interrupt, timer_0_overflow_counter, timer_delay_us
psect	udata_acs   ; reserve data space in access ram
glcd_data_bus:  ds 1
; 0000000X CMD X=0: DATA: X=1	
LCD_cnt_l:	ds 1	; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h:	ds 1	; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms:	ds 1	; reserve 1 byte for ms counter
glcd_temp_w:	ds 1	; store working register for a litte bit
glcd_temp_status:   ds 1 ; store status register
timer_0_overflow_counter:   ds 1
LCD_16_ms_counter:   ds 1 ; 
    
glcd_command_flags: ds 1 
psect	timer_code, class=CODE
 
timer_init:
	; Enable timer0 with 256 prescaler
	movlw	10000111B
	movwf	T0CON, A
	   
	; Enable timer2 with no pre or post scaling
	; Should overflow every 4uS
	movlw	00000100B
	movwf	T2CON, A
	; Enable timer0 interrupt
	; Am i doing the global bits correctly???
	movlw	10100000B
	movwf	INTCON, A
	  
	; Clear register
	movlw	0x00
	movwf	TMR0L, A
	movwf	TMR0H, A
	   
	; output on J for testing
	movwf	TRISJ, A
	movwf	LATJ,  A
	
	return	
	
timer_0_interrupt:
	
	btfss	INTCON,	2, A ; if TMR0IF is set, skip, else return (interrupt we don't care about)
	retfie	f
	bcf	INTCON,	2, A ; reset the bit
	
	; increment overflow counter
	incf	timer_0_overflow_counter, A
	movff	timer_0_overflow_counter, LATJ, A
	
	retfie	f
	
	
	
; ** a few delay routines below here as LCD timing can be quite critical ****    
timer_delay_ms:		    ; delay given in ms in W
	movwf	LCD_cnt_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	timer_delay_4us	
	decfsz	LCD_cnt_ms, A
	bra	lcdlp2
	return
timer_delay_4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l, A	; now need to multiply by 16
	swapf   LCD_cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l, W, A ; move low nibble to W
	movwf	LCD_cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	LCD_cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return

timer_delay_us:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    return

