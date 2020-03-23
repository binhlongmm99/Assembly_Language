#Laboratory Exercise 4, Assignment 2
.text
	li $s0, 0x12345678
	
	# extract MSB from $0
	andi $t0, $s0, 0xff000000
	srl $t0, $t0, 24
	
	andi $t1, $s0, 0xffffff00	# clear LSB of $s0
	ori $t2, $s0, 0x000000ff	# set LSB of $s0	
	andi $s0, $s0, 0x00000000	# clear $s0		


