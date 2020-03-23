#Laboratory Exercise 3, Home Assignment 1
.text
# Assign i, j
	li $s1, 1		# i = $s1 = 1
	li $s2, 2		# j = $s2 = 2
	
start:
	#a. i<j
	#		slt $t0,$s1,$s2
	#		beq $t0,$zero,else
	#b. i>=j
	#		slt $t0,$s1,$s2
	#		bne $t0,$zero,else
	#c. i+j<=0
	#		add $t0,$s1,$s2
	#		slt $t1,$zero,$t0
	#		bne $t1,$zero,else
	#d. i+j>m+n  (assume that m and n are stored in s3 and s4 register respectively)
	#		add $t0,$s1,$s2
	#		add $t1,$s3,$s4
	#		slt $t2,$t1,$t0
	#		beq $t2,$zero,else
	 
	addi $t1,$t1,1 		# then part: x=x+1
	addi $t3,$zero,1 	# z=1
	j endif 		# skip “else” part
else: 	addi $t2,$t2,-1 	# begin else part: y=y-1
	add $t3,$t3,$t3 	# z=2*z
endif:
