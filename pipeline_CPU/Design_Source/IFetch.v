`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/27 17:07:06
// Design Name: 
// Module Name: IFetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IFetch(
    // Inputs
    input clk,
    input rstn,
    input Branch,           // Controller
    input Jump,             // Controller
    input Jalr,             // Controller
    input [31:0] ALUResult, // EX_MEM
    input [31:0] imm32,     // EX_MEM

//    input upg_rst_i,
//    input upg_clk_i, 
//    input upg_wen_i,
//    input[13:0] upg_adr_i, 
//    input[31:0] upg_dat_i, 
//    input upg_done_i,

    // Outputs
    output [31:0] inst,
    output [31:0] pc4_i,
    output FLush
    );
//wire mode = upg_rst_i | (~upg_rst_i & upg_done_i);
reg [31:0] PC;
wire [31:0] next_PC =   (rstn==0)           ? 0 : 
                        (Branch || Jump)    ? PC + imm32 : 
                        (Jalr)              ? ALUResult : 
                        PC + 32'h4;
assign Flush        =   (Branch || Jump)    ? 1'b1 :
                        (Jalr)              ? 1'b1 :
                        1'b0;

always @(negedge clk or negedge rstn) begin
    if (~rstn)
        PC <= 0;
    else
        PC <= next_PC;
end

assign pc4_i = PC + 32'h4;

//programrom instmem (
//    .clka (mode? rom_clk_i : upg_clk_i ),
//    .wea (mode? 1'b0 : upg_wen_i ),
//    .addra (mode? PC[15:2] : upg_adr_i ),
//    .dina (mode? 32'h00000000 : upg_dat_i ),
//    .douta (inst)
//    );
prgrom imem(
.clka(clk),
.addra(PC[15:2]),
.douta(inst)
);

endmodule
