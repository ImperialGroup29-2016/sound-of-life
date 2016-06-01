.global _start

.section .text

_start:
	mov        r0, #640
	mov        r1, #640
	bl         graphics_initialize
	
        mov       r0, #100
        mov       r1, #100
        mov       r2, #0x10000
        sub       r2,r2,#1
        bl        graphics_draw_pixel

loop:
	b         loop
