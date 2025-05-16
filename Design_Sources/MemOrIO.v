`include "../Header_Files/io_header.v"

module MemOrIO( 
    // Inputs
    input mRead,                    // 读内存控制信号
    input mWrite,                   // 写内存控制信号
    input ioRead,                   // 读IO控制信号
    input ioWrite,                  // 写IO控制信号
    input conf_btn_out,             // 来自按键的信号(12bits)
    input [31:0] addr_in,           // 来自ALU的地址
    input [31:0] m_rdata,           // 从dMem读取的数据
    input [7:0] switch_data,        // 从Switch读取的数据(16bits)
    input [4:0] key_data,           // 从Keyboard读取的数据(11bits)
    input [31:0] r_rdata,           // 从Reg读取的数据
    input [7:0] seg_data,           // data from Seg

    // Outputs
    output [31:0] addr_out,
    output [31:0] r_wdata,          // write back data to Reg
    output reg [31:0] write_data,   // 输出到Mem或IO的数据
    output LEDCtrl,                 // LED控制信号
    output SwitchCtrl,              // Switch控制信号
    output KeyCtrl,                 // Keyboard控制信号
    output Segctrl                  // Seg控制信号
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
    
    // 选择Mem或IO写入数据到寄存器堆
    assign r_wdata = (mRead && !isIOAddr) ? m_rdata :      // 内存读取
                     (ioRead && isSwitchAddr) ? {16'h0, switch_data} :  // 
                     (ioRead && isKeyAddr) ? {21'h0, key_data} :        // 键盘读取(扩展32bits)
                     (ioWrite && isSegAddr) ? {23'h0, seg_data} :
                     (ioRead && isBtnAddr) ? {31'h0, conf_btn_out} :    // LED读取(扩展32bits)
                     32'h0;  // 默认
    
    // 控制信号（高电平有效）
    assign LEDCtrl = ioWrite && isLEDAddr;      // 写LED时有效
    assign SwitchCtrl = ioRead && isSwitchAddr; // 读Switch时有效
    assign conf_btn_out = ioRead && isBtnAddr;  // 读Btn时有效
    assign KeyCtrl = ioRead && isKeyAddr;       // 读Keyboard时有效
    assign Segctrl = ioWrite && isSegAddr;
    
    // 写入数据选择
    always @* begin
        if (mWrite || (ioWrite && isLEDAddr))  // 写内存或LED
            write_data = r_rdata;  // 数据来自Reg
        else
            write_data = 32'hZZZZZZZZ;  // 否则为高阻态
    end

endmodule