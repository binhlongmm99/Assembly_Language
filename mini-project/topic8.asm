#--------------------------------------------------------------------------
# Miniproject topic 8: : Write a program to:
# - Input the number of student in class
# - Input name and mark
# - Sort by mark
#--------------------------------------------------------------------------

.data
	# String constant
	Nb_student: .asciiz "Enter the number of student in class: "
	Input_name: .asciiz "Enter name: "
	Input_mark: .asciiz "Enter mark: "
	Invalid_input: .asciiz "Invalid input, try again: "
	Name: .asciiz "\n\nName: "
	Mark: .asciiz "Mark: "
	
	# Variable
	string: .space 20		# Max name length
	nb_student: .word 0		# Number of student
	name_list: .space 400		# 20 student * max name length
	mark_list: .space 80		# 20 student
	

.text
	jal input_num
	j get_data
	

# Get data
# Argument: nb_student, name_list, mark_list
# Output: name_list, mark_list
get_data:
	li $s3, 0			# Index = 0
	la $s4, nb_student
	lw $s4, 0($s4)
	addi $s4, $s4, -1		# Last index = length - 1

get_data_loop:
	# Get data of 1 student: v0, a0, a1, a2, f0 occupied
	jal input_name			# name now in string
	jal input_mark			# mark now in f0
	#bnez $a1, end
	# v0, a0, a1, a2 free
	
	# Copy name to list: s0, a0, a1, a2, t1, t2, t3, t4, t5 occupied
	add $t4, $s3, $zero		# t4 = index
	
	# Save to mark_list
	mul $t5, $t4, 4			# t5 = position in mark_list
	la $a2, mark_list
	add $a2, $a2, $t5
	s.s $f0, 0($a2)
	
	# Save to name_list
	mul $t4, $t4, 80		# t4 = 80 * t4
	la $a0, name_list
	add $a0, $a0, $t4		# move to selected index in name_list
	la $a1, string
	jal name_cpy
	# s0, a0, a1, a2, t1, t2, t3, t4, t5 free
	
	# Check loop condition
	beq $s3, $s4, get_data_end 	# if index = last index, exit
	nop
	addi $s3, $s3, 1		# s3 = s3 + 1 <-> i = i + 1
	j get_data_loop			# next loop

get_data_end:
	j bubble_sort
	

# Bubble sort
# Argument: nb_student, name_list, mark_list
# Output: name_list, mark_list
bubble_sort:
	li $s3, 0			# Index = 0
	la $s4, nb_student
	lw $s4, 0($s4)			# s4 = length

bubble_sort_i_loop:
	addi $s3, $s3, 1			# i = i + 1
	beq $s3, $s4, bubble_sort_end 		# i = n - 1 -> list is sorted
	sub $s5, $s4, $s3			# s5 = n - i = end of j loop
	li $s6, -1				# s6 = j
 	j bubble_sort_j_loop
 	
bubble_sort_j_loop:
	addi $s6, $s6, 1			# j = j + 1
	beq $s6, $s5, bubble_sort_i_loop	# if j = n - i -> break -> back to i loop
	
	# Get mark_list[i] and mark_list[i + 1] to compare
 	mul $s7, $s6, 4				# s7 = position in mark_list
	la $a2, mark_list
	add $a2, $a2, $s7
	l.s $f0, 0($a2)				# f0 = mark_list[i]
	l.s $f1, 4($a2)				# f1 = mark_list[i + 1]
 	
 	# if mark[j] <= mark[j + 1] -> continue, otherwise -> swap
 	c.le.s $f0, $f1
 	bc1t bubble_sort_j_loop
 	
 	# Swap mark
	s.s $f0, 4($a2)
	s.s $f1, 0($a2)
	
	# Swap name
	mul $s7, $s6, 80			# s7 = position in name_list
	la $a2, name_list
	add $a2, $a2, $s7			# a2 = name[j]
	addi $a3, $a2, 80			# a3 = name[j + 1]
	
	# Copy name[j] to string (temp)
	la $a0, string				# a0 = string = dest
	move $a1, $a2				# a1 = name[j] = source
	jal name_cpy				# string = name[j]
	
	# Copy name[j + 1] to name[j]
	move $a0, $a2				# a0 = name[j] = dest
	move $a1, $a3				# a1 = name[j + 1] = source
	jal name_cpy				# name[j] = name[j + 1]
	
	# Copy string (temp) to name[j + 1]
	move $a0, $a3				# a0 = name[j + 1] = dest
	la $a1, string				# a1 = string = source
	jal name_cpy				# name[j + 1] = string
	
	j bubble_sort_j_loop
	
bubble_sort_end:
	j print_all


# Print all student
# Argument: nb_student, name_list, mark_list
# Output: none
print_all:				# Index = 0
	li $s3, 0
	la $s4, nb_student
	lw $s4, 0($s4)
	addi $s4, $s4, -1		# Last index = length - 1

print_all_loop:
	# Copy name + mark to print: s0, a0, a1, a2, t1, t2, t3, t4, t5 occupied
	add $t4, $s3, $zero		# t4 = index
	
	# Copy mark to f12
	mul $t5, $t4, 4			# t5 = position in mark_list
	la $a2, mark_list
	add $a2, $a2, $t5
	l.s $f12, 0($a2)
	
	# Copy name to string
	mul $t4, $t4, 80		# t4 = 80 * t4
	la $a1, name_list
	add $a1, $a1, $t4		# move to selected index in name_list
	la $a0, string
	jal name_cpy
	# s0, a0, a1, a2, t1, t2, t3, t4, t5 free
	
	jal print_student

	beq $s3, $s4, print_all_end 	# if index = last index, exit
	nop
	addi $s3, $s3, 1		# s3 = s3 + 1 <-> i = i + 1
	j print_all_loop		# next loop
	
print_all_end:
	j end


# Input number of student
# Ocuppy v0, a0, a1, a2, a3
# Ouput: a0 int value, a1 int status
input_num:
	li $a3, -2			# Status that Cancel was chosen
	li $v0, 51
	la $a0, Nb_student
	syscall

input_num_check:
	beq $a1, $a3, end		# If Cancel was chosen, quit the program
	bnez $a1, input_num_error	# If not sucess (status a1 != 0) ask for input again
	bltz $a0, input_num_error	# If entered value < 0 ask for input again
	j input_num_end			# Success -> end

input_num_error:
	la $a0, Invalid_input
	syscall
	j input_num_check

input_num_end:
	la $a2, nb_student
	sw $a0, 0($a2)
	jr $ra


# Input name
# Ocuppy v0, v1, a0, a1, a2
# Output: string, a1 int status
input_name:
	li $v0, 54
	la $a0, Input_name
	la $a1, string
	la $a2, 20
	li $v1, -2			# Status that Cancel was chosen
	syscall

input_name_check:
	beq $a1, $v1, end		# If Cancel was chosen, quit the program
	bnez $a1, input_name_error	# If not sucess (status a1 != 0) ask for input again
	j input_name_end		# Success -> end

input_name_error:
	la $a0, Invalid_input
	la $a1, string
	syscall
	j input_name_check

input_name_end:
	jr $ra

# Input mark
# Ocuppy v0, v1, f0, a1
# Ouput f0 float, a1 int status
input_mark:
	li $v0, 52
	la $a0, Input_mark
	li $v1, -2			# Status that Cancel was chosen
	syscall

input_mark_check:
	beq $a1, $v1, end		# If Cancel was chosen, quit the program
	bnez $a1, input_mark_error	# If not sucess (status a1 != 0) ask for input again
	j input_mark_end		# Success -> end

input_mark_error:
	la $a0, Invalid_input
	syscall
	j input_mark_check

input_mark_end:
	jr $ra	
	
# Name copy
# Ocuppy s0, s1, t1, t2, t3
# Argument: $a0 destination string address, $a1 source string address
# Note: x is dest, y is source
name_cpy:
	li $s0, 0			# Index = 0
	li $s1, 19			# Last index

name_cpy_loop:
	add $t1, $s0, $a1		# t1 = s0 + a1 = i + y[0] = address of y[i]
	lb $t2, 0($t1)			# t2 = value at t1 = y[i]
	add $t3, $s0, $a0		# t3 = s0 + a0 = i + x[0] = address of x[i]
	sb $t2, 0($t3)			# x[i] = t2 = y[i]
	beq $s0, $s1, name_cpy_end 	# if index = last index, exit
	nop
	addi $s0, $s0, 1		# s0 = s0 + 1 <-> i = i + 1
	j name_cpy_loop			# next character
	
name_cpy_end:
	jr $ra
	
	
# Print student
# Ocuppy v0, a0, f12
# Arguments: f12 = mark, string = name
# Output: none
print_student:
	# print name
	li $v0, 4
	la $a0, Name
	syscall
	la $a0, string
	syscall
	# print mark
	la $a0, Mark
	syscall
	li $v0, 2
	syscall
	jr $ra
	
end:
