`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/26 22:38:53
// Design Name: 
// Module Name: Controller
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


module Controller(
    // Inputs
    input [31:0] inst,
    input [31:0] ALUResult,
    input zero,
    input ecall_code,

    // Outputs
    output Branch,
    output Jump,
    output Jalr,
    output [1:0] Utype,
    output [1:0] ALUOp,
    output ALUSrc,
    output MemRead,
    output MemWrite,
    output MemtoReg,
    output RegWrite,
    output ioRead,
    output ioWrite,
    output reg eRead,
    output reg eWrite,
    output reg [11:0] EcallOp
    );
//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "../../Header_Files/riscv_defs.v"

//-------------------------------------------------------------
// Control signals
//-------------------------------------------------------------
wire [6:0] opcode = inst[6:0];
wire [2:0] funct3 = inst[14:12];
assign Branch = (opcode == `OPCODE_B);
assign Jump = (opcode == `OPCODE_JAL);
assign Jalr = (opcode == `OPCODE_JALR);
assign Utype = {
            {opcode == `OPCODE_LUI}, 
            {opcode == `OPCODE_AUIPC}
        };
assign ALUOp = {
            {(opcode != `OPCODE_L) && (opcode != `OPCODE_S) && (opcode != `OPCODE_B)}, 
            {(opcode != `OPCODE_L) && (opcode != `OPCODE_S) && (opcode != `OPCODE_R)}
        };
assign ALUSrc = (opcode == `OPCODE_I) || (opcode == `OPCODE_L) || (opcode == `OPCODE_S) || (opcode == `OPCODE_LUI) ||
            (opcode == `OPCODE_AUIPC);
assign MemRead = opcode == `OPCODE_L;
assign MemWrite = (opcode == `OPCODE_S);
assign MemtoReg = (opcode == `OPCODE_L);
assign RegWrite = (opcode == `OPCODE_R) || (opcode == `OPCODE_I) || (opcode == `OPCODE_L) || (opcode == `OPCODE_LUI) ||
            (opcode == `OPCODE_AUIPC) || (opcode == `OPCODE_JAL) || (opcode == `OPCODE_JALR);

assign ioRead = (opcode == `OPCODE_L) && ALUResult[31:8] == 24'hFFFFFC;
assign ioWrite = ( (opcode == `OPCODE_S ) && ALUResult[31:8] == 24'hFFFFFC );

// Ecall Operation Code
always @(*) begin
    if (opcode == `OPCODE_E)
        case (ecall_code[11:0])
            `EOP_PRINT_INT:begin
                eWrite  = 1'b1;
                eRead   = 1'b0;
                EcallOp = `EOP_PRINT_INT;
            end
            `EOP_READ_INT:begin
                eWrite  = 1'b0;
                eRead   = 1'b1;
                EcallOp = `EOP_READ_INT;
            end
            default:begin
                eWrite  = 1'b0;
                eRead   = 1'b0;
                EcallOp = 0;
            end
        endcase
    else begin
        eWrite  = 1'b0;
        eRead   = 1'b0;
        EcallOp = 0;
    end
end

endmodule
