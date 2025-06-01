
# 键盘使用说明
keyboard_scan负责接受键盘输入的信号，实例化于keyboard_driver模块并且传递信号给该模块

|Port| Description|
|------ | ---------|
|`input clk`|系统时钟|
|`input rstn`|复位信号|
|`input ps2_clk`|键盘时钟|
|`input ps2_data`|键盘数据|
|`output [15:0] xkey`|连续键值|
|`output [21:0] data`|连续输入信号|
|`output data_in`|数据输入标识|

keyboard_driver负责将接收到的信号转换成五位的设定值并且输出，实例化于顶层模块并传递信号给Keyboard_cache模块

|Port| Description|
|------ | ---------|
|`input clk`|系统时钟|
|`input rstn`|复位信号|
|`input ps2_clk`|键盘时钟|
|`input ps2_data`|键盘数据|
|`output [4:0] data_out`|转化的键值|

Keyboard_cache键值缓存，负责将接受的值拼接起来，包括删除确认按键，实例化于顶层模块，将处理后的值作为键盘的input
|Port| Description|
|------ | ---------|
|`input clk`|系统时钟|
|`input rstn`|复位信号|
|`input [4:0] key_data`|输入的键值|
|`output [31:0] data_out`|经过拼接后的键盘输入|

#### 主要代码说明
`keyboard_scan`对 PS/2 时钟 (ps2_clk) 和数据 (ps2_data) 进行 8 级移位寄存器滤波，键被按下时的编码叫做通码(makecode)，弹起时的编码叫做断码(breakcode)，大部分键的通码和断码都是 8 位 1 字节，所以进行8 级移位寄存器滤波
当连续 8 个时钟周期检测到相同电平 (全 1 或全 0) 时，更新同步后的信号 ps2cf 和 ps2df
当时钟Clock的下降沿时，侦测到数据Data也拉低，代表一个数据包传送出来，之后的10个时钟下降沿，分别收到从最低位LSB到MSB的八位数据，1位的奇偶校验（1表示八位数据中1的位数为偶数，0是奇数），最后1位高电平表示数据包结束。
![alt text](image.png)
```
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

always @(negedge ps2cf or negedge rstn) begin
    if (!rstn) begin
        count <= 0;
    end else begin
        if (count >= 4'h10 && ps2df == 1'b1) begin
            count <= 0;
            data_in <= 1'b1;
        end else begin
            data_in <= 1'b0;
            count <= count + 1;
        end
    end
end
```
`xkey`作为连续两个键值有效值的拼接，只有八位的有效值，第一位是1位起始低电位，第十位是1位奇偶校验，第十一位是1位结尾高电位
`data`作为连续两个键盘信号的拼接
```
assign xkey = {shift2[8:1], shift1[8:1]};
assign data = {shift2, shift1};
```
`Keyboard_cache`
缓存将上一个状态的键值存入寄存器，当单间键值对应`enter`的时候就根据`key_data_valid`的值对输出数据进行更改
```
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
```

#### 使用说明
键值对应键盘上的`0-f`每次键值的输入由`enter`键确认输入，每次按下`enter`只能输入一位十六进制数字，删除单位数字`backspace`和清空缓存区`tab`都是需要`enter`确认的，最大接受八位十六进制数，发生溢出时高位会被舍弃，低位更新为最新的数字

https://blog.csdn.net/qimoDIY/article/details/99920981