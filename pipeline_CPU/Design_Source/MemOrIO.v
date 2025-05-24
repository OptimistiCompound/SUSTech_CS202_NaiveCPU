`include "../../Header_Files/io_header.v"

module MemOrIO(
    // Inputs
    input mRead,                    // ???????
    input mWrite,                   // ???????
    input ioRead,                   // ?IO????
    input ioWrite,                  // ?IO????

    input conf_btn_out,             // ???????
    input [31:0] addr_in,           // ??ALU???
    input [31:0] m_rdata,           // ?dMem?????
    input [11:0] switch_data,       // ?Switch?????(12bits)
    input [3:0] key_data,           // ?Keyboard?????(32bits)
    input [31:0] r_rdata,           // ?Reg?????

    // Outputs
    output [31:0] addr_out,
    output [31:0] r_wdata,          // write back data to Reg
    output reg [31:0] write_data,   // data to Mem and IO
    output LEDCtrl,                 // LED????
    output SegCtrl                  // Seg????
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
    assign r_wdata = (mRead  && isMemAddr)      ?   m_rdata :                     // Memory
                     (ioRead && isSwitchAddr)   ?   {20'h0, switch_data} :        // Switch
                     (ioRead && isBntAddr)      ?   {31'b0, conf_btn_out} :       // btn state
                     (ioRead && isKeyAddr)      ?   {28'h0, key_data} :           // Keyboard
                     32'h0;                                                       // default

    // For Store: write Mem or IO
    assign LEDCtrl = ioWrite && isLEDAddr;
    assign SegCtrl = ioWrite && isSegAddr;
    always @* begin
        if (mWrite || (ioWrite))
            write_data = r_rdata;
        else
            write_data = 32'h0;
    end

endmodule