#include <xc.inc>

extrn	experiment_init,touchscreen_init, timer_init, display_init,update,  display_write_rect, glcd_tile_data_line, glcd_rect_tile_x, glcd_rect_tile_y, glcd_rect_tile_x_end, glcd_rect_tile_y_end, touchscreen_flags, timer_0_interrupt, experiment_start_timer_0_low, experiment_start_timer_0_high, experiment_start_timer_0_overflow, experiment_end_timer_0_low, experiment_end_timer_0_high, experiment_end_timer_0_overflow, experiment_reaction_low, experiment_reaction_high, experiment_reaction_overflow, experiment_flags, touchscreen_x_high ,touchscreen_temp_flags, experiment_random_countdown, UART_init
	
psect	code, abs	
rst: 	org 0x0
 	goto	init

	; ******* Programme FLASH read Setup Code ***********************
isr:	org 0x08
	goto	timer_0_interrupt
	
init:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory

	; Initialise modules
	call	timer_init
	call	touchscreen_init
	call	display_init
	call	experiment_init
	call	UART_init
	
		
round_start:
	; Begin update loop
	call	update
