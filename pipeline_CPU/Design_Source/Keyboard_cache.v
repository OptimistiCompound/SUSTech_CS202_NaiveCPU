module Keyboard_cache(
    input clk,
    input rstn,
    input [4:0] key_data,
    output reg [31:0] data_out
);

reg [4:0] key_data_valid; // 用于存储上一个按键值

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        data_out <= 32'h0; // 同步复位
    end
    else begin
        if (key_data == 5'b10000)begin
            case(key_data_valid)
                5'b10001: data_out <= {4'h0, data_out[31:4]}; 
                5'b10010: data_out <= 32'b0;
                5'b10000: begin end
                default: 
                    if (key_data_valid != 5'b11111) begin // 过滤无效键值
                        data_out <= {data_out[27:0], key_data_valid[3:0]}; // 左移4位并添加新数据
                    end
            endcase
        end
    end
end
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        key_data_valid <= 5'b11111; // 同步复位
    end
    else begin
        key_data_valid <= key_data; 
    end
end

endmodule