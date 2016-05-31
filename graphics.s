.globl graphics_frame_buffer
.globl graphics_initialize
.globl graphics_draw_pixel

.include "mailbox.s"

@ ------------------------------------------------------------------------------
@ Frame Buffer Definition
@ ------------------------------------------------------------------------------

.section .data
.align 12
graphics_frame_buffer:
  .int 640    @ +0x00: Physical width
  .int 640    @ +0x04: Physical height
  .int 16     @ +0x08: Virtual width
  .int 16     @ +0x0C: Virtual height
  .int 0      @ +0x10: Pitch
  .int 16     @ +0x14: Bit depth
  .int 0      @ +0x18: X
  .int 0      @ +0x1C: Y
  .int 0      @ +0x20: Address
  .int 0      @ +0x24: Size
  
@ ------------------------------------------------------------------------------
@ Initialize the frame buffer
@
@ Arguments:
@   r0 - virtual width
@   r1 - virtual height
@ Returns:
@   r0 - frame buffer address
@ Clobbers:
@   None
@ ------------------------------------------------------------------------------
 
.section .text
graphics_initialize:
        stmfd sp!, {r2, lr}

	width     .req r0
	height    .req r1
    
	cmpls      width,  #4096
	cmpls      height, #4096
    
	result     .req r0
	movhi      result,#0
	movhi      pc,lr
			
	fb_address .req r2
    
	ldr       fb_address, =graphics_frame_buffer
	str       width,  [fb_address, #0x08]
	str       height, [fb_address, #0x0C]
    
	.unreq width
	.unreq height

	mov       r0, fb_address
	orr       r0, #0x40000000
	mov       r1, #0x1
	bl        mailbox_write
	bl        mailbox_read

	mov       result, fb_address
	.unreq    result
	.unreq    fb_address
   
        stmfd sp!, {r2, pc}
@ ------------------------------------------------------------------------------
@ Draw a pixel with a given color
@
@ Arguments:
@   r0 - x position
@   r1 - y position
@   r2 - color
@ Returns:
@   none
@ Clobbers:
@   None
@ ------------------------------------------------------------------------------
   
graphics_draw_pixel:
        stmfd sp!, {r3 - r4}

	px        .req r0
	py        .req r1
        color     .req r2
	
	fb        .req r3
	ldr       fb, =graphics_frame_buffer
	
	height    .req r4
	ldr       height, [fb, #0x0C]
	sub       height,#1
	cmp       py, height
	movhi     pc, lr
	.unreq height
	
	width     .req r4
	ldr       width, [fb, #0x08]
	sub       width, #1
	cmp       px, width
	movhi     pc, lr
	
        address   .req r3
	ldr       address, [fb, #0x20]
	add       width, #1
	mla       px, py, width, px
	.unreq width
	.unreq py
    
	add       address, px, lsl #1
	.unreq px
	
	strh      color, [address]
	.unreq address
    
        stmfd sp!, {r3 - r4}
	mov       pc,lr
