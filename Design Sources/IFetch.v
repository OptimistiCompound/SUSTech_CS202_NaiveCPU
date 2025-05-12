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
    input [31:0] ALUResult,

    input zero,
    input Branch,
    input nBranch,
    input Jump,
    input Branch_lt,
    input Branch_ge,

    // Outputs
    output [31:0] inst
    );
reg [31:0] PC;
always @(negedge clk or negedge rst) begin
    if (~rst)
        PC <= 0;
    else if (Branch && zero || Jump || nBranch && !zero || Branch_lt && ALUResult < 0 || Branch_ge && ALUResult >= 0)
        PC <= PC + imm32;
    else begin
        PC <= PC + 32'h4;
    end
end

prgrom urom (
    .clka(clk),
    .addra(PC[15:2]),
    .douta(inst)
);

endmodule
