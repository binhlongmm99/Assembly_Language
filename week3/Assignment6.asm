.data
A: .word 1, -2, -3, -6, 4
n: .word 5
max: .word 0
i: .word 0
step: .word 1
tmp: .word 0
result: .word 0

.text
	la $s0, A	# s0 = address of A[]
	la $t1, n	
	lw $s1, 0($t1)	# s1 = n (length of array)

	la $t1, max
	lw $s2, 0($t1)	# s2 = max
	la $t1, i
	lw $s3, 0($t1)	# s3 = i
	la $t1, result
	lw $s4, 0($t1)	# s4 = result
	la $t1, step
	lw $s5, 0($t1)	# s5 = step
	la $t1, tmp
	lw $s6, 0($t1)	# s6 = tmp

loop: 
	add $t1, $s3, $s3 # t1 = 2*i
	add $t1, $t1, $t1 # t1 = 4*i
	add $t1, $t1, $s0 # t1 store address of A[i]
	lw $t0, 0($t1) 	
	lw $t2, 0($t1) 	
	slt $t1, $t0, $zero # A[i] < 0
	beq $t1, $zero, find 
	sub $t0, $zero, $t0 # get absolute of A[i] if A[i]<0
find:
	slt $t1, $t0, $s2 # |A[i]| < max
	bne $t1, $zero, check
	add $s2, $zero, $t0 # max = |A[i]|
	add $s6, $zero, $t2 # tmp = A[i]
check:
	add $s3, $s3, $s5	# i = i+step
	bne $s3, $s1, loop
	
	add $s4,$zero,$s6 # result = tmp
