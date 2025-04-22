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

wire [6:0] opcode;
wire sign;
wire [4:0] raddr1;
wire [4:0] raddr2;
wire [4:0] waddr;

// wire Branch;
// wire MemRead;
// wire MemtoReg;
// wire [1:0] ALUOp;
// wire MemWrite;
// wire ALUSrc;
// wire regWrite;

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

assign sign = inst[31];
assign waddr = inst[11:7];
assign raddr1 = inst[19:15];
assign raddr2 = inst[24:20];

endmodule
