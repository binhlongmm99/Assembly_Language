#--------------------------------------------------------------------------
# Miniproject topic 3:
# Create a program to convert from number to text, in English. 
# The number in range from 0 to 999 999 999.
#--------------------------------------------------------------------------

.data
	string:	.space 10
	
	
	inputMsg: .asciiz 	"Please enter an integer\n"
	msgEmpty: .asciiz 	"This string is empty\n"
	msgTooLong: .asciiz 	"String is too long\n"
	msgNotInt: .asciiz 	"Invalid input\n"
	blank: .asciiz 		""
	string1: .asciiz	"Your number is\t"
	and_word: .asciiz 	" and"
	comma: .asciiz 	","
	
	zero: .asciiz "zero"
	one: .asciiz " one"
	two: .asciiz " two"
	three: .asciiz " three"
	four: .asciiz " four"
	five: .asciiz " five"
	six: .asciiz " six"
	seven: .asciiz " seven"
	eight: .asciiz " eight"
	nine: .asciiz " nine"
	ten: .asciiz " ten"
	eleven: .asciiz " eleven"
	twelve: .asciiz " twelve"
	thirteen: .asciiz " thirteen"
	fourteen: .asciiz " fourteen"
	fifteen: .asciiz " fifteen"
	sixteen: .asciiz " sixteen"
	seventeen: .asciiz " seventeen"
	eighteen: .asciiz " eighteen"
	nineteen: .asciiz " nineteen"
	twenty: .asciiz " twenty"
	thirty: .asciiz " thirty"
	forty: .asciiz " forty"
	fifty: .asciiz " fifty"
	sixty: .asciiz " sixty"
	seventy: .asciiz " seventy"
	eighty: .asciiz " eighty"
	ninety: .asciiz " ninety"
	hundred: .asciiz " hundred"
	thousand: .asciiz " thousand"
	million: .asciiz " million"
	
	array_units: .word blank, one, two, three, four, five, six, seven, eight, nine
	array_special_dozens: .word ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen
	array_dozens: .word blank, blank, twenty, thirty, forty, fifty, sixty, seventy, eighty, ninety
	
.text

main:
	li $v0, 54
	la $a0, inputMsg
	la $a1, string
	li $a2, 10
	syscall
	
	beq $a1, -3, exEmpty	# User entered an empty string
	beq $a1, -4, exTooLong  # User entered a string exceeded 32 bytes
	beq $a1, -2, end
	j checkI

#-------------------------------------------------------------------------------------------------
# @brief	Show error message when input is empty
#-------------------------------------------------------------------------------------------------
exEmpty:
	li $v0, 59
	la $a0, msgEmpty
	la $a1, blank
	syscall
	j main
	nop

#-------------------------------------------------------------------------------------------------
# @brief	Show error message when input is too long
#-------------------------------------------------------------------------------------------------
exTooLong:
	li $v0, 59
	la $a0, msgTooLong
	la $a1, blank
	syscall
	j main
	nop

#-------------------------------------------------------------------------------------------------
# @brief	Show error message when input is invalid
#-------------------------------------------------------------------------------------------------
exNotInt:
	li $v0, 59
	la $a0, msgNotInt
	la $a1, blank
	syscall
	j main
	nop

#-------------------------------------------------------------------------------------------------
# Check whether the given string is a number or not
# @param	$a0 hold the address of the string
# @brief	Check if each byte of string is between
#		0x30 (digit 0) and 0x39 (digit 9) or not
# @result	If the string is a number, convert an store it to $a0
#		$t7 count the number of digits
#-------------------------------------------------------------------------------------------------
checkI:
	la $a0, string
	add $t7, $zero, $zero 	# Number of digits
	li $t8, 0x2F		# Number 0 = 0x30
	li $t9, 0x3A		# Number 9 = 0x39
	
# Extracting and checking each byte
loopI:
	lb $t0, 0($a0)
	beq $t0, 0xa, convertI	# '\n' = 0xa
	beq $t0, 0x0, convertI	# terminating null is 0x0
	slt $t1, $t0, $t9	# Is t0 <= 9 ?
	beqz $t1, exNotInt
	nop
	slt $t1, $t8, $t0	# Is t0 >= 0 ?
	beqz $t1, exNotInt
	nop
	addi $t7, $t7, 1
	addi $a0, $a0, 1
	j loopI
	nop

#-------------------------------------------------------------------------------------------------
# @brief	Initialize the convert process
# @param	$a0 hold the address of the string need to be converted
#		$t0 = $t7 = the number of digits
# @return	Initialization of the convert process
#-------------------------------------------------------------------------------------------------
convertI:
	la $a1, string
	add $v1, $zero, $zero
	add $s0, $zero, $zero
	add $t0, $t7, $zero

#-------------------------------------------------------------------------------------------------
# @brief	Convert the string to integer and enlgíh word
# @param	$a0 hold the address of the string need to be converted
#		$t0 = $t7 = the number of digits
# @return	$v0 hold the converted number in decimal
#-------------------------------------------------------------------------------------------------	
convertL: 
	addi $t0, $t0, -1
	slt $t3, $t0, $zero		# If (t0 < 0) then the converting process is completed
	beq $t3, 1, end_convert
	nop
	# Calculate 10 ^ position of digit
	li $t1, 1			# t1 = 1 = 10 ^ 0
	add $t2, $t0, $zero
expL:	
	beqz $t2, endE
	nop
	mul $t1, $t1, 10
	addi $t2, $t2, -1
	j expL
	nop
# t1 = 10 ^ t0
endE:	
	lb $a3, 0($a1)
	sub $s1, $a3, 0x30	# Get digit value: x - '0'
	jal print_english_word
	nop
	add $s0, $zero, $s1
	mul $s1, $s1, $t1
	add $v1, $v1, $s1
	addi $a1, $a1, 1
	j convertL
	nop

#-------------------------------------------------------------------------------------------------
# @brief	Print enlish word base on current digit and previous digit
# @param	$t0 = the number of digits
#-------------------------------------------------------------------------------------------------	
print_english_word:
	beq $t0, 8, print_hundred
	beq $t0, 7, print_dozen
	beq $t0, 6, print_unit
	beq $t0, 5, print_hundred
	beq $t0, 4, print_dozen
	beq $t0, 3, print_unit
	beq $t0, 2, print_hundred
	beq $t0, 1, print_dozen
	beq $t0, 0, print_unit
	jr $ra
	

#-------------------------------------------------------------------------------------------------
# @brief	Print enlish word at unit position: 10^8, 10^5, 10^2
# @param	$t8 hold array address
#		$t9 hold the offset value (index)
#		$s0 hold the previous digit
#		$s1 hold the current digit
#-------------------------------------------------------------------------------------------------
print_hundred:
	beqz $s0, no_comma	# print "," if previous digit is not 0
	nop
	li $v0, 4
	la $a0, comma
	syscall
no_comma:
	la $t8, array_units	# $t8 hold array address
	
	add $t9, $s1, $zero	# $t9 hold offset value
	add $t9, $t9, $t9
	add $t9, $t9, $t9
	
	add $t9, $t9, $t8
	lw $s2, 0($t9)
	
	li $v0, 4
	la $a0, 0($s2)
	syscall
	
	li $v0, 4
	la $a0, hundred
	syscall
	
	jr $ra


#-------------------------------------------------------------------------------------------------
# @brief	Print enlish word at dozen position: 10^7, 10^4, 10^1
# @param	$t8 hold array address
#		$t9 hold the offset value (index)
#		$s0 hold the previous digit
#		$s1 hold the current digit
#-------------------------------------------------------------------------------------------------
print_dozen:
	beqz $s0, no_and	# print "and" if previous digit is not 0
	nop
	li $v0, 4
	la $a0, and_word
	syscall
no_and:
	la $t8, array_dozens	# $t8 hold array address
	
	add $t9, $s1, $zero	# $t9 hold offset value
	add $t9, $t9, $t9
	add $t9, $t9, $t9
	
	add $t9, $t9, $t8
	lw $s2, 0($t9)
	
	li $v0, 4
	la $a0, 0($s2)
	syscall
	
	jr $ra
	
	
#-------------------------------------------------------------------------------------------------
# @brief	Print enlish word at hundred position: 10^6, 10^3, 10^0
# @param	$t8 hold array address
#		$t9 hold the offset value (index)
#		$s0 hold the previous digit
#		$s1 hold the current digit
#-------------------------------------------------------------------------------------------------
print_unit:
	bne $s0, 1, not_special_dozen 	# in case previous digit is 1, we use special dozen
# special dozen is all the number from 10, 11, 19	
	la $t8, array_special_dozens	# $t8 hold array address
	
	add $t9, $s1, $zero		# $t9 hold offset value
	add $t9, $t9, $t9
	add $t9, $t9, $t9
	
	add $t9, $t9, $t8
	lw $s2, 0($t9)
	
	li $v0, 4
	la $a0, 0($s2)
	syscall
	
	j check_million
	nop

# not special dozen is all the number from 20, ..., 99
not_special_dozen:
	la $t8, array_units	# $t8 hold array address
	
	add $t9, $s1, $zero	# $t9 hold offset value
	add $t9, $t9, $t9
	add $t9, $t9, $t9
	
	add $t9, $t9, $t8
	lw $s2, 0($t9)
	
	li $v0, 4
	la $a0, 0($s2)
	syscall

# check if current unit is at million position 10^6
check_million:
	bne $t0, 6, not_million		# print million if digit at 10^6 position
	nop
	li $v0, 4
	la $a0, million
	syscall
	
not_million:

# check if current unit is at thousand position 10^3
check_thousand:	
	bne $t0, 3, not_thousand	# print thousand if digit at 10^3 position
	nop
	li $v0, 4
	la $a0, thousand
	syscall

# current unit is at position 10^0
not_thousand:
	jr $ra

end_convert:

#-------------------------------------------------------------------------------------------------
# @brief	Print 0 if the number is 0, because the above code ignore case 0
#-------------------------------------------------------------------------------------------------
check_zero:
	bnez $v1, end
	nop
	
	li $v0, 4
	la $a0, zero
	syscall
	
end:
	
