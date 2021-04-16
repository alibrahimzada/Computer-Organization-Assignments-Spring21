    .data
str:        .asciiz "Input: "
input:      .space 20
newLine:    .asciiz "\n"

    .text
    .globl main

main:
    # Input message
    li $v0, 4
    la $a0, str
    syscall

    li $v0, 8
    la $a0, input
    li $a1, 20
    syscall

    addi $t0, $zero, 0

    while:
        beq $t0, 20, exit
        
        lw $t6, input($t0)

        addi $t0, $t0, 4

        # Prints the current value
        li $v0, 4
        move $a0, $t6
        syscall

        # Prints a new line
        li $v0, 4
        la $a0, newLine
        syscall

        j while
    
    exit:
        li $v0, 10
        syscall


