#Laboratory Exercise 4, Assignment 3a
.text
	li $s1,-5	# $s1 = -5
	#abs $s0, $s1

	sra $at, $s1, 0x001f	# set $at = -1 if $s1 < 0, $at = 0 if $s1 >= 0
	xor $s0, $at, $s1	# set $s0 = NOT $s1 if $at = -1, $s0 = $s1 if $at = 0
	subu $s0, $s0, $at	# $s0 = $s0 - $at	
