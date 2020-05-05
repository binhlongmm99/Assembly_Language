#--------------------------------------------------------------------------
# Miniproject topic 10: power, square, and hexadecimal
#--------------------------------------------------------------------------

.data
	prompt: .asciiz "Enter the integer number to convert (0-30): " 
	header: .asciiz "i	power(2,i)	square(i)			Hexadecimal(i) \n"
	error: .asciiz "Invalid Input ! Please enter the integer number !"
	null: .asciiz "Input can not be empty"
	output: .word 0 # For storing the output after calculate square and power of two
	denominator: .asciiz "1/"
	num: .word 0
	Space: .asciiz "	"
	bigSpace: .asciiz "		"
	moreBigSpace: .asciiz "				"
	headOfHexa: .asciiz "0x"
	result: .space 8
	
.text
#================================================================
#	this program will read the input integer from user and 
#	display the square of that integer,
#	two power that integer, and
#	that integer in hexadecimal form 
#================================================================

main:
# This function for scaning the integer input  
input:
	li $v0, 51
	la $a0, prompt
	syscall
# Check input format - if there is any error, throw the message dialog for warning and terminate program	
	beq $a1,-1,errorType # incorrect format , eg : string like "Hello" , not integer
	beq $a1,-3,emptyInput # empty input
	sgt $t4,$a0,30 # check if the input number greater than 30
	beq $t4,1,errorType
	sw $a0,num # store the input integer in variable num
	
# Display result
	la $a0, header
	jal displayString
	
	lw $a0, num
	jal displayInteger
	
	la $a0,Space
	jal displayString
#=============================================================================================
# Calculate the power of two of that integer
# Check the input integer is negative or not
# If it's positive, calculate power of two as usual
# If it's negative, calculate power of two and print with the header 1/ . Eg : 2^-1 = 1/2^1
#=============================================================================================
	lw $a0, num
	sge $t6,$a0,0 # if input >=0 return 1 else return 0
	beqz $t6,negative # jump to negative function if input < 0
# Continue after checking the sign of the number 
continue:
	lw $a0,num
	abs $t5,$a0 # get the absolute value of the input integer - especially for the negative case
	move $a0,$t5
	jal calPowerTwo		
	sw $t7, output
	lw $a0, output
	jal displayInteger
# bigSpace and Space for aligning the output in format of table
	la $a0, bigSpace
	jal displayString
#====================================================================================
# Calculate the square of the input integer
# Using Lo for storing the first 31 bit (0-31) of the final result of multiplication
#====================================================================================
	lw $a0, num
	jal square
	sw $v0, output
	lw $a0, output
	jal displayInteger
	
	la $a0, moreBigSpace
	jal displayString
#=====================================================================================
# Convert the input integer to hexadecimal
# Rotating the number and using AND operator to get 4 bits each time of the number in sequentially => loop for 8 times (4x8 = 32)
# Using ascii table to get the corresponding character in hexa
# If it's less than 10, plus 48
# If it's greater or equal than 10, plus 55
#=====================================================================================
	la $a0, headOfHexa 
	jal displayString
					
	lw $v0, num
	jal convertToHex
	la $a0, result
	jal displayString

# Function for terminate the program		
Exit:
	la $v0, 10 
	syscall	
# Functions for checking the input number
negative:
	la $a0,	denominator
	jal displayString
	j continue
errorType:
	li $v0,55
	la $a0,error
	la $a1,0
	syscall
	
	j Exit
emptyInput:
	li $v0,55
	la $a0,null
	la $a1,0
	syscall
	
	j input
# Functions for display
displayString:
	li $v0, 4
	syscall
	jr $ra

displayInteger:
	li $v0, 1
	syscall
	jr $ra
# Function for calculating power of two
# By using shift left logical
# Each bit shifting correspondly to each exponent
# Eg : 2^5 => shift left 5 bit
calPowerTwo:
	li $t7,1
	sllv $t7, $t7, $a0	# $t0 = power(2,i)
	jr $ra
# Function for calculate square
# a*a
square:
	mult $a0, $a0
	mflo $v0
	jr $ra
# Function for converting decimal number to hexadecimal
convertToHex:
	move $t1, $v0
	
	li $t0, 8 # counter i = 8
	la $t2, result # storing final result
	
Loop:
	beqz $t0, exitFunc # branch to exit if counter is equal to 0 (i=0)
	rol $t1, $t1, 4 # rotate 4 bits to the left for each time counting
	and $t3, $t1, 0xf # mask with 1111 to get 4 bits each time (in the right side)
	ble $t3, 9, Sum # if it is less than or equal to 9, branch to Sum function
	addi $t3, $t3, 55 # if it is greater than 9, add 55 to the result
			
	j End
	
Sum:
	addi $t3, $t3, 48 # add 48 to the result	
End: 
	sb $t3, 0($t2) # store hex digit into result
	addi $t2, $t2, 1 # increment address counter
	addi $t0, $t0, -1 # decrease loop counter (i--)	
	j Loop
exitFunc:
	jr $ra
	
	


	
		
