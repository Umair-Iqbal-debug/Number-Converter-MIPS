		
		
		.text
			la $a0,invalidNum
			jal isValidHexNumString
			
			move $a0,$v0
			li $v0,1
			syscall
			
			jal Exit
		
		.data
		
			validNum: .asciiz "4A\n"
			invalidNum: .asciiz "ghs\n"
			num: .space 40
		
		.include "utils.asm"
