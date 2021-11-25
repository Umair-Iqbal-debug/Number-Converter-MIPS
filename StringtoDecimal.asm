

	# File: StringToDecimal.asm
	# Purpose: To define a subprogram that can convert a decimal number to binary number
	# Author: Umair Iqbal
	#input: $a0 --> decimal number to convert to binary
	# output: $v0 --> binary number
	.text
		main:
		
			
			li $a1,10
			la $a0,number
			li $v0,8
			syscall
			
			
			la $a0,number
			jal StringToNumber
			
			move $a0,$v0
			li $v0,1
			syscall
			
			li $v0,10
			syscall
	
	
	
	.data
		number: .space 10
		message: .asciiz "Enter number in decimal: "
		decimal: .asciiz "The number in decimal: "
		binary: .asciiz "The number in binary: "
		hex: .asciiz "The number in hex: "
	.include "utils.asm"
	
	.text
	        #a0 is prompt
		ReadString:
		
		addi $sp, $sp,-4
		sw $ra,($sp)
		
		jal PrintString
		
		li $v0,8
		li $a1,15 # max characters to read
		la $a0,number
		syscall
		
		
		lw $ra,($sp)
		addi $sp, $sp,4
		jr $ra
	
		
			
			
			
