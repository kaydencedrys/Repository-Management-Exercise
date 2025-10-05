# Name        : Kaydence Drys
# Username    : kcdrys
# Description : searches through a linked list of people based on the keyword

.text

# initialize variables
la		$t0, keyword		# get pointer to keyword
la		$t1, first			# get pointer to first node
li		$t2, 0				# t2 holds single bit of node for comparison
li		$t3, 0				# t3 holds single bit of keyword for comparison
la		$t4, first			# pointer to current node, updated for comparison
addi	$t1, $t4, 9			# move to name field
li		$t5, 97				# value of 97, lowercase ascii a
li		$t6, 122			# value of 122, lowercase ascii z
li		$t7, 32				# value of 32, ascii space

printKey:
la		$a0, printStatement
li		$v0, 4
syscall

la		$a0, keyword
li		$v0, 4
syscall

la		$a0, newLine
li		$v0, 4
syscall

start: 
la		$t0, keyword		# get pointer to keyword
lb		$t3, ($t0)			# load first char from keyword
beq		$t3, $t7, search	# if char is a space then start comparing
blt		$t3, $t5, lowKey0	# get key to lowercase
b		search				# kind of organized bad but search if it is already lowercase

lowKey0:
addi	$t3, $t3, 32		# add to make the ascii value lowercase
b		search

# highKey0 ????				# don't think I need this


# check the first letter of the name in the node
search:
beq		$t2, -1, terminate
lb		$t2, ($t1)				# load next char from name
beq		$t2, $0, increment		# move if end of name
beq		$t2, $t3, match			# if char is a space then start comparing
blt		$t2, $t5, lowChar0		# get name char to lowercase
search1:						# used to come back if previous line branches
beq		$t2, $t3, match			# print the name if characters are equal
addi	$t1, $t1, 1				# move to next letter in the name 
j		search


# check if they match completely after first match has been found
match:
addi	$t0, $t0, 1			# increment to next keyword char
addi	$t1, $t1, 1			# incrememnt to next name char
lb		$t3, ($t0)			# load next char from keyword
beq		$t3, $t2, match		# if char is a space then keep comparing
beq		$0, $t3, printName	# if keyword has run out, print name
blt		$t3, $t5, lowKey1	# get key to lowercase
match1:
lb		$t2, ($t1)			# load next char from name
beq		$0, $t2, increment		# start over on next name, no match found
blt		$t2, $t5, lowChar1	# get name char to lowercase
match2:
beq		$t3, $t2, match		# keep iterating if the characters match


# move to the next name in the next node
increment:
lw		$t4, 0($t4)			# load next node
beq		$t4, -1, terminate	# end of linked list found
addi	$t1, $t4, 9			# move to name in next pointer
b		start


# update first char in the name to be lowercase
lowChar0:
addi	$t2, $t2, 32		# add to make the ascii value lowercase
b		search1

# update subequent chars in the name to be lowercase
lowChar1:
addi	$t2, $t2, 32		# add to make the ascii value lowercase
b		match2

# update keyword to be lowercase
lowKey1:
addi	$t3, $t3, 32		# add to make the ascii value lowercase
b		match1

# skip over the rest of the current part of the name
skip:
lb		$t2, ($t1)			# load char from name
beq		$t2, $0, increment	# no match, reached the end of the string
beq		$t2, $t7, continue	# found a space in the name, keep comparing
addi	$t1, $t1, 1
j		skip


# skip over space
continue:
addi	$t0, $t0, 1			# increment to next keyword char
j		match



printName:
# print user if match is found
lw		$s0, 4($t4)		#load emp id	
lb		$s1, 8($t4)		#load emp age
addi	$s2, $t4, 9		#load emp name
	
move	$a0, $s2	#print emp name
li		$v0, 4
syscall
	
la		$a0, intermediate		#print ", #"
li		$v0, 4
syscall
	
move	$a0, $s0	#print emp id
li		$v0, 1
syscall
	
la		$a0, age		#print ", age"
li		$v0, 4
syscall
	
move	$a0, $s1	#print emp age
li		$v0, 1
syscall
	
la		$a0, newLine	#print new line
li		$v0, 4
syscall	
	

lw		$t4, 0($t4)			#move to next node
beq		$t4, -1, terminate	# end if all nodes have been checked
addi	$t1, $t4, 9			# move to name in next pointer
b		start



terminate:
    li	$v0, 10			# Exit syscall
    syscall


#personal data section
.data
printStatement: .asciiz	"Searching for: "
newLine:		.asciiz	"\n"
notFound:		.asciiz "No matches found"
intermediate:	.asciiz ", #"
age:			.asciiz ", age "

### START DATA ###
# You can (and should!) modify the linked list in order to test your program, but:
#  1) the keyword to search for should retain the label keyword
#  2) the first node should retain the label first
# You can (and should!) have a separate .data section containing other variables (e.g. string constants).
# NOTE: we will replace everything between the START DATA and END DATA tags during testing!
.data
keyword:    .asciiz     "m "                    # String to search for, NOTE: this may be empty (matches everyone)
first:      .word       node2                   # Next pointer
            .word       20030422                # Employee ID
            .byte       27                      # Age
            .asciiz     "Jim D. Halpert"        # Name, NOTE: you can assume this will NOT be empty
node2:      .word       node3
            .word       20030435
            .byte       26
            .asciiz     "Pam M. Beesly"
node3:      .word       node4
            .word       20010984
            .byte       41
            .asciiz     "Michael G. Scott"
node4:      .word       node5
            .word       20030580
            .byte       31
            .asciiz     "Dwight K. Schrute III"
node5:      .word       node6
            .word       20010321
            .byte       24
            .asciiz     "Ryan B. Howard"
node6:      .word       node7
            .word       20051229
            .byte       32
            .asciiz     "Andy B. Bernard Jr."
node7:      .word       -1
            .word       20084724
            .byte       45
            .asciiz     "Robert  California"
### END DATA ###
