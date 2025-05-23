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

    input        EX_conf_btn_out,
    input [31:0] EX_addr_in,
    input [31:0] EX_m_rdata,
    input [11:0] EX_switch_data,
    input [3:0]  EX_key_data,
    input [31:0] EX_r_rdata,

    // Outputs
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

    output reg        MEM_conf_btn_out,
    output reg [31:0] MEM_addr_in,
    output reg [31:0] MEM_m_rdata,
    output reg [11:0] MEM_switch_data,
    output reg [3:0]  MEM_key_data,
    output reg [31:0] MEM_r_rdata
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../Header_Files/riscv_defs.v"
always @(posedge clk) begin
    if (~rstn || Flush) begin
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

        MEM_conf_btn_out     = 0;
        MEM_addr_in          = 0;
        MEM_m_rdata          = 0;
        MEM_switch_data      = 0;
        MEM_key_data         = 0;
        MEM_r_rdata          = 0;
    end
    else begin
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

        MEM_conf_btn_out    <= EX_conf_btn_out;
        MEM_addr_in         <= EX_addr_in;
        MEM_m_rdata         <= EX_m_rdata;
        MEM_switch_data     <= EX_switch_data;
        MEM_key_data        <= EX_key_data;
        MEM_r_rdata         <= EX_r_rdata;
    end
end

endmodule
