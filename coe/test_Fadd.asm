.data
all_one: .word 0x000000ff
bbeg:	.word 0xfffffC00

.text
main:  
 	la t0,bbeg
 	lw a5,0(t0)
	
loop1: 
	lw a6, 112(a5)
	beq a6,x0,loop1
	
loop2: 
	lw a6, 112(a5) 
	bne a6,x0,loop2
	
	lw a7, 100(a5)
	sw a7,96(a5) ## test content
	
	srli a7,a7,8
	addi s2,x0,0
	beq s2, a7, test000_1
	addi s2,s2,1
	beq s2, a7, test001_1
	addi s2,s2,1
	beq s2, a7, test010_1
	addi s2,s2,1
	beq s2, a7, test011_1
	addi s2,s2,1
	beq s2, a7, test100_1
	addi s2,s2,1
	beq s2, a7, test101_1
	addi s2,s2,1
	beq s2, a7, test110_1
	addi s2,s2,1
	beq s2, a7, test111_1
	addi s2,s2,1
	beq s2, a7, test1000_1
	addi s2,s2,1
	beq s2, a7, test1001_1
	addi s2,s2,1
	beq s2, a7, test1010_1
	addi s2,s2,1
	beq s2, a7, test1011_1
	addi s2,s2,1
	beq s2, a7, test1100_1
	addi s2,s2,1
	beq s2, a7, test1101_1
	addi s2,s2,1
	beq s2, a7, test1110_1
	addi s2,s2,1
	beq s2, a7, test1111_1
	

test000_1:
	
loop1_t000_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t000_1
	
loop2_t000_1: 
	lw a6, 112(a5) 
	bne a6,x0,loop2_t000_1
	
	lb t0,100(a5)
	sw t0,96(a5)
	
loop3_t000_1:
	lw a6,112(a5)
	beq a6,x0,loop3_t000_1
	
loop4_t000_1: 
	lw a6, 112(a5) 
	bne a6,x0,loop4_t000_1	
	
	lb t0,100(a5)
	sw t0,96(a5)
	jal loop1
	
test001_1:

loop1_t001_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t001_1
	
loop2_t001_1: 
	lw a6, 112(a5) 
	bne a6,x0,loop2_t001_1

	lb s10,100(a5)
	sw s10,108(a5)
	sw s10,120(x0)
	jal loop1

test010_1:

loop1_t010_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t010_1
	
loop2_t010_1: 
	lw a6, 112(a5) 
	bne a6,x0,loop2_t010_1

	lbu s11,100(a5)
	sw s11,108(a5)
	sw s11,124(x0)
	jal loop1
	
	# test 3 beq
test011_1:

loop1_t011_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t011_1
loop2_t011_1:
	lw a6,112(a5)
	bne a6,x0,loop2_t011_1
	
	lw s10,120(x0)
	lw s11,124(x0)
	beq s10,s11,label1_t011_1
	sw x0,96(a5)
	jal label2_t011_1
label1_t011_1:
	addi t1,x0,0x00ff
	sw t1,96(a5)
label2_t011_1:
	jal loop1
	
	# test 4 blt
test100_1:

loop1_t100_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t100_1
	
loop2_t100_1:
	lw a6,112(a5)
	bne a6,x0,loop2_t100_1
	
	lw s10,120(x0)
	lw s11,124(x0)
	blt s10,s11,lable1_t100_1
	sw x0,96(a5)
	jal label2_t100_1
lable1_t100_1:
	addi t1,x0,0x00ff
	sw t1,96(a5)
label2_t100_1:
	jal loop1
	# test 5: bltu
test101_1:

loop1_t101_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t101_1
	
loop2_t101_1:
	lw a6,112(a5)
	bne a6,x0,loop2_t101_1
	
	lw s10,120(x0)
	lw s11,124(x0)
	bltu s10,s11,lable1_t101_1
	sw x0,96(a5)
	jal label2_t101_1
lable1_t101_1:
	addi t1,x0,0x00ff
	sw t1,96(a5)
label2_t101_1:
	jal loop1
	
	# test 6: slt
test110_1:

loop1_t110_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t110_1
loop2_t110_1:
	lw a6,112(a5)
	bne a6,x0,loop2_t110_1
	
	lw s10,120(x0)
	lw s11,124(x0)
	slt t0,s10,s11
	sw t0,96(a5)
	jal loop1
	
	# test 7: sltu
test111_1:

loop1_t111_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t111_1
loop2_t111_1:
	lw a6,112(a5)
	bne a6,x0,loop2_t111_1
	
	lw s10,120(x0)
	lw s11,124(x0)
	sltu t0,s10,s11
	sw t0,96(a5)
	jal loop1
	
test1000_1:

loop1_t1000:
	lw a6,112(a5)
	beq a6,x0,loop1_t1000
loop2_t1000:
	lw a6,112(a5)
	bne a6,x0,loop2_t1000
	lb t0,100(a5)
	andi t0, t0, 0xFF    

	
	andi a1, t0, 0x55   
	slli a1, a1, 1     
	andi a2, t0, 0xAA  
	srli a2, a2, 1   
	or t1, a1, a2    

	andi a1, t1, 0x33    
	slli a1, a1, 2      
	andi a2, t1, 0xCC  
	srli a2, a2, 2       
	or t1, a1, a2    

	andi a1, t1, 0x0F   
	slli a1, a1, 4       
	andi a2, t1, 0xF0   
	srli a2, a2, 4     
	or t1, a1, a2    
	sw t1,96(a5)
	jal loop1
	
test1001_1:
loop1_t1001:
	lw a6,112(a5)
	beq a6,x0,loop1_t1001
loop2_t1001:
	lw a6,112(a5)
	bne a6,x0,loop2_t1001
	lb t0, 100(a5)      
	andi t0, t0, 0xFF  

	andi a1, t0, 0x55   
	slli a1, a1, 1
	andi a2, t0, 0xAA
	srli a2, a2, 1
	or t1, a1, a2

	andi a1, t1, 0x33   
	slli a1, a1, 2
	andi a2, t1, 0xCC
	srli a2, a2, 2
	or t1, a1, a2

	andi a1, t1, 0x0F   
	slli a1, a1, 4
	andi a2, t1, 0xF0
	srli a2, a2, 4
	or t1, a1, a2
	
	xor t1, t0, t1 
	snez t1, t1        
	xori t1, t1, 1    
	sw t1,96(a5)
	jal loop1
	
test1010_1:
	
loop1_t1010:
	lw a6,112(a5)
	beq a6,x0,loop1_t1010
loop2_t1010:
	lw a6,112(a5)
	bne a6,x0,loop2_t1010
	
	lb t0, 100(a5) 
	sw t0,96(a5) 
	andi t0, t0, 0xFF
	sw t0,128(x0)  
	mv s0,t0   

	srli t1, t0, 7     # t1 ����λ 
	srli a0, t0, 4     # a0 ָ��
	andi a0, a0, 0x07   
	andi a1, t0, 0x0F   
	slli a1, a1, 4     # a1 С��

	beqz a0, denormal 

	normalized:
	addi a2, a1, 256   # 
	addi a3, a0, -3     
	bgez a3, exp_positive   

	exp_negative: 
	li t2,0
	beqz t1, check_pos
	li a7,0x8000
	sw a7,96(a5)  
	jal store_result

	exp_positive:
	sll a2, a2, a3   

	shift_combine:
	srli t2, a2, 8   
	j check_sign

	denormal:          
	li t2, 0              

	check_sign:
	beqz t1, check_pos
	li a7,0x8000
	sw a7,96(a5)    
	jal store_result

    	check_pos:
    	sw x0,96(a5)  

	store_result:
	mv t1, t2         
	sw t1,108(a5)
	
loop3_t1010:
	lw a6,112(a5)
	beq a6,x0,loop3_t1010
loop4_t1010:
	lw a6,112(a5)
	bne a6,x0,loop4_t1010
	
	lb t0, 100(a5)  
	sw t0,96(a5)
	andi t0, t0, 0xFF
	sw t0,132(x0)  
	mv s1,t0    

	srli t1, t0, 7   
	srli a0, t0, 4   
	andi a0, a0, 0x07   
	andi a1, t0, 0x0F   
	slli a1, a1, 4    

	beqz a0, denormal1 

	normalized1:
	addi a2, a1, 256   # 
	addi a3, a0, -3     
	bgez a3, exp_positive1   

	exp_negative1: 
	li t2,0
	beqz t1, check_pos1
	li a7,0x8000
	sw a7,96(a5)  
	jal store_result1

	exp_positive1:
	sll a2, a2, a3   

	shift_combine1:
	srli t2, a2, 8   
	j check_sign1

	denormal1:          
	li t2, 0              

	check_sign1:
	beqz t1, check_pos1
	li a7,0x8000
	sw a7,96(a5)    
	jal store_result1

    	check_pos1:
    	sw x0,96(a5)  
	
	store_result1:
	mv t1, t2   
	sw t1,108(a5)
	jal loop1
	
test1011_1:# addition of float

loop1_t1011:
	lw a6,112(a5)
	beq a6,x0,loop1_t1011
loop2_t1011:
	lw a6,112(a5)
	bne a6,x0,loop2_t1011

	lw s0, 128(x0)
	lw s1, 132(x0)
	fadd.s ft6,fs0,fs1
    	sw t1, 108(a5)
    	jal loop1

test1100_1: 

loop1_t1100:
    	lw a6, 112(a5)
    	beq a6, x0, loop1_t1100  
loop2_t1100:
     	lw a6, 112(a5)
    	bne a6, x0, loop2_t1100  

    lbu t0, 100(a5)     
    andi t0, t0, 0x0F     
    li t3, 4  
    li t2, 0x13   # 10011
    li t5, 0x10
    mv t4,t0

crc_gen_loop:
    slli t4, t4, 1  
    and t6,t4,t5
    beqz t6,no_xor_gen 
    xor t4, t4, t2       
    
no_xor_gen:
    addi t3, t3, -1
    bnez t3, crc_gen_loop

    slli t1, t0, 4      
    andi t2, t4, 0x0F       
    or t1, t1, t2       
    sw t1, 96(a5)        
    jal loop1
	
test1101_1: # CRC-4 

loop1_t1101:
    lw a6, 112(a5)
    beq a6, x0, loop1_t1101   
loop2_t1101:
    lw a6, 112(a5)
    bne a6, x0, loop2_t1101   

    lbu t0, 100(a5)    
    srli t6,t0,4
    andi t6,t6,0x0F
    li t3,4
    li t2,0x13
    li t5,0x10
    mv t4,t6

crc_gen_loop1:
    slli t4,t4,1
    and a1,t4,t5
    beqz a1,no_xor_gen1
    xor t4,t4,t2

no_xor_gen1:
    addi t3,t3,-1
    bnez t3,crc_gen_loop1

    slli t1,t6,4
    andi t2,t4,0x0F
    or t1,t1,t2
    beq t0,t1,t1101_set1
    li t1,0
    jal t1101_end

t1101_set1:
    li t1,1

t1101_end:
    sw t1, 96(a5)   
    jal loop1
	
test1110_1:

loop1_t1110:
    	lw a6, 112(a5)
    	beq a6, x0, loop1_t1110  
loop2_t1110:
    	lw a6, 112(a5)
    	bne a6, x0, loop2_t1110  
	
	lui t0,0x0111f
	sw t0,108(a5)
	jal loop1
	
test1111_1:
	
loop1_t1111:
    	lw a6, 112(a5)
    	beq a6, x0, loop1_t1111
loop2_t1111:
    	lw a6, 112(a5)
    	bne a6, x0, loop2_t1111
    	
	li a1,1
	li a2,2
	li a3,3
	li a4,4
test_1111_label1:
	sw a1,108(a5)
loop_1111_label1:
    	lw a6, 112(a5)
    	beq a6, x0, loop_1111_label1
loop2_1111_label1:
    	lw a6, 112(a5)
    	bne a6, x0, loop2_1111_label1
    	
    	lb a6,100(a5)
    	andi a6,a6,0x0F
    	sw a6,96(a5)
    	beq a6,a3,test_1111_jalr3
    	jal test_1111_label2
    	
test_1111_jalr3:
	la t1,test_1111_label3
	jalr t1
    	
test_1111_label2:
	sw a2,108(a5)
loop_1111_label2:
    	lw a6, 112(a5)
    	beq a6, x0, loop_1111_label2
loop2_1111_label2:
    	lw a6, 112(a5)
    	bne a6, x0, loop2_1111_label2
    	
    	lb a6,100(a5)
    	andi a6,a6,0x0F
    	sw a6,96(a5)
    	
test_1111_label3:
	sw a3,108(a5)
loop_1111_label3:
    	lw a6, 112(a5)
    	beq a6, x0, loop_1111_label3
loop2_1111_label3:
    	lw a6, 112(a5)
    	bne a6, x0, loop2_1111_label3
    	
    	lb a6,100(a5)
    	andi a6,a6,0x0F
    	sw a6,96(a5)
    	beq a6,a1,test_1111_jalr_ra
    	jal test_1111_end
    	
test_1111_jalr_ra:
	jr ra

test_1111_end:
	slli a4,a4,5
	sw a4,96(a5)
	jal loop1
	
