#--------------------------------------------------------------------------
# Miniproject topic 4: Array of numbers
#--------------------------------------------------------------------------

.data
array:		.space 200
askInput:	.asciiz "Enter value of array's element\n(Cancel to stop input): "
input_m:	.asciiz "Enter range (m, M):\nm = "
input_M:	.asciiz "Enter range (m, M):\nM = "
output:		.asciiz "Array: "
comma:		.asciiz ", "
max:		.asciiz "\nMax = "
warn_M:		.asciiz "M must be greater than m !!!"
inRange1:	.asciiz "\nThe number of elements in range ("
inRange2:	.asciiz ") is: "
invalid:	.asciiz "INVALID INPUT\nPlease enter again"
array_empty:	.asciiz "ARRAY IS EMPTY\nPlease input more elements"
array_full:	.asciiz "ARRAY IS FULL\nCannot input more elements"

.text
.globl main

#---------------------------------------------------------------------------
# main:
#	$s7		array's address
#	$t2		the number of elements in array ($t2 = n)
#---------------------------------------------------------------------------
main:
	la $s7, array		# s7 = array's address
	add $t2, $zero, $zero	# t2 = n = 0 (number of elements)
main_cont1:
	j input_loop
main_cont2:
	j input_range
main_cont3:
	jal traverse_array
	jal print_max
	jal print_in_range
exit:
	li $v0, 10
	syscall

main.end:


#---------------------------------------------------------------------------
# input_loop:		loop to input array's elements (until choose Cancel)
#	$t2 = n		increase by 1 each time user enter an element
#---------------------------------------------------------------------------
input_loop:
	li $v0, 51
	la $a0, askInput
	syscall
	
check_valid_input:
	beq $a1, 0, valid_input
	nop	
	beq $a1, -1, invalid_input
	nop
	beq $a1, -2, input_end		# if user choose Cancel
	nop
	beq $a1, -3, input_loop
	nop

invalid_input:
	jal invalid_error
	j input_loop
invalid_input.end:
			
valid_input:	
	sw $a0, ($s7)			# store input
	addi $t2, $t2, 1		# n++

	blt $t2, 50, input_loop_cont	# the maximum number of elements that array can hold is 200/4 = 50
	nop
	
full_array:				# if array is full
	li $v0, 55
	la $a0, array_full
	li $a1, 2
	syscall
	j input_end
	
input_loop_cont:
	addi $s7, $s7, 4	# move the array over by 1 element
	j input_loop
input_end:
	j main_cont2

#---------------------------------------------------------------------------
# input_range:		input range (n, M)
#	$t8 = m		store the lowerbound of the range
#	$t9 = M		store the upperbound of the range
#---------------------------------------------------------------------------
input_range:
	bnez $t2, input_range.m
	nop
empty:			# if array is empty then show an error message and ask user to input some elements
	li $v0, 55
	la $a0, array_empty
	li $a1, 0
	syscall
	j main_cont1

input_range.m:
	li $v0, 51
	la $a0, input_m
	syscall

check_valid_input_m:	
	beq $a1, -0, valid_input.m
	nop
	beq $a1, -1, invalid_input.m
	nop
	beq $a1, -2, input_range.m
	nop
	beq $a1, -3, input_range.m
	nop
	
invalid_input.m:
	jal invalid_error
	j input_range.m
invalid_input.m.end:

valid_input.m:
	add $t8, $zero, $a0

input_range.M:
	li $v0, 51
	la $a0, input_M
	syscall

check_valid_input_M:	
	beq $a1, 0, valid_input.M
	nop
	beq $a1, -1, invalid_input.M
	nop
	beq $a1, -2, input_range.M
	nop
	beq $a1, -3, input_range.M
	nop
	
invalid_input.M:
	jal invalid_error
	j input_range.M
invalid_input.M.end:

valid_input.M:	
	bgt $a0, $t8, M_is_greater_than_m
	nop
warning:		# if user input M < m then show a warning message and ask user to input M again
	li $v0, 55
	la $a0, warn_M
	li $a1, 2
	syscall
	j input_range.M
	
M_is_greater_than_m:		
	add $t9, $zero, $a0
input_range_end:
	j main_cont3

#-----------------------------------------------------------------------------------
# invalid_error	:	if user input a string or a float then show an error message
#-----------------------------------------------------------------------------------
invalid_error:
	li $v0, 55
	la $a0, invalid
	li $a1, 0
	syscall
	jr $ra
invalid_error.end:
	
#-------------------------------------------------------------------------------------
# traverse_array:	traverse the array to print elements of array, find the
#			maximum element and find the number of elements in range (m,M)
#-------------------------------------------------------------------------------------
traverse_array:
	la $s7, array
	la $a0, output
	li $v0, 4
	syscall

	lw $s0, 0($s7)		# $s0 = max
	add $s1, $zero, $zero	# $s1 = the number of elements in range (m,M)
	add $t3, $zero, $zero	# t3 = i = 0
traverse_loop:
	lw $t0, 0($s7)		# $t0 = array[i]
	
	j print_element
cont1:
	j check_max
cont2:
	j check_range
cont3:
	addi $t3, $t3, 1	# i++
	beq $t3, $t2, traverse_loop.end	# if i = n, stop
	nop
	
	la $a0, comma		# print the comma and a space to separate between elements
	li $v0, 4
	syscall
	addi $s7, $s7, 4	# move the array over by 1 element
	
	j traverse_loop
traverse_loop.end:
end_traverse:	jr $ra

#---------------------------------------------------------------------------
# print_element:	print element array[i] to terminal
#	$t0		temporary variable that store element array[i]
#---------------------------------------------------------------------------
print_element:
	li $v0, 1
	add $a0, $zero, $t0
	syscall
	j cont1

#---------------------------------------------------------------------------
# check_max:		compare element array[i] with max and update max if neccessary
#	$t0		temporary variable that store element array[i]
#	$s0		maximum element in array
#---------------------------------------------------------------------------
check_max:
	sgt $t4, $t0, $s0		# t4 = 1 if t0 > max
	beq $t4, $zero, end_check_max
	nop
	add $s0, $zero, $t0		# new max = t0
end_check_max: j cont2

#---------------------------------------------------------------------------
# check_range:		check if array[i] is in range (m,M) or not,
#			if it is then update the counter $s1
#	$t0		temporary variable that store element array[i]
#	$t8 = m
#	$t9 = M
#	$s1		count the number of elements in range (m,M)
#---------------------------------------------------------------------------
check_range:
	sgt $t5, $t0, $t8	# if $t0 > m
	slt $t6, $t0, $t9	# if $t0 < M
	and $t7, $t5, $t6	# if (($t0 > m) AND ($t0 < M))
	beq $t7, $zero, end_check_range
	nop
	addi $s1, $s1, 1	# $s1 ++
end_check_range: j cont3

#---------------------------------------------------------------------------
# print_max:		print the maximum element in array to Run I/O
#	$s0		maximum element in array
#---------------------------------------------------------------------------
print_max:
	la $a0, max
	li $v0, 4
	syscall
	add $a0, $s0, $zero
	li $v0, 1
	syscall
	jr $ra

#-----------------------------------------------------------------------------
# print_in_range:	print the number of elements in range (m,M) to Run I/O
#	$s1		the number of elements in range (m,M)
#	$t8 = m
#	$t9 = M
#-----------------------------------------------------------------------------
print_in_range:
	la $a0, inRange1
	li $v0, 4
	syscall
	
	add $a0, $t8, $zero
	li $v0, 1
	syscall
	
	la $a0, comma
	li $v0, 4
	syscall
	
	add $a0, $t9, $zero
	li $v0, 1
	syscall
	
	la $a0, inRange2
	li $v0, 4
	syscall
	
	add $a0, $s1, $zero
	li $v0, 1
	syscall
	
	jr $ra















