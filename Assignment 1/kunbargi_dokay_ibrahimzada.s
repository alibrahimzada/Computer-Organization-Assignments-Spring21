    .data

welcome_message:    .asciiz "Welcome to our MIPS project!\n"
main_menu:          .asciiz "\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option: "
q1_enter_string:    .asciiz "\nEnter the String: "
termination:        .asciiz "Program ends. Bye :)"
line_break:         .asciiz "\n"
space:              .ascii " "


    .text
    .globl main

main:
    li $v0, 4
    la $a0, welcome_message
    syscall

main_while:

    li $v0, 4   # print the main menu on standard output
    la $a0, main_menu
    syscall

    li $v0, 5   # get user choice and place it in $v0
    syscall

    add $t0, $v0, $zero   # assign user choice to $t0

case_1:

    addi $t1, $zero, 1   # assign 1 to $1 for case testing
    bne $t0, $t1, case_2   # branch to case 2 if the user did not enter 1

    li $v0, 4   # print string to standard output
    la $a0, q1_enter_string
    syscall

    li $v0, 8   # get string from user
    syscall

    jal q1

    j main_while

case_2:
    addi $t1, $zero, 2
    bne $t0, $t1, case_3

    j main_while

case_3:
    addi $t1, $zero, 3
    bne $t0, $t1, case_4

    j main_while

case_4:
    addi $t1, $zero, 4
    bne $t0, $t1, case_5

    j main_while

case_5:   # if the user choice is not either of 1, 2, 3, and 4, then it should be definitely 5
    li $v0, 4
    la $a0, termination
    syscall

    li $v0, 10   # terminating the process
    syscall

q1:
    addi $sp, $sp, -8   # creating space to preserve the values of arguments
    sw $a0, 4($sp)
    sw $a1, 0($sp)
    addi $sp, $sp, -104   # creating stack frame for english alphabets (26 * 4)

    li $t0, 0
    li $t1, 26

q1_prepare_stack:
    beq $t0, $t1, q1_finish_preparing_stack

    sll $t2, $t0, 2
    add $t2, $t2, $sp
    addi $t3, $t0, 97
    sll $t3, $t3, 24
    sw $t3, 0($t2)

    addi $t0, $t0, 1

    j q1_prepare_stack

q1_finish_preparing_stack:

    move $s0, $a0
    li $t0, 0   # loop variable (i)

q1_count_loop:
    add $t1, $s0, $t0   # &charArray[i]
    li $t2, 0
    lb $t2, 0($t1)   # charArray[i]

    beq $t2, $zero, q1_print   # exit the character is '\0'

    slti $t3, $t2, 65   # checking if the char's ascii code is smaller than 'A' (65)
    bne $t3, $zero, q1_loop_next_iter   # skip to next character if the previous check is true

    slti $t3, $t2, 91   # checking if the character is an uppercase one
    bne $t3, $zero, q1_to_lowercase   # converting character to lower case by adding 32

    li $t4, 122
    slt $t3, $t4, $t2   # checking if the char's ascii code is bigger than 'z' (122)
    bne $t3, $zero, q1_loop_next_iter   # skip to next character if the previous check is true

    and $t5, $t5, $zero
    addi $t5, $t2, -97
    sll $t5, $t5, 2
    add $t5, $t5, $sp
    lw $t6, 0($t5)
    
    srl $t7, $t6, 24
    sll $t7, $t7, 24
    andi $t6, $t6, 0x0FFF
    addi $t6, $t6, 1
    or $t6, $t7, $t6

    sw $t6, 0($t5)
    addi $t0, $t0, 1
    j q1_count_loop

q1_to_lowercase:
    addi $t2, $t2, 32

q1_loop_next_iter:
    addi $t0, $t0, 1
    j q1_count_loop

q1_print:

    li $t0, 0
    li $s1, 26

q1_print_loop:

    beq $t0, $s1, q1_exit

    sll $t1, $t0, 2
    add $t1, $t1, $sp

    lw $t1, 0($t1)

    srl $t2, $t1, 24
    li $v0, 11
    add $a0, $t2, $zero
    syscall

    li $v0, 4
    la $a0, space
    syscall

    andi $t1, $t1, 0x0FFFF
    li $v0, 1
    add $a0, $t1, $zero
    syscall

    li $v0, 4
    la $a0, line_break
    syscall

    addi $t0, $t0, 1
    j q1_print_loop

q1_exit:

    addi $sp, $sp, 104   # removing the created stack frame
    lw $a1, 0($sp)
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
