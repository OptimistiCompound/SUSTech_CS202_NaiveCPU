`timescale 1ns / 1ps
module LED_con(
    input clk,
    input rstn,
    input base,
    input LEDCtrl,
    input SegCtrl,
    input [31:0] write_data,
    output reg [15:0] reg_LED,
    output [7:0] digit_en,      
    output [7:0] sseg,         
    output [7:0] sseg1
);
reg [31:0] seg_data;

seg seg_output(
    .clk(clk),
    .rstn(rstn),
    .data(seg_data),
    .base(base),
    .digit_en(digit_en),
    .sseg(sseg),
    .sseg1(sseg1)
);

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        reg_LED <= 16'b0;
    end
    else if(LEDCtrl) begin
        reg_LED <= write_data[15:0];
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        seg_data <= 32'b0;
    end
    else if(SegCtrl) begin
        seg_data <= write_data;
    end
end

endmodule