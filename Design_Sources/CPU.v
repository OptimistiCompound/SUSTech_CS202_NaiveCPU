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
    input rstn,
    input conf_btn,
    input [15:0] switch_d,
    input ps2_clk,
    input ps2_data,
    input start_pg,
    input rx,
    output [7:0] digit_en,      
    output [7:0] sseg,         
    output [7:0] sseg1,
    output [15:0] reg_LED,
    output tx
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
    wire conf_btn_out;
    wire cpu_clk;
    wire upg_clk,upg_clko;
    wire upg_wen_o;
    wire upg_done_o;
    wire [14:0] upg_addr_o;
    wire [31:0] upg_data_o;
    wire key_data;

//-------------------------------------------------------------
// Instantiation of modules
//-------------------------------------------------------------

    cpuclk cpuclk(
        .clk_in1(clk),
        .clk_out1(cpu_clk),
        .clk_out2(upg_clk)
    );

    uart_bmpg_0 uart (
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i(rx),

        .upg_clk_o(upg_clk_w),
        .upg_wen_o(upg_wen_w),
        .upg_adr_o(upg_adr_w),
        .upg_dat_o(upg_dat_w),
        .upg_done_o(upg_done_w),
        .upg_tx_o(tx)
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
        .en(en),
        .write_data(write_data),
        .reg_LED(reg_LED),
        .digit_en(digit_en),
        .sseg(sseg),
        .sseg1(sseg1)
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

    keyboard_driver keyboard(
        .clk(cpu_clk),
        .rst(rstn),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .data_out(key_data)
    );


//-------------------------------------------------------------
// direct connections
//-------------------------------------------------------------

    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];


endmodule
