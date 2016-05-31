.global mailbox_read
.global mailbox_write

@ ------------------------------------------------------------------------------
@ Mailbox Base Address
@ ------------------------------------------------------------------------------

.equ MAILBOX_BASE,        0x2000B880

@ ------------------------------------------------------------------------------
@ Reads a value from the mailbox
@
@ Arguments:
@   r0 - channel
@ Returns:
@   r1 
@ Clobbers:
@   r0-r3
@ ------------------------------------------------------------------------------

mailbox_read: 
	and       r3, r0, #0xf
	ldr       r0, =MAILBOX_BASE
	
wait1: 
    ldr       r2,[r0, #0x18]
    tst       r2,#0x40000000
    bne       wait1
        
    ldr       r1, [r0, #0x00]
    and       r2, r1, #0xf
    teq       r2, r3
    bne       wait1

	and      r0, r1, #0xfffffff0
	mov      pc, lr

@ ------------------------------------------------------------------------------
@ Writes a value to the mailbox
@
@ Arguments:
@   r0 - data
@   r1 - channel
@ Returns:
@   none
@ Clobbers:
@   r0-r3
@ ------------------------------------------------------------------------------
    
mailbox_write:
	and       r2, r1, #0xf
	and       r1 ,r0, #0xfffffff0
	orr       r1, r2
    
	ldr       r0, =MAILBOX_BASE

wait2: 
    ldr       r2, [r0, #0x18]
    tst       r2, #0x80000000
    bne       wait2

	str       r1, [r0, #0x20]
    
	mov       pc, lr