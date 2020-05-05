#------------------------------------------------
# Miniproject topic 2: Prime number  
#------------------------------------------------

#-----------------------------------------------------------------------------------
# To input the value and check the validaton, we use register $v0, $a0 and $a1
# @brief	Print the prime number from a range of an integer N to an integer M
# @param[in]	$s0 - integer N
# @param[in]	$s1 - integer M
# @param[in]	$s2 - integer we consider, $s2 runs from N to M
#		$s2++ after one loop
# To check the validation of input, we use register $t5, $t6, $t7
# @register	$t5 = -1
# @register	$t6 = -2
# @register	$t7 = -3
# @return	result - the array of prime numbers
#---------------------------------------------------
.data
	Message1: .asciiz "Input integer N: "
	Message2: .asciiz "Input integer M: "
	Result: .space 200			# allocating 50 integers
	MessageResult1: .asciiz "The prime numbers are from "
	MessageResult2: .asciiz " to "
	MessageResult3: .asciiz ": "
	MessageFailedParse: .asciiz "The format input is not correct!"
	MessageChoosingCancel: .asciiz "The cancel button was choosen!"
	MessageNoDataInputted: .asciiz "No data was inputted!"
.text
main:
# Initializing $t5, $t6, $t7
	li $t5, -1
	li $t6, -2
	li $t7, -3
# Input N
	li $v0, 51
	la $a0, Message1
	syscall
	beq $a1, $t5, failedParse
	beq $a1, $t6, choosingCancel
	beq $a1, $t7, noDataInputted
	move $s0, $a0

# Input M
	li $v0, 51
	la $a0, Message2
	beq $a1, $t5, failedParse
	beq $a1, $t6, choosingCancel
	beq $a1, $t7, noDataInputted
	syscall
	move $s1, $a0
	j trueFormat
failedParse:
# Print "The format input is not correct!"
	li $v0, 4
	la $a0, MessageFailedParse
	syscall
	j end_main
choosingCancel:
# Print "The cancel button was choosen!"
	li $v0, 4
	la $a0, MessageChoosingCancel
	syscall
	j end_main
noDataInputted:
# Print "No data was inputted!"
	li $v0, 4
	la $a0, MessageNoDataInputted
	syscall
	j end_main
# Main loop
# @param[i]	$t0 - index of array [2, ... , $s2]
# @param[i]	$t1 - remainder of N / i
# @param[i]	$t2 - index of array Result
trueFormat:
# Initial $t2
	li $t2, 0
# $s2 is counted from $s0 to $s1 to check prime
	move $s2, $s0
# Recursive loop:
# For each number from N to M, we check whether it is prime by procedure checkPrime
loop:
	li $t0, 2		# i = 2

	sw $fp, -4($sp)		# save frame pointer
	move $fp, $sp		# create a new frame pointer
	addi $sp, $sp, -20	# take 4 words for: $fp, $s0, $s1, $ra
	sw $ra, 12($sp)		# save return address
	sw $s2, 8($sp)		# save s2
	sw $s1, 4($sp)		# save s1
	sw $s0, 0($sp)		# save s0

	jal checkPrime

	lw $s0, 0($sp)		# restore s0
	move $sp, $fp
	lw $fp, -4($sp)		# restore frame pointer
	lw $ra, -8($sp)		# restore return address
	lw $s2, -12($sp)	# restore s2
	lw $s1, -16($sp)	# restore s1

	sub $s3, $s2, $s1	# s2 = N - M
	bgez $s3, end_loop	# if N > M then end loop
	nop
	#if not
	addi $s2, $s2, 1	# N ++

	j loop
end_loop:
# @param[i]	$t3 - index of array Result from 0 to $t2 to print each element in array Result
	li $t3, 0
# Print "The prime numbers from "
	li $v0, 4
	la $a0, MessageResult1
	syscall
# Print N
	li $v0, 1
	move $a0, $s0
	syscall
# Print " to "
	li $v0, 4
	la $a0, MessageResult2
	syscall
# Print M
	li $v0, 1
	move $a0, $s1
	syscall
# Print ": "
	li $v0, 4
	la $a0, MessageResult3
	syscall
loop_output:
	li $v0, 1
	la $a0, Result
	add $a0, $a0, $t3	# address of prime_array[index]
	lw $a0, 0($a0)
	syscall

	# print a white space
	li $v0, 11
	li $a0, ' '
	syscall

	addi $t3, $t3, 4	# next element
	bge $t3, $t2, end_main
	nop
	j loop_output
end_main:
# exit the program
	li $v0, 10
	syscall
#-----------------------------------------------------------------------------
# Procedure checkPrime: We will check whether this number is prime
# Algorithm:
# If there are any number X that can divide one number in array from 2 to X-1 then it is not a prime number
# Else X is a prime number
checkPrime:
loop_checkPrime:
	# Divide $s2 into $t0
	divu $s2, $t0
	mfhi $t1		# move the remainder into $t1
	#If $t1 = 0 then this number is not prime
	beqz $t1, NotPrime
	nop
	#if not, continue loop until i < n
	addi $t0, $t0, 1	# i++
	# condition: i < $s2
	bge $t0, $s2, end_checkPrime
	nop
	j loop_checkPrime
end_checkPrime:
# store the prime numbers into array Result
	la $t4, Result
	add $t4, $t4, $t2	# address of Result[index]
	sw $s2, 0($t4)		# store integer we are considering (from N to M) into Result
	addi $t2, $t2, 4	# index++
	jr $ra
NotPrime:
	jr $ra
