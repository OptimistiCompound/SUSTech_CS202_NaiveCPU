`include "../Header_Files/io_header.v"

module MemOrIO(
    // Inputs
    input mRead,                    // 读内存控制信号
    input mWrite,                   // 写内存控制信号
    input ioRead,                   // 读IO控制信号
    input ioWrite,                  // 写IO控制信号
    input eRead,                    // 从外界读取
    input eWrite,                   // 向外界显示
    input [11:0] EcallOp,                  // 系统调用操作码

    input conf_btn_out,             // 来自按键的信号
    input [31:0] addr_in,           // 来自ALU的地址
    input [31:0] m_rdata,           // 从dMem读取的数据
    input [11:0] switch_data,       // 从Switch读取的数据(12bits)
    input [31:0] key_data,           // 从Keyboard读取的数据(4bits)
    input [31:0] r_rdata,           // 从Reg读取的数据
    input [31:0] ecall_a0_data,

    // Outputs
    output [31:0] addr_out,
    output reg [31:0] r_wdata,          // write back data to Reg
    output reg [31:0] write_data,   // data to Mem and IO
    output LEDCtrl,                 // LED控制信号
    output SegCtrl                  // Seg控制信号
);
    assign addr_out = addr_in;

    // Decide Read address
    wire isSwitchAddr    = (addr_in == `SWITCH_BASE_ADDR);
    wire isKeyAddr       = (addr_in == `KEY_BASE_ADDR);
    wire isBntAddr       = (addr_in == `Btn_ADDR);
    // Decide Write address
    wire isLEDAddr       = (addr_in == `LED_BASE_ADDR);
    wire isSegAddr       = (addr_in == `SEG_BASE_ADDR);
    // Decide Mem address
    wire isMemAddr       = !isBntAddr && !isSwitchAddr && !isKeyAddr;

    // For Load: write reg
    always @(*) begin
        if (mRead  && isMemAddr)
            r_wdata = m_rdata;
        else if (ioRead && isSwitchAddr)
            r_wdata = {20'h0, switch_data};
        else if (ioRead && isBntAddr)
            r_wdata = {31'b0, conf_btn_out}
        else if (ioRead && isKeyAddr)
            r_wdata = {28'h0, key_data}
        else if (eRead && EcallOp == `EOP_READ_INT)
            r_wdata = {20'h0, switch_data};
        else 
            r_wdata = 32'h0;
    end

    // For Store: write Mem or IO
    assign LEDCtrl = (ioWrite && isLEDAddr) || (eWrite && EcallOp == `EOP_PRINT_INT);
    assign SegCtrl = ioWrite && isSegAddr;
    always @* begin
        if (mWrite || (ioWrite && !eWrite) )
            write_data = r_rdata;
        else if (eWrite && EcallOp == `EOP_PRINT_INT)
            write_data = ecall_a0_data;
        else
            write_data = 32'h0;
    end

endmodule