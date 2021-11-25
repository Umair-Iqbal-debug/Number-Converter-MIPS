		
		
		.text
			la $a0,invalidNum
			jal isNumericString
			
			move $a0,$v0
			li $v0,1
			syscall
			
			jal Exit
		
		.data
		
			validNum: .asciiz "1234\n"
			invalidNum: .asciiz "g\n"
			num: .space 40
		
		.include "utils.asm"
