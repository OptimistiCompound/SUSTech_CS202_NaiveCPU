module DMem(
    input clk, 
    input MemRead,MemWrite,
    input [13:0] addr, 
    input [31:0] din,
    input upg_rst_i,
    input upg_clk_i,
    input upg_wen_i,
    input [14:0]upg_addr_i,
    input [31:0]upg_data_i,
    input [31:0]upg_done_i,

    output[31:0] dout
    );
    wire clkn = ~clk;

    wire mode = upg_rst_i | (~upg_rst_i & upg_done_i);
    
    RAM udram(
        .clka (mode ? clkn : upg_clk_i),
        .wea (mode ? MemWrite : (upg_wen_i& upg_addr_i[14])),
        .addra (mode ? addr : upg_addr_i[13:0]),
        .dina (mode ? din : upg_data_i),
        .douta (dout)
        );
 endmodule