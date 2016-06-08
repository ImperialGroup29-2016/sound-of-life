.global play_columns
.global play_rows
.global test_get_sound

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

    mov r5, #16
    mov r6, #16
    mul r4, r1, r6
    add r4, r4, r2
    mov r3, #4
    mul r4, r4, r3
    add r4, r4, r7
    ldr r7, [r4]

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
        lsl status, row
        orr notes, status 
        add row, #1
        cmp row, rows
        bne 2b

      bl  play_sound
      mov notes, #0
      mov row, #0
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
