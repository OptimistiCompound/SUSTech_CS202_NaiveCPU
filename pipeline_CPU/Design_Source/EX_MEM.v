`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 17:27:07
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    // Inputs
    input clk, rstn, Flush,
    input        EX_Branch,
    input        EX_zero,
    input        EX_Jump,
    input        EX_Jalr,
    input        EX_MemRead,
    input        EX_MemWrite,
    input        EX_MemtoReg,
    input        EX_RegWrite,
    input        EX_ioRead,
    input        EX_ioWrite,
    input [4:0]  EX_rs2_addr,
    input [4:0]  EX_rd_addr,
    input [31:0] EX_ALUResult,
    input [31:0] EX_rs2_v,
    input [31:0] EX_imm32,

    input [31:0] EX_addr_in,
    input [31:0] EX_m_rdata,
    input [31:0] EX_r_rdata,

    // Outputs
    output reg        MEM_Branch,
    output reg        MEM_zero,
    output reg        MEM_Jump,
    output reg        MEM_Jalr,
    output reg        MEM_MemRead,
    output reg        MEM_MemWrite,
    output reg        MEM_MemtoReg,
    output reg        MEM_RegWrite,
    output reg        MEM_ioRead,
    output reg        MEM_ioWrite,
    output reg [4:0]  MEM_rs2_addr,
    output reg [4:0]  MEM_rd_addr,
    output reg [31:0] MEM_ALUResult,
    output reg [31:0] MEM_rs2_v,
    output reg [31:0] MEM_imm32,

    output reg [31:0] MEM_addr_in,
    output reg [31:0] MEM_m_rdata,
    output reg [31:0] MEM_r_rdata
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../../Header_Files/riscv_defs.v"
always @(posedge clk) begin
    if (~rstn || Flush) begin
        MEM_Branch           = 0;
        MEM_zero             = 0;
        MEM_Jump             = 0;
        MEM_Jalr             = 0;
        MEM_MemRead          = 0;
        MEM_MemWrite         = 0;
        MEM_MemtoReg         = 0;
        MEM_RegWrite         = 0;
        MEM_ioRead           = 0;
        MEM_ioWrite          = 0;
        MEM_rs2_addr         = 0;
        MEM_rd_addr          = 0;
        MEM_ALUResult        = 0;
        MEM_rs2_v            = 0;
        MEM_imm32            = 0;

        MEM_addr_in          = 0;
        MEM_m_rdata          = 0;
        MEM_r_rdata          = 0;
    end
    else begin
        MEM_Branch           = EX_Branch;
        MEM_zero             = EX_zero;
        MEM_Jump             = EX_Jump;
        MEM_Jalr             = EX_Jalr;
        MEM_MemRead         <= EX_MemRead;
        MEM_MemWrite        <= EX_MemWrite;
        MEM_MemtoReg        <= EX_MemtoReg;
        MEM_RegWrite        <= EX_RegWrite;
        MEM_ioRead          <= EX_ioRead;
        MEM_ioWrite         <= EX_ioWrite;
        MEM_rs2_addr        <= EX_rs2_addr;
        MEM_rd_addr         <= EX_rd_addr;
        MEM_ALUResult       <= EX_ALUResult;
        MEM_rs2_v           <= EX_rs2_v;
        MEM_imm32           <= EX_imm32;

        MEM_addr_in         <= EX_addr_in;
        MEM_m_rdata         <= EX_m_rdata;
        MEM_r_rdata         <= EX_r_rdata;
    end
end

endmodule
