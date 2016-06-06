.section .init

.global _start
_start:
    b       main

.section .text

main:
    bl      initialise_frame_buffer

	color .req r2
	ldr color, =0xffff    

    bl      gol_main

render:
    bl gol_game_tick
    b       render
