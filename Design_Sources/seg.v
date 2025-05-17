module seg(
    input        clk,      
    input        rstn, 
    input  [31:0]data,      
    input        base,
    output reg [7:0] digit_en,      
    output reg [7:0] sseg,         
    output reg [7:0] sseg1
);
    // 将12位数据分解为6个十进制数位
    wire [3:0] digit0 = (base) ? (data % 10)       : data[3:0];  // 个位/LSB
    wire [3:0] digit1 = (base) ? ((data / 10) % 10) : data[7:4];  // 十位
    wire [3:0] digit2 = (base) ? ((data / 100) % 10) : data[11:8]; // 百位（十六进制时可能超出范围）
    wire [3:0] digit3 = (base) ? ((data / 1000) % 10) :  data[15:12];
    wire [3:0] digit4 = (base) ? ((data / 10000) % 10)  : data[19:16];  // 个位/LSB
    wire [3:0] digit5 = (base) ? ((data / 100000) % 10) :  data[23:20];  // 十位
    wire [3:0] digit6 = (base) ? ((data / 1000000) % 10) :  data[27:24]; // 百位（十六进制时可能超出范围）
    wire [3:0] digit7 = (base) ? ((data / 10000000) % 10) :  data[31:28];
   

    parameter CLK_DIV = 16'd50000;  // 时钟分频系数，用于扫描控制
    
    reg [15:0] clk_div_cnt;         // 时钟分频计数器
    reg [2:0] digit_sel;         
    reg [3:0] digit_data;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            clk_div_cnt <= 16'd0;
            digit_sel <= 2'd0;
        end else begin
            if (clk_div_cnt >= CLK_DIV) begin
                clk_div_cnt <= 16'd0;
                digit_sel <= digit_sel + 2'd1;
                if (digit_sel >= 3'd7)
                    digit_sel <= 3'd0;
            end else begin
                clk_div_cnt <= clk_div_cnt + 16'd1;
            end
        end
    end

    // 数码管扫描控制（简化版，使用clk的低2位作为扫描信号）
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin 
            digit_en <= 8'b11111111;
        end else begin 
            case (digit_sel)
                3'b000: begin digit_en <= 8'b0000_0001; end 
                3'b001: begin digit_en <= 8'b0000_0010; end 
                3'b010: begin digit_en <= 8'b0000_0100; end 
                3'b011: begin digit_en <= 8'b0000_1000; end
                3'b100: begin digit_en <= 8'b0001_0000; end 
                3'b101: begin digit_en <= 8'b0010_0000; end 
                3'b110: begin digit_en <= 8'b0100_0000; end 
                3'b111: begin digit_en <= 8'b1000_0000; end
                default: begin digit_en <= 8'b0000_0000; end
            endcase
        end
    end
    always @(*) begin
          case (digit_sel)
              3'd0: digit_data = digit0;
              3'd1: digit_data = digit1;
              3'd2: digit_data = digit2;
              3'd3: digit_data = digit3; 
              3'd4: digit_data = digit4;
              3'd5: digit_data = digit5;
              3'd6: digit_data = digit6;
              3'd7: digit_data = digit7;     
              default: digit_data = 4'd0;
          endcase
     end

    always @(*) begin
        if(digit_sel<=3)begin
            case (digit_data)
                4'h0: sseg = 8'b1111110;
                4'h1: sseg = 8'b0110000; 
                4'h2: sseg = 8'b1101101; 
                4'h3: sseg = 8'b1111001;
                4'h4: sseg = 8'b0110011; 
                4'h5: sseg = 8'b1011011; 
                4'h6: sseg = 8'b1011111;
                4'h7: sseg = 8'b1110000;
                4'h8: sseg = 8'b1111111;
                4'h9: sseg = 8'b1111011; 
                4'hA: sseg = 8'b1110111;
                4'hB: sseg = 8'b0011111; 
                4'hC: sseg = 8'b1001110;
                4'hD: sseg = 8'b0111101;
                4'hE: sseg = 8'b1001111; 
                4'hF: sseg = 8'b1000111;
                default: sseg = 8'b0000001; 
            endcase
        end else begin
            case (digit_data)
                4'h0: sseg1 = 8'b1111110;
                4'h1: sseg1 = 8'b0110000; 
                4'h2: sseg1 = 8'b1101101; 
                4'h3: sseg1 = 8'b1111001;
                4'h4: sseg1 = 8'b0110011; 
                4'h5: sseg1 = 8'b1011011; 
                4'h6: sseg1 = 8'b1011111;
                4'h7: sseg1 = 8'b1110000;
                4'h8: sseg1 = 8'b1111111;
                4'h9: sseg1 = 8'b1111011; 
                4'hA: sseg1 = 8'b1110111;
                4'hB: sseg1 = 8'b0011111; 
                4'hC: sseg1 = 8'b1001110;
                4'hD: sseg1 = 8'b0111101;
                4'hE: sseg1 = 8'b1001111; 
                4'hF: sseg1 = 8'b1000111;
                default: sseg1 = 8'b0000001; 
            endcase
        end
    end
endmodule