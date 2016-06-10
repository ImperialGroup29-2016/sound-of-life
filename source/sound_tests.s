.global sound_test_board
.global sound_test_fill
.global test_get_sound

.section .text

@------------------------------------------------------------------------------
@ Function to set up the board without playing gol
@ to test sound functions
@
@ Sets up a diagonal board
@------------------------------------------------------------------------------
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

@------------------------------------------------------------------------------
@ Completely fills the board for testing purposes
@
@------------------------------------------------------------------------------
sound_test_fill:
  stmfd sp!, {r1-r6, lr}
  
  mov   r5, #16                   @ Matrix dimensions
  mov   r6, #16
  ldr   r7, =gol_matrix_address   @ GOL Matrix address

  row   .req r1
  col   .req r2
  mov   row, #0

1:
  mov   col, #0
  2:
    mov   r3, #0
    bl    gol_set_alive
    
    add   col, #1
    cmp   col, r5
    beq   3f
    b     2b
  3:
    add   row, #1
    cmp   row, r5
    blt   1b

  ldmfd sp!, {r1-r6, pc} 

@------------------------------------------------------------------------------
@ Tests the get_sound function to make sure that the right values are
@ returned from the sound matrix
@------------------------------------------------------------------------------
test_get_sound:
    stmfd sp!, {lr}    

    ldr r7, =sound_rows
    mov r1, #0
    mov r2, #0
    
    bl  get_sound
    
    cmp r7, #0
    bne flash

    cmp r1, #0
    bne flash

    cmp r2, #0
    bne flash

    ldr r7, =sound_rows
    mov r1, #5
    mov r2, #5
    
    bl  get_sound
    
    cmp r7, #5
    bne flash

    cmp r1, #5
    bne flash

    cmp r2, #5
    bne flash

    ldr r7, =sound_rows
    mov r1, #2
    mov r2, #2
    
    bl  get_sound
    
    cmp r7, #2
    bne flash

    cmp r1, #2
    bne flash

    cmp r2, #2
    bne flash

    ldr r7, =sound_rows
    mov r1, #15
    mov r2, #15
    
    bl  get_sound
    
    cmp r7, #15
    bne flash

    cmp r1, #15
    bne flash

    cmp r2, #15
    bne flash

    ldmfd sp!, {pc}
