@ label_prefix: gol_

.global gol_main
.global gol_game_tick
.global gol_get_alive
.global gol_cycle
.global gol_set_alive
.global gol_set_dead
.global gol_matrix_address

.section .text

@-------------------------------------------------------------------------------
@ gol_set_size
@
@ Effect:
@   imports information for game of life implementation
@ Arguments:
@   none
@ Returns:
@   r5 = number of lines
@   r6 = number of columns
@   r7 = pointer of matrix
@ Clobbers:
@   r5 - r7
@-------------------------------------------------------------------------------
gol_set_size:
  ldr   r5, =16                  @ d1
  ldr   r6, =16                  @ d2
  ldr   r7, =gol_matrix_address  @ &a
  mov   pc, lr                   @ return

@-------------------------------------------------------------------------------
@ gol_main*
@
@ Effect:
@   insert some cells.(glider)
@ Arguments:
@   none
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
gol_main:
  stmfd sp!, {r0-r8, lr}
  mov   r1, #4                   @ i = 4
  mov   r2, #1                   @ j = 1
  mov   r3, #0
  bl    gol_set_alive
  mov   r1, #5                   @ i = 5
  mov   r2, #2                   @ j = 2
  mov   r3, #0
  bl    gol_set_alive
  mov   r1, #6                   @ i = 6
  mov   r2, #0                   @ j = 0
  mov   r3, #0
  bl    gol_set_alive
  mov   r1, #6                   @ i = 6
  mov   r2, #1                   @ j = 1
  mov   r3, #0
  bl    gol_set_alive
  mov   r1, #6                   @ i = 6
  mov   r2, #2                   @ j = 2
  mov   r3, #0
  bl    gol_set_alive

  ldmfd sp!, {r0-r8, pc}         @ return

@-------------------------------------------------------------------------------
@ game_tick*
@
@ Effect:
@   advances the game of life by 1 generation
@ Arguments:
@   none
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
gol_game_tick:
  stmfd sp!, {r0-r8, lr}
  bl    gol_set_size

  mov   r1, #0                   @ i = 0
  gol_loop1:                     @ for(i = 0 -> d1)
    cmp   r1, r5
    beq   gol_loop1_end

    mov   r2, #0                   @ j = 0
    gol_loop1_1:                   @ for(j = 0 -> d2)
      cmp   r2, r6
      beq   gol_loop1_1_end

    @ loop1_1 body
      bl    gol_get_alive
      cmp   r3, #0                    @ if cell is dead, don't update neighbours
      beq   gol_loop1_1_if_end
      stmfd sp!, {r2}
      stmfd sp!, {r1}
      stmfd sp!, {r2}
      stmfd sp!, {r1}
      stmfd sp!, {r2}

      sub   r1, r1, #1               @ NW
      sub   r2, r2, #1
      bl    gol_cycle
      bl    gol_add_neighbour

      ldmfd sp!, {r2}                @ N
      bl    gol_add_neighbour

      add   r2, r2, #1               @ NE
      bl    gol_cycle
      bl    gol_add_neighbour

      ldmfd sp!, {r1}                @ E
      bl    gol_add_neighbour

      add   r1, r1, #1               @ SE
      bl    gol_cycle
      bl    gol_add_neighbour

      ldmfd sp!, {r2}                @ S
      bl    gol_add_neighbour

      sub   r2, r2, #1               @ SW
      bl    gol_cycle
      bl    gol_add_neighbour

      ldmfd sp!, {r1}                @ W
      bl    gol_add_neighbour

      ldmfd sp!, {r2}
      gol_loop1_1_if_end:
    @ end loop1_1 body

      add   r2, r2, #1
      b     gol_loop1_1
    gol_loop1_1_end:

    add   r1, r1, #1
    b     gol_loop1
  gol_loop1_end:

  mov   r1, #0                   @ i = 0
  gol_loop2:                     @ for(i = 0 -> d1)
    cmp   r1, r5
    beq   gol_loop2_end

    mov   r2, #0                   @ j = 0
    gol_loop2_1:                   @ for(j = 0 -> d2)
      cmp   r2, r6
      beq   gol_loop2_1_end

    @ loop2_1 body
      bl    gol_get_neighbours     @ find the next status of the cell
      cmp   r3, #3
      bne   gol_update_endif_1
      b     gol_alive
      gol_update_endif_1:
      cmp   r3, #2
      bne   gol_dead
      bl    gol_get_alive
      cmp   r3, #1
      bne   gol_dead
      gol_alive:
        bl    gol_get_alive
        bl    gol_set_alive
        b     gol_update_end
      gol_dead:
        bl    gol_get_alive
        bl    gol_set_dead
      gol_update_end:
    @ end loop2_1 body

      add   r2, r2, #1
      b gol_loop2_1
    gol_loop2_1_end:

    add   r1, r1, #1
    b gol_loop2
  gol_loop2_end:

  ldmfd sp!, {r0-r8, pc}         @ return

@-------------------------------------------------------------------------------
@ get_alive*
@
@ Effect:
@   finds out if a cell is alive or not
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@ Returns:
@   r3 - if a[i][j] lives {#0 dead, #1 alive}
@ Clobbers:
@   r3
@-------------------------------------------------------------------------------
gol_get_alive:
  stmfd sp!, {r4-r8, lr}
  bl    gol_set_size
  bl    gol_get_status
  cmp   r3, #0
  blt   gol_get_alive_else
  mov   r3, #0
  b     gol_get_alive_end
  gol_get_alive_else:
  mov   r3, #1
  gol_get_alive_end:
  ldmfd sp!, {r4-r8, pc}         @ return

@-------------------------------------------------------------------------------
@ get_neighbours
@
@ Effect:
@   finds out if a cell is alive or not
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ Returns:
@   r3 - how many alive neighbour a[i][j] has {#0 .. #8}
@ Clobbers:
@   r3, r4
@-------------------------------------------------------------------------------
gol_get_neighbours:
  stmfd sp!, {lr}
  bl    gol_get_status
  and   r3, r3, #0x000000ff      @ select the neighbour sum, which is bit 4-7
  ldmfd sp!, {pc}                @ return

@-------------------------------------------------------------------------------
@ get_status
@
@ Effect:
@   Returns unformatted information about a cell
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ Returns:
@   r3 - information about a[i][j] {(+-) for dead/alive, abs(r3) for neighbours}
@ Clobbers:
@   r3, r4
@-------------------------------------------------------------------------------
gol_get_status:
  stmfd sp!, {lr}
  mul   r4, r1, r6
  add   r4, r4, r2
  mov   r4, r4, lsl #2
  add   r4, r4, r7
  ldr   r3, [r4]
  ldmfd sp!, {pc}                @ return

@-------------------------------------------------------------------------------
@ add_neighbour
@
@ Effect:
@   Returns a neighbour to a cell
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ Returns:
@   none
@ Clobbers:
@   r3, r4
@-------------------------------------------------------------------------------
gol_add_neighbour:
  stmfd sp!, {lr}
  bl    gol_get_status
  add   r3, r3, #1               @ add 1 alive neighbour
  bl    gol_put
  ldmfd sp!, {pc}                @ return

@-------------------------------------------------------------------------------
@ cycle*
@
@ Effect:
@   cycles around the map if a[i][j] is slightly out of bounds
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@ Returns:
@   r1 - i coordonate
@   r2 - j coordonate
@ Clobbers:
@   r1, r2
@-------------------------------------------------------------------------------
gol_cycle:
  stmfd sp!, {r5-r7, lr}
  bl    gol_set_size
  cmp   r1, #0
  bge   gol_cycle_endif_1
  add   r1, r1, r5
  gol_cycle_endif_1:
  cmp   r1, r5
  blt   gol_cycle_endif_2
  sub   r1, r1, r5
  gol_cycle_endif_2:
  cmp   r2, #0
  bge   gol_cycle_endif_3
  add   r2, r2, r6
  gol_cycle_endif_3:
  cmp   r2, r6
  blt   gol_cycle_endif_4
  sub   r2, r2, r6
  gol_cycle_endif_4:
  ldmfd sp!, {r5-r7, pc}         @ return

@-------------------------------------------------------------------------------
@ put
@
@ Effect:
@   replaces information about a cell
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@   r3 - new unformatted information about a cell
@   r5 - d1
@   r6 - d2
@ Returns:
@   none
@ Clobbers:
@   r4
@-------------------------------------------------------------------------------
gol_put:
  stmfd sp!, {lr}
  mul   r4, r1, r6
  add   r4, r4, r2
  mov   r4, r4, lsl #2
  add   r4, r4, r7
  str   r3, [r4]
  ldmfd sp!, {pc}                @ return

@-------------------------------------------------------------------------------
@ set_alive*
@
@ Effect:
@   makes a cell alive(and resets the neighbour count)
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
gol_set_alive:
  stmfd sp!, {r0-r8, lr}
  bl    gol_set_size
  cmp   r3, #0
  bne   gol_set_alive_skip_graphics
  stmfd sp!, {r0-r2}
  mov   r0, r2
  ldr   r2, =0xffff
  bl    graphics_draw_square
  ldmfd sp!, {r0-r2}
  gol_set_alive_skip_graphics:
  mov   r3, #0x80000000
  bl    gol_put
  ldmfd sp!, {r0-r8, pc}         @ return

@-------------------------------------------------------------------------------
@ set_dead*
@
@ Effect:
@   makes a cell dead(and resets the neighbour count)
@ Arguments:
@   r1 - i coordonate
@   r2 - j coordonate
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
gol_set_dead:
  stmfd sp!, {r0-r8, lr}
  bl    gol_set_size
  cmp   r3, #0
  beq   gol_set_dead_skip_graphics
  stmfd sp!, {r0-r2}
  mov   r0, r2
  ldr   r2, =0
  bl    graphics_draw_square
  ldmfd sp!, {r0-r2}
  gol_set_dead_skip_graphics:
  mov   r3, #0
  bl    gol_put
  ldmfd sp!, {r0-r8, pc}         @ return

.ltorg
.section .text
gol_matrix_address:
  .space 2048, 0
