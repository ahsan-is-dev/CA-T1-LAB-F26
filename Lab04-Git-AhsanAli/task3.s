# Bubble Sort implemented in Assembly code 

li x5, 0x100        # x5 = starting memory address
li x1, 23
sw x1, 0(x5)

li x1, 12
sw x1, 4(x5)
li x1, 5
sw x1, 8(x5)
li x1, 44
sw x1, 12(x5)
li x1, 98
sw x1, 16(x5)
li x1, 53
sw x1, 20(x5)
li x1, 6
sw x1, 24(x5)
li x1, 89
sw x1, 28(x5)
li x1, 32
sw x1, 32(x5)
li x1, 65
sw x1, 36(x5)



li x20, 10
li x22, 1 # swapped
li x30, 1

start:
    li x21, 1 # i
    li x22,0
    ForLoop:
        bge x21, x20, WhileLoop
        slli x3, x21, 2
        addi x4, x3, -4
        lw x1, 0x100(x3)
        lw x2, 0x100(x4)
        bge x1, x2, continue
        sw x1, 0x100(x4)
        sw x2, 0x100(x3)
        li x22,1
        continue:
            addi x21, x21, 1
            beq x0,x0,ForLoop
    WhileLoop:
        beq x22, x30, start


Exit:
    li x7, 109



