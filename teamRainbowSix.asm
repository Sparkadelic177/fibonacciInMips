.data
	promptR: .asciiz "Which number in the Fibonacci sequence do you want?"
        promptE: .asciiz  "Invalid entry"
        promptA: .asciiz "The number you asked for is "
        input: .word 0
.text		

	#giving the instruction to syscall to print something
           addi $v0,$zero,4 
        #loading the address of the prompt to a registar 
        #this is going to be sent to the syscall 
           la $a0,promptR
        #this prints the prompt for the user to read and saved in $v0
           syscall
           addi $v0,$zero,5
           syscall
           add $s0,$v0,$zero
           blez $s0,Error
           b main
           
           
           Error: 
           addi $v0,$zero,4
           la $a0,promptE
           syscall  
           b finished     

	main:	
		addi $v0,$zero,4
		la $a0,promptA
		syscall
		add $a0,$zero,$zero
		add $a0, $a0,$s0
		jal factorial
		# move what ever is returned into $a0
		add $a0,$zero, $v0
		addi  $v0,$zero,1
		syscall
		b finished
	
	factorial: 
		addi $t1,$zero, 2
		ble $a0, $t1, basecase
		# store arguments & return address on stack
		addi $sp, $sp, -12
		sw $a0, 0($sp)
		sw $s1, 8($sp)
		sw $ra, 4($sp)
		# set new argment
		addi $a0, $a0, -1
		
		# call procedure
		jal factorial
		add $s1,$zero,$v0
		addi $a0,$a0,-1
		jal factorial
		# restore arguments & return address from stack
		add  $v0,$v0,$s1
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		lw $s1, 8($sp)
		addi $sp, $sp, 12
		jr $ra
	basecase:	addi $v0, $zero, 1
		jr $ra
	finished: