.section .init

.global _start
_start:
    b       main

.section .text

main:
    bl      initialise_frame_buffer
    bl      setup_sound

	color .req r2
	ldr color, =0xffff    

    bl      test_get_sound
    bl      sound_test_board

render:
    bl      play_columns

    b       render

