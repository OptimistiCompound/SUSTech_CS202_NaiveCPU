`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 02:04:30
// Design Name: 
// Module Name: display_cache
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


module display_cache(
    input [31:0] write_data,
    input init,
    input rstn,
    output reg [31:0]data
    );
    always@(rstn or ioWrite) begin
        if(!rstn) data = 0;
        else if(init)begin data = write_data; end
        else data = 0;
    end
endmodule
