.section .init

.global _start
_start:
    b       main

.section .text

main:
    bl      initialise_frame_buffer

	color .req r2
	ldr color, =0xffff    

render:
    bl      gol_main

    b       render
