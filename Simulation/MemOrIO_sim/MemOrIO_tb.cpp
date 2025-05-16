#include "VMemOrIO.h"          // Verilator 生成的头文件
#include "verilated.h"         // Verilator 核心库
#include "verilated_vcd_c.h"   // 波形跟踪支持[7](@ref)
#include "../../Header_Files/io_header.h"

vluint64_t main_time = 0;      // 仿真时间戳
VerilatedVcdC* tfp;

void tick(VMemOrIO* dut) {
    dut->eval();
    tfp->dump(main_time++);
}

int main(int argc, char** argv) {
    // 初始化 Verilator 环境
    Verilated::commandArgs(argc, argv);
    VMemOrIO* dut = new VMemOrIO;
    
    // 初始化波形跟踪
    Verilated::traceEverOn(true);

    tfp = new VerilatedVcdC;
    dut->trace(tfp, 5);
    tfp->open("waveform.vcd");

    // 复位初始化
    dut->mRead = 0;
    dut->mWrite = 0;
    dut->ioRead = 0;
    dut->ioWrite = 0;

    dut->conf_btn_out = 0;
    dut->addr_in = 0;
    dut->m_rdata = 0;
    dut->switch_data = 0;
    dut->key_data = 0;
    dut->r_rdata = 0;
    tick(dut);

//-------------------------------------------------------------
// Read Test
//-------------------------------------------------------------
    printf("\n=== Read Test ===\n\n");
    // 内存读测试
    dut->mRead = 1;
    dut->mWrite = 0;
    dut->ioRead = 0;
    dut->ioWrite = 0;
    dut->addr_in = 0x00001000;
    dut->m_rdata = 0xDEADBEEF;
    tick(dut);
    if (dut->r_wdata != 0xDEADBEEF) {
        printf("Memory read failed! Got r_wdata=0x%08X \n",
             dut->r_wdata);
    } else {
        printf("test1 passed!\n");
    }

    // Switch 读测试
    dut->mRead = 0;
    dut->mWrite = 0;
    dut->ioRead = 1;
    dut->ioWrite = 0;
    dut->addr_in = SWITCH_BASE_ADDR;
    dut->switch_data = 0xABC;
    tick(dut);
    if (dut->r_wdata != dut->switch_data) {
        printf("Switch read failed! r_wdata=0x%08X \n", 
              dut->r_wdata);
    } else {
        printf("test2 passed!\n");
    }

    // Keyboard 读测试
    dut->mRead = 0;
    dut->mWrite = 0;
    dut->ioRead = 1;
    dut->ioWrite = 0;
    dut->addr_in = KEY_BASE_ADDR;
    dut->key_data = 0x5;
    tick(dut);
    if (dut->r_wdata != dut->key_data) {
        printf("Keyboard read failed! r_wdata=0x%08X \n", 
              dut->r_wdata);
        printf("key_data=0x%08X \n", dut->key_data);
    } else {
        printf("test3 passed!\n");
    }

    // Btn 读测试
    dut->mRead = 0;
    dut->mWrite = 0;
    dut->ioRead = 1;
    dut->ioWrite = 0;
    dut->addr_in = Btn_ADDR;
    dut->conf_btn_out = 0x1;
    tick(dut);
    if (dut->r_wdata != dut->conf_btn_out) {
        printf("Keyboard read failed! r_wdata=0x%08X \n", 
              dut->r_wdata);
    } else {
        printf("test4 passed!\n");
    }

//-------------------------------------------------------------
// Write Test
//-------------------------------------------------------------
    printf("\n=== Write Test ===\n\n");
    // 内存写测试
    dut->mRead = 0;
    dut->mWrite = 1;
    dut->ioRead = 0;
    dut->ioWrite = 0;
    dut->conf_btn_out = 0;
    dut->addr_in = 0x00001000;
    dut->r_rdata = 0xCAFEBABE;
    tick(dut);
    if (dut->write_data != dut->r_rdata) {
        printf("Memory write failed! Got write_data=0x%08X\n",
             dut->write_data);
    } else {
        printf("test5 passed!\n");
    }

    // LED写测试
    dut->mRead = 0;
    dut->mWrite = 0;
    dut->ioRead = 0;
    dut->ioWrite = 1;
    dut->conf_btn_out = 0;
    dut->addr_in = LED_BASE_ADDR;
    dut->r_rdata = 0xCAFEBABE;
    tick(dut);
    if (dut->write_data != dut->r_rdata || !dut->LEDCtrl) {
        printf("LED write failed! Got write_data=0x%08X LEDCtrl=0x%08X \n",
             dut->write_data, dut->LEDCtrl);
    } else {
        printf("test6 passed!\n");
    }

    // Seg写测试
    dut->mRead = 0;
    dut->mWrite = 0;
    dut->ioRead = 0;
    dut->ioWrite = 1;
    dut->conf_btn_out = 0;
    dut->addr_in = SEG_BASE_ADDR;
    dut->r_rdata = 0xCAFEBABE;
    tick(dut);
    if (dut->write_data != dut->r_rdata || !dut->SegCtrl) {
        printf("Seg write failed! Got write_data=0x%08X SegCtrl=0x%08X \n",
             dut->write_data, dut->SegCtrl);
    } else {
        printf("test7 passed!\n");
    }

    // 清理资源
    tfp->close();
    delete dut;
    delete tfp;
    printf("\nSimulation completed!\n");
    return 0;
}