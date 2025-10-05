# Name        : Kaydence Drys
# Username    : kcdrys
# Description : creates and prints a matrix of integers based on user inputs

.text

# initialize variables to ensure they start at zero
	li		$t0, 1		# always zero, used to compare to m and n
	li		$t1, 9		# 9 used to compare m, later tracks current index address while printing
	li		$t2, 20		# always 20, used to compare length
	li		$t3, 0		# holds N
	li		$t4, 0		# holds M - a value between 0 and 9 determined by user
	li		$t5, 0		# holds input row number
	li		$t6, 0 		# holds input column number
	li		$t7, 0		# holds address of array beginning
	li		$t8, 0		# eventually holds index of last filled array value
	li		$t9, 4		# value of 4 for multiplication, also column counter later on


inputs:
	# get N from user and make it the length
	li		$v0, 5
	syscall
	sw		$v0, length

	# check N is an acceptable integer
	lw		$t3, length
	blt		$t3, $t0, terminate
	bgt		$t3, $t2, terminate
	
	addi	$t0, $t0, -1		# put $t0 at 0


	# get M from user and make it the array value printed
	li		$v0, 5
	syscall
	move	$t4, $v0

	# check M is an acceptable integer
	blt		$t4, $t0, terminate
	bgt		$t4, $t1, terminate

	# calc and store index of last array value
	mult	$t3, $t3
	mflo	$t8
	mult	$t8, $t9
	mflo	$t8


	la		$t7, length				# t7 has base address of array "length"

	add		$t8, $t7, $t8			# t9 has address of last array element


# fill the array with a full square matrix of value M
setArray:
	lw		$t2, 0($t7)		# load array value into $t2
	add		$t2, $0, $t4	# add desired value to temp register
	sw		$t2, 0($t7)		# store updated value at array index
	
	addi	$t7, $t7, 4				# go to the next empty value in the array
	bne		$t8, $t7, setArray		# keep looping until array is full


	li		$t9, 4		# reset for multiplication
increment:
	la		$t7, length				# t7 has base address of array "length"
	# read in values to increment
	li		$v0, 5					# row to increment
	syscall
	move	$t6, $v0
	blt		$t6, $t0, print
	bge		$t6, $t3, print

	li		$v0, 5					# column to increment
	syscall
	move	$t5, $v0
	blt		$t5, $t0, print
	bge		$t5, $t3, print
	
	# increment inputted value
	mult	$t3, $t6			# multiply column and row number to increment
	mflo	$t6					# t5 is array index to increment
	add		$t6, $t6, $t5		# add in final incomplete row
	mult	$t6, $t9
	mflo	$t6					# byte offset
	add		$t6, $t6, $t7		# add base index with desired byte number
	
	lb		$t5, 0($t6)			# load value at array index
	beq		$t5, $t1, goBack	# wrap value to 0 if it is at 9
	addi	$t5, $t5, 1			# increment value
	sb		$t5, 0($t6)			# store new value in same place
	b		increment
	goBack:
		addi	$t5, $t5, -9			# increment value
		sb		$t5, 0($t6)			# store new value in same place
		b		increment

print:	
	addi	$t7, $0, 0		# reset current array index for printing
	li		$t9, 0			# reset t9 to 0 to count columns printed
	la		$t2, length		# t2 keeps track of index address
	
	
printRow:
	beq		$t9, $t3, terminate		# end if columns are complete
	lw		$t4, 0($t2)
	move	$a0, $t4
	li		$v0, 1			# one iteration of printing a value
	syscall
	addi	$t7, $t7, 1		# increment row index
	addi	$t2, $t2, 4		# increment index address
	bne		$t7, $t3, printRow
	#b		terminate
	
	printColumn:
	mult		$t7, $t7
	mflo		$t1
	beq			$t1, $t8, terminate	# ends program if final line has printed
	
	addi		$t9, $t9, 1			# increment column counter
	
	# print a linefeed
	li			$v0, 11			# syscall 11 = print character in $a0
	li			$a0, 10			# ASCII code 10 is a linefeed
	syscall
	addi	$t7, $0, 0			# reset current array index for printing
	bne			$t3, $t7, printRow




terminate:
	li		$v0, 10				# syscall 10 = terminate execution
	syscall


.data
length:  .word 400		# max size of the square array is 20x20
