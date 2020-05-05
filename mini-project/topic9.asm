#--------------------------------------------------------------------------
# Miniproject topic 9: Write a program to:
# - Read number of students
# - Read their name and Math mark
# - Print who have not passed Math
#--------------------------------------------------------------------------

.data
   	array:			.space  1000
   	string: 		.space  20000		#store all the names
   	pass_mark:		.float  4.0
   	min_mark:		.float  0.0
   	max_mark:		.float  10.0
    	enter_name: 		.asciiz "Enter a name:"
    	enter_num: 		.asciiz "Enter number of students:"
    	enter_mark: 		.asciiz "Enter his/her Math mark:"
    	list_pass_not: 		.asciiz "List of students not passing Math:\n"
	touch_min_mess: 	.asciiz "Mark has to be greater than 0.0"
	touch_max_mess: 	.asciiz "Mark has to be less than 10.0"
    	no_input_mess:		.asciiz "You have inputted nothing"
    	wrong_format_mess: 	.asciiz "Wrong format of input"


#---------------------------------------------------------------
#---Brief: Read each name and push into STACK-------------------
#----------Read his/her mark then compare with 4.0--------------
#----------Who has mark less than 4.0 then pop out of the stack-
#----------and store in one array-------------------------------
#----------Print that array of strings--------------------------

.text
initial:
	l.s	$f1,pass_mark		# load pass mark to f1
	l.s	$f2,min_mark		# load pass mark to f2
	l.s	$f3,max_mark		# load pass mark to f3
	la 	$t1,array 		# t1 = arrdess of array
	addi	$t2,$zero,1        	# t2 = count = 1
    	add 	$t3,$zero,$zero       	# t3 = not_pass_count = 0
    	la 	$t5,string          	# t5 = address of string
main:
   	li 	$v0,51  		# read number of students
    	la 	$a0,enter_num
    	syscall
    	jal	check_input_Int
	nop
    	addi 	$t0,$a0,0               # t0 = number of students

       	mul	$t7,$t0,4		# t7 = size of stack
       	sub	$sp,$sp,$t7		# update stack pointer
#---------------------------------------------------------------------
read_string:
    	bgt 	$t2,$t0,printName  	# if count > number of names then go to printName
    	nop
    	li 	$v0, 54
	la	$a0, enter_name
	move	$a1,$t5			# for a1 will be erased after syscall then copy content a1 to t4
	move	$t4,$a1
	la 	$a2, 20
    	syscall

    	addi	$sp,$sp,4
 	sw 	$t4,0($sp) 		# push $t4 register to stack

read_mark:
	li 	$v0,52			# read his/her mark
	la	$a0, enter_mark
    	syscall
    	jal 	check_input_Float
    	nop
#----------------------------------------------------------
check: #check mark in(0,10) and check if it is <4 or not
	c.lt.s  $f0,$f2
	bc1t	touch_min
	nop
	c.lt.s  $f3,$f0
	bc1t	touch_max
	nop
    	#the mark auto stored in f0
    	c.lt.s  $f0,$f1   		# compare f0, f1=pass_mark
    	bc1t  	storeName		# if true then branch to storeName
    	nop
    	j 	update
touch_min:
	li	$v0,50
	la	$a0,touch_min_mess
	syscall
	beq	$a0,2,done
	j 	read_mark
touch_max:
	li	$v0,50
	la	$a0,touch_max_mess
	syscall
	beq	$a0,2,done
	j 	read_mark
#------------------------------------------------------------
storeName:
	lw	$s1,0($sp)		# load pointer of that string from stack to s1
	sw	$s1,0($t1)		# store pointer of that string from s1 to array
	addi 	$t1,$t1,4		# update index of array
	addi	$t3,$t3,1		# update not pass_count

update:
    	addi 	$t2,$t2,1		# update count
    	addi 	$t5,$t5,20 		# update string
    	j 	read_string
#-------------------------------------------------------------
printName:
	la 	$t1,array 		# t1 = arrdess of array
    	addi    $t2,$zero,1         	# count = 1
	la      $a0,list_pass_not	# print sentence: List student not passing Math
   	li      $v0,4
    	syscall
while:
	bgt 	$t2,$t3,done		# if count > not_pass_count
	nop
    	lw 	$s3,0($t1)    		# load name from arr to s3
    	move    $a0,$s3			# copy s3 to a0
    	li      $v0,4
    	syscall
    	addi    $t1,$t1,4           	# advance array index
    	addi    $t2,$t2,1           	# advance count
    	j       while
#-----------------------------------------------------
check_input_Int:
	beq	$a1,-1,wrong_format_Int
	nop
	beq	$a1,-2,done
	nop
	beq	$a1,-3,no_input_Int
	nop
	jr	$ra
no_input_Int:
	li	$v0,50
	la	$a0,no_input_mess
	syscall
	beq	$a0,2,done
	j	main
wrong_format_Int:
	li	$v0,50
	la	$a0,wrong_format_mess
	syscall
	beq	$a0,2,done
	j 	main
#--------------------------------------------------------
#--------------------------------------------------------
check_input_Float:
	beq	$a1,-1,wrong_format_Float
	nop
	beq	$a1,-2,done
	nop
	beq	$a1,-3,no_input_Float
	nop
	jr	$ra
no_input_Float:
	li	$v0,50
	la	$a0,no_input_mess
	beq	$a0,2,done
	syscall
	j	read_mark
wrong_format_Float:
	li	$v0,50
	la	$a0,wrong_format_mess
	syscall
	beq	$a0,2,done
	j 	read_mark
#--------------------------------------------------------
done:
    	li      $v0,10
    	syscall


