.global gol_game_tick
.global gol_main
.global gol_get_alive
.global gol_cycle
.global gol_set_alive
.global gol_set_dead

.section .text

@ game_of_life
@ label_prefix : gol_
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ldr r5,=16                     @ d1
ldr r6,=16                     @ d2
ldr r7,=gol_matrix_address     @ &a

@initial data
@   0 1 2 3 4
@ 0
@ 1     x x
@ 2   x x
@ 3     x
@ 4
@ 5         
@
@
@ expected results:
@ after 1 tick
@   0 1 2 3 4
@ 0 x x
@ 1 x x
@ 2
@ 3     x
@ 4     x
@ 5     x
@
@ after 2 tick
@   0 1 2 3 4
@ 0 x x
@ 1 x x
@ 2   x
@ 3
@ 4   x x x
@ 5
@
gol_main: @ temporary function that insert some cells and ticks twice.

  stmfd sp!,{lr}
  ldr r5,=16                     @ d1
  ldr r6,=16                     @ d2
  ldr r7,=gol_matrix_address     @ &a
  mov r1,#7                      @ i = 1
  mov r2,#8                      @ j = 0
  mov r3,#0
  bl gol_set_alive
  mov r1,#8                      @ i = 0
  mov r2,#7                      @ j = 1
  mov r3,#0
  bl gol_set_alive
  mov r1,#8                      @ i = 1
  mov r2,#8                      @ j = 1
  mov r3,#0
  bl gol_set_alive
  mov r1,#9                      @ i = 0
  mov r2,#8                      @ j = 2
  mov r3,#0
  bl gol_set_alive
  mov r1,#7                      @ i = 2
  mov r2,#9                      @ j = 1
  mov r3,#0
  bl gol_set_alive

  mov r1,#0x1000000
  gol_countdown_loop1:
    cmp r1,#0
    beq gol_countdown_end1
    sub r1,r1,#1
    b gol_countdown_loop1
  gol_countdown_end1:

  bl gol_game_tick

  mov r1,#0x1000000
  gol_countdown_loop2:
    cmp r1,#0
    beq gol_countdown_end2
    sub r1,r1,#1
    b gol_countdown_loop2
  gol_countdown_end2:

  bl gol_game_tick

  ldmfd sp!,{pc}                        @ return

@ game_tick:
@ input
@   r5 - d1
@   r6 - d2
@   r7 - &a
@ uses
@   r1, r2, r3, r4
@ effect
@   advances the game of life by 1 generation
gol_game_tick:
  stmfd sp!,{lr}
  ldr r5,=16                     @ d1
  ldr r6,=16                     @ d2
  ldr r7,=gol_matrix_address     @ &a

  mov r1,#0                      @ i = 0
  gol_loop1:                     @ for(i = 0 -> d1)
    cmp r1,r5
    beq gol_loop1_end

    mov r2,#0                      @ j = 0
    gol_loop1_1:                   @ for(j = 0 -> d2)
      cmp r2,r6
      beq gol_loop1_1_end

    @ loop1_1 body
      bl gol_get_alive
      cmp r3,#0                    @ if cell is dead, no need to update neighbours
      beq gol_loop1_1_if_end
      stmfd sp!,{r2}
      stmfd sp!,{r1}
      stmfd sp!,{r2}
      stmfd sp!,{r1}
      stmfd sp!,{r2}
      sub r1,r1,#1                 @ NW
      sub r2,r2,#1
      bl gol_cycle
      bl gol_add_neighbour
      ldmfd sp!,{r2}               @ N
      bl gol_add_neighbour
      add r2,r2,#1                 @ NE
      bl gol_cycle
      bl gol_add_neighbour
      ldmfd sp!,{r1}               @ E
      bl gol_add_neighbour
      add r1,r1,#1                 @ SE
      bl gol_cycle
      bl gol_add_neighbour
      ldmfd sp!,{r2}               @ S
      bl gol_add_neighbour
      sub r2,r2,#1                 @ SW
      bl gol_cycle
      bl gol_add_neighbour
      ldmfd sp!,{r1}               @ W
      bl gol_add_neighbour
      ldmfd sp!,{r2}
      gol_loop1_1_if_end:
    @ end loop1_1 body

      add r2,r2,#1
      b gol_loop1_1
    gol_loop1_1_end:

    add r1,r1,#1
    b gol_loop1
  gol_loop1_end:

  mov r1,#0                      @ i = 0
  gol_loop2:                     @ for(i = 0 -> d1)
    cmp r1,r5
    beq gol_loop2_end

    mov r2,#0                      @ j = 0
    gol_loop2_1:                   @ for(j = 0 -> d2)
      cmp r2,r6
      beq gol_loop2_1_end

    @ loop2_1 body
      bl gol_get_neighbours
      cmp r3,#3
      bne gol_update_endif_1
      bl gol_get_alive
      b gol_alive
      gol_update_endif_1:
      cmp r3,#2
      bne gol_dead
      bl gol_get_alive
      cmp r3,#1
      bne gol_dead
      gol_alive:
        bl gol_set_alive
        b gol_update_end
      gol_dead:
        bl gol_set_dead
      gol_update_end:
    @ end loop2_1 body

      add r2,r2,#1
      b gol_loop2_1
    gol_loop2_1_end:

    add r1,r1,#1
    b gol_loop2
  gol_loop2_end:

  ldmfd sp!,{pc}                   @ return

@ get_alive
@ input
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ output
@   r3 - if a[i][j] lives
gol_get_alive:
  stmfd sp!,{lr}
  bl gol_get_status
  cmp r3,#0
  blt gol_get_alive_else
  mov r3,#0
  b gol_get_alive_end
  gol_get_alive_else:
  mov r3,#1
  gol_get_alive_end:
  ldmfd sp!,{pc}                   @ return

@ get_neighbours
@ input
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ output
@   r3 - how many alive neighbour a[i][j] has
gol_get_neighbours:
  stmfd sp!,{lr}
  bl gol_get_status
  and r3,r3,#0x000000ff            @ select the neighbour sum, which is bit 4-7
  ldmfd sp!,{pc}                   @ return

@ get_status
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ output
@   r3 - sensible information about a[i][j] not shifted
@ please use the derivates get_alive and get_neighbours
gol_get_status:
  mul r4,r1,r6
  add r4,r4,r2
  add r4,r4,r4
  add r4,r4,r4
  add r4,r4,r7
  ldr r3,[r4]
  mov pc,lr                        @ return

@ add_neighbour
@ input
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ uses
@   r3
@   r4
@ effect
@   neighbour[i][j]++
gol_add_neighbour:
  stmfd sp!,{lr}
  bl gol_get_status
  add r3,r3,#1                     @ add 1 alive neighbour
  bl gol_put
  ldmfd sp!,{pc}                   @ return

@ cycle
@ input
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ effect
@   it cycles around the map if a[i][j] is out of bounds
gol_cycle:
  cmp r1,#0
  bge gol_cycle_endif_1
  add r1,r1,r5
  gol_cycle_endif_1:
  cmp r1,r5
  blt gol_cycle_endif_2
  sub r1,r1,r5
  gol_cycle_endif_2:
  cmp r2,#0
  bge gol_cycle_endif_3
  add r2,r2,r6
  gol_cycle_endif_3:
  cmp r2,r6
  blt gol_cycle_endif_4
  sub r2,r2,r6
  gol_cycle_endif_4:
  mov pc,lr                        @ return

@ put
@   r1 - i coordonate
@   r2 - j coordonate
@   r3 - the new sensible value of cell
@   r5 - d1
@   r6 - d2
@ effect
@   it cycles around the map if a[i][j] is out of bounds
@ use with care
gol_put:
  mul r4,r1,r6
  add r4,r4,r2
  add r4,r4,r4
  add r4,r4,r4
  add r4,r4,r7
  str r3,[r4]
  mov pc,lr                        @ return

@ set_alive
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ uses
@   r3
@   r4
@ effect
@   a[i][j] becomes alive
gol_set_alive:
  stmfd sp!,{lr}
  cmp r3,#0
  bne gol_set_alive_skip_graphics
  stmfd sp!,{r0-r2}
  mov r0,r2
  ldr r2,=0xffff
  bl graphics_draw_square
  ldmfd sp!,{r0-r2}
  gol_set_alive_skip_graphics:
  mov r3,#0x80000000
  bl gol_put
  ldmfd sp!,{pc}                   @ return

@ set_dead
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ uses
@   r3
@   r4
@ effect
@   a[i][j] becomes dead
gol_set_dead:
  stmfd sp!,{lr}
  cmp r3,#0
  beq gol_set_dead_skip_graphics
  stmfd sp!,{r0-r2}
  mov r0,r2
  ldr r2,=0
  bl graphics_draw_square
  ldmfd sp!,{r0-r2}
  gol_set_dead_skip_graphics:
  mov r3,#0
  bl gol_put
  ldmfd sp!,{pc}

.ltorg
.section .text
gol_matrix_address:
  .space 2048, 0
