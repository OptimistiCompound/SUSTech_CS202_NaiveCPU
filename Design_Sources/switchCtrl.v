`timescale 1ns / 1ps
module Switch_con(
    input clk,
    input rstn,
    input io_read,
    input [15:0]switch_d,
    output reg [15:0] switch_data
);

always @(posedge clk,negedge rstn)
begin
    if (!rstn)
        switch_data <= 15'b0;
    else if (io_read)
        switch_data <= switch_d;
    else
        switch_data <= switch_data;
end

endmodule