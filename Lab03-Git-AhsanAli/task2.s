
addi x10,x0,14 #g
addi x11,x0,14 #h
addi x12,x0,12 #i
addi x13,x0,12 #j



jal x1,leaf_example #calls the function named sum
addi x11,x10,0
li x10,1
ecall
j exit

leaf_example:
    addi x2, x2, -12    #adjusting stack pointer (3*4 bytes)
    sw x18, 8(x2)      
    sw x19, 4(x2)       
    sw x20, 0(x2)         

    add x18, x10, x11   # g + h 
    add x19, x12, x13   # i + j 
    sub x20, x18, x19   # (g + h) - (i + j)
    add x10, x20, x0    

    lw x20, 0(x2)      
    lw x19, 4(x2)      
    lw x18, 8(x2)     
    addi x2, x2, 12    

    jalr x0, 0(x1)      #return to the calling function
exit: