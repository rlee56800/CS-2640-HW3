########################################################################
# Program: Homework3   			 Programmer: Rebecca Lee
# Due Date: Oct 1, 2020   		 Course: CS2640.03
########################################################################
# Overall Program Functional Description:
#    Program asks user for 20 numbers, then
#	1. Prints numbers on separate lines
#	2. Prints numbers on 1 line, with spaces between
#	3. Asks user for number between 0 and 20 (n)
#	4. Prints n numbers on each line
#
########################################################################
# Register usage in Main:
#    $t0 -- Counter to 20
#    $t1 -- Counter to $s0 (n, the given value)
#    
########################################################################
# Pseudocode Description:
#    1. Calls takein
#    2. Calls line
#    3. Calls spaces
#    4. Calls check
#    5. Calls spec
#    6. Terminates program
#
########################################################################
		.data
arr:		.space 80
welcomea:	.asciiz "Please enter a number: "
welcomeb:	.asciiz "/20\n"
nline:		.asciiz "\n"
spacer:		.asciiz " "
checka:		.asciiz	"\nPlease enter amount of numbers per line (0<n<20)\n"
		.align 2
		.globl main
		
		.text
main:	jal	res	#Reset counter ($t0) and address pointer ($t2)
	jal	takein	#Get 20 numbers from user
	jal	res	#Reset counter ($t0) and address pointer ($t2)
	jal	lines	#Print one number per line
	jal	res	#Reset counter ($t0) and address pointer ($t2)
	jal	spaces	#Print numbers with spaces
	jal	res	#Reset counter ($t0) and address pointer ($t2)
	jal	check	#Gets user input (n) for amt numbers on row
	li	$t1, 0	#Reset n counter to 0 //changed here
	jal	spec	#Prints n numbers per row
	li	$v0, 10	#Terminates program
	syscall
########################################################################
# Function Name: void res(value)
########################################################################
# Functional Description:
#    Resets all counters and addresses
#
########################################################################
# Register Usage in the Function:
#    $t0 -- Counter to 20 (set to 0)
#    $t2 -- Pointer to address of arr (set to front)
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Sets counter ($t0) to 0
#    2. Sets $t2 to address of arr
#
########################################################################
res:	li	$t0, 0		#resets counter to 0
	la	$t2, arr	#enters address of array to $t2
	jr	$ra		#return to subroutine //changed here
	
########################################################################
# Function Name: void takein(value)
########################################################################
# Functional Description:
#    Takes 20 integers from the user and stores them on an array
#	"Please enter a number: x/20" where x is amount of numbers entered
#
########################################################################
# Register Usage in the Function:
#    $t0 -- Counter to 20 (reaches 20)
#    $t2 -- Pointer to address of arr (reaches end)
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Print welcome message
#    2. Take in number from user + store in array
#    3. Repeat 2. until array is full (ie 20 times)
#
########################################################################
takein: addi	$t0, $t0, 1	#Increment counter
	la	$a0, welcomea	#Prints welcomea ("Please enter a number: )
	li	$v0, 4
	syscall
	move	$a0, $t0	#Prints counter number
	li	$v0, 1
	syscall
	la	$a0, welcomeb	#Prints welcomeb ("/20")
	li	$v0, 4
	syscall
	li	$v0, 5		#Prompt for number
	syscall
	sw	$v0, ($t2)	#Save user's number to array
	addi	$t2, $t2, 4	#Increment address pointer
	blt	$t0, 20, takein	#If counter < 20, run takein again
	jr	$ra		#return to subroutine //changed here

########################################################################
# Function Name: void lines(value)
########################################################################
# Functional Description:
#    Prints each integer in the array on a new line
#
########################################################################
# Register Usage in the Function:
#    $t0 -- Counter to 20 (reaches 20)
#    $t2 -- Pointer to address of arr (reaches end)
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Print integer
#    2. Print newline
#    3. Repeat 1. and 2. 20 times
#
########################################################################
lines:	lw	$a0, ($t2)		#Prints number //changed here
	li	$v0, 1
	syscall
	la	$a0, nline		#Prints newline
	li	$v0, 4
	syscall
	addi	$t2, $t2, 4		#Increment address pointer
	addi	$t0, $t0, 1		#Increment counter
	blt	$t0, 20, lines		#If counter < 20, run lines again
	jr	$ra			#return to subroutine //change here

########################################################################
# Function Name: void spaces(value)
########################################################################
# Functional Description:
#    $t0 -- Counter to 20 (reaches 20)
#    $t2 -- Pointer to address of arr (reaches end)
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Input value, and also parameter to send to syscall
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Print integer
#    2. Print space
#    3. Repeat 1. and 2. 20 times
#
########################################################################
spaces:	lw	$a0, ($t2)	#Prints number //changed here
	li	$v0, 1
	syscall
	la	$a0, spacer	#Prints space
	li	$v0, 4
	syscall
	addi	$t2, $t2, 4	#Increment address pointer
	addi	$t0, $t0, 1	#Increment counter
	blt	$t0, 20, spaces	#If counter < 20, run spaces again //changed here
	jr	$ra		#return to subroutine //changed here
	
########################################################################
# Function Name: void check(value)
########################################################################
# Functional Description:
#    Takes user input for amount of numbers per line (for spec);
#      if number is less than 0 or greater than 20, asks user again
#
########################################################################
# Register Usage in the Function:
#    $s0 -- User input value (amt numbers per line)
#    
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Ask user for a number between 0 and 20
#    2. If number is not valid, run check again
#    3. If number is valid, save number to $s0 and exit
#
########################################################################
check:	la	$a0, checka	#Prints checka (prompt to enter number)
	li	$v0, 4
	syscall
	li	$v0, 5		#Loads user input
	syscall
	bltz	$v0, check	#Re-runs check if 0>n or n>20
	bge	$v0, 20, check
	move	$s0, $v0	#Save number if conditions are met
	jr	$ra		#return to subroutine //changed here
	
########################################################################
# Function Name: void spec(value)
########################################################################
# Functional Description:
#    Prints specified amount (n) of numbers on a line (with spaces between)
#
########################################################################
# Register Usage in the Function:
#    $t0 -- Counter to 20 (reaches 20)
#    $t1 -- Counter to $s0 (n, the given value) (reaches n)
#    $s0 -- User input value (amt numbers per line)
#    $t2 -- Pointer to address of arr (reaches end)
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. If n counter == n; jump to sform
#    2. Print number
#    3. Print space
#    4. Repeat steps 1. - 3. 20 times
#
########################################################################
spec:	bge	$t1, $s0, sform	#if n words are on the line, go to sform
	lw	$a0, ($t2)	#Prints number //changed here
	li	$v0, 1
	syscall
	la	$a0, spacer	#Prints space
	li	$v0, 4
	syscall
	addi	$t2, $t2, 4	#Increment address pointer
	addi	$t0, $t0, 1	#Increment counter to 20
	addi	$t1, $t1, 1	#Increment counter to n
	blt	$t0, 20, spec	#If counter < 20, run spec again
	jr	$ra		#return to subroutine //changed here

########################################################################
# Function Name: void sform(value)
########################################################################
# Functional Description:
#    Helper for spec; creates new line and resets n counter
#     (called when n numbers are printed on a line)
#
########################################################################
# Register Usage in the Function:
#    $t1 -- Counter to $s0 (n, the given value) (set to 0)
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Resets n counter
#    2. Prints new line
#    3. Jumps back to spec
#
########################################################################
sform:	li	$t1, 0		#Reset n counter to 0
	la	$a0, nline	#Print new line
	li	$v0, 4
	syscall
	j	spec		#Go back to spec
