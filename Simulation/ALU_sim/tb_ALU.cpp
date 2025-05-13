#include "VALU.h"          // Verilator生成的模块头文件
#include <verilated.h>
#include <verilated_vcd_c.h> // 波形跟踪
#include "/media/zhongyong/课程/Computer_Orgnization_proj/SUSTech_CS202_NaiveCPU/Header_Files/riscv_macros.h"

vluint64_t main_time = 0;  // 仿真时间戳

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VALU* dut = new VALU;  // 实例化ALU模块

    // 初始化波形跟踪（可选）
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 5); // 跟踪5层信号
    tfp->open("waveform.vcd");

    // test1: ADD
    dut->ReadData1 = 0x00000001;
    dut->ReadData2 = 0x00000002;
    dut->ALUOp = ALUOP_R;
    dut->funct3 = (INST_ADD >> 8); // 需要右移来去掉funct7
    dut->funct7 = (INST_ADD & 0x0FF); // 需要去掉funct3
    dut->ALUSrc = 0; // from reg
    dut->eval();
    tfp->dump(main_time++);
    if (dut->ALUResult == 0x00000003 && zero = 0) {
        printf("test1 passed!")
    } else {
        printf("test1 failed: ADD 0x%08X 0x%08X: Result=0x%08X, zero=%d\n", dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }

    // // test_case_2: 立即数运算（ALUSrc=1）
    // dut->imm32 = 0xFFFF0000;
    // dut->ALUSrc = 1;        // 选择立即数
    // dut->eval();
    // tfp->dump(main_time++);
    // printf("IMM Test: Result=0x%08X\n", dut->ALUResult);

    // // test_case_3: 逻辑运算（如AND）
    // dut->ALUOp = 0b10;      // 假设10表示逻辑运算
    // dut->funct3 = 0b111;    // AND操作
    // dut->ReadData1 = 0xF0F0F0F0;
    // dut->ReadData2 = 0x0F0F0F0F;
    // dut->eval();
    // tfp->dump(main_time++);
    // printf("AND Test: Result=0x%08X\n", dut->ALUResult);

    // 清理资源
    tfp->close();
    delete dut;
    return 0;
}