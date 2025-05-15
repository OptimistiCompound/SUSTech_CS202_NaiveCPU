`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/14 21:01:34
// Design Name: 
// Module Name: CPU
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


module CPU(
    input clk,
    input rstn
    );

//-------------------------------------------------------------
// definations
//-------------------------------------------------------------

    wire [31:0] inst;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ALUResult;
    wire [31:0] imm32;
    wire zero;
    wire Branch, ALUSrc, MemRead, MemWrite, MemtoReg, RegWrite;
    wire [1:0] ALUOp;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] MemData;
    wire [31:0] pc4_i;
    wire [15:0] switch_data;
    wire conf_btn, conf_btn_out;
    wire switch_d;

//-------------------------------------------------------------
// Instantiation of modules
//-------------------------------------------------------------

    clk_wiz cpuclk(
        .clk_in1(clk),
        .clk_out1(cpu_clk),
        .clk_out2(mem_clk)
    );

    IFetch ifetch(
        .clk(cpu_clk),
        .rst(rstn),
        .imm32(imm32),
        .Branch(Branch),
        .inst(inst),
        .pc4_i(pc4_i)
    );

    Controller controller(
        .inst(inst),
        .ALUResult(ALUResult),
        .zero(zero),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .mem_io_reg(mem_io_reg),
        .io_read(io_read),
        .io_write(io_write)
    );

    ALU alu(
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .imm32(imm32),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUResult(ALUResult),
        .zero(zero)
    );
    
    Decoder decoder(
        .clk(cpu_clk),
        .rstn(rstn),
        .ALUResult(ALUResult),
        .MemData(MemData),
        .pc4_i(pc4_i),
        .regWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .inst(inst),
        .rdata1(ReadData1),
        .rdata2(ReadData2),
        .imm32(imm32)
    );

    // need to test and complicate

    MemOrIO memorio(
        .mRead(MemRead),        // read from Mem
        .mWrite(MemWrite),      // write to Mem
        .ioRead(io_read),       // read from IO
        .ioWrite(io_write),     // write to IO
        .addr_in(ALUResult),    // address from ALU
        .conf_btn_out(conf_btn_out), 
        .addr_out(),            
        .m_rdata(MemData),
        .switch_data(switch_data),
        .key_data(12'h0),
        .r_wdata(),
        .r_rdata(ReadData2),
        .write_data(),
        .LEDCtrl(LEDCtrl),
        .SwitchCtrl(),
        .KeyCtrl(),
        .seg_ctrl(),
        .seg_data()
    );
    
    LED_con led(
        .clk(cpu_clk),
        .rstn(rstn),
        .LEDCtrl(LEDCtrl),
        .seg_ctrl(seg_ctrl),
        .write_data(write_data),
        .reg_LED(),
        .reg_seg74(), //from left 7 6 5 4 -> 1 0
        .reg_seg30(),
        .reg_tub_sel()
    );

    debounce conf_btn_deb(
        .clk(cpu_clk),
        .rstn(rstn),
        .key_in(conf_btn),
        .key_out(conf_btn_out)
    );

    Switch_con switch_con(
        .clk(cpu_clk),
        .rstn(rstn),
        .io_read(io_read),
        .switch_d(switch_d),
        .switch_data(switch_data)
    );


//-------------------------------------------------------------
// direct connections
//-------------------------------------------------------------

    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];


endmodule
