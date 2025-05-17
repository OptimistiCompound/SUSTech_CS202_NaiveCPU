module DMem(
    input clk, 
    input MemRead,MemWrite,
    input [13:0] addr, 
    input [31:0] din,
    // input upg_rst_i,
    // input upg_clk_i,
    // input upg_wen_i,
    // input [13:0]upg_addr_i,
    // input [31:0]upg_data_i,
    // input [31:0]upg_done_i,

    output[31:0] dout
    );
    wire clkn = ~clk;
    
    RAM udram(
        .clka(clkn), .wea(MemWrite), .addra(addr[13:0]), .dina(din), .douta(dout)
        );
 endmodule