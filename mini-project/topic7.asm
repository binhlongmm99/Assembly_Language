#--------------------------------------------------------------------------
# Miniproject topic 7: number-triangle
#--------------------------------------------------------------------------

.data
Mess: .asciiz "Input number of rows (in range of [1,200]): "
blank: .asciiz " "
next_line: .asciiz "\n"
error: .asciiz "The number of rows is out of range [1,200] , try again!!!"
.text
input_rows:
# Input number of rows 
	li $v0,51
	la $a0,Mess
	syscall
	
	la $a2,0($a0)	# load value of rows into a2
	
#--------------------------------------------------------------------------
#Algorithm in C 
#	printf("Input number of rows: ");
#	int rows;
#	scanf("%d",&rows);
#	for(int i=1;i<=rows;i++){
#		for(int j = 2*(rows-i);j>0;j--){
#			printf(" ");
#		}
#		int k;
#		for(k=1;k<i;++k){
#			printf("%d ",k);
#		}
#		for(;k>0;--k){
#			printf("%d ",k);
#		}
#		printf("\n");
#	}
#--------------------------------------------------------------------------

# @param a2 : rows
# @param s0 : i
# @param s1 : j
# @param s2 : k

  	li $t0,200	# t2 = 200
# check input value
	blez $a2,mess_error
	nop
	bgt $a2,$t0,mess_error
	nop
	j main
mess_error:
	li $v0,55
	la $a0,error
	syscall
	j input_rows
	
#--------------------------------------------------------------------------
main:
	addi $s0,$zero,1 # init value for counter i	
loop1: # loop for print number of rows
	bgt $s0,$a2,end_loop1	# if(i>n) end_loop
	sub $s1,$a2,$s0		# init counter j = n - i
	add $s1,$s1,$s1		# j = 2(rows - i)
loop2: # loop for print number of blanks
	blez $s1,end_loop2	# if (j<=0) end_loop
	li $v0,4	# print blanks 
	la $a0,blank
	syscall 
	addi $s1,$s1,-1 # j--
	j loop2		# continue loop2
end_loop2:
	addi $s2,$zero,1	# init counter k
loop3: # loop for print numbers in ascending order
	bge $s2,$s0,end_loop3	# if (k>=i) end_loop
	la $v0,1		# print out k with ascending order
	la $a0,0($s2)
	syscall
	la $v0,4		# print blank
	la $a0,blank
	syscall
	addi $s2,$s2,1		# k++
	j loop3
end_loop3:

loop4:	# loop for print numbers in descending order
	blez $s2,end_loop4	# if(k<=0) end_loop
	la $v0,1		# print out k with descending order
	la $a0,0($s2)
	syscall
	la $v0,4		# print blank
	la $a0,blank
	syscall
	addi $s2,$s2,-1		# k--
	j loop4
end_loop4:
	la $v0,4		# next line
	la $a0,next_line
	syscall
	addi $s0,$s0,1		# i++
	j loop1
end_loop1:
exit_main:
	li $v0,10		# exit program
	syscall
	
	
