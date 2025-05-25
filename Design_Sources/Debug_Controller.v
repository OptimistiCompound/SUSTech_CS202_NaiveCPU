module Debug_Controller(
    input clk, rstn,
    input eBreak,
    input eRead,
    input btn1,
    input clk_in,
    output reg clk_out,
    output reg mode
);

// 何时进入debug模式？
//      1. eBreak
//      2. eRead
// 何时退出debug模式？
//      1. 按下btn1
// 在debug模式下，CPU的行为
//      1. 按下btn2，时钟行进一个clk_in周期然后clk_out变为0
//      2. 可以通过switch和conf_btn查询寄存器的值，显示在数码管上

always @(posedge clk or negedge rstn) begin
    if (~rstn)begin
        mode = 0;
    end
    else if (btn1)
        mode = 0;
    else if (eBreak || eRead)
        mode = 1; 
end

always @(*) begin
    if (~mode)
        clk_out = clk_in;
    else if (mode)begin
        clk_out = 0;
    end
end
endmodule