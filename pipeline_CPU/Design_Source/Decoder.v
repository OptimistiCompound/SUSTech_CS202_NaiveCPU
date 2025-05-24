`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/22 00:45:44
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    // Inputs
    input clk,
    input rstn,
    input [4:0] WB_rd_addr,    // WB_ID
    input [31:0] ALUResult, // WB_ID
    input [31:0] MemData,   // WB_ID
    input [31:0] pc4_i,     // IF_ID
    input regWrite,         // WB_ID
    input MemtoReg,         // WB_ID
    input [31:0] inst,      // IF_ID

    // Outputs
    output [31:0] rdata1,
    output [31:0] rdata2,
    output [31:0] imm32,
    output [2:0]  funct3,
    output [6:0]  funct7,
    output [4:0]  rs1_addr,
    output [4:0]  rs2_addr,
    output [4:0]  rd_addr
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../../Header_Files/riscv_defs.v"

assign opcode = inst[6:0];
assign rs1_addr = inst[19:15];
assign rs2_addr = inst[24:20];
assign rd_addr = inst[11:7];
assign funct3 = inst[14:12];
assign funct7 = inst[31:25];

//-------------------------------------------------------------
// Write data selection
//-------------------------------------------------------------
reg [31:0] wdata;
always @(*) begin
    if (opcode == `OPCODE_JAL || opcode == `OPCODE_JALR)
        wdata = pc4_i;
    else if (opcode == `OPCODE_LUI)
        wdata = imm32;
    else if (opcode == `OPCODE_AUIPC)
        wdata = pc4_i + imm32;
    else if (MemtoReg == 1)
        wdata = MemData;
    else 
        wdata = ALUResult;
end

//-------------------------------------------------------------
// Submodules
//-------------------------------------------------------------
RegisterFile uRegisterFile(
    .clk(clk),
    .rstn(rstn),
    .raddr1(rs1_addr),
    .raddr2(rs2_addr),
    .waddr(WB_rd_addr),
    .wdata(wdata),
    .regWrite(regWrite),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

ImmGen uImmGen(
    .inst(inst),
    .imm32(imm32)
);


endmodule
