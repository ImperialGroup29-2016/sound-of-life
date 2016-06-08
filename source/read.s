read_main:
  stmfd sp!,{lr}
  bl read_gpio                   @ read signals

  and r7,r4,#0x00400000          @ interpret signal 22 directly
  cmp r7, #0
  bne read_next_1
  ldmfd sp!,{pc}                 @ return if interrupt signal is broken
  read_next_1:

  and r7,r3,#0x00800000          @ interpret signal 23
  cmp r7, #0
  beq read_next_2
  bl read_restore_square
  add r1,r1,#1                   @ increase x
  bl gol_cycle
  read_next_2:

  and r7,r3,#0x01000000          @ interpret signal 24
  cmp r7, #0
  beq read_next_3
  add r2,r2,#1                   @ increase y
  bl gol_cycle
  read_next_3:

  and r7,r3,#0x01000000          @ interpret signal 25
  cmp r7, #0
  beq read_next_4
  bl read_toggle_square          @ toggle the cell
  read_next_4:

  stmfd sp!,{r0-r2}
  mov r0,r2
  ldr r3,=0x8888
  bl graphics_draw_square        @ draw the new cell status
  ldmfd sp!,{r0-r2}
  
  b read_main

@ read_gpio uses r4 and returns r3 when the edge of a signal has been changed
@ growing edge formula = cur_val & !past_val
read_gpio:
  stmfd sp!,{lr}
  ldr r9,=0x20200034
  ldr r3,[r9]
  stmfd sp!,{r3}
  mvn r4,r4
  and r3,r3,r4                   @ detecting growing edge signal
  ldmfd sp!,{r4}                 @ memorise the current signals
  ldmfd sp!,{pc}

read_restore_square:
  stmfd sp!,{lr}
  bl gol_get_alive
  cmp r3,#0
  beq read_restore_square_dead

  stmfd sp!,{r0-r2}
  mov r0,r2
  ldr r2,=0xffff
  bl graphics_draw_square
  ldmfd sp!,{r0,r2}
  b read_restore_square_end

  read_restore_square_dead:
  stmfd sp!,{r0-r2}
  mov r0,r2
  ldr r2,=0
  bl graphics_draw_square
  ldmfd sp!,{r0,r2}
  
  read_restore_square_end:
  ldmfd sp!,{pc}

read_toggle_square:
  stmfd sp!,{lr}
  bl gol_get_alive
  cmp r3,#0
  beq read_toggle_square_dead

  bl gol_set_alive
  b read_toggle_square_end

  read_toggle_square_dead:
  bl gol_set_dead
  
  read_toggle_square_end:
  ldmfd sp!,{pc}

read_init:
  stmfd sp!,{r0-r9,lr}
  ldr r9,=0x20200008
  ldr r3,=0x00000000
  str r3,[r9]
  ldr r9,=0x20200028
  ldr r3,=0x03C00000   @ gpio 22-25
  str r3,[r9]
  ldmfd sp!,{r0-r9,pc}
