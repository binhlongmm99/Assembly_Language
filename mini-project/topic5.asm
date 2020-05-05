#--------------------------------------------------------------------------
# Miniproject topic 5: Decimal-Binary-Hexa
#--------------------------------------------------------------------------

.data
array:		.space 200
Mess: 		.asciiz "Enter a number: \n(Cancel to stop input)"
newline: 	.asciiz "\n"
tab:		.asciiz "\t\t"
invalid:	.asciiz "INVALID INPUT"
output:		.asciiz "\t\tDecimal\t\tHexadecimal\t\tBinary\n"
exceed:		.asciiz "The array is full!"
array_empty:	.asciiz "The array is empty!"

.text
.globl main

#---------------------------------------------------------------------------
# main:
#	$s7		array of decimal numbers's address
#	$t2		the number of elements in array ($t2 = n)
#	
#---------------------------------------------------------------------------
main:
	la $s7, array			# s7 = array's address
	add $t2, $zero, $zero		# t2 = n = 0 (number of elements)
	jal get_decimal_numbers
	jal traverse_array
	
exit: 
	li $v0, 10
	syscall

main.end: 

#----------------------------------------------------------------------------------------------
# 	get_decimal_numbers:		loop to input decimal numbers until user click Cancel
#	$t2 = n				increase by 1 each time user enter a decimal number 
#----------------------------------------------------------------------------------------------
get_decimal_numbers:
	li $v0, 52	# Input Dialog Float
	la $a0, Mess
	syscall
	
check_valid_input:	
	beq $a1, -1, invalid_error 	# user entered wrong type
	nop
	beq $a1, -2, input_end		# user clicked Cancel 
	nop
	beq $a1, -3, get_decimal_numbers	# user did not input anything
	nop
	
cont_input:
	mfc1 $s1, $f0		# Move from Coprocessor 1 : $s1 = $f0
	sw $s1, ($s7)		# store input
	addi $t2, $t2, 1	# n++
	beq $t2, 50, exceed_array	# the maximum number of elements that array can hold is 200/4 = 50
	nop
	addi $s7, $s7, 4	# move the array over by 1 element
	j get_decimal_numbers
exceed_array: 
	li $v0, 55		# Message Dialog 
	la $a0, exceed
	li $a1, 2		# Warning message
	syscall
input_end:	jr $ra
 
#-----------------------------------------------------------------------
# invalid_error (only happen when user input invalid value)
#-----------------------------------------------------------------------
invalid_error:
	li $v0, 55		#Message Dialog 
	la $a0, invalid
	li $a1, 0
	syscall
	j get_decimal_numbers
	
#------------------------------
# TRAVERSE ARRAY
#------------------------------
traverse_array:

	beqz $t2, empty		# if the array is empty, show an error message
	la $s7, array		# load address of the array to $s7
	
	la $a0, output
	li $v0, 4
	syscall

	add $t3, $zero, $zero	# t3 = i = 0
	
print:
	la $a0, tab		# print tab (\t)
	li $v0, 4
	syscall
	
	lw $t0, 0($s7)		# $t0 = array[i]
	li $v0, 2		# print float
	mtc1 $t0,$f12		# Move to Coprocessor 1 : $f12 = $t0
	syscall
	
	la $a0, tab
	li $v0, 4
	syscall

	li $v0, 34		# print the number in hexadecimal
	add $a0, $t0, $zero
	syscall


	la $a0, tab
	li $v0, 4
	syscall

	li $v0, 35		# print the number in binary
	add $a0, $t0, $zero
	syscall
	
	la $a0, newline		# print new line
	li $v0, 4
	syscall
	
	addi $t3, $t3, 1	# i++
	beq $t3, $t2, end_traverse	# if i = n, stop printing
	nop
	addi $s7, $s7, 4	# move the array over by 1 element
	j print
end_traverse: jr $ra

empty: 
	li $v0, 55
	la $a0, array_empty
	li $a1, 0
	syscall
	j exit
