#Michael Rocco CISC3160
#calculate grade for CISC3160
#current data for numbers is based on spreadsheet on website
.data
prompt1: .asciiz "enter the 6 lab scores: \n"
prompt2: .asciiz "enter the 4 writing scores: \n"
prompt3: .asciiz "enter the 3 quiz scores: \n"
prompt4: .asciiz "enter the final score: \n"
prompt5: .asciiz "enter the score for professionalism \n"
prompterr: .asciiz "error, invalid score, please try again \n"

outp: .asciiz "the final score is: "

labt: .float 18
writt: .float 16
quizt: .float 15
fint: .float 100

labf: .float 20
writf: .float 15
quizf: .float 15
finf: .float 40

.text


	
	#get labs
	la $a0, prompt1 #prompt for lab scores load to a0
	li $v0, 4	#print string
	syscall
	
	la $t1, 3	#the maximum score for labs is 3
	la $t2, 6	#there are 6 lab scores
	la $a1, 0	#initialize score
	jal get
	
	la $s0, 0($a1)	#saved 0 is labs
	
	#get writing
	la $a0, prompt2 #prompt for writing load to a0
	li $v0, 4	#print string
	syscall
	
	la $t1, 4	#the maximum score for writing is 4
	la $t2, 4	#there are 4 writing scores
	la $a1, 0	#initialize score
	jal get
	
	la $s1, 0($a1)	#saved 1 is writing
	
	#get quizes
	la $a0, prompt3 #prompt for quiz load to a0
	li $v0, 4	#print string
	syscall
	
	la $t1, 5	#the maximum score for a quiz is 5
	la $t2, 3	#there are 3 quiz scores
	la $a1, 0	#initialize score
	jal get
	
	la $s2, 0($a1)	#saved 2 is quizes
	
	#get final
	la $a0, prompt4 #prompt for quiz load to a0
	li $v0, 4	#print string
	syscall
	
	la $t1, 100	#the maximum score for a final is 100
	la $t2, 1	#there is only 1 final scores
	la $a1, 0	#initialize score
	jal get
	
	la $s3, 0($a1)	#saved 3 is the final
	
	#get PROFESSIONALISM
	la $a0, prompt5 #prompt for professionalisim load to a0
	li $v0, 4	#print string
	syscall
	
	la $t1, 10	#the maximum score for professionalism is 10
	la $t2, 1	#there is only 1 pro score
	la $a1, 0	#initialize score
	jal get
	
	la $s4, 0($a1)	#saved 4 is professionalism
	
	
	#calculate final score!
	#labs are worth 20 points
	mtc1.d  $s0, $f12	#move int word to $f12 from $s0
	cvt.s.w $f12, $f12	#convert to floating point
	mov.s $f0, $f12		#move $f12 to #f0 - quiz score is now in f0
	
	l.s $f14, labt		#load float 14 with total score
	l.s $f16, labf		#load float 16 with percentage of final
		
	div.s $f18, $f0, $f14	#divide f0 by f14 and put answer in f12, average
	mul.s $f12,$f18, $f16	#multiply by percentage of final grade
	
	mov.s $f0, $f12		#move total score back

	
	#writing is worth 15 points
	mtc1.d  $s1, $f12	#move int word to $f12 from $s1
	cvt.s.w $f12, $f12	#convert to floating point
	mov.s $f1, $f12		#move $f12 to #f1 - writing score is now in f1
	
	l.s $f14, writt		#load float 14 with total score
	l.s $f16, writf		#load float 16 with percentage of final	
	
	div.s $f18, $f1, $f14	#divide f1 by f14 and put answer in f12, average
	mul.s $f12,$f18, $f16	#multiply by percentage of final grade

	mov.s $f1, $f12		#move total score back
	
	#quizzes are worth 15 points - doesn't change
	mtc1.d  $s2, $f12	#move int word to $f12 from $s2
	cvt.s.w $f12, $f12	#convert to floating point
	mov.s $f2, $f12		#move $f12 to #f2 - quiz score is now in f2
	
	
	#the final is worth 40 points
	mtc1.d  $s3, $f12	#move int word to $f12 from $s3
	cvt.s.w $f12, $f12	#convert to floating point
	mov.s $f3, $f12		#move $f12 to #f3 - quiz score is now in f3
	
	l.s $f14, fint		#load float 14 with total score
	l.s $f16, finf		#load float 16 with percentage of final	
	
	div.s $f18, $f3, $f14	#divide f3 by f14 and put answer in f12, average
	mul.s $f12,$f18, $f16	#multiply by percentage of final grade
	
	mov.s $f3, $f12		#move total score back
	
	#professionalism doesn't change
	mtc1.d  $s4, $f12	#move int word to $f12 from $s3
	cvt.s.w $f12, $f12	#convert to floating point
	mov.s $f4, $f12		#move $f12 to #f4 - professionalism is now in f4
	
	#total score added up in f5
	add.s $f5, $f0, $f1
	add.s $f5, $f5, $f2
	add.s $f5, $f5, $f3
	add.s $f5, $f5, $f4

	la $a0, outp 	#output for final score
	li $v0, 4	#print string
	syscall
	
	mov.s $f12, $f5		#move total score to $f12
	li $v0, 2		#print float from $f12		
	syscall	
	
	
	li $v0, 10 	#end program
	syscall
	
	
#gets sum of scores from user
#outputs to $a1
geterr:
	la $a0, prompterr 	#error, try again 
	li $v0, 4		#print string
	syscall	
get:
	li $v0, 5		#get user input - integer
	syscall

	bltz $v0, geterr	#check that input v0 is greater than 0

	bgt $v0, $t1, geterr	#check that input v0 is not higher than maximum score
	
	add $a1, $a1, $v0	#adds valid score at v0 to a1 as output
	
	subi $t2, $t2, 1	#decrement counter for number of scores to enter 
	
	bgtz $t2, get		#continue getting scores if counter is greater than 0
	
	jr $ra			#return if finished
