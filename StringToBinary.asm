

	# File: StringToDecimal.asm
	# Purpose: To define a subprogram that can convert a decimal number to binary number
	# Author: Umair Iqbal
	#input: $a0 --> decimal number to convert to binary
	# output: $v0 --> binary number
	.text
		main:
		
			la $a0,number
			jal StringToBinary
			
			move $s0,$v0
			
			la $a0,decimal
			move $a1,$s0
			jal PrintInt
			
			jal PrintNewLine
			
			la $a0,binary
			move $a1,$s0
			jal PrintBinary
			
			jal PrintNewLine
			
			la $a0,hex
			li $v0,4
			syscall
			
			li $v0,34
			move $a0,$s0
			syscall
	
			li $v0,10
			syscall
	
	
	
	.data
		number: .asciiz "1010"
		decimal: .asciiz "The number in decimal: "
		binary: .asciiz "The number in binary: "
		hex: .asciiz "The number in hex: "
	.include "utils.asm"
	
	
	
		
			
			
			
