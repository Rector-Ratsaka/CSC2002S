#This program reads in a colour PPM and increase each RGB value by 10 and write the image in new file.
#RTSREC001 - Rector Ratsaka
#19 September 2023

.data
fileIn: .asciiz "/home/r/rtsrec001/Downloads/RTSREC001_CSC2002S_Arch1/Arch1/sample_images/jet_64_in_ascii_lf.ppm"
fileOut: .asciiz "/home/r/rtsrec001/Downloads/RTSREC001_CSC2002S_Arch1/Arch1/sample_images/jet_incB_64_in_ascii_lf.ppm"
pixel_old: .asciiz "Average pixel value of the original image:\n"
pixel_new: .asciiz "\nAverage pixel value of new image:\n"
error_msg: .asciiz "Error occured."
esc: .asciiz "\n"                     # escape "\n" for jumping to next line when writing to a file
buffer:    .space  60000              # Buffer to read all the lines/chars
buffer2:    .space 60000              # Buffer for writing to a file
divisor: .word 3133440                # 64*64*3*255

.text
.globl main
main:
    li $t8, 0   # initial Average pixel value of the original image
    li $t9, 0   # initial Average pixel value of the new image
    la $s4, buffer2
    la $s6, esc
    lb $s6, ($s6)
    li $s7, 0           #counter for bytes to write in new file 

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

modify: 
    #increase brightness and calculate average pixel
    move $t7, $v0             #get read data size
    li $t1, 18
    loop1:                    #$s3="P3\n# Jet\n64 64\n255" loop through the header and store bytes in $s4
        lb $t0, ($s3)
        beqz $t1, skip 
        sb   $t0, ($s4)        #$s4 is data that will be stored in new file
        addi $s3, $s3, 1       
        addi $s4, $s4, 1     
        addi $t1, $t1, -1
        j loop1
    skip:   
        sb $s6, ($s4)           #store "\n" to move to next line when writing to a file
        addi $s4, $s4, 1 
        addi $s7, $s7, 19
        addi $s5, $t7, -12307  #counter for when to execute all numbers/bytes.
        j reset_int

    reset_int: 
        #reset values for string_to_int for next line execution
        add $t8, $t8, $t2       #sum for original image pixel
        beqz $s5, readLines
        li $t5, 10  
        li $t4, 48
        li $t2, 0
        j string_to_int    
    
    string_to_int: 
        #convert read string to integer for some computations
        addi $s3, $s3, 1
        lb $t0, ($s3)
        beq $t0, $t5, add_10
        sub $t1, $t0, $t4
        mul $t2, $t2, $t5
        add $t2, $t2, $t1
        addi $s5, $s5, -1 
        j   string_to_int

    add_10: #increase each RGB value by 10
        bne $t2, 255, add_less
        li $t5, 255
        j sum_new
        add_less:  #less than255
            addi $t5, $t2, 10
            bne $t5, 255, sum_new
            li $t5, 255
        sum_new:    #sum for original image pixel
            add $t9, $t9, $t5   
            j int_to_string

    int_to_string: 
        #convert intergers back to strings for writing to file 
        li $t1, 10        
        div $t5,$t1
        mflo $t3         
        mfhi $t4    
        div $t3, $t1 
        mfhi $t3
        mflo $t1    
        addi $t4, $t4, 48 
        addi $t3, $t3, 48
        addi $t1, $t1, 48
        blt $t5, 100, two_digits
        sb $t1, ($s4)   
        addi $s4, $s4, 1
        addi $s7, $s7, 1
        two_digits:            #store two bytes if int<100
            sb $t3, ($s4)   
            addi $s4, $s4, 1
            sb $t4, ($s4)   
            addi $s4, $s4, 1 
            sb $s6, ($s4)   
            addi $s4, $s4, 1 
            addi $s7, $s7, 3
            j reset_int
done:
    #print averages and close files
    li $v0, 4
    la $a0, pixel_old
    syscall

    #Average calculations for original image
    lw $t1, divisor 
    mtc1 $t8, $f2    # Move $t8 to $f0 as a double
    mtc1 $t1, $f4    # Move $t1 to $f2 as a double
    div.d  $f12, $f2, $f4
    li $v0, 3          # Load syscall code for printing a double
    syscall

    li $v0, 4
    la $a0, pixel_new
    syscall

    #Average calculations for new image
    mtc1 $t9, $f2    # Move $t9 to $f0 as a double
    mtc1 $t1, $f4    # Move $t1 to $f2 as a double
    div.d  $f12, $f2, $f4
    li $v0, 3          # Load syscall code for printing a double
    syscall

    #write into new file, new pixels stored in $s4
    sb $zero, 0($s4)
    li $v0, 15
	move $a0, $s1
	la $a1, buffer2
	move $a2, $s7
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





    
