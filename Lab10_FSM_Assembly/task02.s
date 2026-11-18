
.text
.globl RESET_INIT

# 1. SYSTEM INITIALIZATION & RESET STATE
# initialize stack pointer and memory-mapped I/O base addresses for peripherals.

RESET_INIT:
    addi x2, x0, 252
    addi x18, x0, 512
    addi x19, x0, 256
    addi x20, x0, 768
    addi x9, x0, 0

# 2. STATE S0: INPUT WAITING STATE (IDLE)
# continuously clear LEDs and poll switches until a non-zero input is detected.

INPUT_WAIT_STATE:
    addi x8, x0, 0
    sw   x0, 0(x19)
    lw   x5, 0(x18)
    beq  x5, x0, INPUT_WAIT_STATE   # While testing, I changed x5 value to 3 before executing this statement

# 3. STATE S1: COUNTDOWN STATE
# update fsm state and pass captured switch value to the countdown subroutine.

COUNTDOWN_STATE:    
    addi x8, x0, 1
    add  x10, x5, x0
    jal  x1, COUNTDOWN_SUB
    beq  x0, x0, INPUT_WAIT_STATE

# 4. SUBROUTINE: COUNTDOWN_SUB
# allocate stack space, decrement counter to zero, and handle early reset.

COUNTDOWN_SUB:
    addi x2, x2, -12
    sw   x1, 8(x2)
    sw   x8, 4(x2)
    sw   x9, 0(x2)
    add  x9, x10, x0

COUNTDOWN_LOOP:
    sw   x9, 0(x19)
    lw   x6, 0(x20)
    bne  x6, x0, EXIT_COUNTDOWN
    jal  x1, DELAY_LOOP_INIT
    bne  x6, x0, EXIT_COUNTDOWN
    addi x9, x9, -1
    bne  x9, x0, COUNTDOWN_LOOP

EXIT_COUNTDOWN:
    addi x9, x0, 0
    sw   x0, 0(x19)
    lw   x9, 0(x2)
    lw   x8, 4(x2)
    lw   x1, 8(x2)
    addi x2, x2, 12
    jalr x0, x1, 0

# 5. SUBROUTINE: 10 MHz DELAY & RESET POLLING
# execute a 1 second hardware delay loop while continuously checking for reset.

DELAY_LOOP_INIT:
    lui  x7, 0x262     # Comment out for venus testing
    addi x7, x7, 0x5A0   # Comment out for venus testing
    # addi x7, x0, 2        # Uncomment for venus testing

DELAY_LOOP:
    lw   x6, 0(x20)
    bne  x6, x0, DELAY_EXIT
    addi x7, x7, -1
    bne  x7, x0, DELAY_LOOP

DELAY_EXIT:
    jalr x0, x1, 0