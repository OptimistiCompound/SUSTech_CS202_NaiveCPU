module Debug_Controller(
    input clk, rstn,
    input eBreak,
    input btn1,
    input btn2,
    input clk_in,
    output reg clk_out
);
reg mode;
always @(posedge clk or negedge rstn) begin
    if (~rstn)begin
        mode = 0;
    end
    else if (eBreak)
        mode = 1;
    else if (btn1)
        mode = ~mode; 
end

always @(*) begin
    if (~mode)
        clk_out = clk_in;
    else if (mode)begin
        if (btn2) 
            clk_out = ~clk_out;
    end
end
endmodule