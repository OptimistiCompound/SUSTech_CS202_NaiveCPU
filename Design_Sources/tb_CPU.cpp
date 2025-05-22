#include "VCPU.h"          // Verilator生成的模块头文件
#include <verilated.h>
#include <verilated_vcd_c.h> // 波形跟踪
#include "../Header_Files/riscv_macros.h"

vluint64_t main_time = 0;  // 仿真时间戳

VCPU* dut;
VerilatedVcdC* tfp;

void clk_tick() {
    for (int i = 0; i < 20; i++) {
        dut->clk = dut->clk ^ 1;
        dut->eval();
        tfp->dump(main_time++);
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    dut = new VCPU;  // 实例化ALU模块

    // 初始化波形跟踪（可选）
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    dut->trace(tfp, 5); // 跟踪5层信号
    tfp->open("CPU_waveform.vcd");

    // initialization
    dut->clk            = 0;
    dut->rstn           = 0;
    dut->conf_btn       = 0;
    dut->switch_data    = 0;
    dut->ps2_clk        = 0;
    dut->ps2_data       = 0;
    dut->start_pg       = 1;
    dut->rx             = 0;
    dut->base           = 0;
    dut->eval();
    tfp->dump(main_time++);

    printf("\n=== CPU Test ===\n\n");

    dut->clk            = 1;
    dut->rstn           = 1;
    dut->conf_btn       = 1;
    dut->switch_data    = 0x000011110000 + 0x0001;
    dut->eval();
    tfp->dump(main_time++);


    dut->clk            = 0;
    dut->conf_btn       = 0;
    dut->switch_data    = 0x000011110000 + 0x0001;
    dut->eval();
    tfp->dump(main_time++);











    if (dut->ALUResult == (dut->ReadData1 + dut->ReadData2) && dut->zero == 0) {
        printf("test1 passed!\n");
    } else {
        printf("test1 failed: ADD 0x%08X 0x%08X: Result=0x%08X, zero=%d\n", 
            dut->ReadData1, dut->ReadData2, dut->ALUResult, dut->zero);
    }







    // 清理资源
    tfp->close();
    delete dut;
    return 0;
}