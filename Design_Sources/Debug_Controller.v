module Debug_Controller(
    input clk, rstn,
    input eBreak,
    input eRead,
    input btn1,
    input clk_in,
    output reg clk_out,
    output reg mode
);
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