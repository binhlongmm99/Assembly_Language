.data
A: 	.word 7,-2,5,1,5,6,7,3,6,8,8,59,5
.text
	la $a0, A	# a0 = Address(A[0])
	li $a1, 12	# a1 = n = number of elements-1
	add $a1,$a1,-1	# a1 = n-1
	li $t0, 0	#initialize index i in $t0 to 0
	li $t3, 0
loop1:
	li $t1, 0	#initialize index j in $t1 to 0
	slt $t4, $t0, $a1	# i < n-1 ?
	bne $t4, $zero, loop2	# if true, loop2
	j end
loop2:
	sub $a2, $a1, $t0	# a2 = n-1-i
	slt $t4, $t1, $a2	# j < n-1-i ?
	beq $t4, $zero, inc_i 	# if false, inc_i
	add $s0, $a0, $t3	# s0 = address(A[j])
	lw $s1, 0($s0)		# s1 = A[j]
	addi $t2, $t3, 4	# t2 = j + 1
	add $s2, $a0, $t2	# s2 = address(A[j+1])
	lw $s3, 0($s2)		# s3 = A[j+1]
	slt $t4, $s3, $s1	# A[j+1] < A[j]?
	bne $t4, $zero, swap	# if true, swap(A[j+1], A[j])
	j inc_j
inc_i:
	addi $t0, $t0, 1	# i++
	j loop1
inc_j:
	addi $t1, $t1, 1	# j++
	add $t3, $t1, $t1	# t3 = 2j
	add $t3, $t3, $t3	# t3 = 4j 
	j loop2	 
swap:
	sw $s1, 0($s2)	# load A[j] to address A[j+1]
	sw $s3, 0($s0)	# load A[j+1] to address A[j]
	j inc_j
end:
