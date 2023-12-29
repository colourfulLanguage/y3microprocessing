#include <xc.inc>

global  display_init, display_write_rect, glcd_tile_data_line, glcd_tile_data_line, glcd_rect_tile_x, glcd_rect_tile_y, glcd_rect_tile_x_end, glcd_rect_tile_y_end, timer_0_overflow_counter
extrn	timer_delay_4us, timer_delay_ms, timer_delay_us
psect	udata_acs   ; reserve data space in access ram
glcd_data_bus:  ds 1	    ; data bus register for glcd
glcd_rect_tile_x:	ds 1  ; left side
glcd_rect_tile_y:	ds 1  ; top side
glcd_rect_tile_x_end:	ds 1  ; right side
glcd_rect_tile_y_end:	ds 1  ; bottom side 
glcd_line:		ds 1	; what line are we on
glcd_cursor:		ds 1	; where is the cursor? 
glcd_x_pos:		ds 1	; x pos
glcd_tile_line:		ds 1	; line within the tile
glcd_tile_data_line:	ds 1	; tile data line for what data to write to tile
    
psect	display_code, class=CODE
  
display_init:
	; Set PORT B, F as outputs
	movlw	0x00
	movwf	TRISB,	A
	movwf	TRISD,  A
	 
	; Clear LATB, LATD
	movlw	0x00
	movwf	LATB,  A
	movwf	LATD,  A
	
	; Set display into write mode 
	bcf	LATB,	PORTB_RB3_POSN,  A
	; Set reset pin high
	bsf	LATB,	PORTB_RB5_POSN,  A

	; Set page 0, turn on display
	call	display_set_page_0
	movlw	00111111B
	movwf	glcd_data_bus, A
	call	display_send_cmd
	
	; Set page 1, turn on display
	call	display_set_page_1
	movlw	00111111B
	movwf	glcd_data_bus, A
	call	display_send_cmd

	; Ensure GCLD starts up properly
	movlw	20
	call	timer_delay_ms
	
	; Set Z address to zero (Position viewing in internal RAM) on both pages
	call	display_set_page_0
	movlw	11000000B
	movwf	glcd_data_bus, A
	call	display_send_cmd
	
	call	display_set_page_1
	movlw	11000000B
	movwf	glcd_data_bus, A
	call	display_send_cmd
	   
	; clear the screen
	movlw	0
	movwf	glcd_rect_tile_y, A
	movlw	0
	movwf	glcd_rect_tile_x, A
	movlw	8
	movwf	glcd_rect_tile_y_end, A
	movlw	16
	movwf	glcd_rect_tile_x_end, A
	movlw	0xff
	movwf	glcd_tile_data_line, A
	call	display_write_rect
	movlw	0x00
	movwf	glcd_tile_data_line, A
	call	display_write_rect
	return


display_set_line:
	; set line position on glcd
	
	; The last 3 bits are the line number, first 5 the command
	movf	glcd_line, W, A
	; Set bit 7, 5, 4, 3
	iorlw	10111000B
	; Clear bit 6
	andlw	10111111B
	movwf	glcd_data_bus, A
	call	display_send_cmd
	return
	
display_set_cursor:
	; set cursor position on glcd
	
	; The last 6 bits are the cursor number, first 2 the command
	movf	glcd_cursor, W, A
	; Set bit 6
	iorlw	01000000B
	; Clear bit 7
	andlw	01111111B
	movwf	glcd_data_bus, A
	call	display_send_cmd
	return
	 
display_write_rect:
	; start on page 0, then move to page 1 if neccessary.
	call	display_set_page_0
	movf	glcd_rect_tile_x, W, A
	; initial x pos is 8* the left tile corner, due to tile width being 8
	addwf	WREG, A
	addwf	WREG, A
	addwf	WREG, A
	movwf	glcd_x_pos, A	
display_write_rect_columns:
	; move line back to the top
	; Reset the line at the top of the column
	movff	glcd_rect_tile_y, glcd_line, A
	; If the 6th bit is positive, then we're on the next page.
	btfsc	glcd_x_pos, 6, A
	call	display_set_page_1
	; Set cursor position by doing mod 64 of the x_pos
	movf	glcd_x_pos, W, A
	andlw	00111111B
	movwf	glcd_cursor, A
	; Write the tiles in this column. 
	; ABOVE IS BEFORE LOOP
	call	display_write_rect_tiles	
	; BELOW IS AFTER LOOP
	; Increment cursor position by 8
	movf	glcd_x_pos, W, A
	addlw	8
	movwf	glcd_x_pos, A
	; Loop back and write another column
	movf	glcd_x_pos, W, A
	; divide by 8 to compare to glcd rect_tile_x_end. right shift 3 times.
	rrncf	WREG, A 
	rrncf	WREG, A 
	rrncf	WREG, A 
	
	subwf	glcd_rect_tile_x_end, W, A
	btfss	STATUS, 2, A ; 0 bit of the status register
	; write another column
	goto	display_write_rect_columns
	; exit
	return
display_write_rect_tiles:
	
	; Set the cursor and line to the start of the tile and the current line.
	call	display_set_cursor
	call	display_set_line
	; Write a block of 8 pixels. TODO is to map this to a address with a font.
	movlw	8
	movwf	glcd_tile_line, A
    display_write_tile_line:
	; Write a line to the tile
	movff	glcd_tile_data_line, glcd_data_bus, A    
	call	display_send_data
	; If we write the entire tile, finish
	decfsz	glcd_tile_line, A
	goto	display_write_tile_line
	; Finished writin tile
	incf	glcd_line, A
	; Check to see if we have finished writing.
	movf	glcd_line, W, A
	subwf	glcd_rect_tile_y_end, W, A
	btfss	STATUS, 2, A ; 0 bit of the status register
	; if not zero write next tile
	goto	display_write_rect_tiles
	; else exit and write another column
	return

    
display_send_data:
	; send data to glcd
        call    busy_check
	movff   glcd_data_bus, LATD, A 
	bsf	LATB,	PORTB_RB2_POSN,  A
	call	display_pulse_E_pin
	return	
display_send_cmd:
	; send cmd to glcd
        call    busy_check
	movff   glcd_data_bus, LATD, A 
	bcf	LATB,	PORTB_RB2_POSN,  A
	call	display_pulse_E_pin
	return
display_set_page_0:
	; set page0
	bcf	LATB,	PORTB_RB0_POSN, A
	bsf	LATB,	PORTB_RB1_POSN, A
	return
display_set_page_1:
	; set page 1
	bsf	LATB,	PORTB_RB0_POSN, A
	bcf	LATB,	PORTB_RB1_POSN, A
	call	timer_delay_ms
	return
display_pulse_E_pin:
	; Pulse enable pin to push through a command or data to the glcd
	bsf	LATB,	PORTB_RB4_POSN, A
	call	timer_delay_us
	bcf	LATB,	PORTB_RB4_POSN, A
	return

busy_check:
	; Set dipslay into read mode and port D to input
	bsf	LATB,	PORTB_RB3_POSN,  A
	movlw	0xff
	movwf	TRISD,  A
	; Enable Send command
	bcf	LATB, 	PORTB_RB2_POSN,  A    
	; Pulse	E pin and read
busy_check_loop:
	call	display_pulse_E_pin
	; Read display data and look at B7 for the busy flag. Look back if its still busy. (High)
	btfsc	PORTD,	PORTD_RD7_POSN, A
	goto	busy_check_loop
	; Set display back into write mode and port D back to output
	bcf	LATB,	PORTB_RB3_POSN,  A
	movlw	0x00
	movwf	TRISD,  A
	return 
