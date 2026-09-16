li x22, 0 # 1st loop counter
li x23, 0 # 2nd loop counter
li x24, 0 # sum
li x1, 10 # loop limit

Loop1:
    slli x2, x22, 2
    bge x22, x1, Loop2
    sw x22, 0x200(x2)
    addi x22, x22, 1
    beq x0, x0, Loop1

Loop2:
    slli x2, x23, 2
    bge x23, x1, Exit
    lw x3, 0x200(x2)
    add x24, x24, x3
    addi x23, x23, 1
    beq x0, x0, Loop2

Exit:
    end:
        j end
    