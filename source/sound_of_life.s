.global play_columns
.global play_rows
.global get_sound
.global sound_rows


.ltorg
.section .data

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

.section .text

@--------------------------------------------------------
@ Arguments supplied:
@ r7 = start of sound matrix
@ r1 = y value
@ r2 = x value
@ 
@ Returns:
@ r7 = sound no to play
@
@--------------------------------------------------------
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

@--------------------------------------------------------
@ Plays the sounds of the columns in a matrix 
@
@ Arguments:
@ none
@ Returns:
@ none
@--------------------------------------------------------
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

        
        @Cheers, Paul
        stmfd sp!, {r0-r2}
        
        mov r0, r2
        ldr r2, =0xD8D8D8

        cmp status, #1
        bleq graphics_draw_square
        
        ldmfd sp!, {r0-r2}

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
        bleq  graphics_draw_square

        ldmfd sp!, {r0-r2}

        add   row, #1
        cmp   row, rows
        bne   2b
        

      add col, #1
      cmp col, columns
      bne 1b

    ldmfd sp!, {r0 - r7, pc}


play_rows:
    stmfd sp!, {r0 - r6, lr}

    row     .req  r1
    col     .req  r2
    status  .req  r3
    rows    .req  r5
    columns .req  r6
    notes   .req  r0
    
    mov     notes, #0
    mov     rows, #16
    mov     columns, #16

    mov     row, #0
    1:
      mov   col, #0

      2:
        bl  gol_get_alive
        lsl status, row
        orr notes, status 
        add col, #1
        cmp col, columns
        bne 2b

      bl  play_sound
      mov notes, #0
      add row, #1
      cmp row, rows
      bne 1b

    ldmfd sp!, {r0 - r6, pc}
