.data
	string: .space 21
	result: .space 21
.text
get_string:
	li $v0, 8
	la $a0, string
	li $a1, 21
	syscall
get_length: 
	la $a0, string 		# a0 = Address(string[0])
	xor $v0, $zero, $zero 	# v0 = length = 0
	xor $t0, $zero, $zero 	# t0 = i = 0
check_char: 
	add $t1, $a0, $t0 	# t1 = a0 + t0
				#= Address(string[0]+i)
	lb $t2, 0($t1) 		# t2 = string[i]
	beq $t2,$zero,end_of_str # Is null char?
	addi $v0, $v0, 1 	# v0=v0+1->length=length+1
	addi $t0, $t0, 1 	# t0=t0+1->i = i + 1
	j check_char
end_of_str:
	add $s0, $zero, $v0	# s0 = length
	sub $s0,$s0,1		# s0= length-1 (array index starts from 0)
			
strcpy_inverse:
	la $a0, string		# a0 = address(string[0])
	la $a1, result		# a1 = address(result[0])
	add $t0, $zero, $s0	# t0 = i = s0 = length(string) 
	xor $t1,$zero,$zero 	# t1 = j  = 0
loop:
	add $t2, $t0, $a0 	# t2 = a0 + t0 = address(string[0]+i)
	add $t3, $t1, $a1 	# t2 = a1 + t1 = address(result[0]+j)
	lb $t4, 0($t2)		# t4 = string[i]
	sb $t4, 0($t3)		# result[j] = t4
	beq $t4,$zero,end_of_strcpy
	subi $t0,$t0,1		#i--
	addi $t1,$t1,1		#j++
	j loop
end_of_strcpy:
	li $v0, 55
	la $a0, result
	li $a1, 1
	syscall

