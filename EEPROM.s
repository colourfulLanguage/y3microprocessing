#include <xc.inc>
    
; global  timer_init, timer_delay_4us, timer_delay_ms, timer_0_interrupt, timer_0_overflow_counter
psect	udata_acs   ; reserve data space in access ram
eeprom_pointer:  ds 1
 
psect	timer_code, class=CODE

eeprom_init:
    return
    
write_eeprom:
    return


