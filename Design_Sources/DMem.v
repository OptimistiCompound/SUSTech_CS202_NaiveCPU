module DMem(
 input clk, 
input MemRead,MemWrite,
 input [31:0] addr, 
input [31:0] din,
 output[31:0] dout);
 RAM udram(.clka(clk), .wea(MemWrite), .addra(addr[13:0]), .dina(din), .douta(dout));
 endmodule