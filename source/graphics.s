.global     set_graphics_address
.global     graphics_draw_pixel
.global     graphics_draw_square

@-------------------------------------------------------------------------------
@ set_graphics_address*
@ Effect:
@   Saves the address of the frame buffer so that we can draw to it.
@ Arguments:
@   r0 - graphical frame buffer address
@ Returns:
@   none
@ Clobbers:
@   r0-r1
@-------------------------------------------------------------------------------
.section .text
set_graphics_address:
  ldr       r1, =graphics_address
  str       r0, [r1]
  mov       pc, lr
    
.section .data
.align 2
graphics_address:
  .int 0

@-------------------------------------------------------------------------------
@ graphics_draw_pixel*
@ Effect:
@   Renders a pixel of colour r2 at (r0, r1)
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

  x         .req r0
  y         .req r1
  color     .req r2
  address   .req r3
	
  @ Get address of the frame buffer structure
  ldr       address, =graphics_address
  ldr       address, [address]
	
  width     .req r4
  ldr       width, [address, #0]
	
  @ Gets the address to the actual frame buffer
  fb_addr   .req r3
  ldr       fb_addr, [address, #32]
  .unreq    address
	
  @ fb_addr = fb_addr + y * width + x
  mla       x, y, width, x
  add       fb_addr, x, lsl #1
  .unreq    y
  .unreq    x
	
  @ Store the color
  strh      color, [fb_addr]
  .unreq    color
  .unreq    fb_addr
    
  ldmfd     sp!, {r0 - r4, pc} 
    
@-------------------------------------------------------------------------------
@ graphics_draw_square*
@ Effect:
@   Renders a a suare of colour r2 at (r0 * square_size, r1 * square_size)
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
  stmfd     sp!, {r0 - r8, lr}

  curr_x    .req r0
  curr_y    .req r1
  x         .req r3
  y         .req r4
  max_x     .req r5
  max_y     .req r6
  
  @ Move arguments into other registers so that we can use r0 and r1
  mov       x, r0
  mov       y, r1
    
  @ Gets the spacing between individual grid squares
  grid_size .req r7
  ldr       grid_size, =fb_grid_size
  ldr       grid_size, [grid_size]
  
  @ Gets the size of the square within the grid. Different from grid_size so
  @ that we have a border
  sq_size   .req r8
  ldr       sq_size, =fb_square_size
  ldr       sq_size, [sq_size]
    
  @ Transforms the grid coordinates into the actual coordinates on the screen
  mul       curr_x, x, grid_size
  mul       curr_y, y, grid_size
  
  @ Calculates where the square should end
  mov       max_x, curr_x
  add       max_x, sq_size
    
  mov       max_y, curr_y
  add       max_y, sq_size
    
  drawRow:
    drawPixel:
      bl        graphics_draw_pixel
			
      add       curr_x,#1
      cmp       curr_x, max_x
			ble       drawPixel

		mul       curr_x, x, grid_size
			
  add       curr_y,#1
  cmp       curr_y, max_y
  ble       drawRow
    
  ldmfd     sp!, {r0 - r8, pc} 

