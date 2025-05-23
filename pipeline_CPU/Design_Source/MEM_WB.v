`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 17:27:27
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    // Inputs
    input clk, rstn,
    input        MEM_MemtoReg,
    input        MEM_RegWrite,
    input        MEM_ioWrite,

    input [4:0]  MEM_rd_addr
    input [31:0] MEM_ALUResult,
    input [31:0] MEM_MemData,

    // Outputs
    output reg        WB_MemtoReg,
    output reg        WB_RegWrite,
    output reg        WB_ioWrite,

    output reg [4:0]  WB_rd_addr
    output reg [31:0] WB_ALUResult,
    output reg [31:0] WB_MemData,
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../Header_Files/riscv_defs.v"
always @(posedge clk, negedge rstn) begin
    if(~rstn) begin
        
        WB_MemtoReg     = 0;
        WB_RegWrite     = 0;
        WB_ioWrite      = 0;

        WB_rd_addr      = 0;
        WB_ALUResult    = 0;
        WB_MemData      = 0;
    end
    else begin
        
        WB_MemtoReg     <= MEM_MemtoReg;
        WB_RegWrite     <= MEM_RegWrite;
        WB_ioWrite      <= MEM_ioWrite;

        WB_rd_addr      <= MEM_rd_addr;
        WB_ALUResult    <= MEM_ALUResult;
        WB_MemData      <= MEM_MemData;
    end
end
endmodule
