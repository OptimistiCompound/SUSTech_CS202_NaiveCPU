module MemOrIO( 
    input mRead,        // 读内存控制信�?
    input mWrite,       // 写内存控制信�?
    input ioRead,       // 读IO控制信号
    input ioWrite,      // 写IO控制信号
    input [31:0] addr_in,  // 来自ALU的地�?
    output [31:0] addr_out, // 输出到数据存储器的地�?
    input [31:0] m_rdata,   // 从数据存储器读取的数�?
    input [15:0] switch_data, // 从开关读取的数据(16�?)
    input [11:0] key_data,   // 从键盘读取的数据(11�?)
    output [31:0] r_wdata,  // 输出到寄存器堆的数据
    input [31:0] r_rdata,   // 从寄存器堆读取的数据
    output reg [31:0] write_data, // 输出到存储器或IO的数�?
    output LEDCtrl,         // LED片�?�信�?
    output SwitchCtrl,      // �?关片选信�?
    output KeyCtrl,         // 键盘片�?�信�?
    output seg_ctrl,       // 七段数码管控制信�?
    output [7:0] seg_data   // 七段数码管数�?
);

    // 地址映射定义
    parameter LED_BASE_ADDR = 32'hFFFFFC60;     // LED基地�?
    parameter SWITCH_BASE_ADDR = 32'hFFFFFC64;  // �?关基地址
    parameter KEY_BASE_ADDR = 32'hFFFFFC68;     // 键盘基地�?
    
    // 判断地址类型
    wire isLEDAddr = (addr_in == LED_BASE_ADDR);
    wire isSwitchAddr = (addr_in == SWITCH_BASE_ADDR);
    wire isKeyAddr = (addr_in == KEY_BASE_ADDR);
    wire isIOAddr = isLEDAddr || isSwitchAddr || isKeyAddr;
    
    // 输出地址直接连接输入地址
    assign addr_out = addr_in;
    
    // 从存储器或IO读取的数据到寄存器堆
    assign r_wdata = (mRead && !isIOAddr) ? m_rdata :      // 内存读取
                     (ioRead && isSwitchAddr) ? {16'h0, switch_data} :  // �?关读�?
                     (ioRead && isKeyAddr) ? {21'h0, key_data} :        // 键盘读取(扩展�?32�?)
                     32'h0;  // 默认�?
    
    // 片�?�信号（高电平有效）
    assign LEDCtrl = ioWrite && isLEDAddr;      // 写LED时有�?
    assign SwitchCtrl = ioRead && isSwitchAddr; // 读开关时有效
    assign KeyCtrl = ioRead && isKeyAddr;       // 读键盘时有效
    
    // 写入数据选择
    always @* begin
        if (mWrite || (ioWrite && isLEDAddr))  // 写内存或LED�?
            write_data = r_rdata;  // 数据来自寄存器堆
        else
            write_data = 32'hZZZZZZZZ;  // 否则为高阻�??
    end

endmodule