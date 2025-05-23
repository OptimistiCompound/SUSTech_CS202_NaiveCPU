.data
all_one: .word 0x000000ff
bbeg:	.word 0xfffffC00

.text
main:  # 表示和 EGO1 开发板交互的地址
 	la t0,bbeg
 	lw a5,0(t0)
	
loop1: # 开始按钮
	lw a6, 112(a5)
	beq a6,x0,loop1
	
loop2: # 按钮结束
	lw a6, 112(a5) # 需要考虑 byte 即可
	bne a6,x0,loop2
	
	# 读取测试样例编号 
	lw a7, 100(a5)
	sw a7,96(a5) ## test content
	
	# 计数器清零
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
	
loop2_t000_1: # 按钮结束
	lw a6, 112(a5) 
	bne a6,x0,loop2_t000_1
	
	lb t0,100(a5)
	sw t0,96(a5)
	
loop3_t000_1:
	lw a6,112(a5)
	beq a6,x0,loop3_t000_1
	
loop4_t000_1: # 按钮结束
	lw a6, 112(a5) 
	bne a6,x0,loop4_t000_1	
	
	lb t0,100(a5)
	sw t0,96(a5)
	jal loop1
	
test001_1:

loop1_t001_1:
	lw a6,112(a5)
	beq a6,x0,loop1_t001_1
	
loop2_t001_1: # 按钮结束
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
	
loop2_t010_1: # 按钮结束
	lw a6, 112(a5) 
	bne a6,x0,loop2_t010_1

	lbu s11,100(a5)
	sw s11,108(a5)
	sw s11,124(x0)
	jal loop1
	
	# test 3 beq
test011_1:
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
	slt s10,s11,t0
	sw t0,96(a5)
	jal loop1
	
	# test 7: sltu
test111_1:
	sltu s10,s11,t0
	sw t0,96(a5)
	jal loop1
	
test1000_1:

loop1_t1000:
	lw a6,112(a5)
	beq a6,x0,loop1_t1000
loop2_t1000:
	lw a6,112(a5)
	bne a6,a0,loop2_t1000
	lb t0,100(a5)
	andi t0, t0, 0xFF    # 转换为无符号8位，高位清零

	# 第一次交换相邻的1位
	andi a1, t0, 0x55    # 提取奇数位
	slli a1, a1, 1       # 左移1位
	andi a2, t0, 0xAA    # 提取偶数位
	srli a2, a2, 1       # 右移1位
	or t1, a1, a2       # 组合结果

	# 第二次交换相邻的两位块
	andi a1, t1, 0x33    # 提取低两位
	slli a1, a1, 2        # 左移2位
	andi a2, t1, 0xCC    # 提取高两位
	srli a2, a2, 2        # 右移2位
	or t1, a1, a2       # 组合结果

	# 第三次交换相邻的四位块
	andi a1, t1, 0x0F    # 提取低四位
	slli a1, a1, 4        # 左移4位
	andi a2, t1, 0xF0    # 提取高四位
	srli a2, a2, 4        # 右移4位
	or t1, a1, a2       # 组合结果，t1低8位为翻转后的值，高位为0
	sw t1,96(a5)
	jal loop1
	
test1001_1:
loop1_t1001:
	lw a6,112(a5)
	beq a6,x0,loop1_t1001
loop2_t1001:
	lw a6,112(a5)
	bne a6,a0,loop2_t1001
	lb t0, 100(a5)        # 加载字节到t0（符号扩展）
	andi t0, t0, 0xFF     # 确保处理无符号8位值

	# 位翻转逻辑（复用之前的代码）
	andi a1, t0, 0x55     # 第一次交换
	slli a1, a1, 1
	andi a2, t0, 0xAA
	srli a2, a2, 1
	or t1, a1, a2

	andi a1, t1, 0x33     # 第二次交换
	slli a1, a1, 2
	andi a2, t1, 0xCC
	srli a2, a2, 2
	or t1, a1, a2

	andi a1, t1, 0x0F     # 第三次交换
	slli a1, a1, 4
	andi a2, t1, 0xF0
	srli a2, a2, 4
	or t1, a1, a2
	
	xor t1, t0, t1 
	snez t1, t1           # 若不同则t1=1，相同则t1=0
	xori t1, t1, 1        # 结果取反（相同则t1=1，不同则0）
	sw t1,96(a5)
	jal loop1
	
test1010_1:
	
loop1_t1010:
	lw a6,112(a5)
	beq a6,x0,loop1_t1010
loop2_t1010:
	lw a6,112(a5)
	bne a6,a0,loop2_t1010
	
	lb t0, 100(a5)  
	mv s10,t0   
	andi t0, t0, 0xFF   

	srli t1, t0, 7      
	srli a0, t0, 4      
	andi a0, a0, 0x07   
	andi a1, t0, 0x0F   
	slli a1, a1, 4      

	beqz a0, denormal 

	normalized:
	addi a2, a1, 256      
	addi a3, a0, -3       
	bgez a3, exp_positive   

	exp_negative:
	neg a4, a3         
	srl a2, a2, a4        
	j shift_combine

	exp_positive:
	sll a2, a2, a3   

	shift_combine:
	srli t2, a2, 8   
	j check_sign

	denormal:          
	li t2, 0              

	check_sign:
	beqz t1, store_result
	neg t2, t2           

	store_result:
	mv t1, t2         
	sw t1,96(a5)
	
loop3_t1010:
	lw a6,112(a5)
	beq a6,x0,loop3_t1010
loop4_t1010:
	lw a6,112(a5)
	bne a6,a0,loop4_t1010
	
	lb t0, 100(a5)  
	mv s11,t0   
	andi t0, t0, 0xFF   

	srli t1, t0, 7      
	srli a0, t0, 4      
	andi a0, a0, 0x07   
	andi a1, t0, 0x0F   
	slli a1, a1, 4      

	beqz a0, denormal 

	normalized1:
	addi a2, a1, 256      
	addi a3, a0, -3       
	bgez a3, exp_positive1   

	exp_negative1:
	neg a4, a3         
	srl a2, a2, a4        
	j shift_combine1

	exp_positive1:
	sll a2, a2, a3   

	shift_combine1:
	srli t2, a2, 8   
	j check_sign1

	denormal1:          
	li t2, 0              

	check_sign1:
	beqz t1, store_result1
	neg t2, t2           

	store_result1:
	mv t1, t2         
	sw t1,96(a5)
	jal loop1
	
test1011_1:# addition of float
	#s10,s11

test1100_1: 
loop1_t1100:
    lw a6, 112(a5)
    beq a6, x0, loop1_t1100  
loop2_t1100:
    lw a6, 112(a5)
    bne a6, x0, loop2_t1100  

    lbu t0, 100(a5)     
    andi t0, t0, 0x0F     
    li t2, 0              
    li t3, 4             
    slli t4, t0, 4 

crc_gen_loop:
    slli t2, t2, 1     
    srli t5, t4, 7         
    or t2, t2, t5          
    slli t4, t4, 1         

    andi t5, t2, 0x10     
    beqz t5, no_xor_gen
    xori t2, t2, 0x13  
no_xor_gen:
    addi t3, t3, -1
    bnez t3, crc_gen_loop

    slli t1, t0, 4      
    andi t2, t2, 0x0F       
    or t1, t1, t2       
    sw t1, 96(a5)        
    jal loop1
	
test1101_1: # CRC-4 校验（输入8位，校验通过则LED亮）
loop1_t1101:
    lw a6, 112(a5)
    beq a6, x0, loop1_t1101   
loop2_t1101:
    lw a6, 112(a5)
    bne a6, x0, loop2_t1101   

    lbu t0, 100(a5)    
    srli a0, t0, 4        
    andi a1, t0, 0x0F      
    li t2, 0                
    li t3, 8           

crc_check_loop2:
    slli t2, t2, 1         
    srli t5, t0, 7     
    or t2, t2, t5          
    slli t0, t0, 1       

    andi t5, t2, 0x10    
    beqz t5, no_xor_check2
    xori t2, t2, 0x13  
no_xor_check2:
    addi t3, t3, -1
    bnez t3, crc_check_loop2

    andi t2, t2, 0x0F    
    seqz t1, t2     
    sw t1, 96(a5)   
    jal loop1
	
test1110_1:
	
test1111_1:
	

	
