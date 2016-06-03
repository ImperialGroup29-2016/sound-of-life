.global game_tick


.section .text

ldr r3,=32             @ d1
ldr r4,=32             @ d2
mov r8,#0x100          @ cell is alive
mov r1,#1
mov r1,#1
sub r0,r15,#4          @ preparing call
b put
mov r1,#1
mov r1,#2
sub r0,r15,#4          @ preparing call
b put
mov r1,#2
mov r1,#1
sub r0,r15,#4          @ preparing call
b put
mov r1,#2
mov r1,#2
sub r0,r15,#4          @ preparing call
b put
mov r1,#5
mov r1,#5
sub r0,r15,#4          @ preparing call
b put

game_tick:
  mov r1,#0              @ i
  loop1:                 @ for(i = 0 -> d1)
    cmp r1,r3
    beq loop1_end
    mov r2,#0              @ j
    loop1_1:               @ for(j = 0 -> d2)
      cmp r2,r4
      beq loop1_1_end
    @ loop1_1 body
      sub r0,r15,#4          @ preparing call
      b get
      and r6,#1,r5,lsr,#8    @ selecting the status of the cell
      sub r10,r15,#4         @ preparing call
      b nw
      sub r10,r15,#4         @ preparing call
      b n
      sub r10,r15,#4         @ preparing call
      b ne
      sub r10,r15,#4         @ preparing call
      b e
      sub r10,r15,#4         @ preparing call
      b se
      sub r10,r15,#4         @ preparing call
      b s
      sub r10,r15,#4         @ preparing call
      b sw
      sub r10,r15,#4         @ preparing call
      b w
    @ end loop1_1 body
      b loop1_1
    loop1_1_end:
    b loop1
  loop1_end:
  mov r1,#0              @ i
  loop2:                 @ for(i = 0 -> d1)
    cmp r1,r3
    beq loop2_end
    mov r2,#0              @ j
    loop2_1:               @ for(j = 0 -> d2)
      cmp r2,r4
      beq loop2_1_end
    @ loop2_1 body
      sub r0,r15,#4          @ preparing call
      b get
      and r6,r5,#0xff        @ selecting the first 8 bits in r6
      sub r0,r15,#4          @ preparing call
      b bitsum
      and r6,#1,r5,lsr,#8    @ selecting the status of the cell
      mov r8,#0              @ by default the cell will die
      cmp r7,#2              @ cell has 2 neighbours and is alive
      bne endif2_1_1
      cmp r6,#1
      bne endif2_1_1
      mov r8,#1
      endif2_1_1:
      cmp r7,#3  @ cell has 3 neighbours
      bne endif2_1_2
      mov r8,#1
      endif2_1_2:
      ldr r9,=4294967167     @ 2^32 - 1 - 256
      and r5,r5,r9           @ clears the alive status
      orr r8,r5,r8,lsl,#8    @ replacing the living status of the cell
      sub r0,r15,#4          @ preparing call
      b put
    @ end loop2_1 body
      b loop2_1
    loop2_1_end:
    b loop1
  loop2_end:
  andeq r0,r0,r0  @ for emulator use

@ get
@ input
@   r0 - return PC
@   r1 - i coordonate
@   r2 - j coordonate
@   r4 - d2
@ output
@   r5 - a[i][j]
get:
  mul r5,r1,r4
  add r5,r5,r2
  lsl r5,#1
  add r5,r5,#4096 @ APTR
  ldr r5,[r5]
  mov r15,r0  @ return
  mov r0,r0   @ scrap for pc
  mov r0,r0   @ scrap for pc

@ put
@ input
@   r0 - return PC
@   r1 - i coordonate
@   r2 - j coordonate
@   r4 - d2
@   r8 - value
@ output
@ effect
@   a[i][j] = value
@ uses
@   r5
put:
  mul r5,r1,r4
  add r5,r5,r2
  lsl r5,#1
  add r5,r5,#4096 @ APTR
  str r8,[r5]
  mov r15,r0             @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc

@ bitsum, should be improved
@ input
@   r0 - return PC
@   r6 - the value
@ output
@   r7 - the number of set bits in b0 r6
@ uses
@   r8
bitsum:
  mov r7,#0
  and r8,r6,#1
  add r7,r7,r8
  and r8,r6,#2
  add r7,r7,r8,lsr,#1
  and r8,r6,#4
  add r7,r7,r8,lsr,#2
  and r8,r6,#8
  add r7,r7,r8,lsr,#3
  and r8,r6,#16
  add r7,r7,r8,lsr,#4
  and r8,r6,#32
  add r7,r7,r8,lsr,#5
  and r8,r6,#64
  add r7,r7,r8,lsr,#6
  and r8,r6,#128
  add r7,r7,r8,lsr,#7
  mov r15,r0             @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc

@ cycle
@ input
@ r0 - return PC
@ r1 - i coordonate
@ r2 - j coordonate
@ r3 - d1
@ r4 - d2
@ effect
@ it cycles around the map if a[i][j] is out of bounds
cycle:
  cmp r1,#0
  bge cycle_endif_1
  add r1,r1,r3
  cycle_endif_1:
  cmp r1,r3
  blt cycle_endif_2
  sub r1,r1,r3
  cycle_endif_2:
  cmp r2,#0
  bge cycle_endif_3
  add r2,r2,r4
  cmp r2,r4
  cycle_endif_3:
  blt cycle_endif_4
  sub r2,r2,r4
  cycle_endif_4:
  mov r15,r0             @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc

@ nw -> se
@ input
@   r1 - i coordonate
@   r2 - j coordonate
@   r3 - d1
@   r4 - d2
@   r8 - status
@   r10 - return PC
@ output
@ effect
@   alters neighbours of a[i+-1][j+-1] depending on function and status
@ uses
@   r5, r9, r0
nw:
  sub r1,r1,#1
  sub r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967294     @ 2^32 - 1 - 1
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  add r1,r1,#1
  add r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
n:
  sub r1,r1,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967293     @ 2^32 - 1 - 2
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  add r1,r1,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
ne:
  sub r1,r1,#1
  add r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967291     @ 2^32 - 1 - 4
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  add r1,r1,#1
  sub r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
e:
  add r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967287     @ 2^32 - 1 - 8
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  sub,r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
se:
  add r1,r1,#1
  add r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967279     @ 2^32 - 1 - 16
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  sub r1,r1,#1
  sub r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
s:
  add r1,r1,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967263     @ 2^32 - 1 - 32
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  sub r1,r1,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
sw:
  add r1,r1,#1
  sub r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967231     @ 2^32 - 1 - 64
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  sub r1,r1,#1
  add r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
e:
  sub r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  sub r0,r15,#4          @ preparing call
  b get
  ldr r9,=4294967167     @ 2^32 - 1 - 128
  and r5,r5,r9           @ clears the neighbour status
  orr r8,r5,r8,lsl,#0    @ replacing the neighbour status of the cell
  sub r0,r15,#4          @ preparing call
  b put
  add r2,r2,#1
  sub r0,r15,#4          @ preparing call
  b cycle
  mov r15,r10            @ return
  mov r0,r0              @ scrap for pc
  mov r0,r0              @ scrap for pc
