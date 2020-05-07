#------------------------------------------------
# Miniproject topic 2: Prime number  
#------------------------------------------------

.data
new_line:		.asciiz "\n"
get_m_msg:		.asciiz	"Enter the integer N : "
get_n_msg:		.asciiz	"Enter the integer M : "
input_invalid_error_msg:.asciiz "Invalid input data !"
cancel_error_msg:	.asciiz "Cancal was chosen !"
no_input_error_msg:	.asciiz "OK was chosen but no input data"

.text
main:
	li	$v0, 51		
	la	$a0, get_m_msg
	syscall
	
	jal	catch_error
	add	$t1, $zero, $a0		# copy the inputed value to $t1
	
	li	$v0, 51
	la	$a0, get_n_msg
	syscall
	
	jal	catch_error
	add	$t2, $zero, $a0		# copy the inputed value to $t2
	
	
for: 						# for i from N to M
	sle	$t3, $t0, $t2	
	beq	$t3, $zero, exit		# if i <= M, exit program
	
	add	$a0, $zero, $t0			# call is_prime(i)
	jal	is_prime
	
	beq	$v1, $zero, for_continue 	# if i is not prime , continue for
	
	add	$a0, $zero, $t0			# call print_prime_number(i)
	jal	print_number	

for_continue:
	addi	$t0, $t0, 1			# i = i + 1
	j	for

exit:
	li	$v0, 10
	syscall
		
#----------------------------------------------------------------------------------
# 	Procedure catch_error: catch error of dialog input
#	param[in]	$a1	error code
#----------------------------------------------------------------------------------	
catch_error:
	beq	$a1, -1, catch_input_invalid_error
	beq	$a1, -2, catch_cancel_error
	beq	$a1, -3, catch_no_input_error
	
	jr	$ra		# return
catch_input_invalid_error:
	li	$v0, 4
	la	$a0, input_invalid_error_msg
	syscall
	j	exit
catch_cancel_error:
	li	$v0, 4
	la	$a0, cancel_error_msg
	syscall
	j	exit
catch_no_input_error:
	li	$v0, 4
	la	$a0, no_input_error_msg
	syscall
	j	exit
	

#----------------------------------------------------------------------------------
# 	Procedure is_prime: Tells if num is prime
#	param[in]	$a0	integer num
#	return		$v1	1 if the number is prime, 0 if it's not
#	Resigters usage:
#		$s0		- variable x
#		$s1, $s3	- temp resigter
#----------------------------------------------------------------------------------
is_prime:
	subu	$sp, $sp, 12
	sw	$s0, 0($sp)				# save the local enviroment
	sw	$s1, 4($sp)
	sw	$s3, 8($sp)
	
	ble	$a0, 1, is_prime_return_false
	
	addi	$s0, $s0, 2				# int x = 2	

is_prime_test:
	slt	$s1, $s0, $a0			
	bne	$s1, $zero, is_prime_loop 		# if (x >= num) 
	
	j	is_prime_return_true
	
is_prime_loop:
	div	$a0, $s0
	mfhi	$s3				    	    # c = (num % x)
	bne	$s3, $zero, is_prime_loop_continue	# if (c == 0)
	
	j	is_prime_return_false
	
is_prime_loop_continue:
	addi	$s0, $s0, 1				# x = x + 1
	j	is_prime_test
	
is_prime_return_true:
	addi	$v1, $zero, 1 			    	    # It's a prime, return 1 
	j	is_prime_return

is_prime_return_false:
	add	$v1, $zero, $zero			    # It's not a prime, return 0
	j	is_prime_return

is_prime_return:
	lw	$s0, 0($sp)				    # restore the prior enviroment
	lw	$s1, 4($sp)				    # restore the prior enviroment
	lw	$s3, 8($sp)				    # restore the prior enviroment
	addu	$sp, $sp, 12
	jr	$ra					    # return 0
	
#----------------------------------------------------------------------------------
#	Procedure print_prime_number: print out prime number
#	param[in]	$a0	the prime number
#----------------------------------------------------------------------------------
print_number:
	subu	$sp, $sp, 12
	sw	$ra, 0($sp)	# save the local enviroment
	sw	$v0, 4($sp)	# save the local enviroment
	sw	$a0, 8($sp)	# save the local enviroment
		
	li	$v0, 1		# print prime_number 
	syscall
	
	li	$v0, 4		# prime new line
	la	$a0, new_line
	syscall
	
	lw	$ra, 0($sp)	# restore the prior enviroment
	lw	$v0, 4($sp)	# restore the prior enviroment
	lw	$a0, 8($sp)	# restore the prior enviroment
	addu	$sp, $sp, 12	# restore the prior enviroment
	
	jr	$ra
	
