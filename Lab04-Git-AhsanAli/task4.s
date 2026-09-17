# This program takes an array, sorts it and 
# then find index of an element using recursive binary search.


li x8, 0x300 

li x7, 7
sw x7, 0(x8)
li x7, 2
sw x7, 4(x8)
li x7, 9
sw x7, 8(x8)
li x7, 1
sw x7, 12(x8)
li x7, 4
sw x7, 16(x8)
li x7, 6
sw x7, 20(x8)

main:

    addi x10, x8, 0             # base address
    addi x11, x0, 6             # length of array

    addi sp, sp, -4             # for x1
    sw x1, 0(sp)

    jal x1, sort

    lw x1, 0(sp)        # save return addr
    addi sp, sp, 4

    # arg for binary search
    addi x10, x8, 0             # base addr
    addi x11, x0, 0             # low
    addi x12, x0, 5             # high 
    addi x13, x0, 6             # target

    addi sp, sp, -4
    sw x1, 0(sp)

    jal x1, binary_search       

    lw x1, 0(sp)
    addi sp, sp, 4

    j end


# sort(base addr, length)
# Uses selection sort 
sort:
    addi sp, sp, -16            
    sw x1,  12(sp)              
    sw x9,   8(sp)             
    sw x18,  4(sp)              
    sw x19,  0(sp)              

    addi x18, x10, 0            # base addr array
    addi x9,  x0,  0            # i = 0
    addi x19, x11, 0            # length of array

outer_loop:
    bge x9, x19, sort_done      # i >= length? 

    addi x5, x9, 0              # min_index = 1
    addi x6, x9, 1              # start = i + 1

inner_loop:  # Finds minimum value index
    bge x6, x19, do_swap        # start >= length? do the swap

    slli x7, x6, 2              #  start * 4
    add  x7, x18, x7            # addr of array[start]
    lw   x7, 0(x7)              # array[start]

    slli x28, x5, 2             # min_index * 4
    add  x28, x18, x28          # addr of array[min_index]
    lw   x28, 0(x28)            # array[min_index]

    bge x7, x28, skip_update    # array[start] >= array[min_index] then skip
    addi x5, x6, 0              # else min_index = start

skip_update:
    addi x6, x6, 1              # start++
    j inner_loop

do_swap:
    beq x5, x9, next_i          # min_index == i? skip swap

    slli x10, x9, 2
    add  x10, x18, x10          

    slli x11, x5, 2
    add  x11, x18, x11          

    jal x1, swap                # swap both

next_i:
    addi x9, x9, 1              # i++
    j outer_loop # Continue selection sort

sort_done:
    lw x1,  12(sp)              # restoring all registers here
    lw x9,   8(sp)             
    lw x18,  4(sp)          
    lw x19,  0(sp)              
    addi sp, sp, 16             
    jalr x0, 0(x1)             


# swap(addr1, addr2)
swap:
    lw x5, 0(x10)               # t0 = *addr1
    lw x6, 0(x11)               # t1 = *addr2
    sw x6, 0(x10)               # *addr1 = t1
    sw x5, 0(x11)               # *addr2 = t0
    jalr x0, 0(x1)              # return


# binary_search(base addr, low, high, target)
# Returns index, if not found then -1
binary_search:
    addi sp, sp, -20            # save all arguments
    sw x1,  16(sp)              
    sw x10, 12(sp)              
    sw x11,  8(sp)              
    sw x12,  4(sp)              
    sw x13,  0(sp)              

    blt x11, x12, compute_mid   # low < high, continue with search
    beq x11, x12, compute_mid   # low == high, continue as well
    # not found
    addi x10, x0, -1            # returning -1
    j bs_return

compute_mid:
    add  x5, x11, x12           # low + high
    srai x5, x5, 1              # mid = (low + high) / 2

    slli x6, x5, 2              # mid * 4
    add  x6, x10, x6          
    lw   x6, 0(x6)              # array[mid]

    beq x6, x13, found          # array[mid] == target? found

    bge x13, x6, go_right       # search right

go_left:
    lw  x10, 12(sp)             # restore base addr, low and target
    lw  x11,  8(sp)            
    addi x12, x5, -1            # high = mid - 1
    lw  x13,  0(sp)            
    jal x1, binary_search
    j bs_return

go_right:
    lw  x10, 12(sp)             # restore base addr, high, and target
    addi x11, x5, 1             # low = mid + 1
    lw  x12,  4(sp)             
    lw  x13,  0(sp)             
    jal x1, binary_search
    j bs_return

found:
    addi x10, x5, 0             # index of found

bs_return:
    lw x1, 16(sp)              
    addi sp, sp, 20            
    jalr x0, 0(x1)              
end: