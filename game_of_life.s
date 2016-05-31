@ game_of_life
@ label_prefix : gol_
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ldr r5,=32                     @ d1
ldr r6,=32                     @ d2
ldr r7,=0x0ffd                 @ &a

@initial data
@   0 1 2 3 4
@ 0 x x
@ 1 x x
@ 2
@ 3
@ 4   x x x
@ 5
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
gol_main:
  mov r1,#0                      @ i = 0
  mov r2,#0                      @ j = 0
  call gol_set_alive
  mov r1,#1                      @ i = 1
  mov r2,#0                      @ j = 0
  call gol_set_alive
  mov r1,#0                      @ i = 0
  mov r2,#1                      @ j = 1
  call gol_set_alive
  mov r1,#1                      @ i = 1
  mov r2,#1                      @ j = 1
  call gol_set_alive
  mov r1,#4                      @ i = 4
  mov r2,#1                      @ j = 1
  call gol_set_alive
  mov r1,#4                      @ i = 4
  mov r2,#2                      @ j = 2
  call gol_set_alive
  mov r1,#4                      @ i = 4
  mov r2,#3                      @ j = 3
  call gol_set_alive
  gol_skip_import:
  call gol_game_tick
  call gol_game_tick
  andeq r0,r0,r0  @ for emulator use
  gol_break:
    b gol_break

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
  mov r1,#0                      @ i = 0
  gol_loop1:                     @ for(i = 0 -> d1)
    cmp r1,r5
    beq gol_loop1_end
    mov r2,#0                      @ j = 0
    gol_loop1_1:                   @ for(j = 0 -> d2)
      cmp r2,r6
      beq gol_loop1_1_end
    @ loop1_1 body
      call gol_get_alive
      cmp r3,#0                    @ if cell is dead, no need to update neighbours
      beq gol_loop1_1_if_end
      push r2
      push r1
      push r2
      push r1
      push r2
      sub r1,r1,#1                 @ NW
      sub r2,r2,#1
      call gol_cycle
      call gol_get_status
      add r3,r3,#0x01000000           @ add 1 alive neighbour
      call gol_put
      pop r2                       @ N
      call gol_add_neighbour
      add r2,r2,#1                 @ NE
      call gol_cycle
      call gol_add_neighbour
      pop r1                       @ E
      call gol_add_neighbour
      add r1,r1,#1                 @ SE
      call gol_cycle
      call gol_add_neighbour
      pop r2                       @ S
      call gol_add_neighbour
      sub r2,r2,#1                 @ SW
      call gol_cycle
      call gol_add_neighbour
      pop r1                       @ W
      call gol_add_neighbour
      pop r2
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
      call gol_get_neighbours
      cmp r3,#3
      bne gol_update_endif_1
      b gol_alive
      gol_update_endif_1:
      cmp r3,#2
      bne gol_dead
      call gol_get_alive
      cmp r3,#1
      bne gol_dead
      gol_alive:
        call gol_set_alive
        @ TODO call gol_martin_graphic
        b gol_update_end
      gol_dead:
        call gol_set_dead
        @ TODO call gol_martin_graphic
      gol_update_end:
    @ end loop2_1 body
      add r2,r2,#1
      b gol_loop2_1
    gol_loop2_1_end:
    add r1,r1,#1
    b gol_loop2
  gol_loop2_end:
  return

@ get_alive
@ input
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ output
@   r3 - if a[i][j] lives
gol_get_alive:
  call gol_get_status
  and r3,r3,#0x80000000            @ select the alive status, which is bit 0
  mov r3,r3,lsr,#31
  return

@ get_neighbours
@ input
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ output
@   r3 - how many alive neighbour a[i][j] has
gol_get_neighbours:
  call gol_get_status
  and r3,r3,#0x0f000000            @ select the neighbour sum, which is bit 4-7
  mov r3,r3,lsr,#24
  return

@ get_status
@   r1 - i coordonate
@   r2 - j coordonate
@   r5 - d1
@   r6 - d2
@ output
@   r3 - sensible information about a[i][j] not shifted
@ please use the derivates get_alive and get_neighbours
gol_get_status:
  mul r3,r1,r6
  add r3,r3,r2
  add r3,r3,r7
  ldr r3,[r3]
  return

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
  call gol_get_status
  add r3,r3,#0x01000000           @ add 1 alive neighbour
  call gol_put
  return

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
  return

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
  add r4,r4,r7
  str r3,[r4]
  return

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
  call gol_get_status
  ldr r4,=0x00ffffff
  and r3,r3,r4                   @ restart the cell
  add r3,r3,#0x80000000          @ make the cell alive
  call gol_put
  return

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
  call gol_get_status
  ldr r4,=0x00ffffff
  and r3,r3,r4                   @ restart the cell
  call gol_put
  return
