.data
array: .word 1, 2, 3, 4, 5, 6
.text
# Assign i, n, step, sum, array A
	li $s1, -1		# i = $s1 = 1
	la $s2, array 		# starting address of A = $s2
	li $s3, 2		# n = $s3 = 3
	li $s4, 1		# step = $s4 = 1
	li $s5, 0		# sum = $s5 = 0
loop:
	add $s1,$s1,$s4 	#i=i+step
	add $t1,$s1,$s1 	#t1=2*s1
	add $t1,$t1,$t1 	#t1=4*s1
	add $t1,$t1,$s2 	#t1 store the address of A[i]
	lw $t0,0($t1) 		#load value of A[i] in $t0
	add $s5,$s5,$t0 	#sum=sum+A[i]
	bne $s1,$s3,loop 	#if i != n, goto loop

	# blt $s1, $s3, loop 	# a) i < n
	# ble $s1, $s3, loop 	# b) i <= n
	# bge $s5, $0, loop 	# c) sum >= 0
	# beq $t0, $0, loop 	# d) A[i] == 0
