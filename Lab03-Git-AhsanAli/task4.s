
li, x22, 0x100  # x array address
li, x23, 0x200  # y array address

li x1, 0x666F7572
sw x1, 0(x23)

li x21, 0   # i

jal x1, strcpy
ecall
j exit

strcpy:
    add x18, x23, x21  # Base Address y + offset
    lb x5, 0(x18)
    add x18, x22, x21    # Base Address x + offset
    sb x5, 0(x18)
    beq x5, x0, end
    addi x21, x21, 1
    beq x0, x0, strcpy
end:
    jalr x0, 0(x1)

exit:
