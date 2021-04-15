    .data

welcome_message:    .asciiz "Welcome to our MIPS project!\n"
main_menu:          .asciiz "\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option: "
q1_enter_string:    .asciiz "\nEnter the String: "
termination:        .asciiz "Program ends. Bye :)"
line_break:         .asciiz "\n"
char_occurrence:    .asciiz "Character Occurrence\n"
space:              .asciiz " "

    .text
    .globl main

main:   # this is the starting point of the program

    li $v0, 4   # printing the welcome message on standard output
    la $a0, welcome_message
    syscall

main_while: # this is an inifinite loop which keeps the program running until user chooses 5 to Exit

    li $v0, 4   # print the main menu on standard output
    la $a0, main_menu
    syscall

    li $v0, 5   # get user choice and place it in $v0
    syscall

    add $t0, $v0, $zero # assign user choice to $t0

case_1: # case 1 corresponds to counting occurrences of a character in a string

    addi $t1, $zero, 1   # assign 1 to $t1 for case testing
    bne $t0, $t1, case_2   # branch to case 2 if the user did not enter 1

    li $v0, 4   # print string (i.e., Enter the String: ) to standard output
    la $a0, q1_enter_string
    syscall

    li $v0, 8   # get string from user and place it in $a0
    syscall

    jal q1  # jump to q1 label

    j main_while    # restart with main menu and ask user for input

case_2: # case 2 corresponds to sorting a sequence of unordered numbers in a string

    addi $t1, $zero, 2  # assign 2 to $t1 for case testing
    bne $t0, $t1, case_3    # branch to case 3 if the user did not enter 2

    ### Alper please do the necessary input taking and calling q2 below (check case 1 for reference)

    ### Alper please finish your code before this line

    j main_while    # restart with main menu and ask user for input

case_3: # case 3 corresponds to finding the number of prime numbers

    addi $t1, $zero, 3  # assign 3 to $t1 for case testing
    bne $t0, $t1, case_4    # branch to case 4 if the user did not enter 3

    ### Sameeh please do the necessary input taking and calling q3 below (check case 1 for reference)

    ### Sameeh please finish your code before this line

    j main_while    # restart with main menu and ask user for input

case_4: # case 4 corresponds to constructing Huffman Code Tree

    addi $t1, $zero, 4  # assign 4 to $t1 for case testing
    bne $t0, $t1, case_5    # branch to case 5 if the user did not enter 4

    j main_while    # restart with main menu and ask user for input

case_5: # if the user choice is not either of 1, 2, 3, and 4, then it should be definitely 5

    li $v0, 4   # print goodbye state
    la $a0, termination
    syscall

    li $v0, 10  # terminating the process
    syscall
    
    # end of program

q1:
    addi $sp, $sp, -8   # creating space to preserve the values of arguments (i.e., $a0, $a1, etc.)
    sw $a0, 4($sp)  # pushing arguments to stack
    sw $a1, 0($sp)
    addi $sp, $sp, -104   # creating stack frame for english alphabets (26 * 4 = 104 bytes)

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
    #move $a0, $sp
    #li $a1, 26
    #jal isort

    li $v0, 4
    la $a0, char_occurrence
    syscall

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

isort:
    addi $sp, $sp, -4
    sw	$ra, 0($sp)

    add $s0, $a0, $zero
    li $s1, 0

    addi $s2, $a1, -1

isort_for:
    bge $s1, $s2, isort_exit	# if i >= length-1 -> exit loop
		
    move $a0, $s0		# base address
    move $a1, $s1		# i
    move $a2, $s2		# length - 1
    
    jal	mini
    move	$s3, $v0		# return value of mini
    
    move	$a0, $s0		# array
    move	$a1, $s1		# i
    move	$a2, $s3		# mini
    
    jal	swap

    addi	$s1, $s1, 1		# i += 1
    j	isort_for		# go back to the beginning of the loop
		
isort_exit:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

mini:

    add $t0, $a0, $zero		# base of the array
    add $t1, $a1, $zero		# mini = first = i
    add $t2, $a2, $zero		# last
    
    sll	$t3, $t1, 2		# first * 4
    add	$t3, $t3, $t0		# index = base array + first * 4		
    lw	$t4, 0($t3)		# min = v[first]
    
    addi	$t5, $t1, 1		# i = 0

mini_for:

    bgt	$t5, $t2, mini_end	# go to min_end

	sll	$t6, $t5, 2		# i * 4
	add	$t6, $t6, $t0		# index = base array + i * 4		
	lw	$t7, 0($t6)		# v[index]

	bge	$t7, $t4, mini_if_exit	# skip the if when v[i] >= min
		
	move	$t1, $t5		# mini = i
	move	$t4, $t7		# min = v[i]

mini_if_exit:

    addi $t5, $t5, 1		# i += 1
	j mini_for

mini_end:
    move $v0, $t1		# return mini
	jr	$ra

swap:

    sll	$t1, $a1, 2		# i * 4
    add	$t1, $a0, $t1		# v + i * 4
    
    sll	$t2, $a2, 2		# j * 4
    add	$t2, $a0, $t2		# v + j * 4

    lw	$t0, 0($t1)		# v[i]
    lw	$t3, 0($t2)		# v[j]

    sw	$t3, 0($t1)		# v[i] = v[j]
    sw	$t0, 0($t2)		# v[j] = $t0

    jr	$ra
