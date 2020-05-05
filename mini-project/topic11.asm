#--------------------------------------------------------------------------
# Miniproject topic 11: FirstName - LastName
#--------------------------------------------------------------------------

.data
.align 2

array:	.space 20				# array can store 20 strings
string: .space 300000
message1 : .asciiz	"Enter name : "
message2 : .asciiz	"Duplicate "
message4 : .asciiz	"Name has invalid character. Please enter again "
message3 : .asciiz	"Name after converting"
message5 : .asciiz	"Null string!\n"
newline:    .asciiz "\n"

.text
# this program will read 2 strings from input stream
# them output name in revert order
main:
	li	$t0, 1				# counter
	add	$t1, $zero, $zero		# index array
	la	$s1, string			# load address of string storage area
read_string:
	bgt	$t0, 2, convert			# if user has inputed 2 strings, stop reading
	# output message
	li	$v0, 4
	la	$a0, message1
	syscall

	# get name
	li	$v0, 8
	move	$a0, $s1
	li	$a1, 40
	syscall
	move	$s0, $a0
	move	$s7, $a0				# $s7 store address of string for checking invalid character

#----CHECK VALID OF INPUT NAME-----#
check_null:
	lb	$t9, ($s0)
	bne	$t9, 10, check_valid
	li	$v0, 4
	la	$a0, message5
	syscall
	j	read_string
	#---CHECK IF NAME CONTAINS INVALID CHARACTER ? ----#
	check_valid:					# function checking if name has invalid character

    		# increment $t9 to next char of string
		lb	$t9, ($s7)
		beq	$t9, 10, compare_string
   		blt     $t9, 65, name_invalid         # less than 'A'? if yes, loop
    		bgt     $t9, 122, name_invalid        # greater than 'z'? if yes, loop

    		blt     $t9, 91, continue         # less than or equal to 'Z'? if yes, doit
    		bgt     $t9, 96, continue         # greater than or equal to 'a'? if yes, doit

    		continue:
    			addi	$s7, $s7, 1
    			j       check_valid

    		name_invalid:
    			beq	$t9, 32, continue	# 'space' is a valid character
    			li 	$v0, 4
    			la	$a0, message4
    			syscall
    			jal	new_line
    			j 	read_string

	#---COMPARE 2 STRINGS, IF THEY ARE THE SAME, INFORM "DUPLICATE"---#
	compare_string:
		li 	$t2, 1					# counter
		add	$t3, $zero, $zero			# index of array
		init:
			beq	$t2, $t0 , store_c_string	# more string to compare ? store current string & continue
			lw	$s2, array($t3)			# load address of existing string in array
			move	$s3, $a0			# copy address of current string to $s3
		while1:
			lb	$t8, ($s2)
			lb	$t9, ($s3)
			bne	$t8, $t9, strneq		# if 2 characters not equal -> stop comparing
			beqz    $t8, checks2			# else if meet end character in first string -> check second string
			beqz	$t9, strneq			# else 2 strings are not equal
			addi	$s2, $s2, 1			# array_index++
			addi	$s3, $s3, 1			# array_index++
			j 	while1
		checks2:
			bnez	$t9, strneq
    		streq:						# if 2 string are equal, output message, read again
    			li	$v0, 4
    			la	$a0, message2
    			syscall
    			jal	new_line
    			j	read_string
		strneq:
			addi    $t3,$t3,4           # array_index++
    			addi    $t2,$t2,1           # count++
    			j       init
    		store_c_string:
    			sw	$s0, array($t1)     # store current word into array
    			addi	$t1, $t1, 4	    # array_index++
    			addi	$t0, $t0, 1	    # count++
    			addi	$s1, $s1, 40        # move to next string area
    			j	read_string	    # return to read_strings
	#----------------------------------------------------------------
#----CONVERT FUCNTION-----#
convert:
	#-------------------------------------------------------------------
	# $t0 : index array
	# $t1 : counter
	# $s0 : address of current string
	#-------------------------------------------------------------------
	li	$v0, 4
	la	$a0, message3
	syscall
	jal	new_line
	addi	$t0, $zero, 0				# index of array
	addi	$t1, $zero, 1				# counter
	while2:
		bgt	$t1, 2, print_result
		lw	$s0, array($t0)
		# sub_program finding position of the last space in name
		find_space:
			move	$s2, $s0 			#
			li	$t8, 0 				# mark position of blank
			li	$t9, 0				# count character
		loop:
			lb	$t2, ($s2)
			beq	$t2, 10, done
			beq	$t2, 32, dost
			addi	$t9, $t9, 1
			addi	$s2, $s2,1
			j	loop
		dost:
			add	$t8, $zero, $t9
			addi	$t9, $t9, 1
			addi	$s2, $s2, 1
			j	loop
	done:
		beq	$t8, 0, advance			# if name has only 1 word -> no need to modify any thing, continue with the next string
		part1:					# first copy fisrtname to temporary register  $s1
		add	$s2, $s0, $t8			# move the pointer to last space position
		addi	$s2, $s2, 1
		addi	$s1, $s1,40
		loop1:
			lb	$t2, ($s2)
			beq	$t2, 10, part2
			sb	$t2, ($s1)
			addi	$s2, $s2, 1
			addi	$s1, $s1, 1
			j	loop1
		part2:					# then, copy lastname to temporary register  $s1
#		lw	$s0, array($t0)
		add	$s2, $s0, $t8
		lb	$t2, ($s2)
		sb	$t2, ($s1)
		addi	$s1, $s1, 1
		add	$s2 $s0, $zero
		li	$t3, 0				# counter
		loop2:
			beq	$t3, $t8, cont
			lb	$t2, ($s2)
			sb	$t2, ($s1)
			addi	$s2, $s2, 1
			addi	$s1, $s1, 1
			addi	$t3, $t3, 1
			j	loop2
	cont:
		la	$a1, newline
		lb	$t2, ($a1)
		sb	$t2, ($s1)
		sub	$s1, $s1, $t9
		sw	$s1, array($t0)			# store value of $s1 back to the array
	advance:
		addi	$t0, $t0, 4			# continue with the next element in array
		addi	$t1, $t1, 1
		j	while2
print_result:
	li	$t0, 0				# index
	li	$t1, 1				# counter
	while:
		bgt	$t1, 2, end
		lw	$a0, array($t0)
		li	$v0, 4
		syscall
		addi	$t0, $t0, 4
		addi	$t1, $t1, 1
		j	while
new_line:
    la      $a0,newline
    li      $v0,4
    syscall
    jr      $ra
end:
	li	$v0, 10
	syscall

