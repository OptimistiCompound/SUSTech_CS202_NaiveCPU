loop1_t1111:
    # 输入引导：读取a6的值
    li a7, 5        # ecall代码5为读取整数
    ecall           # 输入的值存入a0
    mv a6, a0       # 将输入值移动到a6
    beq a6, x0, loop1_t1111  # 若输入为0，继续循环

    li a1, 1        # 初始化寄存器
    li a2, 2
    li a3, 3
    li a4, 4

test_1111_label1:
    # 输出测试编号1并换行
    li a7, 1        # ecall代码1为打印整数
    li a0, 1        # 测试编号1
    ecall
    li a7, 11       # ecall代码11为打印字符
    li a0, 10       # 换行符ASCII码
    ecall

loop_1111_label1:
    # 输入引导：读取a6的值
    li a7, 5
    ecall
    mv a6, a0
    beq a6, x0, loop_1111_label1  # 输入为0则继续循环

    andi a6, a6, 0x0F
    beq a6, a2, test_1111_jar_12
    beq a6, a3, test_1111_jalr_13
    jal test_1111_label1

test_1111_label2:
    # 输出测试编号2并换行
    li a7, 1
    li a0, 2
    ecall
    li a7, 11
    li a0, 10
    ecall

loop_1111_label2:
    # 输入引导：读取a6的值
    li a7, 5
    ecall
    mv a6, a0
    beq a6, x0, loop_1111_label2

    andi a6, a6, 0x0F
    beq a6, a1, test_1111_jar_21
    beq a6, a3, test_1111_jalr_23
    jal test_1111_label2

test_1111_label3:
    # 输出测试编号3并换行
    li a7, 1
    li a0, 3
    ecall
    li a7, 11
    li a0, 10
    ecall

loop_1111_label3:
    # 输入引导：读取a6的值
    li a7, 5
    ecall
    mv a6, a0
    beq a6, x0, loop_1111_label3

    andi a6, a6, 0x0F
    beq a6, a1, test_1111_jar_31
    beq a6, a2, test_1111_jar_32
    beq a6, a4, test_1111_jar_34
    jr ra

test_1111_jar_21:
test_1111_jar_31:
    jal test_1111_label1

test_1111_jar_12:
test_1111_jar_32:
    jal test_1111_label2

test_1111_jalr_13:
    la t1, test_1111_label3
    jalr t1

test_1111_jalr_23:
    la t1, test_1111_label3
    jalr t1

test_1111_jar_34:
    jal test_1111_label1
