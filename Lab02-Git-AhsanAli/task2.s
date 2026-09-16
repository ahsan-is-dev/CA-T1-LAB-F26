li x20, 3 # For testing
li x22, 1

addi x1, x0 , 1
addi x2, x0 , 2
addi x3, x0 , 3
addi x4, x0 , 4

beq x20, x1, case1
beq x20, x2, case2
beq x20, x3, case3
beq x20, x4, case4

default:
    addi x21, x0, 0
    beq x0, x0, Exit

case1:
    add x21, x22, x23
    beq x0, x0, Exit

case2:
    sub x21, x22, x23
    beq x0, x0, Exit

case3:
    slli x21, x22, 1
    beq x0, x0, Exit

case4:  
    srli x21, x22, 1
    beq x0, x0, Exit

Exit:
    addi x1, x0, 1