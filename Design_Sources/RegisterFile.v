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
    // Inputs
    input clk,
    input rstn,
    input mode,
    input conf_btn,
    input [12:0] switch_data,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,
    input [31:0] wdata,
    input regWrite,

    // Outputs
    output [31:0] rdata1,
    output [31:0] rdata2,
    output [31:0] a7_data,
    output [31:0] a0_data,
    output [31:0] reg_data
    );
reg [31:0] registers [31:0];

assign rdata1 = registers[raddr1];
assign rdata2 = registers[raddr2];
assign a7_data = registers[5'd17];
assign a0_data = registers[5'd10];
integer i;
always @(posedge clk or negedge rstn) begin
    registers[0] = 0;
    if (~rstn) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end
    else if (regWrite && waddr != 5'b0)
        registers[waddr] <= wdata;
end

always @(posedge clk or negedge rstn) begin
    if (~rstn || ~mode)
        reg_data = 32'h0;
    else if (mode) begin
        if (conf_btn) 
            reg_data = registers[switch_data[4:0]];
        else 
            reg_data <= reg_data;
    end
end

endmodule
