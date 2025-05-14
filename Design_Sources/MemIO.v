`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/14 21:37:15
// Design Name: 
// Module Name: MemIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   memory I/O module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 需要进行的操作，选择 IO 读取、IO写入还是 Mem读取和写入
// 选择 IO 读取，相关的控制信号在 Control 控制中

module MemIO(
    input         clk,
    input  [31:0] addr,  
    input  [31:0] wdata, 
    input         MemRead, 
    input         MemWrite,
    output [31:0] rdata 
);
    reg [31:0] mem [0:1023];     // 1K x 32bit 存储空间

    // 写操作
    always @(posedge clk) begin
        if (MemWrite)
            mem[addr[11:2]] <= wdata; // 以字为单位寻址
    end

    // 读操作
    assign rdata = (MemRead) ? mem[addr[11:2]] : 32'b0;

endmodule