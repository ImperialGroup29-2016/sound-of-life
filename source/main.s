.section .init

.global _start
_start:
    b       main

.section .text

main:
    bl      initialise_frame_buffer
    bl      setup_sound
    bl      read_init

	color .req r2
	ldr color, =0xffff    

    @bl      test_get_sound
    @bl      sound_test_fill
    bl      gol_main
    mov     r4,#0                  @ signal 04 starts as 0

render:
    bl      sound_of_life

    @ Pause between ticks if playing sounds
    ldr     r1, =sound_game_type
    ldr     r1, [r1]
    cmp     r1, #0 
    movne   r0, #0
    blne    play_sound

    stmfd   sp!,{r3}
    bl      read_check
    cmp     r7,#0
    beq     main_skip_interrupt
    bl      read_main
    mov     r4,#0x00020000         @ signal 04 was up
main_skip_interrupt:
    ldmfd   sp!,{r3}

    bl      gol_game_tick

    b       render

