module Debug_Controller(
    input clk, rstn,
    input eBreak,
    input eRead,
    input btn1,
    input btn2,
    input btn3,
    input clk_in,
    output reg clk_out,
    output reg mode
);

// 何时进入debug模式？
//      1. eBreak
//      2. eRead
//      3. 按下btn2
// 何时退出debug模式？
//      1. 按下btn1
// 在debug模式下，CPU的行为
//      1. 按下btn2，时钟行进一个clk_in周期然后clk_out变为0
//      2. 可以通过switch和conf_btn查询寄存器的值，显示在数码管上
reg pos_btn1;
reg trig_1_1, trig_1_2, trig_1_3;
always @(posedge clk_in or negedge rstn) begin
    if (~rstn) begin
        trig_1_1 <= 0;
        trig_1_2 <= 0;
        trig_1_3 <= 0;
    end
    else begin
        trig_1_1 <= btn1;
        trig_1_2 <= trig_1_1;
        trig_1_3 <= trig_1_2;
    end
end

always @(posedge clk_in or negedge rstn) begin
    if (~rstn) begin
        pos_btn1 <= 0;
    end
    else begin
        pos_btn1 <= (~trig_1_3) & (trig_1_2);
    end
end

always @(posedge clk_in or negedge rstn) begin
    if (~rstn)begin
        mode = 0;
    end
    else if (btn2) begin
       mode = 0; 
    end
    else if (eBreak || eRead || btn3) begin
        mode = 1; 
    end
    else
        mode = ~pos_btn1;
end

always @(*) begin
    if (~mode)
        clk_out = clk_in;
    else if (mode) begin
        clk_out = 0;
    end
end
endmodule