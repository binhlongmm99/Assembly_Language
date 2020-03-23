.data
A: 	.word 7,-2,5,1,5,6,7,3,6,8,8,59,5
.text
	la $a0, A	# a0 = Address(A[0])
	li $a1, 13	# a1 = n = number of elements
	li $t0, 1	#initialize index i in $t0 to 1
	li $t3, 4
loop1:
	slt $t4, $t0, $a1	# i < n?
	beq $t4, $zero, end	# if false, end
	add $s0, $a0, $t3	# s0 = address(A[i])
	lw $s1, 0($s0)		# s1 = key = A[i]
	add $t1, $t0, -1	# j = i-1
loop2:
	add $t3, $t1, $t1	# t3 = 2j
	add $t3, $t3, $t3	# t3 = 4j
	add $s2, $a0, $t3	# s2 = address(A[j])
	addi $s4, $s2, 4	# s4 = address(A[j+1])
	slt $t4, $t1, $zero	# j < 0?
	bne $t4, $zero, key 	# if true, key
	lw $s3, 0($s2)		# s3 = A[j]
	slt $t4, $s1, $s3	# key < A[j] ?
	beq $t4, $zero, key 	# if false, key
	sw $s3, 0($s4)
	addi $t1, $t1, -1
	j loop2
key:
	sw $s1, 0($s4)
inc_i:
	addi $t0, $t0, 1	# i = i+1
	add $t3, $t0, $t0	# t3 = 2i
	add $t3, $t3, $t3	# t3 = 4i
	j loop1
end: