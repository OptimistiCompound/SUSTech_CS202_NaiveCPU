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
    input Pause,
    input Branch,           // EX_MEM
    input zero,             // EX_MEM
    input Jump,             // EX_MEM
    input Jalr,             // EX_MEM
    input [31:0] ALUResult, // EX_MEM
    input [31:0] imm32,     // EX_MEM
    input [31:0] MEM_pc_i, // EX_MEM

   input upg_rst_i,
   input upg_clk_i, 
   input upg_wen_i,
   input[14:0] upg_adr_i, 
   input[31:0] upg_dat_i, 
   input upg_done_i,

    // Outputs
    output [31:0] inst,
    output [31:0] pc4_i,
    output [31:0] pc_i,
    output Flush
    );
wire mode = upg_rst_i | (~upg_rst_i & upg_done_i);
reg [31:0] PC;
wire [31:0] next_PC =   (rstn==0)           ? 0 : 
                        (Branch && zero || Jump)    ? MEM_pc_i + imm32 : 
                        (Jalr)              ? ALUResult : 
                        PC + 32'h4;
assign Flush        =   (rstn==0)           ? 1'b0 :
                        (Branch && zero || Jump || Jalr) ? 1'b1 : 
                        1'b0;

always @(negedge clk or negedge rstn) begin
    if (~rstn)
        PC <= 0;
    else if (Pause && !Flush) begin
        // 空指令 nop
        // 保持指令不变暂停一个周期
    end
    else
        PC <= next_PC;
end
 
assign pc4_i = PC + 32'h4;
assign pc_i  = PC;

programrom instmem (
    .clka (mode? clk : upg_clk_i ),
    .wea (mode? 1'b0 : (upg_wen_i & ~upg_adr_i[14])) ,
    .addra (mode? PC[15:2] : upg_adr_i[13:0] ),
    .dina (mode? 32'h00000000 : upg_dat_i ),
    .douta (inst)
    );
//prgrom imem(
//.clka(clk),
//.addra(PC[15:2]),
//.douta(inst)
//);


endmodule
