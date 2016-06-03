.global set_graphics_address
.global graphics_draw_pixel
.global graphics_draw_square

.section .data
.align 2
graphics_address:
    .int 0

.section .text
set_graphics_address:
    ldr       r1, =graphics_address
    str       r0, [r1]
    mov       pc, lr


@-------------------------------------------------------------------------------
@ Renders a pixel of colour r2 at (r0, r1)
@ Arguments:
@   r0 - x coordinate
@   r1 - y coordinate
@   r2 - colour
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
graphics_draw_pixel:
    stmfd     sp!, {r0 - r4, lr}

    x .req r0
    y .req r1
    color .req r2
	address .req r3
	
	ldr address,=graphics_address
	ldr address,[address]
	
	width .req r4
	ldr width,[address, #0]
	
	fb_address .req r3
	ldr fb_address,[address, #32]
	.unreq address
	
	mla x, y, width, x
	add fb_address, x,lsl #1
	.unreq y
	.unreq x
	
	strh color, [fb_address]
	.unreq color
	.unreq fb_address
    
    ldmfd     sp!, {r0 - r4, pc} 
    
@-------------------------------------------------------------------------------
@ Renders a a suare of colour r2 at (r0 * square_size, r1 * square_size)
@ Arguments:
@   r0 - x
@   r1 - y
@   r2 - colour
@ Returns:
@   none
@ Clobbers:
@   none
@-------------------------------------------------------------------------------
graphics_draw_square:
	stmfd     sp!, {r0 - r7, lr}

    curr_x .req r0
    curr_y .req r1
    x .req r3
    y .req r4
    max_x .req r5
    max_y .req r6
    
    mov x, r0
    mov y, r1
    
    size .req r7
    ldr size,=square_size
    ldr size,[size]
    
    mul curr_x, x, size
    mul curr_y, y, size
    
    sub size, #1
    
    mov max_x, curr_x
    add max_x, size
    
    mov max_y, curr_y
    add max_y, size
    
    add size, #1
    
    drawRow:
		drawPixel:
			bl graphics_draw_pixel
			
			add curr_x,#1
			cmp curr_x, max_x
			ble drawPixel

		mul curr_x, x, size
			
		add curr_y,#1
		cmp curr_y, max_y
		ble drawRow
    
    ldmfd     sp!, {r0 - r7, pc} 

