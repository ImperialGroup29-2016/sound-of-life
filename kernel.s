.global _start

.include "graphics.s"

.section .text

_start:
  ldr r0, =#16
  ldr r1, =#16
  bl  graphics_initialize

  ldr r0, =#10
  ldr r1, =#10
  ldr r2, =0x0000
  bl  graphics_draw_pixel

Loop:
  b Loop
