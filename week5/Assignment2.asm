#Laboratory Exercise 5, Assignnment 2
.data
	message1: .asciiz "The sum of "
	message2: .asciiz " and "
	message3: .asciiz " is "
.text
	li $s0, 1
	li $s1, 2
	add $s2, $s0, $s1	#s2 = s0 + s1
	
	li $v0, 4
	la $a0, message1
	syscall			#print message1
	li $v0, 1
	add $a0, $zero, $s0
	syscall			#print value of s0
	li $v0, 4
	la $a0, message2
	syscall			#print message2
	li $v0, 1
	add $a0, $zero, $s1
	syscall			#print value of s1
	li $v0, 4
	la $a0, message3
	syscall			#print message3
	li $v0, 1
	add $a0, $zero, $s2
	syscall
