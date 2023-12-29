#include <xc.inc>

global  update, experiment_init, experiment_start_timer_0_low, experiment_start_timer_0_high, experiment_start_timer_0_overflow, experiment_end_timer_0_low, experiment_end_timer_0_high, experiment_end_timer_0_overflow,  experiment_reaction_low, experiment_reaction_high, experiment_reaction_overflow, experiment_flags, experiment_random_countdown, UART_Transmit_Byte
extrn	touchscreen_read_x, touchscreen_read_y, touchscreen_flags, display_write_rect, glcd_rect_tile_x, glcd_rect_tile_y, glcd_rect_tile_x_end, glcd_rect_tile_y_end, glcd_tile_data_line, timer_0_overflow_counter, timer_delay_ms
psect	udata_acs   ; reserve data space in access ram
dud:		    ds 1;
experiment_flags:   ds 1 
; 00000CBA 
; A=0 if box not on screen, A=1 if box on screen, 
; B=1 experiment has not started, B=0 experiment has started
; C=1 Random timer interrupt, C=0 random timer interrupt.
experiment_start_timer_0_low:		ds 1 
experiment_start_timer_0_high:		ds 1  
experiment_start_timer_0_overflow:	ds 1 
; Round Start time
experiment_end_timer_0_low:		ds 1  
experiment_end_timer_0_high:		ds 1  
experiment_end_timer_0_overflow:	ds 1  
; Round end time
experiment_reaction_low:		ds 1
experiment_reaction_high:		ds 1
experiment_reaction_overflow:		ds 1
; Reaction time
experiment_temp_low:			ds 1
experiment_temp_high:			ds 1
experiment_temp_overflow:		ds 1
; Temp variables
experiment_subtract_status:		ds 1
; Temp variable for subtraction
experiment_random_countdown:		ds 1
; Random time countdown

psect	experiment_code, class=CODE



experiment_init:
	; Set experiment not started, box not on screen, interrupt not triggered
	movlw	00000010B
	movwf	experiment_flags, A
	return
update:
	call	check_if_box_pressed
	goto	update
	return
	
start_round:
	
	; set the experiment to started
	bcf	experiment_flags, 1, A
	
	; Now say go!
	movlw	0xff
	movwf	glcd_tile_data_line
	call	paint_go
	movlw	0x00
	movwf	glcd_tile_data_line
	call	paint_go

	; Read from timer2 thats on a very high frequency to get a psuedorandom 8 bit number
	; This number can represent a number in units of the delay time.
	movff	TMR2, experiment_random_countdown, A
	; Set first bit to be on so it' at least two seconds
	bsf	experiment_random_countdown, 5, A
    random_timer_inner_loop:
	movlw	32
	call	timer_delay_ms
	decfsz	experiment_random_countdown, A
	bra	random_timer_inner_loop
	
	; Set the box drawn flag
	bsf	experiment_flags, 0,  A
	; start timer as close to creation of box as possible.
	call	start_timer
	    
	; draw the box on screen
	movlw	0xff
	movwf	glcd_tile_data_line, A
	call	paint_box
	
	; Wait till touchscreen is not touched
    touchscreen_wait_loop:
	call	touchscreen_read_x
	btfsc	touchscreen_flags, 0, A
	bra	touchscreen_wait_loop
	return
	
start_timer:
	; Copy current time into storage
	movff	TMR0L, experiment_start_timer_0_low, A
	movff	TMR0H, experiment_start_timer_0_high,A
	movff	timer_0_overflow_counter, experiment_start_timer_0_overflow, A
	return

check_if_box_pressed:
	call	touchscreen_read_x
	movf	experiment_flags, W, A
	; roll over to the right by 1 to match with X touch flag.
	rrncf	WREG, W, A
	andwf	touchscreen_flags, W, A
	; if we have a touch and experiment hasn't started, start a round.
	btfsc	WREG, 0, A
	call	start_round
	; if there is a box on screen and we have touched, then end the round and start a new one
	movf	experiment_flags, W, A
	andwf	touchscreen_flags, W, A
	btfsc	WREG, 0, A
	call	end_and_start_round
	return	
end_and_start_round:
	; set box on screen flag to zero
	; end timer as fast as possible so it's accurate
	call	end_timer
	bcf	experiment_flags, 0,  A
	movlw	0x00
	movwf	glcd_tile_data_line, A
	call	paint_box
	call	calculate_reaction_time
	call	start_round
	return
end_timer:
	movff	TMR0L, experiment_end_timer_0_low, A
	movff	TMR0H, experiment_end_timer_0_high, A
	movff	timer_0_overflow_counter, experiment_end_timer_0_overflow,A
	return


calculate_reaction_time:
	clrf	experiment_subtract_status, A
	; We should check to see if end time has overflowed really.
	; We can check and then swap end and start time if thats the case.
	
    perform_subtraction:
	; Assume end time is higher than start time.
	; Low bytes
	movf	experiment_start_timer_0_low, W, A
	subwf	experiment_end_timer_0_low, W, A
	movwf	experiment_reaction_low, A
	btfss   STATUS, 0, A    ; Check carry bit. If clear, there was a borrow, increment.
	incf	experiment_subtract_status, A  
	; High bytes
	movf	experiment_start_timer_0_high, W, A
	subwf	experiment_end_timer_0_high, W, A
	btfsc	experiment_subtract_status, 0, A ; if set, increment. carry occured.
	decf	WREG, A
	movwf	experiment_reaction_high, A
	btfss	STATUS, 0, A ; check carry bit. If clear, there was a borrow, increment.
	incf	experiment_subtract_status, A
	btfsc	STATUS, 0, A ; if there wasn't ensure we set status to zero.
	clrf	experiment_subtract_status, A
	; Overflow bytes
	movf	experiment_start_timer_0_overflow, W, A
	subwf	experiment_end_timer_0_overflow, W, A
	btfsc	experiment_subtract_status, 0, A ; if set, incremenet. carry occured.
	decf	WREG, A
	movwf	experiment_reaction_overflow, A
	
	; transmit result across UART 
	movf	experiment_reaction_overflow, W, A
	call	UART_Transmit_Byte
	movf	experiment_reaction_high, W, A
	call	UART_Transmit_Byte
	movf	experiment_reaction_low, W, A
	call	UART_Transmit_Byte
	
	nop
	
paint_box: ; make sure to set the dataline before calling
	movlw	3
	movwf	glcd_rect_tile_x, A
	movlw	13
	movwf	glcd_rect_tile_x_end, A    
	movlw	3
	movwf	glcd_rect_tile_y, A
	movlw	5
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	return
paint_go: ; make sure to set the dataline before calling
	
	   
	; left 
	movlw	1
	movwf	glcd_rect_tile_x, A
	movlw	2
	movwf	glcd_rect_tile_x_end, A    
	movlw	1
	movwf	glcd_rect_tile_y, A
	movlw	7
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	   
	; top 
	movlw	1
	movwf	glcd_rect_tile_x, A
	movlw	7
	movwf	glcd_rect_tile_x_end, A    
	movlw	1
	movwf	glcd_rect_tile_y, A
	movlw	2
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	;bottom
	movlw	1
	movwf	glcd_rect_tile_x, A
	movlw	5
	movwf	glcd_rect_tile_x_end, A    
	movlw	6
	movwf	glcd_rect_tile_y, A
	movlw	7
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	; mid right
	movlw	5
	movwf	glcd_rect_tile_x, A
	movlw	6
	movwf	glcd_rect_tile_x_end, A    
	movlw	4
	movwf	glcd_rect_tile_y, A
	movlw	6
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	; center 
	movlw	4
	movwf	glcd_rect_tile_x, A
	movlw	7
	movwf	glcd_rect_tile_x_end, A    
	movlw	4
	movwf	glcd_rect_tile_y, A
	movlw	5
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	; top
	movlw	9
	movwf	glcd_rect_tile_x, A
	movlw	15
	movwf	glcd_rect_tile_x_end, A    
	movlw	1
	movwf	glcd_rect_tile_y, A
	movlw	2
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	; right
	movlw	14
	movwf	glcd_rect_tile_x, A
	movlw	15
	movwf	glcd_rect_tile_x_end, A    
	movlw	1
	movwf	glcd_rect_tile_y, A
	movlw	7
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	; bottom
	movlw	9
	movwf	glcd_rect_tile_x, A
	movlw	15
	movwf	glcd_rect_tile_x_end, A    
	movlw	6
	movwf	glcd_rect_tile_y, A
	movlw	7
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	; left
	movlw	9
	movwf	glcd_rect_tile_x, A
	movlw	10
	movwf	glcd_rect_tile_x_end, A    
	movlw	1
	movwf	glcd_rect_tile_y, A
	movlw	7
	movwf	glcd_rect_tile_y_end, A  
	call	display_write_rect
	
	
	
	return
	