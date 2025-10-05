# Name        : Kaydence Drys
# Username    : kcdrys
# Description : takes a series of integer inputs and outputs data on the set of integers

.text
	# Initialize registers we plan to use
	li			$t0, 0				# $t0 will store count of numbers in series
	li			$t1, 0				# $t1 will store the sum
	li			$t2, 0				# $t2 will store the max
	li			$t3, 0				# $t3 will store the min
	li			$t4, 0				# $t4 will store the even count
	li			$t5, 0				# $t5 will temporarily hold input remainder
	li			$t6, 2				# $t6 will hold value of 2 for division math
	li			$t7, 0				# $t7 will hold the value of 0 for comparison
	li			$t8, 0				# $t8 will hold the sum for comparison

loop:
	li			$v0, 5				# syscall 5 = read integer into $v0
	syscall
	
	add			$t8, $0, $t1		# reset temp sum
	beqz		$v0, finished		# Stop if we read a 0
	addi		$t0, $t0, 1			# Increment our count of numbers in the series
	add			$t1, $t1, $v0		# Add integer to total sum
	bgt			$t1, $t2, max
	blt			$t1, $t8, min
	b 			loop

max:
	#blt			$t2, $t7, loop		# don't update max if max is less than zero
	add			$t2, $0, $t1		# update max
	bge			$t2, $t7, loop		# continue if max is not negative
	sub			$t2, $t2, $v0		# if max is negative, reset
	b			loop				# Go back to start and read another integer

min:
	#beq			$t1, $t7, loop		# don't update min if sum is greater than zero
	add			$t3, $0, $t1		# update min
	blt			$t3, $t7, loop		# continue if min is negative
	li			$t3, 0				# if min is not negative, reset
	
	b			loop

even:
	add			$t8, $t8, $v0		# update temp sum for accurate comparison
	
	div			$v0, $t6			# divide input by 2
	mfhi		$t5					# remainder of division- value of 0 means even input
	beq			$t5, 1, loop		# go back to start if number is not equal
	addi		$t4, $t4, 1			# increment count of even inputs
	b			loop				# Go back to start and read another integer

finished:
	# Print a linefeed to separate the input and output
	li			$v0, 11				# syscall 11 = print character in $a0
	addi		$a0, $0, 10			# ASCII code 10 is a linefeed
	syscall

	# Print the count
	move		$a0, $t0			# Copy $t0 into $a0 in order to print it
	li			$v0, 1				# syscall 1 = print integer in $a0
	syscall
	li			$v0, 11				# syscall 11 = print character in $a0
	addi		$a0, $0, 10			# ASCII code 10 is a linefeed
	syscall
	
	# Print the sum
	move		$a0, $t1			# Copy $t1 into $a0 in order to print it
	li			$v0, 1				# syscall 1 = print integer in $a0
	syscall
	li			$v0, 11				# syscall 11 = print character in $a0
	addi		$a0, $0, 10			# ASCII code 10 is a linefeed
	syscall

	# Print the max
	move		$a0, $t2			# Copy $t2 into $a0 in order to print it
	li			$v0, 1				# syscall 1 = print integer in $a0
	syscall
	li			$v0, 11				# syscall 11 = print character in $a0
	addi		$a0, $0, 10			# ASCII code 10 is a linefeed
	syscall

	# Print the min
	move		$a0, $t3			# Copy $t0 into $a0 in order to print it
	li			$v0, 1				# syscall 1 = print integer in $a0
	syscall
	li			$v0, 11				# syscall 11 = print character in $a0
	addi		$a0, $0, 10			# ASCII code 10 is a linefeed
	syscall
	
	# Print the even count
	#move		$a0, $t4			# Copy $t4 into $a0 in order to print it
	#li			$v0, 1				# syscall 1 = print integer in $a0
	#syscall
	#li			$v0, 11				# syscall 11 = print character in $a0
	#addi		$a0, $0, 10			# ASCII code 10 is a linefeed
	#syscall

	li			$v0, 10				# syscall 10 = terminate execution
	syscall
