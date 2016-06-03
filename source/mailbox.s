.global get_mailbox_base
.global mailbox_write
.global mailbox_read

get_mailbox_base:
    ldr     r0, =0x2000B880
    mov     pc, lr

@-------------
@ Inputs: r0 = what to write
@         r1 = what mailbox to write it to
@
@-------------
mailbox_write:
    @ Test lowest 4 bits of r0 are 0
    tst     r0, #0b1111
    movne   pc, lr

    @ Check that r1 is an existing mailbox
    cmp     r1, #15
    movhi   pc, lr

    @ Store registers and return
    stmfd   sp!, {r2-r10, lr}

    @ Set register names and set r0 = mailbox base
    channel .req  r1
    value   .req  r2
    mov     value, r0
    bl      get_mailbox_base
    mailbox .req  r0

    @ Wait until the status of the mailbox is correct
    1:
        status    .req r3
        ldr       status, [mailbox, #0x18]
      
        tst       status, #0x80000000
        .unreq    status
        bne       1b

    @ Add the channel to the value
    add     value, channel
    .unreq  channel

    @ Store the result to the write field
    str     value, [mailbox, #0x20]
    .unreq  value
    .unreq  mailbox

    @ Return
    ldmfd   sp!, {r2-r10, pc}


@-----------
@ Inputs: r0 = which mailbox to read from
@
@-----------
mailbox_read:
    @ Test that r0 is an existing mailbox
    cmp     r0, #15
    movhi   pc, lr


    @ Store registers and return
    stmfd   sp!, {r1-r10, lr}

    @ Set names and get mailbox base
    channel .req  r1
    mov     channel, r0
    bl      get_mailbox_base
    mailbox .req  r0

    1:
        2:
            @ Gets the current status
            status  .req r2
            ldr     status, [mailbox, #0x18]
            
            @ Checks that the 30th bit of status is 0 or waits
            tst     status, #0x40000000
            .unreq  status
            bne     2b
        
        @ Read next mailbox item
        mail    .req r2
        ldr     mail, [mailbox, #0] 

        @ Check that the mail channel is right or goes back
        inchannel .req r3
        and     inchannel, mail, #0b1111
        teq     inchannel, channel
        .unreq  inchannel
        bne     1b


    .unreq  mailbox
    .unreq  channel

    @ Move the answer to r0
    and r0, mail, #0xfffffff0
    .unreq  mail

    @ Return
    ldmfd sp!, {r1-r10, pc}

