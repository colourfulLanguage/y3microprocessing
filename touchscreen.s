#include <xc.inc>

global  touchscreen_init, touchscreen_read_x, touchscreen_read_y, touchscreen_flags, touchscreen_x_high, touchscreen_temp_flags
psect	udata_acs   ; reserve data space in access ram
; y position of most recent touchscreen press
touchscreen_y_low:  ds 1 
touchscreen_y_high: ds 1
; x position of most recent touchscreen press
touchscreen_x_low:  ds 1
touchscreen_x_high: ds 1
; 000000YX , Y/X=1 if touched else Y/X=0
touchscreen_flags: ds 1 
; temp flags for touch detection calculations
touchscreen_temp_flags: ds 1
	
psect	touchscreen_code, class=CODE
   
touchscreen_init:
	
	; Init touchscreen input/output ports...
	bsf	TRISF,	PORTF_RF2_POSN, A
	bsf	TRISF,	PORTF_RF5_POSN, A
	
	bcf	TRISE,	PORTE_RE4_POSN, A
	bcf	TRISE,	PORTE_RE5_POSN, A 
	
	bcf	TRISH,	PORTH_RH7_POSN, A 
	
	; Connect AN7 TO ADC
	movlw   00011101B	   
	movwf   ADCON0, A
	    
	; Configure V_ref
	movlw   00110000B	   
	movwf   ADCON1, A
	    
	; Configure AC Clock and Right justified output
	movlw   101110110B	   
	movwf   ADCON2, A    
	
	; set initial flags to zero.
	movlw	0x00
	movwf	touchscreen_flags, A
	movwf	touchscreen_temp_flags, A
	
	return
	
touchscreen_read_y:
    
	; SFR memory
	; Connect AN7 to ADC and turn on.
	movlw   00011101B	   
	movwf   ADCON0, A
	; Drive voltage over X direction to read Y position
	bcf	LATE,	PORTE_RE4_POSN, A
	bsf	LATE,	PORTE_RE5_POSN, A
	; Activate ADC and poll
	bsf	GO
	call	poll_adc
	; Read ADC result into memory
	movf	ADRESL, W, A
	movwf	touchscreen_y_low, A
	movf	ADRESH,	W, A
	movwf	touchscreen_y_high, A
	   
	return 
touchscreen_read_x:
	; read X position and also determine if there has been a touch or not 
    
	; Connect AN10 to ADC and turn on.
	movlw   00101001B
	movwf   ADCON0, A
	; Drive voltage over X direction to read Y position
	bsf	LATE,	PORTE_RE4_POSN, A
	bcf	LATE,	PORTE_RE5_POSN, A
	; Activate ADC and poll
	bsf	GO
	call	poll_adc
	; Read ADC result into memory
	movf	ADRESL, W, A
	movwf	touchscreen_x_low, A
	movf	ADRESH,	W, A
	movwf	touchscreen_x_high, A
	    
	; Check if the value is more than 10 (result negative)
	
	movlw	10
	subwf	touchscreen_x_high, W, A
	btfsc	STATUS, 0, A
	bsf	touchscreen_temp_flags, 0, A
	; Check if value is less than 245 (result positive)
	movlw	245
	subwf	touchscreen_x_high, W, A
	btfss	STATUS, 0, A
	bsf	touchscreen_temp_flags, 1, A
	
	; If result is between between 245, 10, then touchscreen_temp_flags is 3, and there's been a touch
	movlw	3
	subwf	touchscreen_temp_flags, W, A
	btfsc	STATUS, 2 , A ; Is result zero? then touchscreen was touched.
	goto	touchscreen_x_is_touched
	
    touchscreen_x_not_touched:
	bcf	touchscreen_flags, 0, A ; set x bit to 0
	bcf	LATH,	7 , A
        goto	touchscreen_x_touch_continue
	
    touchscreen_x_is_touched:
	bsf	LATH,	7 , A
	bsf	touchscreen_flags, 0, A ; set x bit to 0

    touchscreen_x_touch_continue:
	movlw	0x00
	movwf	touchscreen_temp_flags, A
	return 
poll_adc:
	btfsc	GO
	bra	poll_adc
	return
	