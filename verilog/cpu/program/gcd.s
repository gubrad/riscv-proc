.option norvc
.text
.globl _start

_start:
    addi x30, x0, 0       # Error code: 0 = success
    addi x31, x0, 0       # Done flag

    li x1, 5435332       # a = 48
    li x2, 302190       # b = 18
    add x15, x0, x1
    add x16, x0, x2

gcd_loop:
    beq  x1, x2, gcd_done # If a == b, GCD found
    bltu x1, x2, b_smaller

    sub  x1, x1, x2       # a = a - b
    jal  x0, gcd_loop

b_smaller:
    sub  x2, x2, x1       # b = b - a
    jal  x0, gcd_loop

gcd_done:
    addi x17, x1, 0       # GCD result = 6
    addi x31, x0, 1       # Done flag = 1

finish:
    ebreak
    jal  x0, finish       # Stop here
