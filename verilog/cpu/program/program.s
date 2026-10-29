
.option norvc
.text
.globl _start

_start:
    # Initialize
    addi x30, x0, 0       # Error code: 0 = success
    addi x31, x0, 0       # Completion flag

    # Arithmetic
    addi x1, x0, 12       # x1 = 12
    addi x2, x0, 5        # x2 = 5
    add  x3, x1, x2       # x3 = 17
    sub  x4, x1, x2       # x4 = 7

    # Logical operations
    and  x5, x1, x2       # x5 = 4
    or   x6, x1, x2       # x6 = 13
    xor  x7, x1, x2       # x7 = 9

    # Shifts
    slli x8, x2, 2        # x8 = 20
    srli x9, x1, 1        # x9 = 6

    addi x11, x0, -8      # x11 = -8
    srai x12, x11, 1      # x12 = -4
    srli x13, x11, 1      # x13 = 0x7ffffffc

    # Comparisons
    slt  x14, x11, x1     # x14 = 1 (signed -8 < 12)
    sltu x15, x11, x1     # x15 = 0 (unsigned comparison)

    # Store and load
    addi x16, x0, 256     # Data memory address = 256
    sw   x3, 0(x16)       # RAM[64] = 17
    lw   x17, 0(x16)      # x17 = 17

    # BEQ: should be taken
    beq  x3, x17, test_bne
    addi x30, x0, 1       # Error 1: BEQ failed

test_bne:
    # BNE: should be taken
    bne  x1, x2, test_blt
    addi x30, x0, 2       # Error 2: BNE failed

test_blt:
    # BLT: signed -8 < 12, should be taken
    blt  x11, x1, test_bge
    addi x30, x0, 3       # Error 3: BLT failed

test_bge:
    # BGE: signed 12 >= -8, should be taken
    bge  x1, x11, test_bltu
    addi x30, x0, 4       # Error 4: BGE failed

test_bltu:
    # BLTU: unsigned 0xfffffff8 < 12 is false
    bltu x11, x1, fail_bltu
    jal  x0, test_jal

fail_bltu:
    addi x30, x0, 5       # Error 5: BLTU incorrectly taken

test_jal:
    # JAL should skip the next instruction
    jal  x19, jal_target
    addi x30, x0, 6       # Error 6: JAL failed

jal_target:
    # x19 should contain the address after JAL

    # Mark successful completion
    addi x31, x0, 1

finish:
    ebreak
    jal  x0, finish       # Infinite loop

