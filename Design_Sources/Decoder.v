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
    input [31:0] ALUResult,
    input [31:0] MemData,
    input [31:0] pc4_i,
    input regWrite,
    input MemtoReg,
    input eRead,
    input [31:0] inst,

    // Outputs
    output [31:0] rdata1,
    output [31:0] rdata2,
    output [31:0] imm32,
    output [31:0] ecall_code,
    output [31:0] ecall_a0_data
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../Header_Files/riscv_defs.v"

assign opcode = inst[6:0];
wire [4:0] raddr1 = inst[19:15];
wire [4:0] raddr2 = inst[24:20];
wire [4:0] rd_v = inst[11:7];
wire [2:0] funct3 = inst[14:12];

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
    else if (MemtoReg == 1) begin
            case (funct3)
            `INST_LB:
                wdata = {{24{MemData[7]}}, MemData[7:0]};
            `INST_LH:
                wdata = {{16{MemData[16]}}, MemData[15:0]};
            `INST_LW:
                wdata = MemData;
            `INST_LBU:
                wdata = {24'b0, MemData[7:0]};
            `INST_LHU:
                wdata = {16'b0, MemData[15:0]};
            default:
                wdata = 0;
            endcase
        end
    else
        wdata = ALUResult;
end
 
//-------------------------------------------------------------
// Submodules
//-------------------------------------------------------------
RegisterFile uRegisterFile(
    .clk(clk),
    .rstn(rstn),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr(rd_v),
    .wdata(wdata),
    .regWrite(regWrite),
    .rdata1(rdata1),
    .rdata2(rdata2),
    .a7_data(ecall_code),
    .a0_data(ecall_a0_data)
);

ImmGen uImmGen(
    .inst(inst),
    .imm32(imm32)
);


endmodule
