`include "../Header_Files/io_header.v"
`include "../Header_Files/riscv_defs.v"

module MemOrIO(
    // Inputs
    input mRead,                    // ???????
    input mWrite,                   // ???????
    input ioRead,                   // ?IO????
    input ioWrite,                  // ?IO????
    input eRead,                    // ?????
    input eWrite,                   // ?????
    input [11:0] EcallOp,                  // ???????

    input conf_btn_out,             // ???????
    input [31:0] addr_in,           // ??ALU???
    input [31:0] m_rdata,           // ?dMem?????
    input [11:0] switch_data,       // ?Switch?????(12bits)
    input [31:0] key_data,           // ?Keyboard?????(32bits)
    input [31:0] r_rdata,           // ?Reg?????
    input [31:0] ecall_a0_data,
    // input rstn,                     // ????

    // Outputs
    output [31:0] addr_out,
    output reg [31:0] r_wdata,          // write back data to Reg
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
    always @(*) begin
        if (mRead  && isMemAddr)
            r_wdata = m_rdata;
        else if (ioRead && isSwitchAddr)
            r_wdata = {20'h0, switch_data};
        else if (ioRead && isBntAddr)
            r_wdata = {31'b0, conf_btn_out};
        else if (ioRead && isKeyAddr)
            r_wdata = {key_data};
        else if (eRead && EcallOp == `EOP_READ_INT)
            r_wdata = {20'h0, switch_data};
        else 
            r_wdata = 32'h0;
    end

    // For Store: write Mem or IO
    assign LEDCtrl = (ioWrite && isLEDAddr);
    assign SegCtrl = ioWrite && isSegAddr || eWrite;
    always @* begin
        // if (!rstn) begin
        //     write_data = 32'h0;
        // end else
        if (mWrite || (ioWrite && !eWrite) )
            write_data = r_rdata;
        else if (eWrite && EcallOp == `EOP_PRINT_INT)
            write_data = ecall_a0_data;
        else
            write_data = 32'h0;
    end

endmodule