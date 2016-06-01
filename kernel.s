.global _start

.include "graphics.s"

.section .text

_start:
	mov        r0, #16
	mov        r1, #16
	bl         graphics_initialize
	
success:
	b success
	
fail:
  ldr r0, =0x20200004
  ldr r1, =0x00040000
  str r1, [r0]

  ldr r6, =0x20200028
  ldr r7, =0x2020001C
  ldr r10, =0x00010000

  mov r2, #100
mainloop:
  sub r2, r2, #1
  cmp r2, #0
  bgt countonloop

  andeq r0, r0, r0
  b fail

countonloop:
  ldr r3, =10000000
  b countonstart

countonstart:
  sub r3, r3, #1
  cmp r3, #0
  beq turn_on
  b countonstart

countoffloop:
  ldr r4, =10000000
  b countoffstart

countoffstart:
  sub r4, r4, #1
  cmp r4, #0
  beq turn_off
  b countoffstart

turn_on:
  str r10, [r7]
  b countoffloop

turn_off:
  str r10, [r6]
  b mainloop
