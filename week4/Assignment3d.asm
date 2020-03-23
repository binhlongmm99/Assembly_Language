#Laboratory Exercise 4, Assignment 3d
.text
	li $s1, 1			#$s1 = 1
	li $s2, -2			#s2 = -2

	slt $t0, $s2, $s1		
	beq $t0, $zero, L		# if $t0 = 0, jump to L 
L:
