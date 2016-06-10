.global sound_of_life
.global sound_game_type

@ Global for testing purposes
.global get_sound
.global sound_rows
.global play_diagonal

.ltorg
.section .data

.align 2
sound_game_type:
  .int 0


.align 4
sound_rows:
    .int  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .int  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    .int  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
    .int  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
    .int  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
    .int  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
    .int  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    .int  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .int  8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
    .int  9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
    .int  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
    .int  11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11
    .int  12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12
    .int  13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13
    .int  14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
    .int  15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15

.align 4
sound_columns:
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15



.section .text

@------------------------------------------------------------------------------
@ sound_of_life*
@
@ Effect:
@   plays the sound of life depending on the game mode
@ Arguments:
@   None
@ Returns:
@   None
@ Clobbers:
@   None
@------------------------------------------------------------------------------
sound_of_life:
  stmfd   sp!, {r0, lr}
  
  ldr     r0, =sound_game_type
  ldr     r0, [r0]

  cmp     r0, #1
  bleq    play_columns

  cmp     r0, #2
  bleq    play_rows

  ldmfd   sp!, {r0, pc}

@------------------------------------------------------------------------------
@ get_sound
@
@ Effect:
@  Returns the sound number at the given coordinates in a sound matrix
@ Arguments supplied:
@  r7 = start of sound matrix
@  r1 = y value
@  r2 = x value
@ Returns:
@  r7 = sound no to play
@ Clobbers:
@  r7
@------------------------------------------------------------------------------
get_sound:
  stmfd sp!, {r0-r6, lr}

  mov r6, #16       @ r6 = no of cols 
  mul r4, r1, r6
  add r4, r4, r2
  mov r3, #4
  mul r5, r4, r3
  add r5, r5, r7
  ldr r7, [r5]

  ldmfd sp!, {r0-r6, pc}

@------------------------------------------------------------------------------
@ play_columns
@ Effect:
@   Plays the matrix column by column
@ Arguments:
@ none
@ Returns:
@ none
@------------------------------------------------------------------------------
play_columns:
  stmfd sp!, {r0 - r7, lr}

  row     .req  r1
  col     .req  r2
  status  .req  r3
  rows    .req  r5
  columns .req  r6
  smatrix .req  r7
  notes   .req  r0
  
  mov     notes, #0
  mov     rows, #16
  mov     columns, #16

  mov     col, #0
  1:
    mov   row, #0

    2:
      ldr smatrix, =sound_rows
      bl  get_sound      
      bl  gol_get_alive  

      
      @ Need to move the coordinates around to draw the square
      stmfd sp!, {r0-r2}
      
      mov r0, r2
      ldr r2, =0xD8D8D8

      cmp status, #1
      @ Draw the square a different colour to see it playing
      bleq graphics_draw_square     
      
      ldmfd sp!, {r0-r2}

      @ Set the status bit of the note returned from get_sound
      lsl status, smatrix
      orr notes, status 
      add row, #1
      cmp row, rows
      bne 2b

    bl  play_sound
    mov notes, #0

    mov row, #0
    2:
      bl gol_get_alive

      @ Cheers, Paul
      stmfd sp!, {r0-r2}
      
      mov   r0, r2
      ldr   r2, =0xFFFF

      cmp   status, #1
      @ Redraw the square so it's white again.
      bleq  graphics_draw_square

      ldmfd sp!, {r0-r2}

      add   row, #1
      cmp   row, rows
      bne   2b
      

    add col, #1
    cmp col, columns
    bne 1b

  ldmfd sp!, {r0 - r7, pc}


@------------------------------------------------------------------------------
@ play_rows
@
@ Effect:
@   Plays the matrix row by row
@ Arguments:
@ none
@ Returns:
@ none
@------------------------------------------------------------------------------
play_rows:
  stmfd sp!, {r0 - r7, lr}

  row     .req  r1
  col     .req  r2
  status  .req  r3
  rows    .req  r5
  columns .req  r6
  smatrix .req  r7
  notes   .req  r0
  
  mov     notes, #0
  mov     rows, #16
  mov     columns, #16

  mov     row, #0
  1:
    mov   col, #0

    2:
      ldr smatrix, =sound_columns
      bl  get_sound      
      bl  gol_get_alive

      
      @Cheers, Paul
      stmfd sp!, {r0-r2}
      
      mov r0, r2
      ldr r2, =0xB02335

      cmp status, #1
      bleq graphics_draw_square
      
      ldmfd sp!, {r0-r2}

      lsl status, smatrix
      orr notes, status 
      add col, #1
      cmp col, columns
      bne 2b

    bl  play_sound
    mov notes, #0

    mov col, #0
    2:
      bl gol_get_alive

      stmfd sp!, {r0-r2}
      
      mov   r0, r2
      ldr   r2, =0xFFFF

      cmp   status, #1
      bleq  graphics_draw_square

      ldmfd sp!, {r0-r2}

      add   col, #1
      cmp   col, columns
      bne   2b
      

    add row, #1
    cmp row, rows
    bne 1b

  ldmfd sp!, {r0 - r7, pc}



@------------------------------------------------------------------------------
@ play_diagonal
@
@ Effect:
@   Plays the cells of the matrix in a diagonal fashion.
@ Arguments:
@ none
@ Returns:
@ none
@------------------------------------------------------------------------------
play_diagonal:
  stmfd sp!, {r0 - r9, lr}

  ytmp      .req  r1
  xtmp      .req  r2
  status    .req  r3
  y         .req  r4
  ys        .req  r5
  xs        .req  r6
  smatrix   .req  r7
  x         .req  r8
  notes     .req  r0
  drawwhite .req  r9
  
  mov     notes, #0
  mov     xs, #16
  mov     ys, #16

  mov     x, #0
  mov     y, #0
  1:
    mov     xtmp, x
    mov     ytmp, y

    cmp   drawwhite, #1
    beq   3f
    2:
      mov   drawwhite, #1
      @ Check that the coordinate is within the bounds of the square
      cmp   ytmp, #0
      blt   4f
      cmp   ytmp, #15
      bgt   4f
      cmp   xtmp, #0
      blt   4f
      cmp   xtmp, #15
      bgt   4f

      ldr   smatrix, =sound_columns
      bl    get_sound
      bl    gol_get_alive

      stmfd sp!, {r0-r2}
        
      mov   r0, r2
      ldr   r2, =0x2200

      cmp   status, #1
      bleq  graphics_draw_square
      
      ldmfd sp!, {r0-r2}

      lsl   status, smatrix
      orr   notes, status 
      
      sub   ytmp, #1
      add   xtmp, #1
      bl    2b
  3:
      @ Used for drawing the squares white again after sound is played
      mov   drawwhite, #0
      @ Check that the coordinate is within the bounds of the square
      cmp   ytmp, #0
      blt   4f
      cmp   ytmp, #15
      bgt   4f
      cmp   xtmp, #0
      blt   4f
      cmp   xtmp, #15
      bgt   4f

      bl    gol_get_alive

      stmfd sp!, {r0-r2}
        
      mov   r0, r2
      ldr   r2, =0xffff
      cmp   status, #1
      bleq  graphics_draw_square
      
      ldmfd sp!, {r0-r2}
      
      sub   ytmp, #1
      add   xtmp, #1
      bl    3b
  4:
    @ Switch draw white
    cmp   drawwhite, #1
    beq   1b

    bl  play_sound
    mov notes, #0
    add   y, #1
    cmp   y, ys
    bne   1b
    sub   y, #1
    add   x, #1
    cmp   x, xs
    bne   1b

  ldmfd sp!, {r0 - r9, pc}
