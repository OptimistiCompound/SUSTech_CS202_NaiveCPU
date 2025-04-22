`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/22 00:50:02
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input clk,
    input rst,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,
    input [31:0] wdata,
    input regWrite,
    output [31:0] rdata1,
    output [31:0] rdata2
    );
reg [31:0] registers [4:0];

assign rdata1 = registers[raddr1];
assign rdata2 = registers[raddr2];

always @(*) begin
    if (regWrite)
        registers[waddr] <= wdata;
end

endmodule
