# Assuming D is a character array
li x7, 0  # i
li x29, 0 # j

li x5, 2
li x6, 3
li x10, 0x100  # dummy base address

Loop1:
    bge x7, x5, Exit
    Loop2:
        bge x29, x6, reset
        slli x20, x29, 2
        add x21, x7, x29
        add x11, x10, x20 # Array address
        sb x21, 0(x11)
        addi x29, x29, 1
        beq x0, x0, Loop2

    reset:
        addi x7, x7, 1
        li x29, 0
        beq x0, x0, Loop1

Exit:
    end:
        j end 