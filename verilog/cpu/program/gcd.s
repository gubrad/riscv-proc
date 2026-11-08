.option norvc
.text
.globl _start
.align 2

_start:
    la x1, number1
    la x2, number2
    lw x1, 0(x1)
    lw x2, 0(x2)
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
    addi x17, x1, 0       # GCD result
    addi x31, x0, 1       # Done flag = 1
    la x1, result
    sw x17, 0(x1)

    ebreak

.data
.align 2
number1:
    .word 123824

number2:
    .word 654548

result:
    .word 0
