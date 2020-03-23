#------------------------------------------------------
# col 0x1 col 0x2 col 0x4 col 0x8
#
# row 0x1 0 1 2 3
# 0x11 0x21 0x41 0x81
#
# row 0x2 4 5 6 7
# 0x12 0x22 0x42 0x82
#
# row 0x4 8 9 a b
# 0x14 0x24 0x44 0x84
#
# row 0x8 c d e f
# 0x18 0x28 0x48 0x88
#
#------------------------------------------------------
# command row number of hexadecimal keyboard (bit 0 to 3)
# Eg. assign 0x1, to get key button 0,1,2,3
# assign 0x2, to get key button 4,5,6,7
# NOTE must reassign value for this address before reading,
# eventhough you only want to scan 1 row
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
# receive row and column of the key pressed, 0 if not key pressed
# Eg. equal 0x11, means that key button 0 pressed.
# Eg. equal 0x28, means that key button D pressed.
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014

.data
arr: .word 0x1, 0x2, 0x4, 0x8

.text
main: 	li $t1, IN_ADRESS_HEXA_KEYBOARD
	li $t2, OUT_ADRESS_HEXA_KEYBOARD
	#li $t3, 0x08 	# check row 4 with key C, D, E, F
	la $s0, arr 	# load address of arr to $s0
	li $t4, 0 	# $t4 = i = 0
	add $t5, $t4, $t4	# $t5 = 2i
	add $t5, $t5, $t5	# $t5 = 4i
	add $t5, $t5, $s0	# $t5 = address of arr[i]
	lw $t3, 0($t5)	# t3 = arr[i]

polling: sb $t3, 0($t1) # must reassign expected row
	lb $a0, 0($t2) 	# read scan code of key button
	beq $a0, $zero, inc
	
print: 	li $v0, 34 	# print integer (hexa)
	syscall
	
sleep: 	li $a0, 5000 	# sleep 5000ms
	li $v0, 32
	syscall

inc:	addi $t4, $t4, 1	# i++
	slti $t0, $t4, 4	# t4 < 4? 
	bne $t0, $zero, back_to_polling 	# if true => back_to_polling
	li $t4, 0		
	
back_to_polling:
	add $t5, $t4, $t4	
	add $t5, $t5, $t5
	add $t5, $t5, $s0	# $t5 = address of arr[i]
	lw $t3, 0($t5)		# t3 = arr[i] 
	j polling # continue polling