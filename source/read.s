@ label_prefix: read_
.global read_main
.global read_init
.global read_check

.section .text

@-------------------------------------------------------------------------------
@ read_main*
@
@ Effect:
@   initialises the virtual software interrupts and handles gpio inputs
@ Arguments:
@   none
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
read_main:
  stmfd sp!, {r0-r9, lr}
  ldr   r0, =sound_game_type
  ldr   r8, [r0]
  mov   r0, #0
  bl    play_sound
  mov   r4, #0x00000010          @ initialise the growing edge register
  mov   r1, #0                   @ clears the sound buffer
  mov   r2, #0
  bl    read_place_tmp           @ draw the new temp cell
  read_cycle:
    bl    read_gpio                @ read signals

    and   r7, r3, #0x00000010      @ interpret signal 4
    cmp   r7, #0
    beq   read_next_1
    bl    read_restore_tmp         @ restore the current cell
    ldr   r0, =sound_game_type
    str   r8, [r0]
    ldmfd sp!, {r0-r9, pc}         @ return if interrupt signal is broken
    read_next_1:

    and   r7, r3, #0x00400000      @ interpret signal 22
    cmp   r7, #0
    beq   read_next_2
    bl    read_restore_tmp         @ restore the current cell
    sub   r1, r1, #1               @ decrease i
    sub   r2, r2, #1               @ decrease j
    bl    gol_cycle
    bl    read_place_tmp           @ draw the new temp cell
    read_next_2:

    and   r7, r3, #0x00800000      @ interpret signal 23
    cmp   r7, #0
    beq   read_next_3
    bl    read_restore_tmp         @ restore the current cell
    add   r1, r1, #1               @ increase i
    bl    gol_cycle
    bl    read_place_tmp           @ draw the new temp cell
    read_next_3:

    and   r7, r3, #0x01000000      @ interpret signal 24
    cmp   r7, #0
    beq   read_next_4
    bl    read_restore_tmp         @ restore the current cell
    add   r2, r2, #1               @ increase j
    bl    gol_cycle
    bl    read_place_tmp           @ draw the new temp cell
    read_next_4:

    and   r7, r3, #0x02000000      @ interpret signal 25
    cmp   r7, #0
    beq   read_next_5
    bl    read_toggle_square       @ toggle the cell
    read_next_5:

    and   r7, r3, #0x08000000      @ interpret signal 27
    cmp   r7, #0
    beq   read_next_6
    cmp   r8, #0
    bne   read_main_sig27_shift
    mov   r8, #1                   @ switch the play mode
    bl    read_place_tmp           @ draw the new temp cell
    b     read_next_5
    read_main_sig27_shift:
    lsl   r8, #1
    and   r8, r8, #0x0000000f      @ switch the play mode
    bl    read_place_tmp           @ draw the new temp cell
    read_next_6:

    bl    read_wait
    b     read_cycle

@-------------------------------------------------------------------------------
@ read_gpio
@
@ Effect:
@   reads input from gpio and computes rising edge for all gpio pins 0->31
@   growing edge formula = cur_value & !past_value
@ Arguments:
@   r4 - the past signals
@ Returns:
@   r3 - the growing edge signals
@   r4 - the current signals
@ Clobbers:
@   r3, r4
@-------------------------------------------------------------------------------
read_gpio:
  stmfd sp!, {lr}
  ldr   r9, =0x20200034
  ldr   r3, [r9]
  stmfd sp!, {r3}
  mvn   r4, r4
  and   r3, r3, r4               @ detecting growing edge signal
  ldmfd sp!, {r4}                @ memorise the current signals
  ldmfd sp!, {pc}

@-------------------------------------------------------------------------------
@ read_restore_tmp
@
@ Effect:
@   replaces the cell at position (r1, r2) with its proper status.
@ Arguments:
@   r1 - line
@   r2 - column
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
read_restore_tmp:
  stmfd sp!, {lr}
  bl    gol_get_alive
  cmp   r3, #0
  beq   read_restore_tmp_dead

  stmfd sp!, {r0-r2}
  mov   r0, r2
  ldr   r2, =0xffff
  bl    graphics_draw_square
  ldmfd sp!, {r0-r2}
  b     read_restore_tmp_end

  read_restore_tmp_dead:
  stmfd sp!, {r0-r2}
  mov   r0, r2
  ldr   r2, =0
  bl    graphics_draw_square
  ldmfd sp!, {r0-r2}
  
  read_restore_tmp_end:
  ldmfd sp!, {pc}

@-------------------------------------------------------------------------------
@ read_place_tmp
@
@ Effect:
@   places a temporary cell at position (r1, r2).
@   the colour is defined by the parse register(r8).
@ Arguments:
@   r1 - line
@   r2 - column
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
read_place_tmp:
  stmfd sp!, {r0-r2, lr}
  mov   r0, r2
  ldr   r2, =0x2200
  cmp   r8, #0
  addgt r2, r2, #0x2200
  cmp   r8, #1
  addgt r2, r2, #0x2200
  cmp   r8, #2
  addgt r2, r2, #0x2200
  cmp   r8, #4
  addgt r2, r2, #0x2200
  bl    graphics_draw_square
  ldmfd sp!, {r0-r2, pc}

@-------------------------------------------------------------------------------
@ read_toggle_square
@
@ Effect:
@   toggles the cell at position (r1, r2) between dead and alive.
@ Arguments:
@   r1 - line
@   r2 - column
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
read_toggle_square:
  stmfd sp!, {lr}
  bl    gol_get_alive
  cmp   r3, #0
  bne   read_toggle_square_dead

  bl    gol_set_alive
  b     read_toggle_square_end

  read_toggle_square_dead:
  bl    gol_set_dead
  
  read_toggle_square_end:
  ldmfd sp!, {pc}

@-------------------------------------------------------------------------------
@ read_init*
@
@ Effect:
@   initialises gpio pins for input, and clears them.
@   Pins initialised: 22->25, 27
@ Arguments:
@   none
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
read_init:
  stmfd sp!, {r0-r9, lr}
  ldr   r9, =0x20200008
  ldr   r3, =0x00000000
  str   r3, [r9]
  ldr   r9, =0x20200004
  ldr   r3, =0x00000000
  str   r3, [r9]
  ldr   r9, =0x20200028
  ldr   r3, =0x2FF00010          @ gpio 04, 22-25, and 27
  str   r3, [r9]
  ldmfd sp!, {r0-r9, pc}

@-------------------------------------------------------------------------------
@ read_check*
@
@ Effect:
@   Checks if the system needs to enter software interrupt mode.
@ Arguments:
@   r4 - the past signals
@ Returns:
@   r4 - the current signals
@   r7 - returns the growing edge of signal 4
@ Clobbers:
@   r4, r7
@-------------------------------------------------------------------------------
read_check:
  stmfd sp!, {r3, lr}
  bl    read_gpio
  and   r7, r3, #0x00000010      @ interpret signal 4
  ldmfd sp!, {r3, pc}

@-------------------------------------------------------------------------------
@ read_check*
@
@ Effect:
@   waits a few miliseconds before next input check.
@   This prevents dublicate signal toggle in most of the cases
@ Arguments:
@   none
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
read_wait:
  stmfd sp!, {r0, lr}
  mov   r0, #0x20000
  read_wait_loop:
    sub   r0, r0, #1
    cmp   r0, #0
    bne   read_wait_loop
  ldmfd sp!, {r0, pc}
  
