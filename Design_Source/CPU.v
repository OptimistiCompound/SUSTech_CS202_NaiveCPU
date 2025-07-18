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
    input rstn_fpga,
    input conf_btn,
    input [11:0] switch_data,
    input ps2_clk,
    input ps2_data,
    input start_pg,
    input btn1,
    input btn2,
    input btn3,
    input rx,
    input base,
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
    wire Branch, Jump, Jalr, ALUSrc, MemRead, MemWrite, MemtoReg, RegWrite;
    wire [3:0] Ftype;
    wire eRead, eWrite, eBreak;
    wire mode;
    wire [11:0] EcallOp;
    wire [1:0] ALUOp;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] MemData;
    wire [31:0] pc4_i;
    wire [31:0] pc_i;
    wire conf_btn_out;
    wire start_pg_debounce;
    wire btn1_debounce;
    wire btn2_debounce;
    wire btn3_debounce;
    wire wiz_clk;
    wire cpu_clk;
    wire [31:0]addr_out;
    wire ioRead,ioWrite;
    wire [31:0] ecall_code;
    wire [31:0] ecall_a0_data;

    wire upg_clk;
    wire upg_clk_w;
    wire upg_wen_w;
    wire upg_done_w;
    wire [14:0] upg_addr_w;
    wire [31:0] upg_data_w;

    wire [4:0]key_data_sub;
    wire [31:0]key_data;

    wire SegCtrl;
    wire LEDCtrl;
    wire [31:0] write_data;
    wire [31:0] r_wdata;
//-------------------------------------------------------------
// Instantiation of modules
//-------------------------------------------------------------
    reg upg_rst;
    always@(posedge clk)begin 
        if(~rstn_fpga)begin
            upg_rst <= 1'b1;
        end
        else if(start_pg_debounce)begin
            upg_rst <= 0;
        end
    end
    
    wire rstn;
    assign rstn = rstn_fpga | !upg_rst;

// assign wiz_clk=clk;
// assign upg_clk=clk;
   clk_wiz cpuclk(
       .clk_in1(clk),
       .clk_out1(wiz_clk),
       .clk_out2(upg_clk)
   );

    Debug_Controller debug_ctrl(
        .clk(clk),
        .rstn(rstn),
        .eBreak(eBreak),
        .eRead(eRead),
        .btn1(btn1),
        .clk_in(wiz_clk),
        .clk_out(cpu_clk),
        .mode(mode)
    );

    uart_bmpg_0 uart (
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i(rx),

        .upg_clk_o(upg_clk_w),
        .upg_wen_o(upg_wen_w),
        .upg_adr_o(upg_addr_w[14:0]),
        .upg_dat_o(upg_data_w),
        .upg_done_o(upg_done_w),
        .upg_tx_o(tx)
    );

    IFetch ifetch(
        .clk(cpu_clk),
        .rstn(rstn_fpga),
        .imm32(imm32),
        .Branch(Branch),
        .Jump(Jump),
        .Jalr(Jalr),
        .ALUResult(ALUResult),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_w),
        .upg_adr_i(upg_addr_w[14:0]),
        .upg_dat_i(upg_data_w),
        .upg_done_i(upg_done_w),
        .inst(inst),
        .pc4_i(pc4_i),
        .pc_i(pc_i)
    );

    Controller controller(
        .inst(inst),
        .ALUResult(ALUResult),
        .zero(zero),
        .ecall_code(ecall_code),
        .Branch(Branch),
        .Jump(Jump),
        .Jalr(Jalr),
        .Ftype(Ftype),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .ioRead(ioRead),
        .ioWrite(ioWrite),
        .eRead(eRead),
        .eWrite(eWrite),
        .EcallOp(EcallOp),
        .eBreak(eBreak)
    );

    ALU alu(
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .imm32(imm32),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .Ftype(Ftype),
        .ALUResult(ALUResult),
        .zero(zero)
    );
    
    DMem dmem(
        .clk(cpu_clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr_out[15:2]),
        .din(ReadData2),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_w),
        .upg_addr_i(upg_addr_w[14:0]),
        .upg_data_i(upg_data_w),
        .upg_done_i(upg_done_w),
        .dout(MemData)
    );

    Decoder decoder(
        .clk(cpu_clk),
        .rstn(rstn),
        .ALUResult(ALUResult),
        .MemData(r_wdata),
        .pc4_i(pc4_i),
        .pc_i(pc_i),
        .regWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .eRead(eRead),
        .inst(inst),
        .rdata1(ReadData1),
        .rdata2(ReadData2),
        .imm32(imm32),
        .ecall_code(ecall_code),
        .ecall_a0_data(ecall_a0_data)
    );

    // need to test and complicate

    MemOrIO memorio(
        .mRead(MemRead),        // read from Mem
        .mWrite(MemWrite),      // write to Mem
        .ioRead(ioRead),       // read from IO
        .ioWrite(ioWrite),     // write to IO
        .eRead(eRead),
        .eWrite(eWrite),
        .EcallOp(EcallOp),
        .conf_btn_out(conf_btn_out), 
        .key_btn(btn2_debounce),
        .addr_in(ALUResult),    // address from ALU         
        .m_rdata(MemData),
        .switch_data(switch_data),
        .key_data(key_data),
        .r_rdata(ReadData2),
        .ecall_a0_data(ecall_a0_data),
        .addr_out(addr_out),   
        .r_wdata(r_wdata),
        .write_data(write_data),
        .LEDCtrl(LEDCtrl),
        .SegCtrl(SegCtrl)
    );
 
//    LED_con led(
//        .clk(clk),
//        .cpu_clk(cpu_clk),
//        .rstn(rstn),
//        .mode(mode),
//        .base(base),
//        .LEDCtrl(LEDCtrl),
//        .SegCtrl(1'b1),
//        .eBreak(eBreak),
//        .eRead(eRead),
//        .write_data(key_data),
//        .reg_LED(reg_LED)
//        .digit_en(digit_en),
//        .sseg(sseg),
//        .sseg1(sseg1)
//    );
    // reg [3:0]cnt_btn;
    // always@(posedge cpu_clk) begin
    //  if (conf_btn_out)cnt_btn<=cnt_btn+1;
    //  end
    //  reg [3:0] cnt_iow;
    //   always@(posedge cpu_clk) begin
    //      if (conf_btn_out)cnt_iow<=cnt_iow+1;
    //      end
    //  wire [31:0]out;
    //  assign out[3:0] = cnt_btn;
    //  assign out[7:4] =cnt_iow;
    //  assign out[15:8] =write_data[7:0];
    //  assign out[31:16] =pc4_i[23:8];
    seg seg(
    .clk(cpu_clk),
    .rstn(rstn),
    .data(key_data),
    .base(base),
    .digit_en(digit_en),
    .sseg(sseg),
    .sseg1(sseg1)
    );

// assign conf_btn_out = conf_btn;
// assign start_pg_debounce = start_pg;
// assign btn2_debounce = btn2;
   debounce conf_btn_deb(
       .clk(clk),
       .rstn(rstn),
       .key_in(conf_btn),
       .key_out(conf_btn_out)
   );
   debounce pg_deb(
       .clk(clk),
       .rstn(rstn),
       .key_in(start_pg),
       .key_out(start_pg_debounce)
   );

    debounce btn1_deb(
        .clk(clk),
        .rstn(rstn),
        .key_in(btn1),
        .key_out(btn1_debounce)
    );
   debounce btn2_deb(
       .clk(clk),
       .rstn(rstn),
       .key_in(btn2),
       .key_out(btn2_debounce)
   );
    debounce btn3_deb(
        .clk(clk),
        .rstn(rstn),
        .key_in(btn3),
        .key_out(btn3_debounce)
    );

    // Switch_con switch_con(
    //     .clk(cpu_clk),
    //     .rstn(rstn),
    //     .io_read(io_read),
    //     .switch_d(switch_d),
    //     .switch_data(switch_data)
    // );

    keyboard_driver keyboard(
        .clk(cpu_clk),
        .rstn(rstn),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .data_out(key_data_sub)
    );

    Keyboard_cache key_cache(
        .clk(cpu_clk),
        .rstn(rstn),
        .key_data(key_data_sub),
        .data_out(key_data)
    );

//-------------------------------------------------------------
// direct connections
//-------------------------------------------------------------

    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];


endmodule