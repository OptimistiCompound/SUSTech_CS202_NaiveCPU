`timescale 1ns / 1ps
module LED_con(
    input clk,
    input rstn,
    input base,
    input LEDCtrl,
    input seg_ctrl,
    input en,
    input [31:0] write_data,
    output reg [15:0] reg_LED,
    output reg [7:0] digit_en,      
    output reg [7:0] sseg,         
    output reg [7:0] sseg1
);

wire [31:0] Lseg_data;

seg seg_output(
    .clk(clk),
    .rst(rstn),
    .data(write_data),
    .base(base),
    .en(en),
    .digit_en(digit_en),
    .sseg(sseg),
    .sseg1(sseg1)
);

always @(posedge clk, negedge rstn) begin
    if(!rstn) begin
        write_data <= 32'b0;
    end
    else if(LEDCtrl) begin
        reg_LED <= write_data[15:0];
    end
    else if(seg_ctrl) begin
        seg_data<= write_data[31:0];
    end

end

endmodule