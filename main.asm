	.text
	
		main:
		
			mainLoop:
				jal PrintNewLine
				
				jal PrintMenu # first print menu
		
				jal GetMenuInput # get menu input in $v0
				
				move $s4,$v0 # save menu choice
				
				beq $v0,4,mainLoopEnd
				
				beq $v0,1, case_1
				beq $v0,2, case_2
				beq $v0,3, case_3
				b invalid_menu_option
				
					case_1:
						#Binary
						la $a0,binaryInputPrompt
						jal ReadString # a0 has input reference
						
						move $s5,$a0
						
						jal isBinaryString
						
						beqz $v0,case_invalid_input
						
						move $a0,$s5
						
						jal StringToBinary #v0 has binary value
						
						move $s0,$v0 # move binary nubmer from v0 to s0
						
						la $a0,binaryNum
						move $a1,$s0
						jal PrintBinary
						
						
						la $a0,hexadecimalNum
						move $a1,$s0
						jal PrintHex
						
						la $a0,decimalNum
						move $a1,$s0
						jal PrintInt
						
						
						b mainLoop
					case_2:
						#Hex
						la $a0,hexInputPrompt
						jal ReadString # a0 has input reference
						
						move $s5,$a0
						
						jal isValidHexNumString
						
						beqz $v0,case_invalid_input
						
						move $a0,$s5
						
						jal StringToHex #v0 has hex value
						
						move $s0,$v0 # move binary nubmer from v0 to s0
						
						la $a0,hexadecimalNum
						move $a1,$s0
						jal PrintHex
						
						la $a0,binaryNum
						move $a1,$s0
						jal PrintBinary
						
						
						la $a0,decimalNum
						move $a1,$s0
						jal PrintInt
						
						b mainLoop
					case_3:
						#decimal
						
						la $a0,decimalInputPrompt
						jal ReadString # a0 has input reference
						
						move $s5,$a0
						
						jal isNumericString
						
						beqz $v0,case_invalid_input
						
						move $a0,$s5
						
						la $a0,num
						
						jal StringToNumber #v0 has hex value
						
						move $s0,$v0 # move binary nubmer from v0 to s0
						
						la $a0,decimalNum
						move $a1,$s0
						jal PrintInt
						
						la $a0,binaryNum
						move $a1,$s0
						jal PrintBinary
						
						la $a0,hexadecimalNum
						move $a1,$s0
						jal PrintHex
						
						b mainLoop
						
				case_invalid_input:
				
						la $a0,invalidMessage
						jal PrintString
				
						beq $s4,1, case_1
						beq $s4,2, case_2
						beq $s4,3, case_3
						
				invalid_menu_option:
				
						la $a0,invalidMenuOption
						jal PrintString
						b mainLoop
						
			mainLoopEnd:
				
				jal Exit
	
	.data
		binaryInputPrompt: .asciiz "\nEnter a binary number: "
		decimalInputPrompt: .asciiz "\nEnter a decimal number: "
		hexInputPrompt: .asciiz "\nEnter a hex number: "
		
		invalidMenuOption: .asciiz "\nEntered menu option is invalid, please ty again..."
		
		invalidMessage: .asciiz "\nEntered number isn't valid, please try again..."
		
		binaryNum: .asciiz "\n Binary Number: "
		decimalNum: .asciiz "\n Decimal Number: "
		hexadecimalNum: .asciiz "\n Hexadecimal Number: "
		num : .space 40
	
	.include "utils.asm"
	
	
