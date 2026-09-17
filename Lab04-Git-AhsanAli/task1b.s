

addi x10, x0 ,4

jal x1, fact
j end

fact:
    addi sp, sp, -8
    sw x5, 0(sp)
    sw x10, 4(sp)  

    addi x5, x0, 1
Loop:
    beq x10, x0, exit
    mul x5, x5, x10
    addi x10, x10, -1
    j Loop 
exit:
    lw x5, 0(sp)
    lw x10, 4(sp) 
    addi sp, sp, 8

    jalr x0, 0(x1)
end: