	.text
		main:
			la $a0,hexNumber
			
			jal StringToHex
			
			move $s0,$v0
			
			la $a0,decimal
			move $a1,$s0
			jal PrintInt
			
			jal PrintNewLine
			
			la $a0,binary
			li $v0,4
			syscall
			
			
			li $v0,35
			move $a0,$s0
			syscall
			
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
		hexNumber: .asciiz "f"
	 	decimal: .asciiz "The number in decimal: "
		binary: .asciiz "The number in binary: "
		hex: .asciiz "The number in hex: "
	.include "utils.asm"
	
	.text
		StringToHex:
		
			addi $sp , $sp, -12
			sw $ra, 0($sp)
			sw $s0, 4($sp) # to save base address
			sw $s1, 8($sp) # to save result 
			
			move $s0,$a0
			
			
			
			li $s1,0 # init result to 0
			
			
			loop:
				# check loop exit condition
				#if(curr character == null character --> 0x00) break
				lb $t0, ($s0)
				beq $t0,0x00,endLoop
				
				#sub $t0,$t0,48 # convert character to numeric digit
				move $a0,$t0
				jal CharToHexDigit
				
			
				move $t0,$v0 # move digit into t0
				
				sll $s1,$s1,4 # multiply result by 16
				
				or $s1,$s1,$t0 # add digit
				
				# base address + (index * size in bytes(1))
				addi $s0,$s0,1
				
						
				b loop
			endLoop:
			
			move $v0,$s1
			lw $ra,($sp)
			lw $s0, 4($sp)
			lw $s1 8($sp)
			addi $sp , $sp, 12
			jr $ra
	
	.text
		# a sub-program that takes a character and converts it to hex digit
		# input a0 -> character to be converted to hex digit
		# outpout $v0 hexDigit
		CharToHexDigit:
		
			addi $sp,$sp,-4
			sw $ra,($sp)

			# check if character is numeric digit or not
			jal isNumeric
			
			beqz $v0,nonNumeric
			
			sub $v0,$a0,48 # = doing char - '0'
			
			b Return
			
			nonNumeric:
				#convert to lower-case	
				ori $a0,$a0,0X60	#curr & 0X4f
				sub $v0,$a0,87
			
			
			Return:
			lw $ra,($sp)
			addi $sp,$sp,4
			jr $ra
		
	.text
		# load back t0,t1 after every time you call is numeric
		isNumeric:
		
			addi $sp,$sp,-12
			sw $ra,($sp)
			sw $t0, 4($sp)
			sw $t1, 8($sp)
		
			# the character is numeric if its ascii value lies between 48-57 inclusive
			sle $t0,$a0,57 # t0 = ( n <= 57)
			sge $t1,$a0,48 # t1 = ( n >= 48)
			and $v0,$t0,$t1 #t0 = ( n <= 57) && ( n >= 48)
			
			lw $ra,($sp)
			lw $t0, 4($sp)
			lw $t1, 8($sp)
			addi $sp,$sp,12
			jr $ra
			
			
			
			
			