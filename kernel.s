.global _start

.include "graphics.s"

.section .text

_start:
	mov        r0, #16
	mov        r1, #16
	bl         graphics_initialize
