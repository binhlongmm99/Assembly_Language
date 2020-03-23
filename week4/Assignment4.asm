#Laboratory Exercise 4, Assignment 4
.text

	li $t0, 0 		#No Overflow is default status
	li $s1, 2000000000
	li $s2, 2000000001
	addu $s3, $s1, $s2

	xor $t1, $s1, $s2 	#Test if $s1 and $s2 have the different sign
	bltz $t1, EXIT 		

	xor $t1, $s3, $s1 	#Test if $s3 and $s1 have the same sign
	bgtz $t1, EXIT 		
 
	xor $t1, $s3, $s2 	#Test if $s3 and $s2 have the same sign
	bgtz $t1, EXIT 		

OVERFLOW:
	li $t1, 1

EXIT:
