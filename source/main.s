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
	mov r0, #0
	mov r1, #0
	bl graphics_draw_square
	
	mov r0, #1
	mov r1, #0
	bl graphics_draw_square
	
	mov r0, #15
	mov r1, #15
	bl graphics_draw_square
	
	b render
