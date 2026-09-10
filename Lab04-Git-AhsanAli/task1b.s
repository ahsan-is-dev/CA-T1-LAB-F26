

addi x10, x0 ,4

jal x1, fact
j end

fact:
    addi x2, x2, 8
    sw x5, -8(x2)
    sw x10, -4(x2)  

    addi, x5, x0, 1
Loop:
    beq x10, x0, exit
    mul x5, x5, x10
    addi x10, x10, -1
    j Loop 
exit:
    lw x5, -8(x2)
    lw x10, -4(x2) 
    addi x2, x2, -8 

    jalr x0, 0(x1)
end: