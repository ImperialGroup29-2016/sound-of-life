.globl graphics_frame_buffer
.globl graphics_initialize
.globl graphics_draw_pixel

@ ------------------------------------------------------------------------------
@ Frame Buffer Definition
@ ------------------------------------------------------------------------------

.section .data
.align 4
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
@   r2
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
		
	stmfd      sp!, {lr}
	
	fb_address .req r2
    
	ldr        fb_address, =graphics_frame_buffer
	str        width,  [fb_address, #0x08]
	str        height, [fb_address, #0x0C]
    
	.unreq     width
	.unreq     height

	
	ldr        r0, =0x1
	ldr        r1, =graphics_frame_buffer
	orr        r1, #0x40000000
	bl         mailbox_write
	bl         mailbox_read

    cmp        result, #0
    beq        success
    
    mov        result, #0
    b          flash
    ldmfd      sp!, {pc}

success:
	mov        result, fb_address
	.unreq     result
	.unreq     fb_address
   
    ldmfd      sp!, {pc}
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
    stmfd      sp!, {r3 - r4}

    px         .req r0
    py         .req r1
    color      .req r2
	
    address    .req r3
    ldr        address, =graphics_frame_buffer
    ldr        address, [address]
	
    height     .req r4
    ldr        height, [address, #0x0C]
    sub        height, #1
    cmp        py, height
    movhi      pc, lr
    .unreq     height
	
    width      .req r4
    ldr        width, [address, #0x08]
    sub        width, #1
    cmp        px, width
    movhi      pc, lr
	
    ldr        address, [address, #0x20]
    add        width, #1
    mla        px, py, width, px
    .unreq     width
    .unreq     py
    
    add        address, px, lsl #1
    .unreq     px
	
    strh       color, [address]
    .unreq     address
    
    ldmfd      sp!, {r3 - r4}
    mov        pc,lr
