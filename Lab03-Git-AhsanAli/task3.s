li x5, 0x00006464
sb x5, 0x100(x0)
sw x5, 0x104(x0)

li x10, 0x100
li x11, 0

jal x1, swap,
addi x11,x10,0
li x10,1
ecall
j exit

swap:
    addi x2, x0, 0
    addi x2, x2, 16
    sw x10, -16(x2)
    sw x11, -12(x2)
    sw x18, -8(x2)
    
    #sw x19, -4(x2)

    slli x11, x11, 2  # offset
    add x18, x10, x11 # base address + offset
    lw x11, 0(x18)
    lw x10, 4(x18)

    sw x11, 4(x18)
    sw x10, 0(x18) 

    lw x10, -16(x2)
    lw x11, -12(x2)
    lw x18, -8(x2)
    #lw x19, -4(x2)

    addi x2, x2, -16

    jalr x0, 0(x1)

exit: