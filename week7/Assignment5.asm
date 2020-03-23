.text
main: 	
#$t0 stores max value, with index is stored in $t1
#$t2 stores min value, with index is stored in $t3

	#load test inputs
	li $s0,1 
	li $s1,2
	li $s2,3
	li $s3,-1 
	li $s4,-2
	li $s5,4
	li $s6,7
	li $s7,8
	
#push into stack
push:
	addi $sp,$sp,-32	#init stack with 8 component
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	sw $s3,12($sp)
	sw $s4,16($sp)
	sw $s5,20($sp)
	sw $s6,24($sp)
	sw $s7,28($sp)
end_push:
	
#jump to function to find max and min
	jal find_max_min
	
	add $t0,$a0,$zero	#store max value inside $t0
	add $t1,$a1,$zero	#store max value index inside $t1
	add $t2,$a2,$zero	#store min value inside $t2
	add $t3,$a3,$zero	#store min value index inside $t3
	
	li $v0,10		#terminate
	syscall
	
find_max_min:
	addi $t0,$t0,0		#init $t0 = 0
	addi $t1,$t1,8		#n = 8
	addi $a0,$zero,0	#init max value = 0
	addi $a2,$zero,999999	#init min value = 999999
	
loop:
	beq $t0,$t1,end_loop
	lw $t2,0($sp)		#pop stack
		
#find max
	blt $t2,$a0,check_min	#if less then max then check if it is min
	#save max value & index
	add $a0,$zero,$t2
	add $a1,$zero,$t0
		
#find min
check_min:
	bgt $t2,$a2,end_check	#if greater than min then stop check
	#save min value & index
	add $a2,$zero,$t2
	add $a3,$zero,$t0
		
end_check:
		
#free stack
	addiu $sp,$sp,4		#decrease stack size
	addi $t0,$t0,1		#increase index
	j loop
		
end_loop:
	jr $ra	#jump back