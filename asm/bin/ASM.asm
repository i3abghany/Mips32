
########################################################
# Ackermann's function implementation using MIPS assembly
# C interface:
#            int AckermannFunc (int m,int n)
########################################################


.text 
.globl AckermannFunc 

# Preconditions:   
#   1st parameter ($a0) m
#   2nd parameter ($a1) n
# Postconditions:
#   result in ($v0) = value of A(m,n)

# we are going to use $s0 as a temporary registers to store m sometimes

AckermannFunc:   
             # make space on stack
            addi    $sp,   $sp, -8          
            # preserve registers used by this function 
              sw      $s0, 4($sp)
            # preserve return address            
              sw      $ra, 0($sp)     

            # move the parameter registers to temporary  - no, only when nec.

LABEL_IF:      # check whether m==0
            # if not then branch to LABEL_ELSE_IF
            bne   $a0, $zero, LABEL_ELSE_IF

            #  code for "result = n+1"
            addi   $v0,   $a1,   1

            # jump to LABEL_DONE
            j LABEL_DONE


LABEL_ELSE_IF:
            # check whether n==0
            #if not then branch to LABEL_ELSE
            bne $a1, $zero,   LABEL_ELSE

            # need to call A(m-1,1)
            # so initiate $a0,$a1 with m-1 and 1 
            addi   $a0,   $a0,   -1
            addi   $a1,   $zero,   1


            # call AckermannFunc
            jal   AckermannFunc
            # Return value already in $v0         

            # jump to LABEL_DONE
            j LABEL_DONE

LABEL_ELSE:      # This block may be a bit tricky !
            ###################################

            # Save "m" to preserve it for the second ackermann call
              add     $s0, $a0, $zero

            # call to acker(m, (n - 1))
              addi    $a1, $a1, -1
              jal AckermannFunc
            # return value will be used very soon!

            # call to acker(m-1, acker(m, (n - 1)))
            # Take the "m" we saved and decrement it to be the new "m-1" :)
           addi    $a0, $s0, -1
           add     $a1, $v0, $zero
           jal AckermannFunc

            # jump to LABEL_DONE
              j   LABEL_DONE

LABEL_DONE:            
            # ALREADY loaded the return value register $v0 with result.

            # restore registers used by this function
            lw   $s0,   4($sp)
            # restore return address 
            lw   $ra,   0($sp)
            # restore stack pointer
            addi   $sp,   $sp,   8

            # return from this function
            jr $ra


.text 

.globl   Print

# print: Print a message.
# Preconditions:   
#   1st parameter (a0) m
#   2nd parameter (a1) n
#   3rd parameter (a2) value
# Postconditions:
#   Prints the "Ackermann(m,n)=value" on the screen.

Print:   

   addi $sp, $sp, -4   # make space on stack
   sw   $a0, 0($sp)   # preserve first parameter m;

   la   $a0, msg1   # load address of msg1
   li   $v0, 4      # load the "print string" syscall number
   syscall

   lw   $a0, 0($sp)   # load first parameter = m
   li   $v0, 1      # load the "print integer" syscall number
   syscall

   la   $a0, comma   # load address of comma
   li   $v0, 4      # load the "print string" syscall number
   syscall

  move   $a0,$a1      # load second parameter = n
   li   $v0, 1      # load the "print integer" syscall number
   syscall


   la   $a0, msg2   # load address of msg2
   li   $v0, 4      # load the "print string" syscall number
   syscall

  move   $a0, $a2   # load third parameter = value
   li   $v0, 1      # load the "print integer" syscall number
   syscall

   la   $a0, endl   # load address of endl
   li   $v0, 4      # load the "print string" syscall number
   syscall


   lw   $a0, 0($sp)   # restore first parameter
   addi   $sp, $sp, 4   # restore stack pointer

   jr   $ra      # return

.globl   main 

# main:   Test the towers function.

main:   
   addi   $sp, $sp, -16   # make space on stack.
   sw   $ra, 0($sp)   # preserve return address.
   sw   $s0, 4($sp)   # preserve registers s0 through s2
   sw   $s1, 8($sp) # as we may clobber it in main 
   sw   $s2, 12($sp)


   la   $a0, prompt_m # first parameter = prompt
   li   $v0, 4      # load the "print string" syscall number 
   syscall

   li   $v0, 5      # load the "read integer" syscall number 
   syscall
   move   $s0, $v0   # m = s0 = value returned in v0


   la   $a0, prompt_n # second parameter = prompt
   li   $v0, 4      # load the "print string" syscall number 
   syscall

   li   $v0, 5      # load the "read integer" syscall number 
   syscall
   move   $s1, $v0   # n = s1 = value returned in v0

   # Ackermann parameter setup
   move   $a0, $s0   # first parameter =  m 
   move   $a1, $s1   # second parameter = n

   jal   AckermannFunc
   move   $s2, $v0   # Ackermann value = s2 = value returned

    # Print parameter setup       
   move   $a0, $s0   # first parameter =  m 
   move   $a1, $s1   # second parameter = n
   move    $a2, $s2   #

   jal Print
   li   $v0, 0      # return value for main

   lw   $ra, 0($sp)   # restore return address
   lw   $s0, 4($sp)   # restore registers s0 through s3
   lw   $s1, 8($sp) # before exiting main
   lw   $s2, 12($sp)
   addi   $sp, $sp, 16   # restore stack pointer

   jr   $ra     # return to Operating System


.data 

prompt_m: .asciiz   "m="
prompt_n: .asciiz   "n="
msg1:   .asciiz   "Ackermann("
msg2:   .asciiz   ")="
comma:  .asciiz ","   
endl:   .asciiz   "\n" 
