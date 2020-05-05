#-------------------------------------
# Miniproject topic 1: Palindrome  
#-------------------------------------

.data
array_of_len: 
	.space 1000 #250 elements
str_inp: 
	.space 1000
newline:
	.asciiz "\n"
msg_ask_for_enter_more_string:
	.asciiz "Do you want to enter another string? Type y/n: "
msg_wrong_input_for_ask:
	.asciiz "\nWrong syntax. Please type your choice correctly again!"
msg_inp: 
	.asciiz  "\nInput String (limit 40): "
msg_out_not_palin: 
	.asciiz " IS NOT a palindrome\n"
msg_out_palin:
	.asciiz " IS a palindrome\n"
string: 
	.asciiz "Output: string "
sign:	
	.asciiz "\""
msg_out_dup:
	.asciiz " is duplicated with your previous input palindrome string. Please enter for another\n\n"	
msg_out_empty:
	.asciiz  "You have entered an empty string. Please enter for another\n"
msg_out_end_program:
	.asciiz  "\nProgram ended. Goodbye\n"
.text 
start:  		
	la $s1,str_inp	#will be array[end]
	la $s2,array_of_len 
input: 
	#print "Input String: "
	li $v0,4	# system call code for print Str
	la $a0,msg_inp	# address of string to print
	syscall		# print msq_inp
	
	#read input string
	li $v0,8	# system call code for read Str
	la $a0,($s1)	# $a0 : addr of input string
	li $a1,100	# length of input: 100
	syscall
	
	#check if string empty
	lb $t0,($a0)
	beq $t0,'\n',empty_string
	
	add $t0,$a0,$zero	# $t0: address of str_inp
	add $s0,$a0,$zero
#===============================================================
# find length of input string
# $t2 stores the length of string
# $a0 : addr of s[0]
# $t0 : addr of s[0]; at the end of loop $t0 = addr of s[strlen]
# $t3 = length/2
#===============================================================
str_len:
	lb  $t1, 1($t0)
	beq  $t1, $0, end_len #If equal to 0 end loop
	nop
	addi $t0, $t0, 1
	j    str_len #Loop
end_len: #end_loop

	li $v0, 1
	sub $t2,$t0,$a0
	div $t3,$t2,2
	#remove newline from string
	add $t5, $t0, $zero
	sb $0,($t5)
	addi $t0, $t0, -1

#===============================================================
# Check_palindrome: Based on this algorithm
# {
# s = input string
# int half = strlen/2
# For (int i=0; i<half; i++){
# 	if (s[i] != s[strlen-1]) {
#		end loop;
#		output: "Not palindrome"
#	}
#	strlen--;
# }	
# output: "Palindrome"	
# }	
# $a0 : addr of s[0]
# $t0 : addr of s[end] 
# $t3 = length/2
#===============================================================
check_palindrome:
	lb  $t1, 0($a0)
	lb  $t4, ($t0)
	
	beqz $t3,end_palin	#If end loop
	nop
	bne $t1, $t4, end_not_palin #If s[i] != s[j] -> end loop and output: "Not palindrome"
	nop 
	
	addi $a0, $a0, 1
	addi $t0, $t0, -1
	addi $t3, $t3, -1
	j    check_palindrome #Loop
#end check

#output
# $t1: addr of result: palindrome or not
end_not_palin: la $t9,msg_out_not_palin
	j output
	
end_palin:	la $t9,msg_out_palin
	#j output
	j check_dup
	
#===============================================================
# check for duplicate
# if user duplicates a palindromes, output: "Enter Again"
# else: check for palindrome
# Simple algorithm: check your new input string with all previous one( which all store in str_inp): 
#	First: check length, if equal then check content, else continue
# 		check content:
# $s0: addr s[0]
# $t0: addr s[end]
# $t7: addr of a[i] aka i
# $t1: addr of s[j] aka j
# $t3: string
# $t4: value of a[i]
# $t5: addr s[j]
# $t6: addr s2[j]
# $t7: addr of a[0]
# $t8: value of s2[j]
#===============================================================

check_dup:
init_dup:
	la $t7,array_of_len
	la $t3,str_inp
	j check_num
	
#===============================================================	
# for (i: 0 -> n-1; i++){ 
#	if (a[i] == str_len) check_content
#	} 

#===============================================================
check_num:
	lw $t4,($t7)
	beq $t7,$s2, end_not_dup #end loop
	nop
	
	beq $t4,$t2,check_dup_content
	nop
	
cont:	#change string array
	add $t3,$t3,$t4
	addi $t3,$t3,1
	addi $t7,$t7,4 #check for next element
	j check_num	#loop
	
#===============================================================
# (for j=0 -> str_len-1; j++){
#  	if (s1[i] != s2[j]) -> break
#	}
#===============================================================
check_dup_content:
	add $t5,$s0,$zero
	add $t6,$t3,$zero
loop_check_dup_content: 
	bgt $t5,$t0,if_dup #end loop: if duplicate 
	nop
	lb  $t1, ($t5)
	lb  $t8, ($t6)
	addi $t5,$t5,1
	addi $t6,$t6,1
	
	bne $t8, $t1, if_not_dup #If s[i] != s[j] -> end loop and output: "Not palindrome"
	nop 
	j    loop_check_dup_content #Loop
#end check
	
if_dup:
	la $t9,msg_out_dup
	j output
if_not_dup:
	j cont
end_not_dup:
	#change string array
	add $s1,$s1,$t2
	addi $s1,$s1,1
	#add strlen(s) to array_of_lenn
	sw $t2,($s2)
	addi $s2,$s2,4
	j output	

#If user enter empty string ""
empty_string:
	la $a0,msg_out_empty
	li $v0,4
	syscall
	
	j input
output: 
	la $a0,string
	li $v0,4
	syscall
	
	la $a0,sign
	li $v0,4
	syscall
	
	la $a0,($s0)
	li $v0,4
	syscall
	
	la $a0,sign
	li $v0,4
	syscall
	
	add $a0,$t9,$zero
	li $v0,4
	syscall

	j ask_user_enter
	
#===============================================================
# ask user if they want to input more string
# if they don't input the correct format, they are required to enter again until 
# $t1: check user input in form or not 
#===============================================================
ask_user_enter:
	#print "Do you want to enter another string? Type y/n: "
	li $v0,4	# system call code for print Str
	la $a0,msg_ask_for_enter_more_string	# address of string to print
	syscall		# print msq_inp
	#read input character
	li $v0,12	# system call code for read Str
	syscall
	
	beq $v0,'y',yes
	nop
	beq $v0,'Y',yes
	nop
	beq $v0,'n',end
	nop
	beq $v0,'N',end
	nop
	
wrong_syntax:
	#print "\nWrong syntax. Please type your choice correctly again!\n"
	li $v0,4	# system call code for print Str
	la $a0,msg_wrong_input_for_ask	# address of string to print
	syscall		# print msq_inp
	
	j ask_user_enter
yes:
	li $v0,4	# system call code for print Str
	la $a0,newline	# address of string to print
	syscall		# print msq_inp
	
	j input
end:
	li $v0,4	# system call code for print Str
	la $a0,msg_out_end_program	# address of string to print
	syscall		# print msq_inp
