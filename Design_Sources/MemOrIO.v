`include "../Header_Files/io_header.v"

module MemOrIO( 
    input mRead,        // 读内存控制信�?
    input mWrite,       // 写内存控制信�?
    input ioRead,       // 读IO控制信号
    input ioWrite,      // 写IO控制信号
    input conf_btn_out, // 来自按键的信号(12�?)
    input [31:0] addr_in,  // 来自ALU的地�?
    input [31:0] m_rdata,   // 从数据存储器读取的数�?
    input [7:0] switch_data, // 从开关读取的数据(16�?)
    input [4:0] key_data,   // 从键盘读取的数据(11�?)
    input [31:0] r_rdata,   // 从寄存器堆读取的数据
    input [7:0] seg_data,
    output [31:0] addr_out,
    output [31:0] r_wdata,
    output reg [31:0] write_data, // 输出到存储器或IO的数�?
    output LEDCtrl,         // LED片�?�信�?
    output SwitchCtrl,      // �?关片选信�?
    output KeyCtrl,         // 键盘片�?�信�?
    output Segctrl      // 七段数码管控制信�? 
);

    // 判断地址类型
    wire isLEDAddr = (addr_in == `LED_BASE_ADDR);
    wire isSwitchAddr = (addr_in == `SWITCH_BASE_ADDR);
    wire isKeyAddr = (addr_in == `KEY_BASE_ADDR);
    wire isSegAddr = (addr_in == `SEG_BASE_ADDR);
    wire isBtnAddr = (addr_in == `Btn_ADDR); //to do
    wire isIOAddr = isLEDAddr || isSwitchAddr || isKeyAddr;
    
    // 输出地址直接连接输入地址
    assign addr_out = addr_in;
    
    // 从存储器或IO读取的数据到寄存器堆
    assign r_wdata = (mRead && !isIOAddr) ? m_rdata :      // 内存读取
                     (ioRead && isSwitchAddr) ? {16'h0, switch_data} :  // �?关读�?
                     (ioRead && isKeyAddr) ? {21'h0, key_data} :        // 键盘读取(扩展�?32�?)
                     (ioWrite && isSegAddr) ? {23'h0, seg_data} :
                     (ioRead && isBtnAddr) ? {31'h0, conf_btn_out} :    // LED读取(扩展�?32�?)
                     32'h0;  // 默认�?
    
    // 片�?�信号（高电平有效）
    assign LEDCtrl = ioWrite && isLEDAddr;      // 写LED时有�?
    assign SwitchCtrl = ioRead && isSwitchAddr; // 读开关时有效
    assign KeyCtrl = ioRead && isKeyAddr;       // 读键盘时有效
    assign Segctrl = ioWrite && isSegAddr;
    
    // 写入数据选择
    always @* begin
        if (mWrite || (ioWrite && isLEDAddr))  // 写内存或LED�?
            write_data = r_rdata;  // 数据来自寄存器堆
        else
            write_data = 32'hZZZZZZZZ;  // 否则为高阻�??
    end

endmodule