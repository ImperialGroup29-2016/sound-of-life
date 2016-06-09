.global     fb_grid_size
.global     fb_square_size
.global     initialise_frame_buffer

@-------------------------------------------------------------------------------
@ Frame Buffer Structure
@-------------------------------------------------------------------------------
.section .data
.align 4
frame_buffer:
  .int      1024  @ Width
  .int      1024  @ Height
  .int      1024  @ VWidth
  .int      1024  @ VHeight
  .int      0     @ Pitch
  .int      16    @ Bit Depth
  .int      0     @ X
  .int      0     @ Y
  .int      0     @ Address
  .int      0     @ Size
    
.align 1
fb_grid_size:
  .int      64
fb_square_size:
  .int      60


@-------------------------------------------------------------------------------
@ initialise_frame_buffer*
@ Effect:
@   Initializes the frame buffer which will be used for outputing graphics
@ Arguments:
@   none
@ Returns:
@   r0
@ Clobbers:
@   r0
@-------------------------------------------------------------------------------
.section  .text
initialise_frame_buffer:
  @ Save registers and return
  stmfd     sp!, {r1-r4, lr}

  @ Store the address of the frame buffer
  fbAddr    .req r4
  ldr       fbAddr, =frame_buffer

  @ Add fbInfo + 0x40000000 so not to cache write
  @ Then write to mailbox channel 1 and read the reply
  mov       r0, fbAddr
  add       r0, #0x40000000
  mov       r1, #1
  bl        mailbox_write

  mov       r0, #1
  bl        mailbox_read

  @ Check if the result is 0, return 0 if not 
  teq       r0, #0
  movne     r0, #0
  bne       1f

  @ Else return the frame buffer info address
  ldr       r0, =frame_buffer
  .unreq    fbAddr  
1:

  @ If r0  is 0 then initialization failed and we will flash the light
  teq       r0, #0
  bne       1f
  bl        flash
	
1:
  bl        set_graphics_address

  ldmfd     sp!, {r1-r4, pc}
    
    
