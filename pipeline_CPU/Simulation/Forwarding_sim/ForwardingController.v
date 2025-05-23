`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 08:55:38
// Design Name: 
// Module Name: ForwardingController
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// 关于简写：
//    EX_*: 即表示ID_EX寄存器组中输出的EX_*
//    MEM_*: 即表示EX_MEM寄存器组中输出的MEM_*
//    WB_*: 即表示EX_MEM寄存器组中输出的WB_*
module ForwardingController(
    // Inputs
    input MEM_RegWrite,
    input WB_RegWrite,
    input [4:0] EX_rs1_addr,
    input [4:0] EX_rs2_addr,
    input [4:0] MEM_rs2_addr,
    input [4:0] MEM_rd_addr,
    input [4:0] WB_rd_addr,

    input [31:0] EX_rs1_v,
    input [31:0] EX_rs2_v,
    input [31:0] MEM_ALUResult,
    input [31:0] MEM_rs2_v,
    input [31:0] WB_mdata,

    // Outputs
    output reg [31:0] true_ReadData1, // mux result to ALU
    output reg [31:0] true_ReadData2, // mux result to ALU
    output reg [31:0] true_m_wdata    // mux result to dMem
    );

// Warning：
//    EX/EX的赋值语句一定要在MEM/EX之后，
//    因为如果两者条件同时满足，应该选择EX/EX forwarding
always @(*) begin
    true_ReadData1 = EX_rs1_v;
    true_ReadData2 = EX_rs2_v;
    true_m_wdata   = MEM_rs2_v;

    if (WB_RegWrite  && WB_rd_addr  != 0 && (WB_rd_addr  == EX_rs1_addr) ) // MEM/EX forwarding to rs1
        true_ReadData1 = WB_mdata;
    if (WB_RegWrite  && WB_rd_addr  != 0 && (WB_rd_addr  == EX_rs2_addr) ) // MEM/EX forwarding to rs2
        true_ReadData2 = WB_mdata;
    if (MEM_RegWrite && MEM_rd_addr != 0 && (MEM_rd_addr == EX_rs1_addr) ) // EX/EX forwarding to rs1
        true_ReadData1 = MEM_ALUResult;
    if (MEM_RegWrite && MEM_rd_addr != 0 && (MEM_rd_addr == EX_rs2_addr) ) // EX/EX forwarding to rs2
        true_ReadData2 = MEM_ALUResult;
    if (WB_RegWrite  && WB_rd_addr  != 0 && (WB_rd_addr  == MEM_rs2_addr) )// MEM/MEM forwading to rs2
        true_m_wdata = WB_mdata;
end

endmodule
