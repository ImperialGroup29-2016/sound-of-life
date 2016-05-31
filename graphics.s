.globl graphics_frame_buffer:
.globl graphics_initialize
.globl graphics_draw_pixel

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
@   r0-r3
@ ------------------------------------------------------------------------------
 
.section .text
graphics_initialize:
	width     .req r0
	height    .req r1
    
	cmpls      width,  #4096
	cmpls      height, #4096
    
	result     .req r0
	movhi      result,#0
	movhi      pc,lr

	push      {r3, lr}			
	fb_adress .req r3
    
	ldr       fb_adress, =graphics_frame_buffer
	str       width,  [r3, #0x08]
	str       height, [r3, #0x0C]
    
	.unreq width
	.unreq height

	mov       r0, fb_adress
	add       r0, #0x40000000
	mov       r1, #0x1
	bl        mailbox_write
	
	mov       r0, #0x1
	bl        mailbox_read
		
	teq       result,#0
	movne     result,#0
	popne     {r3, pc}

	mov       result, fb_adress
	pop       {r3, pc}
	.unreq    result
	.unreq    fb_adress
   
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
@   r0-r4
@ ------------------------------------------------------------------------------
   
graphics_draw_pixel:
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
    
	mov       pc,lr