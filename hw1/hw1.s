.data
test1: .word 0x00000011
test2: .word 0x00001101
test3: .word 0x00010011
newline: .string "\n"
printf1: .string "leading zeros:"
printf2: .string "MSB:"
.text

main:
  lw s0, test1
  jal counting_process
  li t4, 32
  sub s6, t4, s5 #MSB
  jal result   

  lw s0, test2
  jal counting_process
  li t4, 32
  sub s6, t4, s5 
  jal result 

  lw s0, test3
  jal counting_process
  li t4, 32
  sub s6, t4, s5
  jal result 
  j exit

result:
  la a0, printf1
  li a7, 4
  ecall
  mv a0, s5
  li a7, 1 #print n
  ecall
  la a0, newline
  li a7, 4
  ecall
  la a0, printf2
  li a7, 4
  ecall
  mv a0, s6
  li a7, 1
  ecall
  la a0, newline
  li a7, 4
  ecall
  ret
  
exit:
  li a7, 10
  ecall

counting_process:
  #x |= (x >> 1);  
  #x |= (x >> 2);  
  #x |= (x >> 4);  
  #x |= (x >> 8);  
  #x |= (x >> 16); 
  #x |= (x >> 32); 
  srli s1, s0, 1
  or s0, s1, s0
  srli s1, s0, 2
  or s0, s1, s0
  srli s1, s0, 4
  or s0, s1, s0
  srli s1, s0, 8
  or s0, s1, s0
  srli s1, s0, 16
  or s0, s1, s0

  #x -= ((x >> 1) & 0x5555555555555555);
  srli s1, s0, 1 #x>>1
  li s2, 0x55555555 
  and s1, s1, s2 #x>>1 & 0x55..
  sub s0, s0, s1

  #x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
  srli s1, s0, 2
  li s2, 0x33333333
  and s1, s1, s2
  and s3, s0, s2
  add s0, s1, s3

  #x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
  srli s1, s0, 4
  add s1, s0, s1
  li s2, 0x0f0f0f0f
  and s0, s1, s2

  #x += (x >> 8);
  srli s1, s0, 8
  add s0, s0, s1

  #x += (x >> 16);
  srli s1, s0, 16
  add s0, s0, s1

  #x += (x >> 32);
  li s1, 0 #srli 32bit = 0
  add s0, s0, s1

  li t1, 0x0000007f
  and s1, s0, t1
  sub s5, x0, s1 #n=s5
  addi s5, s5, 32
  ret

