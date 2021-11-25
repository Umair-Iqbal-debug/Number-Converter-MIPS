		
		
		.text
			la $a0,validNum
			jal isBinaryString
			
			move $a0,$v0
			li $v0,1
			syscall
			
			jal Exit
		
		.data
		
			validNum: .asciiz "101001\n"
			invalidNum: .asciiz "74\n"
			num: .space 40
		
		.include "utils.asm"
