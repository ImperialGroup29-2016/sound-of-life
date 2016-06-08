.section .init

.global _start
_start:
    b       main

.section .text

main:
    bl      initialise_frame_buffer
    bl      setup_sound

	color .req r2
	ldr color, =0xffff    

    bl      gol_main

render:
    bl      gol_game_tick
    bl      play_board

    b       render

play_board:
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

    mov     col, #0
    1:
      mov   row, #0

      2:
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

    ldmfd sp!, {r0 - r6, pc}


