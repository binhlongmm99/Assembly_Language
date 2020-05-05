#--------------------------------------------------------------------------
# Miniproject topic 6: Star triangle
#--------------------------------------------------------------------------

.data
	space: .asciiz " "
	msg_inp:  .asciiz "Input number: "
	msg_out: .asciiz "Output the triangle:\n"
	newline: .asciiz "\n"
	star: .asciiz "*"

.text
input:	
	li $v0, 51						# system call code for read number, 
								# $a0 contains integer read, 
								# $a1 contains error code with 0 mean no error
	la $a0, msg_inp
	syscall
	bne $a1, $zero, input					# if (a1 != 0) then goto input
	nop
	la $s0,($a0)
	
#----------------------------------------------------------------- 
# Print triangle: Based on this algorithm below
# {
# i = 1
# output: "___*___" (1 star: the top vetex)
# while (i < n-1){
#	output: "_*___*_" (2 stars, location depends on i} 
#	i++;
# }	
# output: "*..*..*..."} (2*n-1 stars: the bottom base)	
# }
# $s0 : input number n
# $t0 : i, 2->n-1
# $t1 : j
#----------------------------------------------------------------- 

#----------------------------------------------------------------- 
# print the top vetex of the triangle
# $t1 : j: 0->n-1: n times
# $t2 = n-1
#----------------------------------------------------------------- 
one_star:
	and $t1, $t1, $zero					# $t1 = j = 0
	addi $t2, $s0, -1 					# $t2 = n-1
loop_one_star:
	beq $t1, $t2, end_loop_one_star
	nop
	jal print_space
	jal print_space
	addi $t1, $t1, 1
	j loop_one_star 					# loop
end_loop_one_star:
	jal print_star
	jal print_newline
	j two_stars
	
#----------------------------------------------------------------- 
# output for "two - star" rows
# $t0 : i, i= 1->n-1 : n-1 times
# $t1 : j, j= 0->n, or end loop
# $t2 = n-1
# $t3 = (n-1)- i
# $t4 = (n-1)+ i
#----------------------------------------------------------------- 

two_stars:
	la $t0, ($zero)						# i = 0
	addi $t1, $zero, 0					# $t1 = j = 0
	addi $t2, $s0, -1 					# $t2 = n-1
	
loop_i:
	addi $t0, $t0, 1					# i =1
	beq $t0, $t2, many_stars 				#end loop when i = n-1, go to "many_stars"
	# $t3 = (n-1) - i
	sub $t3, $t2, $t0
	# $t4 = (n-1) + i
	add $t4, $t2, $t0
	addi $t1, $zero, 0					# $t1 = j = 0
	j loop_two_stars 

loop_two_stars:
	beq $t1, $t3, case_1st_star
	nop
	beq $t1, $t4, case_2nd_star
	nop
	j default
continue:
	addi $t1, $t1, 1
	j loop_two_stars

case_1st_star:
	jal print_star
	jal print_space
	j continue
case_2nd_star:
	jal print_star
	jal print_newline
	j loop_i
default: 
	jal print_space
	jal print_space
	j continue


#----------------------------------------------------------------- 
# print the base of the triangle
# print 2*n-1 stars and 2*n-2 space-s
# $t2 = 2n-2
# $t1 : j: 0-> $t2 aka for(j=0;j<2n-1;j++ )
#----------------------------------------------------------------- 
many_stars:
	add $t1, $zero, $zero					# $t1 = j = 0 
	addi $t2, $s0, -2 					# $t2 = n-2
	add $t2, $t2, $s0 					# $t2 = 2n-2
loop_many_stars:
	beq $t1, $t2, end_loop_many_stars
	nop
	jal print_star
	jal print_space
	addi $t1, $t1, 1
	j loop_many_stars 					# loop
end_loop_many_stars:
	jal print_star
	jal print_newline
	j end

print_space:
	la $a0, space
	li $v0, 4
	syscall
	jr $ra
	
print_star:
	la $a0, star
	li $v0, 4
	syscall
	jr $ra
print_newline:
	la $a0, newline
	li $v0, 4
	syscall
	jr $ra
end:
