.global sound_test_board

.section .text

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Function to set up the board without playing gol
@ to test sound functions
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
sound_test_board:
  stmfd sp!,{r1-r3, lr}

  ldr r5,=16                     @ d1
  ldr r6,=16                     @ d2
  ldr r7,=gol_matrix_address     @ &a

  count .req r8
  max   .req r9
  mov max, #16
  mov count, #0

1:
  mov r1, count
  mov r2, count
  mov r3, #0
  bl gol_set_alive
  add count, #1
  cmp count, max
  bne 1b

  ldmfd sp!,{r1-r3, pc}                        @ return
