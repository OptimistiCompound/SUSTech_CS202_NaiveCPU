`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 16:55:25
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    // Inputs
    input clk, rstn, Pause, Flush,
    input [31:0] IF_pc4_i,
    input [31:0] IF_inst,

    // Outputs
    output reg [31:0] ID_pc4_i,
    output reg [31:0] ID_inst
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../Header_Files/riscv_defs.v"

always @(posedge clk, negedge rstn) begin
    if(~rstn || Flush) begin
        ID_pc4_i = 32'd0;
        ID_inst  = {25'b0, `OPCODE_I};
    end else if(Pause) begin
        // 空操作 nop
        // 阻止寄存器值改变
    end else begin
        ID_pc4_i <= IF_pc4_i;
        ID_inst  <= IF_inst;
    end
end
endmodule
