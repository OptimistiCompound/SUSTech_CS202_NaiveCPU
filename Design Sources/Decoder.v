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
    input clk,
    input rstn,
    input [31:0] wdata,
    input regWrite,
    input [31:0] inst,
    output [31:0] rdata1,
    output [31:0] rdata2,
    output [31:0] imm32
    );

wire sign = inst[31];
assign opcode = inst[6:0];
parameter R = 7'b0110011,
        I = 7'b0010011,
        L = 7'b0000011,
        S = 7'b0100011,
        B = 7'b1100011,
        LUI = 7'b0110111,
        AUIPC = 7'b0010111,
        JAL = 7'b1101111,
        JALR = 7'b1100111;
wire rs1 = opcode == R || opcode == I || opcode == L || opcode == JALR ||
            opcode == S || opcode == B;
wire rs2 = opcode == R || opcode == S || opcode == B;
wire [4:0] raddr1 = (rs1) ? inst[19:15] : 0;
wire [4:0] raddr2 = (rs2) ? inst[24:20] : 0;
wire [4:0] waddr = (regWrite) ? inst[11:7] : 0;

RegisterFile uRegisterFile(
    .clk(clk),
    .rstn(rstn),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr(waddr),
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
