// sim_main.cpp
#include "VForwardingController.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "../../Header_Files/riscv_macros.h"

vluint64_t main_time = 0;

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VForwardingController* dut = new VForwardingController;

    // 创建模块实例和波形对象
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 5); // 跟踪5层信号
    tfp->open("forwarding_wave.vcd");

    // Initialization
    dut->MEM_RegWrite   = 0;
    dut->WB_RegWrite    = 0;
    dut->EX_rs1_addr    = 0;
    dut->EX_rs2_addr    = 0;
    dut->MEM_rs2_addr   = 0;
    dut->MEM_rd_addr    = 0;
    dut->WB_rd_addr     = 0;
    dut->EX_rs1_v       = 0;
    dut->EX_rs2_v       = 0;
    dut->MEM_ALUResult  = 0;
    dut->MEM_rs2_v      = 0;
    dut->WB_mdata       = 0;
    dut->eval();
    tfp->dump(main_time++);

//-------------------------------------------------------------
// EX/EX forwarding Test
//-------------------------------------------------------------
    printf("\n=== EX/EX forwarding Test ===\n\n");

    // test1: EX_MEM.rd_adddr = ID_EX.rs1_addr
    dut->MEM_RegWrite   = 1;
    dut->WB_RegWrite    = 0;
    dut->EX_rs1_addr    = 3;
    dut->EX_rs2_addr    = 5;
    dut->MEM_rs2_addr   = 0;
    dut->MEM_rd_addr    = 3;
    dut->WB_rd_addr     = 0;
    dut->EX_rs1_v       = 0x00011111;
    dut->EX_rs2_v       = 0x00022222;
    dut->MEM_ALUResult  = 0x01010101;
    dut->MEM_rs2_v      = 0;
    dut->WB_mdata       = 0x00000000;
    dut->eval();
    tfp->dump(main_time++);
    if (dut->true_ReadData1 == dut->MEM_ALUResult && dut->true_ReadData2 == dut->EX_rs2_v && dut->true_m_wdata == dut->MEM_rs2_v) {
        printf("test1 passed!\n");
    } else {
        printf("test1 failed: true_ReadData1=0x%08X  true_ReadData2=0x%08X  true_m_wdata=0x%08X  \n", 
            dut->true_ReadData1, dut->true_ReadData2, dut->true_m_wdata);
    }

    // test2: EX_MEM.rd_adddr = ID_EX.rs2_addr
    dut->MEM_RegWrite   = 1;
    dut->WB_RegWrite    = 0;
    dut->EX_rs1_addr    = 3;
    dut->EX_rs2_addr    = 5;
    dut->MEM_rs2_addr   = 0;
    dut->MEM_rd_addr    = 5;
    dut->WB_rd_addr     = 0;
    dut->EX_rs1_v       = 0x00011111;
    dut->EX_rs2_v       = 0x00022222;
    dut->MEM_ALUResult  = 0x01010101;
    dut->MEM_rs2_v      = 0;
    dut->WB_mdata       = 0x00000000;
    dut->eval();
    tfp->dump(main_time++);
    if (dut->true_ReadData1 == dut->EX_rs1_v && dut->true_ReadData2 == dut->MEM_ALUResult && dut->true_m_wdata == dut->MEM_rs2_v) {
        printf("test2 passed!\n");
    } else {
        printf("test2 failed: true_ReadData1=0x%08X  true_ReadData2=0x%08X  true_m_wdata=0x%08X  \n", 
            dut->true_ReadData1, dut->true_ReadData2, dut->true_m_wdata);
    }

    // test3: EX_MEM.rd_adddr = ID_EX.rs1_addr && MEM_WB.rd_addr = ID_EX.rs1_addr
    dut->MEM_RegWrite   = 1;
    dut->WB_RegWrite    = 1;
    dut->EX_rs1_addr    = 3;
    dut->EX_rs2_addr    = 5;
    dut->MEM_rs2_addr   = 0;
    dut->MEM_rd_addr    = 3;
    dut->WB_rd_addr     = 3;
    dut->EX_rs1_v       = 0x00011111;
    dut->EX_rs2_v       = 0x00022222;
    dut->MEM_ALUResult  = 0x01010101;
    dut->MEM_rs2_v      = 0;
    dut->WB_mdata       = 0x00000000;
    dut->eval();
    tfp->dump(main_time++);
    if (dut->true_ReadData1 == dut->MEM_ALUResult && dut->true_ReadData2 == dut->EX_rs2_v && dut->true_m_wdata == dut->MEM_rs2_v) {
        printf("test3 passed!\n");
    } else {
        printf("test3 failed: true_ReadData1=0x%08X  true_ReadData2=0x%08X  true_m_wdata=0x%08X  \n", 
            dut->true_ReadData1, dut->true_ReadData2, dut->true_m_wdata);
    }

//-------------------------------------------------------------
// MEM/EX forwarding Test
//-------------------------------------------------------------
    printf("\n=== MEM/EX forwarding Test ===\n\n");

    // test4: MEM_WB.rd_adddr = ID_EX.rs1_addr
    dut->MEM_RegWrite   = 0;
    dut->WB_RegWrite    = 1;
    dut->EX_rs1_addr    = 3;
    dut->EX_rs2_addr    = 5;
    dut->MEM_rs2_addr   = 0;
    dut->MEM_rd_addr    = 0;
    dut->WB_rd_addr     = 3;
    dut->EX_rs1_v       = 0x00011111;
    dut->EX_rs2_v       = 0x00022222;
    dut->MEM_ALUResult  = 0x01010101;
    dut->MEM_rs2_v      = 0;
    dut->WB_mdata       = 0x00000000;
    dut->eval();
    tfp->dump(main_time++);
    if (dut->true_ReadData1 == dut->WB_mdata && dut->true_ReadData2 == dut->EX_rs2_v && dut->true_m_wdata == dut->MEM_rs2_v) {
        printf("test4 passed!\n");
    } else {
        printf("test4 failed: true_ReadData1=0x%08X  true_ReadData2=0x%08X  true_m_wdata=0x%08X  \n", 
            dut->true_ReadData1, dut->true_ReadData2, dut->true_m_wdata);
    }

    // test5: MEM_WB.rd_adddr = ID_EX.rs2_addr
    dut->MEM_RegWrite   = 0;
    dut->WB_RegWrite    = 1;
    dut->EX_rs1_addr    = 3;
    dut->EX_rs2_addr    = 5;
    dut->MEM_rs2_addr   = 0;
    dut->MEM_rd_addr    = 0;
    dut->WB_rd_addr     = 5;
    dut->EX_rs1_v       = 0x00011111;
    dut->EX_rs2_v       = 0x00022222;
    dut->MEM_ALUResult  = 0x01010101;
    dut->MEM_rs2_v      = 0;
    dut->WB_mdata       = 0x00000000;
    dut->eval();
    tfp->dump(main_time++);
    if (dut->true_ReadData1 == dut->EX_rs1_v && dut->true_ReadData2 == dut->WB_mdata && dut->true_m_wdata == dut->MEM_rs2_v) {
        printf("test5 passed!\n");
    } else {
        printf("test5 failed: true_ReadData1=0x%08X  true_ReadData2=0x%08X  true_m_wdata=0x%08X  \n", 
            dut->true_ReadData1, dut->true_ReadData2, dut->true_m_wdata);
    }

//-------------------------------------------------------------
// MEM/MEM forwarding Test
//-------------------------------------------------------------
    printf("\n=== MEM/MEM forwarding Test ===\n\n");

    // test5: MEM_WB.rd_adddr = ID_EX.rs1_addr
    dut->MEM_RegWrite   = 0;
    dut->WB_RegWrite    = 1;
    dut->EX_rs1_addr    = 0;
    dut->EX_rs2_addr    = 0;
    dut->MEM_rs2_addr   = 3;
    dut->MEM_rd_addr    = 0;
    dut->WB_rd_addr     = 3;
    dut->EX_rs1_v       = 0x00011111;
    dut->EX_rs2_v       = 0x00022222;
    dut->MEM_ALUResult  = 0x01010101;
    dut->MEM_rs2_v      = 0;
    dut->WB_mdata       = 0x00000000;
    dut->eval();
    tfp->dump(main_time++);
    if (dut->true_ReadData1 == dut->EX_rs1_v && dut->true_ReadData2 == dut->EX_rs2_v && dut->true_m_wdata == dut->WB_mdata) {
        printf("test6 passed!\n");
    } else {
        printf("test6 failed: true_ReadData1=0x%08X  true_ReadData2=0x%08X  true_m_wdata=0x%08X  \n", 
            dut->true_ReadData1, dut->true_ReadData2, dut->true_m_wdata);
    }

    // 清理资源
    tfp->close();
    delete dut;
    return 0;
}