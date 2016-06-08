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
    @bl      sound_test_board
    bl      gol_main

render:
    bl      play_columns

    bl      read_check
    cmp     r7,#0
    beq     main_skip_interrupt
    bl      read_main
main_skip_interrupt:
    bl      gol_game_tick

    b       render

