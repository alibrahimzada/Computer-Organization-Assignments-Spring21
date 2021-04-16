    .data

welcome_message:    .asciiz "Welcome to our MIPS project!\n"
main_menu:          .asciiz "\n\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option: "
q1_enter_string:    .asciiz "\nEnter the String: "
q2_enter_string:    .asciiz "\nInput: "
q2_output_string:   .asciiz "Output: "
q3_enter_integer:   .asciiz "\nEnter N between 2 and 1,000,000\n"
q3_output1:         .asciiz "\nprime("
q3_output2:         .asciiz ") is "
q4_enter_string:    .asciiz "\nEnter the string to construct Huffman Code: "
q4_enter_string_convert:    .asciiz "\nEnter the string to be converted using Huffman Code: "
termination:        .asciiz "Program ends. Bye :)"
line_break:         .asciiz "\n"
char_occurrence:    .asciiz "Character Occurrence\n"
space:              .asciiz "         "
space_by_1:              .ascii " "

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

    li $v0, 4   # print string to standard output
    la $a0, q2_enter_string
    syscall

    li $v0, 8   # get string from user
    syscall

    jal q2

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

    li $v0, 4   # print string (i.e., Enter the string to construct Huffman Coding) to standard output
    la $a0, q4_enter_string
    syscall

    li $v0, 8
    syscall

    move $t0, $a0

    li $v0, 4   # print string (i.e., Enter the string to convert) to standard output
    la $a0, q4_enter_string_convert
    syscall

    li $v0, 8
    syscall

    move $a1, $a0
    move $a0, $t0

    jal q4

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

    add $a0, $sp, $zero
    li $a1, 0
    addi $a1, $a1, 26
    li $a2, 0

    jal sort_algorithm

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


# Initiation of q2
q2:
    addi $sp, $sp, -8   # creating space to preserve the values of arguments
    sw $a0, 4($sp)
    sw $a1, 0($sp)

    move  $s0, $a0  # get string to $s0

    # definitions
    li $t0, 0   # loop variable (i)
    li $t3, 0   # to keep the length of substring 1 54 108
    li $t4, 0   # to store the array
    li $t6, 1   # multiplier
    li $t8, 10  # just number
    li $s2, 0   # number of elements
    li $s3, 0   # is negative
    j q2_create_stack  # calling create stack func

# Here we start reading string and filling the stack with numbers by converting them to integer
q2_create_stack:
    add $t1, $s0, $t0   # &charArray[i]
    li $t2, 0
    lb $t2, 0($t1)   # charArray[i]

    slti $t9, $t2, 31   # checking if the given value is smaller than 31 as ASCII character, if it ignore it
    bne $t9, $zero, q2_convert_to_integer_last   # it means it is the end of string, go to the last operation

    beq $t2, 45, q2_activate_negative  # if there is a dash inside the substring, make the $s3 1 to get negativity
    beq $t2, 32, q2_convert_to_integer # if it sees a space, stop getting more, and call the conversion func

    j q2_store_value  # call store func

# This is the place where we active the register s3 for a while to check the negativity
q2_activate_negative:
    li $s3, 1  # make the variable s3 1 so that we can check negativity before we cumulatively sum the number 
    addi $t0, $t0, 1  # increment the loop counter
    j q2_create_stack  # get back to the loop

# This is the place where we push the new character to stack
q2_store_value:
    addi $sp, $sp, -4  # create a new space in stack
    sw $t2, 0($sp)  # assign that number to stack in ASCII form

    j q2_outer_loop_next_iter  # call loop increment func

# Increment the loop counter and the length of substring
q2_outer_loop_next_iter:
    addi $t0, $t0, 1  # increment the loop counter
    addi $t3, $t3, 1  # increment the length of substring
    j q2_create_stack  # get back to the loop

# This is the function converts the ascii consecutive numbers to integer    		
q2_convert_to_integer:
    beq $t3, $zero, q2_check_negativity  # once it is done, go to the check negativity func

    lw $t4, 0($sp)
    addi $t4, $t4, -48  # substract 48 from the ascii value to get the real integer value

    mul $t7, $t6, $t4  # multiply the number with its coefficient. (e.g 1, 10, 100)

    add $t5, $t5, $t7 # add the multiplied value to the total sum

    mul $t6, $t6, $t8  # multiply the coefficient by 10
    
    addi $t3, $t3, -1  # decrement the length (aka loop counter here)
    addi $sp, $sp, 4  # go up in stack to get the next value (it reads from right to left)
    j q2_convert_to_integer  # get back to the beginning

# Here is the place where we check negativity
q2_check_negativity:
    beq $s3, 1, q2_make_negative  # if negatve, call negative
    j q2_save_value  # if not, go directly to the save_value func

# Here is the place where we make the number negative
q2_make_negative:
    sub $t5, $zero, $t5  # substract the value from 0 to get its negative value
    j q2_save_value  # call save_value func

# Here is the place where we save the whole number get by the characters
q2_save_value:
    addi $sp, $sp, -4  # go one level down to create space for the real integer number
    sw $t5, 0($sp)  # store the number
    
    # resetting the registers
    li $t5, 0
    li $t4, 0   # to store the element
    li $t6, 1
    li $t8, 10
    li $s3, 0
    addi $s2, $s2, 1  # increment the number of elements in total given in string
    addi $t0, $t0, 1  # incrementing the loop counter
    j q2_create_stack  # get back to the loop

# This is the function converts the ascii consecutive numbers to integer for the last number
q2_convert_to_integer_last:
    beq $t3, $zero, q2_check_negativity_last # once it is done, go to the check negativity func
    
    lw $t4, 0($sp)
    addi $t4, $t4, -48 # substract 48 from the ascii value to get the real integer value

    mul $t7, $t6, $t4 # multiply the number with its coefficient. (e.g 1, 10, 100)

    add $t5, $t5, $t7 # add the multiplied value to the total sum

    mul $t6, $t6, $t8 # multiply the coefficient by 10
    
    addi $t3, $t3, -1 # decrement the length (aka loop counter here)
    addi $sp, $sp, 4 # go up in stack to get the next value (it reads from right to left)
    j q2_convert_to_integer_last # get back to the beginning

# Here is the place where we save the whole number (last number in string) get by the characters
q2_save_value_last:
    addi $sp, $sp, -4 # go one level down to create space for the real integer number
    sw $t5, 0($sp) # store the number
    
    # resetting the registers
    li $t5, 0
    li $t4, 0  
    li $t6, 1
    li $t8, 10
    li $t0, 0
    li $t1, 0
    li $t2, 0
    li $s3, 0
    addi $s2, $s2, 1  # increment the number of elements in total given in string
    addi $t0, $t0, 1  # incrementing the loop counter

    move	$a0, $sp # $a0=base address af the array
	move	$a1, $s2 # $a1=size of the array
    li      $a2, 1
    jal	sort_algorithm # call sorting func
    j q2_print_array # print after sorting

# Here is the place where we check negativity for the last value
q2_check_negativity_last:
    beq $s3, 1, q2_make_negative_last  # if negatve, call negative
    j q2_save_value_last  # if not, go directly to the save_value func

# Here is the place where we make the number negative
q2_make_negative_last:
    sub $t5, $zero, $t5  # substract the value from 0 to get its negative value
    j q2_save_value_last  # call save_value func

q2_exit:
    j main_while  # jump back to main menu loop

# Here is the place where we print the values in stack (aka array)
q2_print_array:
    # loop definitions
	li $t4, 0
	li $t2, 0
    addi $s2, $s2, 1  # length index is incremented by one to get all numbers
	
	q2_print_array_loop_inner:  # initiate loop
	
		beq $s2, $zero, q2_print_array_loop_end
	
        # print the first value
		li $v0, 1
		lw $a0, 0($s0)
		syscall

        # put space
        li $v0, 4
        la $a0, space_by_1
        syscall

        # go one level up and decrement the loop counter
		addi $s0, $s0, 4
		addi $s2, $s2, -1
		j q2_print_array_loop_inner  # get back to the loop
	
	q2_print_array_loop_end:
        j q2_exit


q3:
    add $s0, $zero, $zero # False variable
    addi $s1, $zero, 1 # True variable
    add $s2, $zero, $zero # prime counter variable
    add	$s3, $sp, 0 # save bottom of stack address in $s3

    add $t0, $v0, $zero # N -> $t0
    li $t1, 2 # counter p -> $t1

# initilize array with ones in stack 
q3_array:
    sw	$s1, 0($sp)	# we start with filling all words with 1
	addi $t1, $t1, 1	# increment the loop variable
	addi $sp, $sp, -4	# here we add 1 more word in stack by subtracting the stack pointer
    
    slt $t5, $t1, $t0
	bne	$t5, $zero, q3_array	# loop shall continue until p <= N

    li $t1, 1 # counter p reseted to 1
    
q3_outer_while:
    addi $t1, $t1, 1 # increment p at each iteration
    mul $t2, $t1, $t1 # save  p * p -> $t2

    slt $t5, $t0, $t2
    bne $t5, $zero, q3_precounter # exit loop if p*p > N 

    add	$t4, $s3, $zero	# we store the bottom of stack pointer to $t4
	mul	$t3, $t1, 4	# aligning according word in order to jump over t1=p
	sub	$t4, $t4, $t3	# subtract the value of $t3 from the bottom of stack pointer
	add	$t4, $t4, 8	# we need to add 8 bytes since the first prime number is 2

	lw	$t3, 0($t4)	# load the value into $t3
	beq	$t3, $s1, q3_inner_for	# go to the inner loop if prime[p] == true
    
    j q3_outer_while

q3_inner_for:
    #for i in range(p * p, n+1, p):
    #       prime[i] = False
    add	$t4, $s3, 0	# we store the bottom of stack pointer to $t4
	mul	$t3, $t2, 4	# aligning according word in order to jump over
	sub	$t4, $t4, $t3	# subtract the value of $t3 from the bottom of stack pointer
	add	$t4, $t4, 8	# we need to add 8 bytes since the first prime number is 2

	sw	$s0, 0($t4)	# store false there ( 0's ) because it's not a prime number

	add	$t2, $t2, $t1	# keep doing this for every multiple of $t1

    slt $t5, $t0, $t2 
	beq $t5, $zero, q3_inner_for # stay in loop while ( p*p <= N )

    j q3_outer_while # go back to outer loop when all multiples are done

q3_precounter:
    li $t9, 1 # set counter variable to 1

q3_counter:

    add	$t4, $s3, 0	# we store the bottom of stack pointer to $t4
	mul	$t3, $t9, 4	# aligning according word in order to jump over
	sub	$t4, $t4, $t3	# subtract the value of $t3 from the bottom of stack pointer
	add	$t4, $t4, 8	# we need to add 8 bytes since the first prime number is 2

	lw	$t3, 0($t4)	# load the content into $t3
    addi $t9, $t9, 1 # increament t9

	beq	$t3, $s1, q3_if_counter	# increment prime counter if prime[p] == true

    slt $t5, $t0, $t9
    bne $t5, $zero, q3_exit # jump to exit if t9 > N
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

q4:
    addi $sp, $sp, -8   # creating space to preserve the values of arguments (i.e., $a0, $a1, etc.)
    sw $a0, 4($sp)  # pushing arguments to stack
    sw $a1, 0($sp)

    jal q1

    lw $a1, 0($sp)  # restore the arguments from stack
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    j main_while  # jump back to main menu loop

sort_algorithm:
    addi $sp, $sp, -4		# create space for return address on stack
    sw $ra, 0($sp)          # store return address
    add $s0, $a0, $zero		# base address of the stack
    add $s1, $zero, $zero	# loop variable i initialized to 0
    addi $s2, $a1, -1		# lenght -= 1
    add $s4, $a2, $zero     # boolean variable to differentiate between q1 and q2 sorting

sort_loop:
    slt $t0, $s1, $s2       # $t0 = (i < length - 1)
    beq $t0, $zero, sort_end# if previous condition is false, then exit the loop

    # here we store some values to arguments before calling get_minimum_index()
    add $a0, $s0, $zero		# base address of the stack
    add $a1, $s1, $zero     # loop variable i
    add $a2, $s2, $zero		# length - 1
    add $a3, $s4, $zero     # assigning the boolean variable to $a3
    
    jal	get_minimum_index   # calling the procedure to find the index of the smallest element
    add $s3, $v0, $zero		# assign the return value to $s3

    # we perform swapping in the following
    sll	$t1, $s1, 2     # multiply the value of first index by 4 for word alignment purposes
	add	$t1, $s0, $t1   # add it with the base of stack to get the exact location
    sll	$t2, $s3, 2		# multiply the value of second index by 4 for word alignment purposes
    add	$t2, $s0, $t2	# add it with the base of stack to get the exact location
    lw $t0, 0($t1)		# load the value at address $t1
    lw $t3, 0($t2)		# load the value at address $t2
    sw $t3, 0($t1)		# swapping happens here
    sw $t0, 0($t2)		# swapping happens here

    addi $s1, $s1, 1		# i += 1
    j sort_loop		# go back to the beginning of the loop
		
sort_end:
    lw $ra, 0($sp)		# restore value from stack
	addi $sp, $sp, 4	# restore stack pointer
	jr $ra			    # return to caller

get_minimum_index:		# this procedure is used to get the index of the smallest element in stack
    add $t0, $a0, $zero		# base of the stack
	add $t1, $a1, $zero		# first index = i
	add $t2, $a2, $zero		# length - 1
    add $t8, $a3, $zero     # assign the boolean variable to $t8

    sll	$t3, $t1, 2		# multiply the current index by 4 for alignment
    add	$t3, $t3, $t0	# add to the base of stack for getting the exact location
    lw	$t4, 0($t3)		# load the value into $t4

    beq $t8, $zero, q1_mask_outer   # mask out the upper 8-bits if necessary

get_minimum_index_cont:
	addi $t5, $t1, 1		# i = 0

get_minimum_index_loop:
    bgt	$t5, $t2, get_minimum_index_end # ending the loop
    sll	$t6, $t5, 2 # multiply the current index by 4 for alignment
    add	$t6, $t6, $t0   # add it to the base of stack for getting the exact location
    lw	$t7, 0($t6) # load the value into $t7
    beq $t8, $zero, q1_mask_inner   # mask out the upper 8-buts if necessary

get_minimum_index_loop_cont:
    slt $t9, $t7, $t4       # $t9 = ($t7 < $t4)
    beq	$t9, $zero, get_minimum_index_skip	# skip if the value of the current index is bigger than min index
    add $t1, $t5, $zero		# assign the minimum index to $t1
    add $t4, $t7, $zero		# update the value of minimum index

get_minimum_index_skip:
    addi $t5, $t5, 1		# incrementing the loop variable
	j get_minimum_index_loop    # start over from the beginning of the loop

get_minimum_index_end:  # the loop condition has failed and here terminate the loop	
    add $v0, $t1, $zero		# return the minimum element's index
	jr $ra              # jump back to caller

q1_mask_outer:          # this is used to mask out the upper 8-bits of the word
    andi $t4, $t4, 0x0FFF
    j get_minimum_index_cont    # continue back from get_minimum_index procedure

q1_mask_inner:          # this is used to mask out the upper 8-bits of the word
    andi $t7, $t7, 0x0FFF
    j get_minimum_index_loop_cont   # continue back from get_minimum_index procedure's loop
