.data
all_one: .word 0x02bcd0ff
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
	sw a7,96(a5) 
	
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
	
test000_1:

loop1_t000_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t000_1
	
loop2_t000_1: 
	lw a6, 112(a5) 
	bne a6,x0,loop2_t000_1
	
	la t1,all_one	# auipc
	lw t2,0(t1)
	sw t2,108(t1)
	jal loop1

test001_1:
	
loop1_t001_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t001_1
	
loop2_t001_1: 
	lw a6, 112(a5) 
	bne a6,x0,loop2_t001_1
	
	lb t0, 100(a5)
	sw t0,96(a5) 
	andi t0, t0, 0xFF
	mv s0,t0
	
loop3_t001_1:
	lw a6,112(a5)
	beq a6,x0,loop3_t001_1
loop4_t001_1:
	lw a6,112(a5)
	bne a6,x0,loop4_t001_1
	
	lb t0, 100(a5)  
	sw t0,96(a5)
	andi t0, t0, 0xFF 
	mv s1,t0 

loop5_t001_1:
	lw a6,112(a5)
	beq a6,x0,loop5_t001_1
loop6_t001_1:
	lw a6,112(a5)
	bne a6,x0,loop6_t001_1	
	
	fadd.s ft6,fs0,fs1
    	sw t1, 108(a5)
    	jal loop1

test010_1:

loop1_t010_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t010_1
loop2_t010_1:
	lw a6,112(a5)
	bne a6,x0,loop2_t010_1	
	
	lb t1,100(a5)
	sw t1,108(a5)

loop3_t010_1:
	lw a6,112(a5)
	beq a6,x0,loop3_t010_1
loop4_t010_1:
	lw a6,112(a5)
	bne a6,x0,loop4_t010_1	
	
	lb t2,100(a5)
	sw t2,96(a5)
	mul t0,t1,t2
	sw t0,108(a5)
	jal loop1
	
test011_1:
	
loop1_t011_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t011_1
loop2_t011_1:
	lw a6,112(a5)
	bne a6,x0,loop2_t011_1
	
	li t0,0
	la t5,all_one
	lw t6,0(t5)
loop3_t011_1:
	addi t0,t0,1
	lw t1,0(x0)
	sw t5,60(x0)
	bne t0,t6,loop3_t011_1
	
	sw t0,108(a5)
	jal loop1

test100_1:
	
	