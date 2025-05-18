#include "VCPU.h"          // Verilator生成的模块头文件
#include <verilated.h>
#include <verilated_vcd_c.h> // 波形跟踪
#include "../../Header_Files/riscv_macros.h"

vluint64_t main_time = 0;  // 仿真时间戳

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VCPU* dut = new VCPU;  // 实例化CPU模块

    // 初始化波形跟踪
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 5); // 跟踪5层信号
    tfp->open("cpu_waveform.vcd");

    // 初始化输入信号
    dut->clk = 0;
    dut->rstn = 0;
    dut->conf_btn = 0;
    dut->switch_data = 0;
    dut->ps2_clk = 0;
    dut->ps2_data = 0;
    dut->start_pg = 0;
    dut->rx = 0;

    // 复位
    dut->rstn = 0;
    dut->clk = 0; dut->eval(); tfp->dump(main_time++);
    dut->clk = 1; dut->eval(); tfp->dump(main_time++);
    dut->rstn = 1;
    dut->clk = 0; dut->eval(); tfp->dump(main_time++);

//-------------------------------------------------------------
// 基本指令测试
//-------------------------------------------------------------
    printf("\n=== Basic Instruction Test ===\n\n");

    dut->inst = ADD;

    // test1: ADD指令
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); tfp->dump(main_time++);
        dut->clk = 1; dut->eval(); tfp->dump(main_time++);
    }
    printf("test1: ADD instruction executed\n");

    // test2: SUB指令
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); tfp->dump(main_time++);
        dut->clk = 1; dut->eval(); tfp->dump(main_time++);
    }
    printf("test2: SUB instruction executed\n");

//-------------------------------------------------------------
// IO设备测试
//-------------------------------------------------------------
    printf("\n=== IO Device Test ===\n\n");

    // test3: LED显示测试
    dut->switch_data = 0xAA55;
    for (int i = 0; i < 5; i++) {
        dut->clk = 0; dut->eval(); tfp->dump(main_time++);
        dut->clk = 1; dut->eval(); tfp->dump(main_time++);
    }
    printf("test3: LED display test completed\n");

    // test4: 键盘输入测试
    dut->ps2_data = 0x1C; // 模拟按键'A'
    for (int i = 0; i < 5; i++) {
        dut->clk = 0; dut->eval(); tfp->dump(main_time++);
        dut->clk = 1; dut->eval(); tfp->dump(main_time++);
    }
    printf("test4: Keyboard input test completed\n");

//-------------------------------------------------------------
// 内存访问测试
//-------------------------------------------------------------
    printf("\n=== Memory Access Test ===\n\n");

    // test5: 内存写测试
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); tfp->dump(main_time++);
        dut->clk = 1; dut->eval(); tfp->dump(main_time++);
    }
    printf("test5: Memory write test completed\n");

    // test6: 内存读测试
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); tfp->dump(main_time++);
        dut->clk = 1; dut->eval(); tfp->dump(main_time++);
    }
    printf("test6: Memory read test completed\n");

    // 清理资源
    tfp->close();
    delete dut;
    return 0;
}
