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


.align 4
sound_diagonal:
    .int  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .int  0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,15
    .int  0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,14,15
    .int  0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,13,14,15
    .int  0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4,12,13,14,15
    .int  0, 1, 2, 3, 4, 5, 5, 5, 5, 5, 5,11,12,13,14,15
    .int  0, 1, 2, 3, 4, 5, 6, 6, 6, 6,10,11,12,13,14,15
    .int  0, 1, 2, 3, 4, 5, 6, 7, 7, 9,10,11,12,13,14,15
    .int  0, 1, 2, 3, 4, 5, 6, 8, 8, 9,10,11,12,13,14,15
    .int  0, 1, 2, 3, 4, 5, 9, 9, 9, 9,10,11,12,13,14,15
    .int  0, 1, 2, 3, 4,10, 9, 9, 9, 9,10,11,12,13,14,15
    .int  0, 1, 2, 3,11,11,11,11,11,11,11,11,12,13,14,15
    .int  0, 1, 2,12,12,12,12,12,12,12,12,12,12,13,14,15
    .int  0, 1,13,13,13,13,13,13,13,13,13,13,13,13,14,15
    .int  0,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15
    .int 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15

.align 4
sound_pulse:
    .int  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14, 0
    .int 14, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12, 0, 1
    .int 13,12, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10, 0, 1, 2
    .int 12,11,10, 0, 1, 2, 3, 4, 5, 6, 7, 8, 0, 1, 2, 3
    .int 11,10, 9, 8, 0, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4
    .int 10, 9, 8, 7,13, 0, 1, 2, 3, 4, 5, 8, 2, 3, 4, 5
    .int  9, 8, 7, 6,12, 9, 0, 1, 2, 3, 6, 9, 3, 4, 5, 6
    .int  8, 7, 6, 5,11, 8,11, 0, 1, 4, 7,10, 4, 5, 6, 7
    .int  7, 6, 5, 4,10, 7,10, 3, 2, 5, 8,11, 5, 6, 7, 8
    .int  6, 5, 4, 3, 9, 6, 9, 8, 7, 6, 9,12, 6, 7, 8, 9
    .int  5, 4, 3, 2, 8, 5, 4, 3, 2, 1, 0,13, 7, 8, 9,10
    .int  4, 3, 2, 1, 7, 6, 5, 4, 3, 2, 1, 0, 8, 9,10,11
    .int  3, 2, 1, 0, 8, 7, 6, 5, 4, 3, 2, 1, 0,10,11,12
    .int  2, 1, 0,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,12,13
    .int  1, 0,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,14
    .int  0,14,13,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0

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

  cmp     r0, #3
  bleq    play_diagonal

  cmp     r0, #4
  bleq    play_pulse

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
      ldr r2, =0xE0C3


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

  .unreq    row     
  .unreq    col     
  .unreq    status  
  .unreq    rows    
  .unreq    columns 
  .unreq    smatrix 
  .unreq    notes   

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

      
      stmfd sp!, {r0-r2}
      
      mov r0, r2
      ldr r2, =0x293F

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

  .unreq    row     
  .unreq    col     
  .unreq    status  
  .unreq    rows    
  .unreq    columns 
  .unreq    smatrix 
  .unreq    notes   

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

      ldr   smatrix, =sound_diagonal
      bl    get_sound
      bl    gol_get_alive

      stmfd sp!, {r0-r2}
        
      mov   r0, r2
      ldr   r2, =0xA017

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
    cmp   drawwhite, #1
    bleq  play_sound

    @ Switch draw white
    cmp   drawwhite, #1
    beq   1b

    mov   notes, #0
    add   y, #1
    cmp   y, ys
    bne   1b
    sub   y, #1
    add   x, #1
    cmp   x, xs
    bne   1b

  .unreq     ytmp      
  .unreq     xtmp      
  .unreq     status    
  .unreq     y         
  .unreq     ys        
  .unreq     xs        
  .unreq     smatrix   
  .unreq     x         
  .unreq     notes     
  .unreq     drawwhite 

  ldmfd sp!, {r0 - r9, pc}

@------------------------------------------------------------------------------
@ play_pulse
@
@ Effect:
@   Plays the cells of the matrix in a "Spiral" fashion, which is essentially
@   playing square outlines of an increasing size from the middle outwards.
@ Arguments:
@ none
@ Returns:
@ none
@------------------------------------------------------------------------------
play_pulse:
  stmfd sp!, {r0 - r12, lr}

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
  sqsize    .req  r10
  i         .req  r11
  direction .req  r12
  
  mov     notes, #0
  mov     xs, #16
  mov     ys, #16
  mov     sqsize, #2
  mov     drawwhite, #0

  mov     x, #7
  mov     y, #7

  1:
    mov     xtmp, x
    mov     ytmp, y
    mov     direction, #0
    
    cmp   ytmp, #0
    blt   4f
    cmp   xtmp, #0
    blt   4f
    
    2:
      mov   i, sqsize

    3:
      ldr   smatrix, =sound_pulse
      bl    get_sound
      bl    gol_get_alive

      stmfd sp!, {r0-r2}
        
      mov   r0, r2
      ldr   r2, =0x25A0

      cmp   drawwhite, #1
      ldreq r2, =0xFFFF

      cmp   status, #1
      bleq  graphics_draw_square
      
      ldmfd sp!, {r0-r2}

      lsl   status, smatrix
      orr   notes, status 

      sub   i, #1
      cmp   i, #0
      blgt  move_dir

      cmp   i, #0
      bgt   3b

      add   direction, #1
      cmp   direction, #4
      blt   2b
      
      cmp   drawwhite, #0
      bleq  play_sound
  
      cmp   drawwhite, #0
      moveq drawwhite, #1
      beq   1b

      cmp   drawwhite, #1
      moveq drawwhite, #0      

      mov   notes, #0

      sub   x, #1
      sub   y, #1
      add   sqsize, #2
      b     1b
  4: 

  .unreq     ytmp     
  .unreq     xtmp     
  .unreq     status   
  .unreq     y        
  .unreq     ys       
  .unreq     xs       
  .unreq     smatrix  
  .unreq     x        
  .unreq     notes    
  .unreq     drawwhite
  .unreq     sqsize   
  .unreq     i        
  .unreq     direction

  ldmfd sp!, {r0 - r12, pc}


@-----------------------------------------------------------------------------
@ move_dir
@ 
@ Effect:
@   Helper function for play_spiral to move in the direction of travel
@ Arguments:
@   ytmp = r1
@   xtmp = r2
@   direction = r12
@-----------------------------------------------------------------------------
move_dir:
  cmp     r12, #0
  addeq   r1, #1
  moveq   pc, lr
  
  cmp     r12, #1
  addeq   r2, #1
  moveq   pc, lr

  cmp     r12, #2
  subeq   r1, #1
  moveq   pc, lr

  cmp     r12, #3
  subeq   r2, #1
  moveq   pc, lr

  bl      flash
