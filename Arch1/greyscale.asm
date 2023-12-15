#This program reads in a colour PPM P3 image and convert this to a greyscale PPM P2 image.
#RTSREC001 - Rector Ratsaka
#19 September 2023

.data
fileIn: .asciiz "/home/r/rtsrec001/Downloads/RTSREC001_CSC2002S_Arch1/Arch1/sample_images/house_64_in_ascii_lf.ppm"
fileOut: .asciiz "/home/r/rtsrec001/Downloads/RTSREC001_CSC2002S_Arch1/Arch1/sample_images/house_greyS_64_in_ascii_lf.ppm"
error_msg: .asciiz "Error occured."
esc: .asciiz "\n"               # escape "\n" for jumping to next line when writing to a file
buffer:    .space  60000        # Buffer to read all the lines/chars
buffer2:    .space 60000        # Buffer for writing to a file
divisor: .word 3                # for average of 1 pixel

.text
.globl main
main:
    lw $t9, divisor
    la $s4, buffer2     #reserved for data that will be store in new file.
    la $s6, esc
    lb $s6, ($s6)
    li $t7, 0           #counter for 1 colour complete
    li $s7, 0           #sum of RGB 
    li $s2, 0           #counter for bytes to write in new file 

    #open file for read
    li $v0, 13
    la $a0, fileIn
    li $a1, 0
    syscall
    move $s0, $v0       #copy $v0 to $s0

    # Create/open output file for writing,with file creation permission.
    li $v0, 13
    la $a0, fileOut
    li $a1, 9
    li $a2, 0644    
    syscall
    move $s1, $v0       #copy $v0 to $s1

    # Check for errors (negative return value) and print error message
    bgez $s0 ,readLines
    li $v0, 4
    la $a0, error_msg
    syscall
    li $v0, 10
    syscall

readLines:
    # Read lines and copy read lines to $s3
    li   $v0, 14
    move $a0, $s0
    la   $a1, buffer
    li   $a2, 60000
    syscall
    la $s3, buffer

    # Check if read was successful
    bgt  $v0, 0, modify   # Branch if successful  
    #If read returned 0, it means end of file
    j done

modify: #greyscale pixel value is calculated by finding the average of its RGB values
    move $t8, $v0       #get read data size
    li $t1, 18
    loop1:              #$s3="P3\n# Jet\n64 64\n255" loop through the header and store bytes in $s4
        lb $t0, ($s3)
        beqz $t1, skip
        bne $t0, 51, continue
        li $t0, 50              #change P3 to P2 
        continue:
            sb   $t0, ($s4)     #$s4 is data that will be stored in new file
            addi $s3, $s3, 1       
            addi $s4, $s4, 1     
            addi $t1, $t1, -1
        j loop1
    skip:   #add \n after header and initialise counter for lines to be executed
        sb $s6, ($s4)   
        addi $s4, $s4, 1 
        addi $s2, $s2, 19
        addi $s5, $t8, -12307  #counter for when all numbers/bytes have been executed
        j reset_int

    reset_int: #reset values for string_to_int of next line
        beqz $s5, readLines
        li $t5, 10  
        li $t4, 48
        li $t2, 0
        li $s7, 0
        li $t7, 0 
        j string_to_int    
    
    string_to_int:        #convert read string to integer for some computations
        addi $s3, $s3, 1
        lb $t0, ($s3)
        beq $t0, $t5, greyscale_calculation
        sub $t1, $t0, $t4
        mul $t2, $t2, $t5
        add $t2, $t2, $t1
        addi $s5, $s5, -1 
        j   string_to_int

    greyscale_calculation: #add RGB from 3 consecutive lines and divide by 3 to get greyscale of 1 pixel
        add $s7, $s7, $t2
        addi $t7, $t7, 1
        li $t2, 0
        bne $t7, $t9, string_to_int
        div $s7, $t9
        mflo $s7
        j int_to_string

    int_to_string:
        #convert intergers back to strings for writing to file 
        li $t1, 10        
        div $s7,$t1
        mflo $t3         
        mfhi $t4    
        div $t3, $t1 
        mfhi $t3
        mflo $t1    
        addi $t4, $t4, 48 
        addi $t3, $t3, 48
        addi $t1, $t1, 48
        blt $s7, 10, one_digit
        blt $s7, 100, two_digits
        sb $t1, ($s4)   
        addi $s4, $s4, 1
        addi $s2, $s2, 1
        two_digits:            #store two bytes if int<100
            sb $t3, ($s4)   
            addi $s4, $s4, 1
            addi $s2, $s2, 1 
        one_digit:             #store one byte if int<10
            sb $t4, ($s4)   
            addi $s4, $s4, 1 
            sb $s6, ($s4)   
            addi $s4, $s4, 1 
            addi $s2, $s2, 2
        j reset_int
    
done:
    #write into new file, new pixels stored in $s4
    sb $zero, 0($s4)
    li $v0, 15
	move $a0, $s1
	la $a1, buffer2
	move $a2, $s2
	syscall 
    
    #close all files
    li $v0, 16
    move $a0, $s0
    syscall
    li $v0, 16
    move $a0, $s1
    syscall

exit:
    li	$v0, 10
    syscall