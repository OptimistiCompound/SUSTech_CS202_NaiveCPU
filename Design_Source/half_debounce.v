module half_debounce (
    input wire clk,
    input wire rstn,
    input wire key_in,
    output key_out
);

parameter CNT_MAX = 20'd9; 

reg key_tmp;
reg key_stable;
reg key_stable_d;
reg [19:0] cnt;
reg pulse_trigger; // 脉冲触发信号

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        key_tmp    <= 1'b0;
        key_stable <= 1'b0;
        key_stable_d <= 1'b0;
        cnt        <= 20'd0;
        pulse_trigger <= 1'b0;
    end 
    else begin
        key_tmp <= key_in;
        if (key_in != key_tmp) begin
            cnt <= 20'd0;
        end 
        else begin
            if (cnt < CNT_MAX) begin
                cnt <= cnt + 1;
            end 
            else begin
                key_stable <= key_in;
            end
        end
        key_stable_d <= key_stable;
        
        // �?测key_stable上升沿并生成�?个时钟周期的触发信号
        pulse_trigger <= key_stable & (~key_stable_d);
    end
end

// 生成半个时钟周期的输出脉�?
reg key_out_reg;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        key_out_reg <= 1'b0;
    end
    else if (pulse_trigger) begin
        key_out_reg <= 1'b1;
    end
    else begin
        key_out_reg <= 1'b0;
    end
end

// 使用组合逻辑生成半个周期宽度的脉�?
assign key_out = key_out_reg & ~clk;

endmodule    