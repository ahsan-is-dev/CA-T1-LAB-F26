
main:
    addi x20, x0, 5    # a=5
    addi x21, x0, 0    # b = 0 + 0 for adding constants: addi x21, x0, 0
    addi x20, x21, 32  # a = b + 32
    add x1, x20, x21   # d = a + b
    addi x22, x1, -5   # d = (a + b) -5

    sub x2, x20, x22   #  a - d
    sub x3, x21, x20   #  b - a 
    add x4, x2, x3     # e = (a-d) + (b-a) 
    add x4, x4, x22    # e = e + d

    add x5, x20, x21
    add x5, x5, x22
    add x4, x5, x4  # e = a + b + d + e;


end:
    j end