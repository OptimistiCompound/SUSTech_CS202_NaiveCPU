`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/27 17:07:06
// Design Name: 
// Module Name: IFetch
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


module IFetch(
    // Inputs
    input clk,
    input rst,
    input [31:0] imm32,
    input Branch,

    // Outputs
    output [31:0] inst
    );
reg [31:0] PC;
wire [31:0] next_PC = (rst==0) ? 0 : (Branch) ? PC + imm32 : PC + 32'h4;
always @(negedge clk or negedge rst) begin
    if (~rst)
        PC <= 0;
    else
        PC <= next_PC;
end

prgrom urom (
    .clka(clk),
    .addra(PC[15:2]),
    .douta(inst)
);

endmodule
