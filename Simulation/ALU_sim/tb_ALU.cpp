#include "VALU.h"          // Verilator生成的模块头文件
#include <verilated.h>
#include <verilated_vcd_c.h> // 波形跟踪
#include "../../Header_Files/riscv_macros.h"

vluint64_t main_time = 0;  // 仿真时间戳

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VALU* dut = new VALU;  // 实例化ALU模块

    // 初始化波形跟踪（可选）
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 5); // 跟踪5层信号
    tfp->open("waveform.vcd");

    int ans = 0;
    int ans_zero = 0;

//-------------------------------------------------------------
// R-type Test
//-------------------------------------------------------------
    printf("\n=== R-type Test ===\n\n");
    // test1: ADD
    dut->ReadData1 = 0x00000001;
    dut->ReadData2 = 0x00000002;
    dut->ALUOp = ALUOP_R;
    dut->funct3 = (INST_ADD >> 8); // 需要右移来去掉funct7
    dut->funct7 = (INST_ADD & 0x0FF); // 需要去掉funct3
    dut->ALUSrc = 0; // from reg
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 + dut->ReadData2) && dut->zero == 0) {
        printf("test1 passed!\n");
    } else {
        printf("test1 failed: ADD 0x%08X 0x%08X: Result=0x%08X, zero=%d\n", 
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test2: SUB
    dut->funct3 = (INST_SUB >> 8);
    dut->funct7 = (INST_SUB & 0x0FF);
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 - dut->ReadData2) && dut->zero == 0) {
        printf("test2 passed!\n");
    } else {
        printf("test2 failed: SUB 0x%08X 0x%08X: Result=0x%08X, zero=%d\n", 
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test3: XOR
    dut->ReadData1 = 0xAA55AA55;
    dut->ReadData2 = 0x55AA55AA;
    dut->funct3 = (INST_XOR >> 8);
    dut->funct7 = (INST_XOR & 0x0FF);
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 ^ dut->ReadData2) && dut->zero == 0) {
        printf("test3 passed!\n");
    } else {
        printf("test3 failed: XOR 0x%08X 0x%08X: Result=0x%08X, zero=%d\n", 
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test4: OR
    dut->ReadData1 = 0xAAAA0000;
    dut->ReadData2 = 0x55550000;
    dut->funct3 = (INST_OR >> 8);    // 0x6 (110b)
    dut->funct7 = (INST_OR & 0x0FF);  // 0x00
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 | dut->ReadData2) && dut->zero == 0) {
        printf("test4 passed!\n");
    } else {
        printf("test4 failed: OR 0x%08X 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test5: AND
    dut->ALUOp = ALUOP_R;
    dut->funct3 = (INST_AND >> 8);
    dut->funct7 = (INST_AND & 0x0FF);
    dut->ReadData1 = 0xF0F0F0FF;
    dut->ReadData2 = 0x0F0F0FFF;
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 & dut->ReadData2) && dut->zero == 0) {
        printf("test5 passed!\n");
    } else {
        printf("test5 failed: ADD 0x%08X 0x%08X: Result=0x%08X, zero=%d\n", 
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test6: SLL
    dut->ReadData1 = 0x0000000F;
    dut->ReadData2 = 0xFF000048; // 移位量（取低5bit）
    dut->funct3 = (INST_SLL >> 8);
    dut->funct7 = (INST_SLL & 0x0FF);
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 << (dut->ReadData2 & 0x1F)) && dut->zero == 0) {
        printf("test6 passed!\n");
    } else {
        printf("test6 failed: SLL 0x%08X by 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test7: SRL
    dut->ReadData1 = 0xF0000000;
    dut->ReadData2 = 0xFF000048;
    dut->funct3 = (INST_SRL >> 8);   // 0x5 (101b)
    dut->funct7 = (INST_SRL & 0x0FF); // 0x00
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == ((uint32_t)dut->ReadData1 >> (dut->ReadData2 & 0x1F)) && dut->zero == 0) {
        printf("test7 passed!\n");
    } else {
        printf("test7 failed: SRL 0x%08X by 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test8: SRA
    dut->ReadData1 = 0xF0000000;
    dut->ReadData2 = 0xFF000048;
    dut->funct3 = (INST_SRA >> 8);   // 0x5 (101b)
    dut->funct7 = (INST_SRA & 0x0FF); // 0x20
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == ((int32_t)dut->ReadData1 >> (dut->ReadData2 & 0x1F)) && dut->zero == 0) {
        printf("test8 passed!\n");
    } else {
        printf("test8 failed: SRA 0x%08X by 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test9: SLT
    dut->ReadData1 = 0xFFFFFFFE; // -2
    dut->ReadData2 = 0x00000001; // 1
    dut->funct3 = (INST_SLT >> 8);   // 0x2 (010b)
    dut->funct7 = (INST_SLT & 0x0FF); // 0x00
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == ((int32_t)dut->ReadData1 < (int32_t)dut->ReadData2) & 0xFFFFFFFF && dut->zero == 0) { // -2 < 1 → 1
        printf("test9 passed!\n");
    } else {
        printf("test9 failed: SLT 0x%08X vs 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // test10: SLTU
    dut->ReadData1 = 0xFFFFFFFE; // 4294967294（无符号）
    dut->ReadData2 = 0x00000001; // 1
    dut->funct3 = (INST_SLTU >> 8);  // 0x3 (011b)
    dut->funct7 = (INST_SLTU & 0x0FF);// 0x00 
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (((uint32_t)dut->ReadData1 < (uint32_t)dut->ReadData2) & 0xFFFFFFFF) && dut->zero == 1) { // 4294967294 > 1 → 0
        printf("test10 passed!\n");
    } else {
        printf("test10 failed: SLTU 0x%08X vs 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }



//-------------------------------------------------------------
// I-type Test
//-------------------------------------------------------------
    printf("\n=== I-type Test ===\n\n");
    // test11: ADDI
    dut->ReadData1 = 0x0000000A;
    dut->imm32 = 0x00000005; // 立即数
    dut->ALUOp = ALUOP_I;
    dut->funct3 = INST_ADDI;      // funct3=0
    dut->ALUSrc = 1;                     // 使用立即数
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 + (int32_t)dut->imm32) && dut->zero == 0) {
        printf("test11 passed!\n");
    } else {
        printf("test11 failed: ADDI 0x%08X 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    // test12: XORI
    dut->ReadData1 = 0xAAAAAAAA;
    dut->imm32 = 0x55555555;         // 立即数
    dut->funct3 = (INST_XORI);       // funct3=4 (100b)
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 ^ (int32_t)dut->imm32) && dut->zero == 0) {
        printf("test12 passed!\n");
    } else {
        printf("test12 failed: XORI 0x%08X 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    // test13: ORI
    dut->ReadData1 = 0x12345678;
    dut->imm32 = 0x0000FFFF;         // 立即数
    dut->funct3 = (INST_ORI);       // funct3=6 (110b)
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 | (int32_t)dut->imm32) && dut->zero == 0) {
        printf("test13 passed!\n");
    } else {
        printf("test13 failed: ORI 0x%08X 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    // test14: ANDI（测试符号扩展）
    dut->ReadData1 = 0xFFFF0000;
    dut->imm32 = 0x0000FFFF;         // 立即数（实际会被符号扩展为0xFFFFFFFF）
    dut->funct3 = (INST_ANDI);      // funct3=7 (111b)
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 & dut->imm32) && dut->zero == 1) {
        printf("test14 passed!\n");
    } else {
        printf("test14 failed: ANDI 0x%08X 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    // test15: SLLI
    dut->ReadData1 = 0x0000000F;
    dut->imm32 = 0x0000001C;         // 移位量（取低5位：0x1C & 0x1F = 28）
    dut->funct3 = (INST_SLLI);      // funct3=1 (001b)
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == (dut->ReadData1 << (dut->imm32 & 0x1F)) && dut->zero == 0) {
        printf("test15 passed!\n");
    } else {
        printf("test15 failed: SLLI 0x%08X by 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    // test16: SRLI（逻辑右移）
    dut->ReadData1 = 0x80000000;
    dut->imm32 = 0x00000004;         // 移位量
    dut->funct3 = (INST_SRLI);      // funct3=5 (101b)
    dut->funct7 = 0x00;                  // 区分SRAI
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == ((uint32_t)dut->ReadData1 >> (dut->imm32 & 0x1F)) && dut->zero == 0) {
        printf("test16 passed!\n");
    } else {
        printf("test16 failed: SRLI 0x%08X by 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    // test17: SRAI（算术右移）
    dut->ReadData1 = 0x80000000;
    dut->imm32 = 0x00000004;         // 移位量
    dut->funct3 = (INST_SRAI);      // funct3=5 (101b)
    dut->funct7 = 0x20;                  // 设置高位区分SRLI[7,12](@ref)
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == ((int32_t)dut->ReadData1 >> (dut->imm32 & 0x1F)) && dut->zero == 0) {
        printf("test17 passed!\n");
    } else {
        printf("test17 failed: SRAI 0x%08X by 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    // test18: SLTUI（无符号比较）
    dut->ReadData1 = 0xFFFFFFFF;         // 无符号4294967295
    dut->imm32 = 0x00000001;         // 立即数1
    dut->funct3 = (INST_SLTUI);     // funct3=3 (011b)
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == 0x0 && dut->zero == 1) { // 4294967295 > 1
        printf("test18 passed!\n");
    } else {
        printf("test18 failed: SLTUI 0x%08X vs 0x%08X: Result=0x%08X, zero=%d\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
    }

    /*
        TODO:
            1. 算术右移需要修复
            2. 完成剩余命令的测试
            3. 将所有zero的赋值改为按照结果是否为0赋值
    */
//-------------------------------------------------------------
// B-type Test
//-------------------------------------------------------------
    printf("\n=== B-type Test ===\n\n");
    // test19: BEQ
    dut->ReadData1 = 0x0000000A;
    dut->ReadData2 = 0x0000000A;
    dut->ALUOp = ALUOP_B;
    dut->funct3 = (INST_BEQ);
    dut->ALUSrc = 0;
    dut->eval();
    tfp->dump(main_time++);
    ans = dut->ReadData1 - dut->ReadData2;
    ans_zero = ans == 0;
    if (dut->ALUResult == ans && dut->zero == ans_zero) {
        printf("test19 passed!\n");
    } else {
        printf("test19 failed: BEQ 0x%08X vs 0x%08X, Result=0x%08X zero=0x%08X\n", 
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
        printf("\tans=0x%08X\n", ans);
    }

    // test20: BNE
    dut->ReadData1 = 0xDEADBEEF;
    dut->ReadData2 = 0xCAFEBABE;
    dut->funct3 = (INST_BNE);
    dut->eval();
    tfp->dump(main_time++);
    ans = dut->ReadData1 - dut->ReadData2;
    ans_zero = ans != 0;
    if (dut->ALUResult == ans && dut->zero == ans_zero) {
        printf("test20 passed!\n");
    } else {
        printf("test20 failed: BNE 0x%08X vs 0x%08X, Result=0x%08X zero=0x%08X\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
        printf("\tans=0x%08X\n", ans);
    }

    // test21: BLT
    dut->ReadData1 = 0xFFFFFFFE;
    dut->ReadData2 = 0x00000001;
    dut->funct3 = (INST_BLT);
    dut->eval();
    tfp->dump(main_time++);
    ans = dut->ReadData1 - dut->ReadData2;
    ans_zero = ans < 0;
    if (dut->ALUResult == ans && dut->zero == ans_zero) {
        printf("test21 passed!\n");
    } else {
        printf("test21 failed: BLT 0x%08X vs 0x%08X, Result=0x%08X zero=0x%08X\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
        printf("\tans=0x%08X\n", ans);
    }

    // test22: BGEU
    dut->ReadData1 = 0xFFFFFFFF;
    dut->ReadData2 = 0x00000001;
    dut->funct3 = (INST_BGEU);
    dut->eval();
    tfp->dump(main_time++);
    ans = (uint32_t)dut->ReadData1 - (uint32_t)dut->ReadData2;
    ans_zero = (uint32_t)ans >= 0;
    if (dut->ALUResult == ans && dut->zero == ans_zero) {
        printf("test22 passed!\n");
    } else {
        printf("test22 failed: BGEU 0x%08X vs 0x%08X, Result=0x%08X zero=0x%08X\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
        printf("\tans=0x%08X\n", ans);
    }

    // test23: BLTU
    dut->ReadData1 = 0x00000001;
    dut->ReadData2 = 0xF0000000;
    dut->funct3 = (INST_BLTU);
    dut->eval();
    tfp->dump(main_time++);
    ans = (uint32_t)dut->ReadData1 - (uint32_t)dut->ReadData2;
    ans_zero = (uint32_t)ans < 0;
    if (dut->ALUResult == ans && dut->zero == ans_zero) {
        printf("test23 passed!\n");
    } else {
        printf("test23 failed: BLTU 0x%08X vs 0x%08X, Result=0x%08X zero=0x%08X\n",
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
        printf("\tans=0x%08X\n", ans);
    }


//-------------------------------------------------------------
// Load-Store Test
//-------------------------------------------------------------
    printf("\n=== Load-Store Test ===\n\n");

    // test24: load
    dut->ReadData1 = 0xFEDCBA87;
    dut->imm32 = 0x00000324;
    dut->ALUOp = ALUOP_L_S;
    dut->ALUSrc = 1;
    dut->eval();
    tfp->dump(main_time++);
    ans = dut->ReadData1 + dut->imm32;
    ans_zero = ans == 0;
    if (dut->ALUResult == ans && dut->zero == ans_zero) {
        printf("test24 passed!\n");
    } else {
        printf("test24 failed: load/store 0x%08X vs 0x%08X, Result=0x%08X zero=0x%08X\n",
            dut->ReadData1, dut->imm32, dut->ALUResult, dut->zero);
        printf("\tans=0x%08X\n", ans);
    }


    // 清理资源
    tfp->close();
    delete dut;
    return 0;
}