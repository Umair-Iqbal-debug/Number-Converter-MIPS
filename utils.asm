
# File: utils.asm
# Purpose: To define utilities which will be used in MIPS programs.
# Author: Umair Iqbal
# Subprograms Index:
# Exit - Call syscall with a server 10 to exit the program
# NewLine - Print a new line character (\n) to the console
# PrintInt - Print a string with an integer to the console
# PrintString - Print a string to the console
# ReadInt - Prompt the user to enter an integer, and return
# it to the calling program.
#
# Modification History
# 10/20/2021 - Initial release



#---- functions----
	
	# subprogram: GenRandomNum
	# author: Umair Iqbal
	# purpose: To print a string to the console	
	# input: $a1 - upper bound (inclusive) , $a2 - lowerbound (inclusive)
	#$a1 - upper bound
	#$a2 - lower bound
	# returns: random number
	# side effects: The String is printed followed by the integer value.
	.text
		GenRandomNum:
			# input already has upper bound in $a1 and lower bound $a2
			
			# subtract lower bound from upper bound and store in $a1 ( $a1 = $a1-$a2 )
			sub $a1,$a1,$a2
			
			addi $a1,$a1,1
			
			# generate random number using syscall 42
			li $v0,42
			syscall
			
			move $v0,$a0 # random number generated is in a0 move it to v0 for return
			add $v0,$v0,$a2 # add lower bound to random generated number
			
			jr $ra # return control to caller
			
	.text
PrintNewLine:
 li $v0, 4
 la $a0, __PNL_newline
 syscall
 jr $ra
.data
 __PNL_newline: .asciiz "\n"
# subprogram: PrintInt
# author: Charles W. Kann
# purpose: To print a string to the console
# input: $a0 - The address of the string to print.
# $a1 - The value of the int to print
# returns: None
# side effects: The String is printed followed by the integer value.
.text
PrintInt:
 # Print string. The string address is already in $a0
 li $v0, 4
 syscall

 # Print integer. The integer value is in $a1, and must
 # be first moved to $a0.
 move $a0, $a1
 li $v0, 1
 syscall

 #return
 jr $ra
# subprogram: PromptInt
# author: Charles W. Kann
# purpose: To print the user for an integer input, and
# to return that input value to the caller.
# input: $a0 - The address of the string to print.
# returns: $v0 - The value the user entered
# side effects: The String is printed followed by the integer value.
.text
PromptInt:
 # Print the prompt, which is already in $a0
 li $v0, 4
 syscall

 # Read the integer value. Note that at the end of the
 # syscall the value is already in $v0, so there is no
 # need to move it anywhere.
 move $a0, $a1
 li $v0, 5
 syscall

 #return
 jr $ra
 
# subprogram: PrintString
# author: Charles W. Kann
# purpose: To print a string to the console
# input: $a0 - The address of the string to print.
# returns: None
# side effects: The String is printed to the console.
.text
PrintString:
 addi $v0, $zero, 4
 syscall
 jr $ra

# subprogram: Exit
# author: Charles Kann
# purpose: to use syscall service 10 to exit a program
# input: None
# output: None
# side effects: The program is exited
.text
Exit:
 li $v0, 10
 syscall
 
 
 
    .text
    
    	# no arugments just prints menu
    	PrintMenu:
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    		
    		la $a0,menuOptionOne
    		jal PrintString
    		
    		la $a0,menuOptionTwo
    		jal PrintString
    		
    		la $a0,menuOptionThree
    		jal PrintString
    		
    		la $a0,menuOptionFour
    		jal PrintString
    		
    		lw $ra, ($sp)
    		addi $sp ,$sp, 4
    		jr $ra
    	
 
    .data
 	menuOptionOne: .asciiz "\n1. Binary to hexadecimal and decimal\n"
 	menuOptionTwo: .asciiz "2. Hexadecimal to binary and decimal\n"
 	menuOptionThree: .asciiz "3. Decimal to binary and hexadecimal\n"
 	menuOptionFour: .asciiz "4. Exit\n"
 	
    .text 
    	GetMenuInput:
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    		
    		la $a0,menuPrompt
    		jal PromptInt
    		
    		lw $ra, ($sp)
    		addi $sp ,$sp, 4
    		jr $ra
    		
    .data
    	menuPrompt: .asciiz "\nPlease enter a number between 1-4: "
    	
   .text
		StringToHex:
		
			addi $sp , $sp, -12
			sw $ra, 0($sp)
			sw $s0, 4($sp) # to save base address
			sw $s1, 8($sp) # to save result 
			
			move $s0,$a0
			
			
			
			li $s1,0 # init result to 0
			
			
			loopHex:
				# check loop exit condition
				#if(curr character == newline character --> ) break
				lb $t0, ($s0)
				beq $t0,0x0a,endLoopHex
				
				#sub $t0,$t0,48 # convert character to numeric digit
				move $a0,$t0
				jal CharToHexDigit
				
			
				move $t0,$v0 # move digit into t0
				
				sll $s1,$s1,4 # multiply result by 16
				
				or $s1,$s1,$t0 # add digit
				
				# base address + (index * size in bytes(1))
				addi $s0,$s0,1
				
						
				b loopHex
			endLoopHex:
			
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
			
	.text 
	
		StringToNumber:
		
			addi $sp , $sp, -8
			sw $ra,($sp)
			sw $s0, 4($sp) # to save base address
			
			move $s0,$a0
			
			
			
			li $v0, 0
			
			li $t2, 0 # character number
			
			loopDecimal:
				# check loop exit condition
				#if(curr character == null character --> 0x00) break
				lb $t0, ($a0)
				beq $t0,0x0a,endLoopDecimal
				
				sub $t0,$t0,48 # convert character to numeric digit
				
				mul $v0,$v0,10 # multiply result by 10
				
				add $v0,$v0,$t0 # add digit
				
				addi $t2,$t2,1
				# base address + (index * size in bytes(1))
				add $a0,$s0,$t2
				#add $a0,$a0,1
				
						
				b loopDecimal
			endLoopDecimal:
			
			
			
			lw $ra,($sp)
			lw $s0, 4($sp)
			addi $sp , $sp, 8 
			jr $ra
			
			
	.text 
	
		StringToBinary:
		
			addi $sp , $sp, -4
			sw $ra,($sp)

			li $v0,0 # result
			

			
			loopBinary:
				# check loop exit condition
				#if(curr character == null character --> 0x00) break
				lb $t0, ($a0)
				beq $t0,0x0a,endLoopBinary
				
				sub $t0,$t0,48 # convert character to numeric digit
				
				sll $v0,$v0,1 # multiply result by 2
				
				or $v0,$v0,$t0 # add digit
				
				# base address + (index * size in bytes(1))
				#add $a0,$s0,$t2
				addi $a0,$a0,1
				
						
				b loopBinary
			endLoopBinary:
			
			lw $ra,($sp)
			addi $sp , $sp, 4
			jr $ra
	
			
  	.text
  		PrintBinary:
  		
  			
			addi $sp, $sp,-4
			sw $ra,($sp)
		
  			# prmpt is already in a0
  			jal PrintString
  			
  			move $a0,$a1
  			li $v0,35
  			syscall
  			
  			lw $ra,($sp)
			addi $sp, $sp,4
			jr $ra
  			
  	.text
  		PrintHex:
  		
  			addi $sp, $sp,-4
			sw $ra,($sp)
  			# prmpt is already in a0
  			jal PrintString
  			
  			move $a0,$a1
  			li $v0,34
  			syscall
  			
  			lw $ra,($sp)
			addi $sp, $sp,4
			jr $ra
			
			
			
	.text
	        #a0 is prompt
		ReadString:
		
		addi $sp, $sp,-4
		sw $ra,($sp)
		
		jal PrintString
		
		li $v0,8
		li $a1,40 # max characters to read
		la $a0,num
		syscall
		
		
		lw $ra,($sp)
		addi $sp, $sp,4
		jr $ra
		
	.text
	#a0 should have address of string 
		isNumericString:
		
		addi $sp,$sp,-8
		sw $ra,($sp)
		sw $s0,4($sp) # to store current address
		
		move $s0,$a0
		
			li $v0,1 # by default string is numeric
		
		     loopNumericCheck:
				# check loop exit condition
				#if(curr character == null character --> 0x00) break
				lb $t0, ($s0)
				beq $t0,0x0a,endLoopNumericCheck
				
				move $a0,$t0
				
				jal isNumeric
				
				beqz $v0,isNotNumeric
				
				# base address + (index * size in bytes(1))
				#add $a0,$s0,$t2
				addi $s0,$s0,1
				
						
				b loopNumericCheck
				
			endLoopNumericCheck:
			 b endOfWorld
			
			isNotNumeric:
			li $v0,0
			
			endOfWorld:
			lw $ra,($sp)
			lw $s0,4($sp)
			addi $sp , $sp, 8
			jr $ra
			
			
			
		.text
		
		isBinaryString:
		
		addi $sp,$sp,-8
		sw $ra,($sp)
		sw $s0,4($sp) # to store current address
		
		move $s0,$a0
		
			li $v0,1 # by default string is numeric
		
		     loopBinaryCheck:
				# check loop exit condition
				#if(curr character == null character --> 0x00) break
				lb $t0, ($s0)
				beq $t0,0x0a,endLoopBinaryCheck
				
				move $a0,$t0
				
				seq $t2,$t0,48
				
				seq $t3,$t0,49
				
				or $t2,$t2,$t3
				
				beqz $t2,isNotBinary
				
				# base address + (index * size in bytes(1))
				#add $a0,$s0,$t2
				addi $s0,$s0,1
				
						
				b loopBinaryCheck
				
			endLoopBinaryCheck:
			 b endOfWorld
			
			isNotBinary:
			li $v0,0
			
			endOfWorldBin:
			lw $ra,($sp)
			lw $s0,4($sp)
			addi $sp , $sp, 8
			jr $ra
			
			
			
	.text
		# a0 is the character
		isValidHexNumChar:
		
		addi $sp, $sp, -8
		sw $s0, 4($sp)
		sw $ra,($sp)
		
		move $s0,$a0
		
		jal isNumeric
		
		move $t6,$v0 #t6 = if the character is 0-9
		#convert to lowercase
		ori $s0,$s0,0X60	
		sge $t5,$s0,97
		sle $t4,$s0,102
		
		and $t4,$t5,$t4
		
		or $t6,$t4,$t6
		
		
		move $v0 , $t6
		
		lw $ra ($sp)
		lw $s0, 4($sp)
		addi $sp,$sp,8
		jr $ra
		
		
	.text 
	
	isValidHexNumString:
	
		
			
		addi $sp,$sp,-8
		sw $ra,($sp)
		sw $s0,4($sp) # to store current address
		
		move $s0,$a0
		
			li $v0,1 # by default string is numeric
		
		     loopHexCheck:
				# check loop exit condition
				#if(curr character == null character --> 0x00) break
				lb $t0, ($s0)
				beq $t0,0x0a,endLoopHexCheck
				
				move $a0,$t0
				
				jal isValidHexNumChar
				
				beqz $v0,isNotHex
				
				# base address + (index * size in bytes(1))
				#add $a0,$s0,$t2
				addi $s0,$s0,1
				
						
				b loopHexCheck
				
			endLoopHexCheck:
			 b endOfWorldHex
			
			isNotHex:
			li $v0,0
			
			endOfWorldHex:
			lw $ra,($sp)
			lw $s0,4($sp)
			addi $sp , $sp, 8
			jr $ra
			
		
		
		
		

			
