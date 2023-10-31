.data
     list:.word 23,15,8
 .text    

# this is 32 unsign int clz computation for three node for list 
main:

  #load address for list 
  la  s0,list
  
  lw  a0,0(s0)   
  call clz
  jal ra, print_result
  
  

  lw a0,4(s0)
  call clz
  jal ra, print_result

  lw a0,8(s0)
  call clz
  jal ra, print_result

  #calculate Sum of three node clz leading zeros
  call sum_clz_zeros
  jal ra,print_result
  
  j exit_program   
     
print_result:


li a7,1
ecall
jr ra


clz:
addi sp,sp,-16
sw ra,0(sp)
sw s0,4(sp)   
sw s1,8(sp)      #Prologue
sw s2,12(sp)

#s0 is x
add s0,x0,a0

li s3, 1
li s4, 0
li s5, 5
counter:
    beq s4, x0, op_main
    sll s3, s3, s4 

op_main:
   addi s4, s4, 1
   srl t0,s0, s3
   or s0,s0,t0
   bne s4, s5, counter
    
#x -= ((x>>1) & 0x55555555)
li t1,0x55555555
srli t0,s0,1
and t0,t0,t1
sub s0,s0,t0


#x = ((x>>2) & 0x33333333)+(x &0x33333333)
li t1,0x33333333
srli t0,s0,2
and t0,t0,t1
and t1,s0,t1
add s0,t0,t1

#x = ((x>>2) +4)&0x0f0f0f0f
srli t0,s0,4
add t0,t0,s0
li t1,0x0f0f0f0f
and s0,t0,t1

#x += (x>>8) 
srli t0,s0,8
add s0,t0,s0

#x += (x>>16) 
srli t0,s0,16
add s0,t0,s0

#(32-(x&0x1f))
li a0,32
andi t0,s0,0x1f
sub a0,a0,t0


lw ra,0(sp)
lw s0,4(sp)      #Epiologue
lw s1,8(sp)
lw s2,12(sp)
addi sp,sp,16

jr ra

sum_clz_zeros:
  addi sp, sp, -16
  sw ra, 0(sp)
  sw s0, 4(sp)      #Prologue
  sw s1, 8(sp)
  sw s2, 12(sp)

  li s0, 0
    
  la s1, list  #load address for list

 loop:
  lw t0, 0(s1) 
  beqz t0,done
  mv a0, t0
  mv t2,a0         
  jal ra, clz       
  add s0, s0, a0
  addi s1,s1,4
  j loop
 

 
 done:
    mv a0,s0    #s0->a0
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)   #Epiologue
    lw s2,12(sp)
    addi sp,sp,16
    jr ra
 



exit_program:
    la s0,list
    li t0,0
    loop_free:
        lw t1,0(s0)
        beqz t1,done_free
        lw t2,4(t1)
        sw zero,0(t1)
        mv s0,t2
        j loop_free
    done_free:      
    li a7,10
    ecall