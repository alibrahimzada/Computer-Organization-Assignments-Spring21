    .data

welcome_message:    .asciiz "Welcome to our MIPS project!\n"
main_menu:  .asciiz "\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option: "
termination: .asciiz "Program ends. Bye :)"

    .text

main:
    li $v0, 4
    la $a0, welcome_message
    syscall

main_while:

    li $v0, 4
    la $a0, main_menu
    syscall

    li $v0, 5
    syscall

    slti $t0, $v0, 5    # $t0 = ($v0 < 5)
    bne $t0, $zero, main_while

    li $v0, 4
    la $a0, termination
    syscall

    li $v0, 10
    syscall
