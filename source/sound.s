@ Global functions
.global setup_sound
.global play_sound

@ Useful addresses
.equ GPIO_FSEL4,       0x20200010
.equ CM_PWMCTL,        0x201010A0
.equ CM_PWMDIV,        0x201010A4
.equ DMA0_CS,          0x20007000
.equ DMA0_CONBLK,      0x20007004
.equ DMA_INT_STATUS,   0x20007FE0
.equ DMA_ENABLE,       0x20007FF0
.equ PWM_CTL,          0x2020C000
.equ PWM_DMAC,         0x2020C008
.equ PWM_RNG1,         0x2020C010
.equ PWM_RNG2,         0x2020C020

@ Macro to select tones
.macro note n
  .long \n\()_start
  .long \n\()_end
.endm

.section .text

@ Setting up the sound
setup_sound:
  @ Set the GPIO pins 40 and 45
  ldr   r0, =GPIO_FSEL4   @ Selects pins 40-49
  ldr   r1, [r0]          @ loads current value
  ldr   r2, =0x00038007
  bic   r1, r1, r2        @ Clears pin 40 and 45
  ldr   r2, =0x00020004
  orr   r1, r1, r2        @ Sets pin 40 and 45
  str   r1, [r0]          @ Activates pin 40 and 45

  @ Set up the PWM clock
  ldr   r0, =CM_PWMDIV    @ Gets address of the clock divisor
  ldr   r1, =0x5A002000
  str   r1, [r0]          @ Sets the clock divisor
  ldr   r0, =CM_PWMCTL    @ Gets address of clock control
  ldr   r1, =0x5A000016
  str   r1, [r0]          @ Activates the clock

  @ Set PWM freq range and activates PWM
  ldr   r1, =0x00002C48
  ldr   r0, =PWM_RNG1
  str   r1, [r0]          @ Set up range for channel 1
  ldr   r0, =PWM_RNG2
  str   r1, [r0]          @ Set up range for channel 2

  ldr   r0, =PWM_CTL
  ldr   r1, =0x00002161
  str   r1, [r0]          @ Activates the channels in serializer
                          @ mode using FIFO (MMIO)
  
  @ Set up PWM to use DMA
  ldr   r0, =PWM_DMAC
  ldr   r1, =0x80000001
  str   r1, [r0]          @ Activates DMA

  @ Enable DMA
  ldr   r0, =DMA_ENABLE
  ldr   r1, =0x00000001
  str   r1, [r0]

  @ Set control block to use
  ldr   r0, =DMA0_CONBLK
  adr   r1, DMA_CTRL_0
  str   r1, [r0]

  @ Start DMA0
  ldr   r0, =DMA0_CS
  ldr   r1, =0x00000001
  str   r1, [r0]

  @ Return
  mov pc, lr


@ Gets what sounds to load in r0
play_sound:
  stmfd sp!, {r0 - r9, lr}

  cmp   r0, #0                  @ Returns if no sounds has to be played
  ldmeqfd sp!, {r0 - r9, pc}

  @ Wait until DMA interrupt is set
  ldr   r1, =DMA_INT_STATUS
  1:
    ldr   r2, [r1]
    tst   r2, r2
    beq   1b

  @ Reset DMA interrupt flag
  ldr   r1, =DMA0_CS
  ldr   r2, =0x00000005
  str   r2, [r1]

  @ Selects the buffer
  ldr   r1, =buffer_index
  ldr   r2, [r1]
  tst   r2, r2
  ldreq r3, =dma_buffer_0
  ldrne r3, =dma_buffer_1
  eor   r2, #1
  str   r2, [r1]

  @ Initialize the notes checking loop
  ldr   r1, =0x10         @ Number of sounds to load
  ldr   r2, =0x00000001   @ Sets the first bit to check
  ldr   r4, =notes        @ Load notes

  mov   r5, r3
  ldr   r6, =0x1D4C0
  mov   r7, #0
  mov   r8, #0            @ Clears registers
  mov   r9, #0

  @ Clear buffer
  1: 
    str   r7, [r5], #4
    subs  r6, r6, #4
    bne   1b

  @ Mix sounds
  1:
    tst   r2, r0
    beq   3f              @ If sound not set to play go to the next one
    mov   r5, r3          @ Set pointer to start of buffer
    ldr   r6, [r4]        @ Get pointer to start of sample
    ldr   r7, [r4, #4]    @ Get pointer to end of sample

    @ Load and mix sound
    2:
      ldrh  r8, [r5]      @ Load current value in buffer
      ldrh  r9, [r6], #4  @ Load next halfword from sample
      lsr   r9, r9, #2 

      add   r8, r8, r9    @ Add current sample and new one
      cmp   r8, r9
      lsrne r8, #1        @ If mixing a new sound, divide by 2
      
      strh  r8, [r5], #4  @ Stores new sample

      cmp   r6, r7        @ If end of sample reached, end. 
      blt   2b            @ This works because the biggest sample is the same size as the buffer

  3:
    lsl   r2, #1
    add   r4, r4, #8      @ Go to the next note
    subs  r1, r1, #1
    bne   1b

  @ Return
  ldmfd sp!, {r0 - r9, pc}

.ltorg
.section .text
@ DMA Control blocks

@ 256-bit aligned
.align 5
DMA_CTRL_0:
  .long 0x00050141    @ Attributes
  .long dma_buffer_0  @ Source address
  .long 0x7E20C018    @ MMIO for the PWM
  .long 0x1D4C0       @ Transfer length
  .long 0             @ 2D mode stride (whatever that means)
  .long DMA_CTRL_1    @ Next control block address

.align 5
DMA_CTRL_1:
  .long 0x00050141    @ Attributes
  .long dma_buffer_1  @ Source address
  .long 0x7E20C018    @ MMIO for the PWM
  .long 0x1D4C0       @ Transfer length
  .long 0             @ 2D mode stride (whatever that means)
  .long DMA_CTRL_0    @ Next control block address

.align 4
@ DMA Buffers - 1D4C0h bytes, filled with 0s
dma_buffer_0:
  .space 0x1D4C0, 0

.align 4
dma_buffer_1:
  .space 0x1D4C0, 0

.align 4
buffer_index:
    .long 0

notes:
  note c3
  note a3
  note g4
  note f4
  note d2
  note c2
  note a2
  note g3
  note f3
  note d1
  note c1
  note a1
  note g2
  note f2
  note g1
  note f1

.section .data
a1_start: .incbin "sounds/A1.bin"
a1_end:
a2_start: .incbin "sounds/A2.bin"
a2_end:
a3_start: .incbin "sounds/A3.bin"
a3_end:
c1_start: .incbin "sounds/C1.bin"
c1_end:
c2_start: .incbin "sounds/C2.bin"
c2_end:
c3_start: .incbin "sounds/C3.bin"
c3_end:
d1_start: .incbin "sounds/D1.bin"
d1_end:
d2_start: .incbin "sounds/D2.bin"
d2_end:
f1_start: .incbin "sounds/F1.bin"
f1_end:
f2_start: .incbin "sounds/F2.bin"
f2_end:
f3_start: .incbin "sounds/F3.bin"
f3_end:
f4_start: .incbin "sounds/F4.bin"
f4_end:
g1_start: .incbin "sounds/G1.bin"
g1_end:
g2_start: .incbin "sounds/G2.bin"
g2_end:
g3_start: .incbin "sounds/G3.bin"
g3_end:
g4_start: .incbin "sounds/G4.bin"
g4_end:
