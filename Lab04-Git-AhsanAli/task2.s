addi x10, x0, 100

jal x1, sum
j end


sum:
addi sp , sp , -8 # adjust stack for 2 items
sw x1 , 4(sp) # save return address
sw x10 , 0(sp) # save argument n

addi x10, x10, -1
bge x10 , x0 , L1  #if (n - 1) >= 0, go to L1

addi x10 , x0 , 0 # return 1
addi sp, sp, 8 # pop stack
jalr x0 , 0(x1) # return

L1:
#addi x10 , x10 , -1 # argument = n - 1
jal x1 , sum # recursive call

addi x6 , x10 , 0 # save result of sum(n -1)
lw x10 , 0(x2) # restore original n
lw x1 , 4(x2) # restore return address
addi sp, sp , 8 # pop stack

add x10 , x10 , x6 
jalr x0 , 0(x1) # return

end: