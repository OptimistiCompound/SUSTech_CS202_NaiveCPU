module keyboard_scan(
    input clk,
    input rstn,
    input ps2_clk,
    input ps2_data,
    output wire [15:0] xkey,
    output wire [21:0] data,
    output reg [3:0]data_in
);

    reg ps2cf;
    reg ps2df;
    reg [0:4] cnt;
    reg [0:7] smg;
    reg [3:0] num;
    reg [1:0] clk_25MHz;
    reg [7:0] ps2c_filter, ps2d_filter;
    reg [10:0] shift1, shift2;
    reg DIR = 1'b0;

    always @(posedge clk) begin  //25MHZ
        if (clk_25MHz >= 3) begin
            DIR <= 1'b1;
            clk_25MHz <= 0;
        end else begin
            clk_25MHz <= clk_25MHz + 1;
            DIR <= 1'b0;
        end
    end

    // 对ps2_clk和ps2_data进行滤波
    always @(posedge DIR or negedge rstn) begin
        if (!rstn) begin
            ps2c_filter <= 0;
            ps2d_filter <= 0;
            ps2cf <= 1;
            ps2df <= 1;
        end else begin
            ps2c_filter[7] <= ps2_clk;
            ps2c_filter[6:0] <= ps2c_filter[7:1];
            ps2d_filter[7] <= ps2_data;
            ps2d_filter[6:0] <= ps2d_filter[7:1];
            if (ps2c_filter == 8'b11111111)
                ps2cf <= 1;
            else if (ps2c_filter == 8'b00000000)
                ps2cf <= 0;
            if (ps2d_filter == 8'b11111111)
                ps2df <= 1;
            else if (ps2d_filter == 8'b00000000)
                ps2df <= 0;
        end
    end

    reg [3:0] count;
    always @(negedge ps2cf or negedge rstn) begin
        if (!rstn) begin
            count <= 0;
        end else begin
            if (count >= 10 && ps2df == 1'b1) begin
                count <= 0;
                data_in <= 1'b1;
            end else begin
                data_in <= 1'b0;
                count <= count + 1;
            end
        end
    end

    always @(negedge ps2cf or negedge rstn) begin
        if (!rstn) begin
            shift1 <= 0;
            shift2 <= 0;
        end else begin
            shift1 <= {ps2df, shift1[10:1]};
            shift2 <= {shift1[0], shift2[10:1]};
        end
    end

    assign xkey = {shift2[8:1], shift1[8:1]};
    assign data = {shift2, shift1};
//     assign data_in = (count >= 11)? 1 : 0;
endmodule

module keyboard_driver (
    input clk,
    input rstn,
    input ps2_clk,
    input ps2_data,
    output reg [4:0] data_out // 用于控制对应0 - 9的显示，每位对应一个数字键，高电平点亮（具体点亮逻辑需结合实际显示硬件，这里先按常规逻辑定义）
);
    wire [15:0] xkey;
    wire [21:0] ps_data;
    wire data_in;
    keyboard_scan scan(.clk(clk),.rstn(rstn),.ps2_clk(ps2_clk),.ps2_data(ps2_data), 
                      .xkey(xkey),.data(ps_data),.data_in(data_in));

    wire [7:0] now_key, pre_key;
    assign now_key = xkey[7:0];
    assign pre_key = xkey[15:8];
    reg [10:0]cnt = 0;
    // 使用 clk 进入always
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_out <= 0; // 复位时全灭
        end else if (data_in) begin
            case (now_key)
                8'd69: data_out <= 5'b00000; 
                8'd22: data_out <= 5'b00001; 
                8'd30: data_out <= 5'b00010; 
                8'd38: data_out <= 5'b00011; 
                8'd37: data_out <= 5'b00100; 
                8'd46: data_out <= 5'b00101; 
                8'd54: data_out <= 5'b00110; 
                8'd61: data_out <= 5'b00111; 
                8'd62: data_out <= 5'b01000;
                8'd70: data_out <= 5'b01001;
                8'h1c: data_out <= 5'b01010;
                8'h32: data_out <= 5'b01011;
                8'h21: data_out <= 5'b01100;
                8'h23: data_out <= 5'b01101;
                8'h24: data_out <= 5'b01110;
                8'h2b: data_out <= 5'b01111;

                8'h5a: data_out <= 5'b10000;
                8'h66: data_out <= 5'b10001;
                8'd13: data_out <= 5'b10010;
                default: data_out <=5'b11111;
            endcase
        end else begin
            data_out <= data_out; // 无有效按键
        end
    end
endmodule
