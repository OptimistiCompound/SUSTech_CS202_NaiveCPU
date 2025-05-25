`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 08:56:07
// Design Name: 
// Module Name: HazardDetector
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


// Read registers after load => Control Hazard
// EX/MEM.rd = ID/EX.rs1 or EX/MEM.rd = ID/EX.rs2
// 发生在上一条是load指令的 EX stage 、下一条指令 ID stage。因为如果下一条指令进入EX了就来不及了
// 所以说stall也只会插入在 ID 和 EX 之间，也只会影响到IF_ID以及ID_EX
module HazardDetector(
    // Inputs
    input       EX_memRead,
    input [4:0] ID_rs1_addr,
    input [4:0] ID_rs2_addr,
    input [4:0] EX_rd_addr,

    // Outputs
    output reg Pause
    );
    always @(*) begin
        if ( (EX_memRead) && (EX_rd_addr == ID_rs1_addr || EX_rd_addr == ID_rs2_addr) )
            Pause = 1'b1;
        else 
            Pause = 1'b0;
    end
endmodule
