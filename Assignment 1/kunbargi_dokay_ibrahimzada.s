    .data

welcome_message:    .asciiz "Welcome to our MIPS project!\n"
main_menu:          .asciiz "\n\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option: "
q1_enter_string:    .asciiz "\nEnter the String: "
q3_enter_integer:   .asciiz "\nEnter N between 2 and 1,000,000\n"
q3_output1:         .asciiz "\nprime("
q3_output2:         .asciiz ") is "
termination:        .asciiz "Program ends. Bye :)"
line_break:         .asciiz "\n"
char_occurrence:    .asciiz "Character Occurrence\n"
space:              .asciiz "         "

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

    li $v0, 4   # print string (i.e., Enter the Integer: ) to standard output
    la $a0, q3_enter_integer
    syscall

    # read N from user 
    li $v0, 5
    syscall

    jal q3 # jump to q3 label

    j main_while    # restart with main menu and ask user for input

case_4: # case 4 corresponds to constructing Huffman Code Tree

    addi $t1, $zero, 4  # assign 4 to $t1 for case testing
    bne $t0, $t1, case_5    # branch to case 5 if the user did not enter 4

    j main_while    # restart with main menu and ask user for input

case_5: # if the user choice is not either of 1, 2, 3, and 4, then it should be definitely 5

    li $v0, 4   # print goodbye string
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

    li $t0, 0   # creating a loop variable and initializing it to 0
    li $t1, 26  # creating a variable to to keep the size of alphabet

q1_prepare_stack:   # here we store the ascii code of characters in the upper 8-bit of a word. The order goes from a - z

    beq $t0, $t1, q1_finish_preparing_stack # check loop condition

    sll $t2, $t0, 2 # align the variable by 4 bytes
    add $t2, $t2, $sp   # add to stack base in order to get the exact location
    addi $t3, $t0, 97   # store the decimal value of ascii character. 97 is for a which is the starting point.
    sll $t3, $t3, 24    # move the lower 8-bits to upper 8-bits
    sw $t3, 0($t2)  # store the calculated value in stack

    addi $t0, $t0, 1    # increase loop variable

    j q1_prepare_stack  # start from the beginning of loop again until i is 26

q1_finish_preparing_stack:  # at this point the stack is ready

    move $s0, $a0
    li $t0, 0   # loop variable (i)

q1_count_loop:  # this loop is used to go over each character in string and increment its frequency in stack

    add $t1, $s0, $t0   # &charArray[i]
    li $t2, 0
    lb $t2, 0($t1)   # charArray[i]

    beq $t2, $zero, q1_print   # exit if the character is '\0'

    slti $t3, $t2, 65   # checking if the char's ascii code is smaller than 'A' (65)
    bne $t3, $zero, q1_loop_next_iter   # skip to next character if the previous check is true

    li $t4, 122
    slt $t3, $t4, $t2   # checking if the char's ascii code is bigger than 'z' (122)
    bne $t3, $zero, q1_loop_next_iter   # skip to next character if the previous check is true

    slti $t3, $t2, 91   # checking if the character is an uppercase one
    bne $t3, $zero, q1_to_lowercase   # converting character to lower case by adding 32

    slti $t3, $t2, 97   # checking the character ascii is between [91, 96], if so skip to next loop iteration
    bne $t3, $zero, q1_loop_next_iter

q1_count_loop_cont: # continue from here if we encountered an uppercase letter, and did the conversion to lowercase

    and $t5, $t5, $zero # zero out the $t5 register
    addi $t5, $t2, -97  # assigning the order value to $t5. i.e. for 'a' the order is 0 since it is in the beginning
    sll $t5, $t5, 2 # aligning the order value by multiplying with 4
    add $t5, $t5, $sp   # add $t5 with $sp to get the exact location for incrementing
    lw $t6, 0($t5)  # load the current state of frequency for a character
    
    srl $t7, $t6, 24    # mask the lower 24-bits
    sll $t7, $t7, 24
    andi $t6, $t6, 0x0FFF   # mask the upper 8-bits
    addi $t6, $t6, 1    # increment the characters frequency
    or $t6, $t7, $t6    # combine the frequency and character info again

    sw $t6, 0($t5)  # store the updated value to stack
    addi $t0, $t0, 1    # increment loop variable
    j q1_count_loop # start from the beginnging of the loop until we reach the '\0'

q1_to_lowercase:    # this is used to change the uppercase alphabet to lowercase one
    addi $t2, $t2, 32
    j q1_count_loop_cont

q1_loop_next_iter:  # this is used to increment the loop variable because we skipped the current iteration
    addi $t0, $t0, 1
    j q1_count_loop

q1_print:   # we use this to print the sorted frequencies from stack

    ### necessary calls to sorting should be made here
    add $a0, $sp, $zero
    li $a1, 0
    addi $a1, $a1, 26

    jal isort

    li $v0, 4   # print the header (i.e., character     occurrence)
    la $a0, char_occurrence
    syscall

    li $t0, 25   # initialize loop variable with 26

q1_print_loop:

    beq $t0, $zero, q1_exit   # check if we have printed all possible alphabets

    sll $t1, $t0, 2 # align the loop variable with 4 bytes
    add $t1, $t1, $sp   # get the specific address from stack

    lw $t1, 0($t1)  # load the data from that address

    andi $t3, $t1, 0x0FFF   # mask out the upper 8-bits and check if frequency is 0, if so then skip to next iteration
    beq $t3, $zero, q1_print_loop_skip

    srl $t2, $t1, 24    # get the ascii code from the upper 8-bits and print it
    li $v0, 11
    add $a0, $t2, $zero
    syscall

    li $v0, 4   # print space between char and count
    la $a0, space
    syscall

    li $v0, 1   # print the occurrence of the corresponding character
    add $a0, $t3, $zero
    syscall

    li $v0, 4   # print line break
    la $a0, line_break
    syscall

    addi $t0, $t0, -1    # decrement the loop variable and continue with next iteration
    j q1_print_loop

q1_print_loop_skip: # here we decrement the loop variable and start from the beginning of the loop

    addi $t0, $t0, -1
    j q1_print_loop

q1_exit:    # here marks the end of question 1

    addi $sp, $sp, 104   # removing the created stack frame
    lw $a1, 0($sp)  # restore the arguments from stack
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    j main_while  # jump back to main menu loop

# selection_sort
isort:		addi	$sp, $sp, -4		# save values on stack
		sw	$ra, 0($sp)

		move 	$s0, $a0		# base address of the array
		move	$s1, $zero		# i=0

		addi	$s2, $a1, -1		# lenght -1

isort_for:	bge 	$s1, $s2, isort_exit	# if i >= length-1 -> exit loop
		
		move	$a0, $s0		# base address
		move	$a1, $s1		# i
		move	$a2, $s2		# length - 1
		
		jal	mini
		move	$s3, $v0		# return value of mini
		
		move	$a0, $s0		# array
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	swap

		addi	$s1, $s1, 1		# i += 1
		j	isort_for		# go back to the beginning of the loop
		
isort_exit:	lw	$ra, 0($sp)		# restore values from stack
		addi	$sp, $sp, 4		# restore stack pointer
		jr	$ra			# return


# index_minimum routine
mini:		move	$t0, $a0		# base of the array
		move	$t1, $a1		# mini = first = i
		move	$t2, $a2		# last
		
		sll	$t3, $t1, 2		# first * 4
		add	$t3, $t3, $t0		# index = base array + first * 4		
		lw	$t4, 0($t3)		# min = v[first]

        ### the following instruction is specific to Q1
        andi $t4, $t4, 0x0FFF
        ###
		
		addi	$t5, $t1, 1		# i = 0
mini_for:	bgt	$t5, $t2, mini_end	# go to min_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# index = base array + i * 4		
		lw	$t7, 0($t6)		# v[index]

        ### the following instruction is specific to Q1
        andi $t7, $t7, 0x0FFF
        ###

		bge	$t7, $t4, mini_if_exit	# skip the if when v[i] >= min
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# min = v[i]

mini_if_exit:	addi	$t5, $t5, 1		# i += 1
		j	mini_for

mini_end:	move 	$v0, $t1		# return mini
		jr	$ra


# swap routine
swap:		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw	$t3, 0($t2)		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra

q3:
    add $s0, $zero, $zero # False variable
    addi $s1, $zero, 1 # True variable
    add $s2, $zero, $zero # prime counter variable
    add	$s3, $sp, 0 # save bottom of stack address in $s3

    add $t0, $v0, $zero # N -> $t0
    li $t1, 2 # counter p -> $t1

# initilize array with ones in stack 
q3_array:
    sw	$s1, ($sp)	# write ones to the stackpointer's address
	addi $t1, $t1, 1	# increment counter variable
	addi $sp, $sp, -4	# subtract 4 bytes from stackpointer (push)
	ble	$t1, $t0, q3_array	# take loop while $t1 <= $t0 ( p <= N )

    li $t1, 1 # counter p reseted to 1
    
q3_outer_while:
    addi $t1, $t1, 1 # increment p at each iteration
    mul $t2, $t1, $t1 # save  p * p -> $t2
    bgt $t2, $t0, q3_precounter # exit loop if p*p > N 

    add	$t4, $s3, $zero	# save the bottom of stack address to $t4
	mul	$t3, $t1, 4	# calculate the number of bytes to jump over t1=p
	sub	$t4, $t4, $t3	# subtract them from bottom of stack address, save prime[p] -> t4
	add	$t4, $t4, 8	# add 2 words, we started counting from 2

	lw	$t3, ($t4)	# load the content into $t3
	beq	$t3, $s1, q3_inner_for	# go to the inner loop if prime[p] == true
    
    j q3_outer_while

q3_inner_for:
    #for i in range(p * p, n+1, p):
    #       prime[i] = False
    add	$t4, $s3, 0	# save the bottom of stack address -> $t4
	mul	$t3, $t2, 4	# calculate the number of bytes to jump over
	sub	$t4, $t4, $t3	# subtract them from bottom of stack address
	add	$t4, $t4, 8	# add 2 words, we started counting from 2

	sw	$s0, ($t4)	# store false there ( 0's ) because it's not a prime number

	add	$t2, $t2, $t1	# keep doing this for every multiple of $t1
     
	ble $t2, $t0, q3_inner_for # stay in loop while ( p*p <= N )

    j q3_outer_while # go back to outer loop when all multiples are done

q3_precounter:
    li $t9, 1 # set counter variable to 1

q3_counter:

    add	$t4, $s3, 0	# save the bottom of stack address to $t4
	mul	$t3, $t9, 4	# calculate the number of bytes to jump over t1=p
	sub	$t4, $t4, $t3	# subtract them from bottom of stack address save prime[p] in t4
	add	$t4, $t4, 8	# add 2 words, we started counting from 2

	lw	$t3, ($t4)	# load the content into $t3
    addi $t9, $t9, 1 # increament t9

	beq	$t3, $s1, q3_if_counter	# increment prime counter if prime[p] == true

    bgt $t9, $t0, q3_exit # jump to exit if t9 > N
    j q3_counter 

q3_if_counter:

    addi $s2, $s2, 1 # increment prime counter
    j q3_counter # go back

q3_exit:	

    #print output
    li $v0, 4
    la $a0, q3_output1
    syscall

    li $v0, 1
    add $a0, $t0, 0
    syscall

    li $v0, 4
    la $a0, q3_output2
    syscall

    # print prime counter
	li	$v0, 1		
	add	$a0, $s2, 0	
	syscall		

    jr	$ra		# exit q3
