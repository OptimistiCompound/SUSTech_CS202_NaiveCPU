`timescale 1ns / 1ps
module LED_con(
    input clk,
    input rstn,
    input LEDCtrl,
    input seg_ctrl,
    input [31:0] write_data,
    output reg [15:0] reg_LED,
    output reg [7:0] reg_seg74, //from left 7 6 5 4 -> 1 0
    output reg [7:0] reg_seg30,
    output reg [7:0] reg_tub_sel
);

reg en=1'b1;
wire [31:0] Lseg_data;

print_output print_(
    .en(en),
    .sign7(write_data[31:28]),
    .sign6(write_data[27:24]),
    .sign5(write_data[23:20]),
    .sign4(write_data[19:16]),
    .sign3(write_data[15:12]),
    .sign2(write_data[11:8]),
    .sign1(write_data[7:4]),
    .sign0(write_data[3:0]),
    .rst(rstn),
    .clk(clk),
    .seg_74(reg_seg74),
    .seg_30(reg_seg30),
    .tub_sel(reg_tub_sel)
)

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