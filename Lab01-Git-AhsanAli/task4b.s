main:
    li x20, 0x78786464
    li x21, 0x7878
    li x22, 0x1919
    li x23, 0xA8A8

    sw x20, 0x100(x0)
    sh x20, 0x200(x0)
    sh x21, 0x202(x0)
    sh x22, 0x204(x0)
    sh x23, 0x206(x0)
    
    # For loop 1st iteration:
    lb x1, 0x100(x0)
    lhu x2, 0x200(x0)
    add x3, x1, x2
    sw x3, 0x300(x0)

    # For loop 2nd iteration:
    lb x1, 0x101(x0)
    lhu x2, 0x202(x0)
    add x3, x1, x2
    sw x3, 0x304(x0)

    # For loop 3rd iteration:
    lb x1, 0x102(x0)
    lhu x2, 0x204(x0)
    add x3, x1, x2
    sw x3, 0x308(x0)

    # For loop 4th iteration:
    lb x1, 0x103(x0)
    lhu x2, 0x206(x0)
    add x3, x1, x2
    sw x3, 0x30C(x0)

end:
    j end

