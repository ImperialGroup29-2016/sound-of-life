.global _start

.section .text

_start:
  ldr r0, =corneria_start
  ldr r1, =dma_buffer
  ldr r2, =0x2000
  mov r3, #0

1:
  ldrb r3, [r0], #1
  str r3, [r1], #4
  subs r2, r2, #1
  bne 1b

  @Set GPIO 40 & 45
  ldr r0, =GPIO_FSEL4
  ldr r1, [r0]
  ldr r2, =0x00038007
  bic r1, r1, r2
  ldr r2, =0x00020004
  orr r1, r1, r2
  str r1, [r0]

  @Setup Clock
  ldr r0, =CM_PWMDIV
  ldr r1, =0x5A002000
  str r1, [r0]
  ldr r0, =CM_PWMCTL
  ldr r1, =0x5A000016
  str r1, [r0]

  @PWM Setup
  ldr r1, =0x00002C48
  ldr r0, =PWM_RNG1
  str r1, [r0]
  ldr r0, =PWM_RNG2
  str r1, [r0]
  
  ldr r0, =PWM_CTL
  ldr r1, =0x00002161
  str r1, [r0]


  @PWM to use DMA
  ldr r0, =PWM_DMAC
  ldr r1, =0x80000001
  str r1, [r0]
  
  @Enable DMA
  ldr r0, =DMA_ENABLE
  ldr r1, =0x00000001
  str r1, [r0]

  @Set Control Block
  ldr r0, =DMA0_CONBLK
  adr r1, DMA_CTRL_0
  str r1, [r0]


  @Start DMA
  ldr r0, =DMA0_CS
  ldr r1, =0x00000001
  str r1, [r0]


play_sound:
  ldr r0, =DMA0_CS
  ldr r1, =0x00000005
  str r1, [r0]

  ldr r0, =dma_buffer

  ldr r1, =corneria_start
  ldr r2, =corneria_ptr
  ldr r3, [r2]
  ldr r4, =corneria_end
  sub r4, r4, #0x2000
  add r3, r3, #0x2000
  cmp r3, r4
  movge r3, r1
  str r3, [r2]

  ldr r4, =0x2000
  mov r2, r0
  
1:
  ldrb  r5, [r3], #1
  lsl   r5, r5, #3
  str   r5, [r2], #4
  subs  r4, r4, #1
  bne   1b
  b     play_sound


.ltorg
.section .text

.align 5
DMA_CTRL_0:
  .long 0x00050141 @Attr
  .long dma_buffer
  .long 0x7E20C018 @Dest Addr
  .long 0x8000 @Length
  .long 0
  .long DMA_CTRL_0

.align 4
dma_buffer:
  .space 0x8000, 0

.section .data


.equ  GPIO_FSEL4,       0x20200010
.equ  CM_PWMCTL,        0x201010A0
.equ  CM_PWMDIV,        0x201010A4
.equ  PWM_RNG1,         0x2020C010
.equ  PWM_RNG2,         0x2020C020
.equ  PWM_CTL,          0x2020C000
.equ  PWM_DMAC,         0x2020C008
.equ  DMA_ENABLE,       0x20007FF0
.equ  DMA0_CONBLK,      0x20007004
.equ  DMA0_CS,          0x20007000

corneria_start: .incbin "corneria.bin"
corneria_end:
corneria_ptr: .long corneria_start
