loop1_t1111:
    # ������������ȡa6��ֵ
    li a7, 5        # ecall����5Ϊ��ȡ����
    ecall           # �����ֵ����a0
    mv a6, a0       # ������ֵ�ƶ���a6
    beq a6, x0, loop1_t1111  # ������Ϊ0������ѭ��

    li a1, 1        # ��ʼ���Ĵ���
    li a2, 2
    li a3, 3
    li a4, 4

test_1111_label1:
    # ������Ա��1������
    li a7, 1        # ecall����1Ϊ��ӡ����
    li a0, 1        # ���Ա��1
    ecall
    li a7, 11       # ecall����11Ϊ��ӡ�ַ�
    li a0, 10       # ���з�ASCII��
    ecall

loop_1111_label1:
    # ������������ȡa6��ֵ
    li a7, 5
    ecall
    mv a6, a0
    beq a6, x0, loop_1111_label1  # ����Ϊ0�����ѭ��

    andi a6, a6, 0x0F
    beq a6, a2, test_1111_jar_12
    beq a6, a3, test_1111_jalr_13
    jal test_1111_label1

test_1111_label2:
    # ������Ա��2������
    li a7, 1
    li a0, 2
    ecall
    li a7, 11
    li a0, 10
    ecall

loop_1111_label2:
    # ������������ȡa6��ֵ
    li a7, 5
    ecall
    mv a6, a0
    beq a6, x0, loop_1111_label2

    andi a6, a6, 0x0F
    beq a6, a1, test_1111_jar_21
    beq a6, a3, test_1111_jalr_23
    jal test_1111_label2

test_1111_label3:
    # ������Ա��3������
    li a7, 1
    li a0, 3
    ecall
    li a7, 11
    li a0, 10
    ecall

loop_1111_label3:
    # ������������ȡa6��ֵ
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
