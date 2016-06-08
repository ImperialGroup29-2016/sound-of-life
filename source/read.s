.global read_main
.global read_init
.global read_check

.section .text

read_main:
  stmfd sp!,{r0-r9,lr}
  mov r4,#0x00400000
  mov r1,#0
  mov r2,#0
  bl read_place_tmp              @ draw the new temp cell
  read_cycle:
    bl read_gpio                   @ read signals

    and r7,r4,#0x00400000          @ interpret signal 22 directly
    cmp r7, #0
    bne read_next_1
    bl read_restore_tmp         @ restore the current cell
    ldmfd sp!,{r0-r9,pc}           @ return if interrupt signal is broken
    read_next_1:

    and r7,r3,#0x00800000          @ interpret signal 23
    cmp r7, #0
    beq read_next_2
    bl read_restore_tmp         @ restore the current cell
    add r1,r1,#1                   @ increase i
    bl gol_cycle
    bl read_place_tmp              @ draw the new temp cell
    read_next_2:

    and r7,r3,#0x01000000          @ interpret signal 24
    cmp r7, #0
    beq read_next_3
    bl read_restore_tmp         @ restore the current cell
    add r2,r2,#1                   @ increase j
    bl gol_cycle
    bl read_place_tmp              @ draw the new temp cell
    read_next_3:

    and r7,r3,#0x02000000          @ interpret signal 25
    cmp r7, #0
    beq read_next_4
    bl read_toggle_square          @ toggle the cell
    read_next_4:

    b read_cycle

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

read_restore_tmp:
  stmfd sp!,{lr}
  bl gol_get_alive
  cmp r3,#0
  beq read_restore_tmp_dead

  stmfd sp!,{r0-r2}
  mov r0,r2
  ldr r2,=0xffff
  bl graphics_draw_square
  ldmfd sp!,{r0-r2}
  b read_restore_tmp_end

  read_restore_tmp_dead:
  stmfd sp!,{r0-r2}
  mov r0,r2
  ldr r2,=0
  bl graphics_draw_square
  ldmfd sp!,{r0-r2}
  
  read_restore_tmp_end:
  ldmfd sp!,{pc}

read_toggle_square:
  stmfd sp!,{lr}
  bl gol_get_alive
  cmp r3,#0
  bne read_toggle_square_dead

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

read_check:
  stmfd sp!,{r0-r4,lr}
  bl read_gpio
  and r7,r4,#0x00400000          @ interpret signal 22 directly
  ldmfd sp!,{r0-r4,pc}

read_place_tmp:
  stmfd sp!,{r0-r2,lr}
  mov r0,r2
  ldr r2,=0x8888
  bl graphics_draw_square
  ldmfd sp!,{r0-r2,pc}
  
