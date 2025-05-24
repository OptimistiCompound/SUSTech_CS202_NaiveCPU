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
    input [11:0] switch_data, // 给到寄存器
    input ps2_clk,
    input ps2_data,
    input start_pg,
    input rx,
    input base, // 给到寄存器
    output [7:0] digit_en,      
    output [7:0] sseg,         
    output [7:0] sseg1,
    output reg [15:0] WB_reg_LED,
    output tx
);

//-------------------------------------------------------------
// definations
//-------------------------------------------------------------
// 冒险
wire Pause; // 数据冒险停顿
wire Flush; // 控制冒险刷新

// IF 阶段
    wire [31:0] IF_pc4_i;
    wire [31:0] IF_inst;

// ID 阶段
    wire [1:0]  ID_ALUOp;
    wire        ID_ALUSrc;
    wire        ID_MemRead;
    wire        ID_MemWrite;
    wire        ID_MemtoReg;
    wire        ID_RegWrite;
    wire        ID_ioRead;
    wire        ID_ioWrite; 
    wire [4:0]  ID_rs1_addr;
    wire [4:0]  ID_rs2_addr;
    wire [31:0] ID_rs1_v;
    wire [31:0] ID_rs2_v;   
    wire [31:0] ID_imm32;   
    wire [2:0]  ID_funct3;  
    wire [6:0]  ID_funct7;  

// EX 阶段
    wire [1:0]  EX_ALUOp;
    wire        EX_ALUSrc;
    wire        EX_MemRead;
    wire        EX_MemWrite;
    wire        EX_MemtoReg;
    wire        EX_RegWrite;
    wire        EX_ioRead;
    wire        EX_ioWrite;   
    wire [4:0]  EX_rs1_addr; 
    wire [4:0]  EX_rs2_addr;
    wire [31:0] EX_ReadData1;
    wire [31:0] EX_ReadData2;
    wire [31:0] EX_imm32;
    wire [2:0]  EX_funct3;
    wire [6:0]  EX_funct7;   

// MEM 阶段
    wire        MEM_MemRead;
    wire        MEM_MemWrite;
    wire        MEM_MemtoReg;
    wire        MEM_RegWrite;
    wire        MEM_ioRead;
    wire        MEM_ioWrite;
    wire [4:0]  MEM_rs2_addr;
    wire [4:0]  MEM_rd_addr;
    wire [31:0] MEM_ALUResult;
    wire [31:0] MEM_rs2_v;
    wire        MEM_conf_btn_out;
    wire [31:0] MEM_addr_in;
    wire [31:0] MEM_m_rdata;
    wire [11:0] MEM_switch_data;
    wire [3:0]  MEM_key_data;
    wire [31:0] MEM_r_rdata;
    
// WB 阶段
    wire        WB_MemtoReg;
    wire        WB_RegWrite;
    wire        WB_ioWrite;
    wire [4:0]  WB_rd_addr;
    wire [31:0] WB_ALUResult;
    wire [31:0] WB_MemData;

//-------------------------------------------------------------
// Instantiation of modules
//-------------------------------------------------------------

    cpuclk cpuclk(
        .clk_in1(clk),
        .clk_out1(cpu_clk),
        .clk_out2(upg_clk)
    );

//    uart_bmpg_0 uart (
//        .upg_clk_i(upg_clk),
//        .upg_rst_i(upg_rst),
//        .upg_rx_i(rx),

//        .upg_clk_o(upg_clk_w),
//        .upg_wen_o(upg_wen_w),
//        .upg_adr_o(upg_adr_w),
//        .upg_dat_o(upg_dat_w),
//        .upg_done_o(upg_done_w),
//        .upg_tx_o(tx)
//    );

    IFetch ifetch(
        .clk(cpu_clk),
        .rstn(rstn),
        .Branch(MEM_Branch),
        .Jump(MEM_Jump),
        .Jalr(MEM_Jalr),
        .ALUResult(MEM_ALUResult)   // for Jalr
        .imm32(MEM_imm32),          // for Branch || Jump
//        .upg_rst_i(upg_rst),
//        .upg_clk_i(upg_clk),
//        .upg_wen_i(upg_wen_w),
//        .upg_adr_i(upg_adr_w),
//        .upg_dat_i(upg_dat_w),
        .inst(IF_inst),
        .pc4_i(IF_pc4_i),
        .FLush(Flush)
    );


    IF_ID if_id(
    // in
    .clk(cpu_clk), .rstn(rstn), .Pause(Pause), .Flush(Flush),
    .IF_pc4_i(IF_pc4_i),
    .IF_inst(IF_inst),
    // out
    .ID_pc4_i(ID_pc4_i),
    .ID_inst(ID_inst)
    );

    Decoder decoder(
        .clk(cpu_clk),
        .rstn(rstn),
        .ALUResult(WB_ALUResult),
        .MemData(WB_MemData),
        .pc4_i(IF_pc4_i),
        .regWrite(WB_RegWrite),
        .MemtoReg(WB_MemtoReg),
        .inst(IF_inst),

        .rdata1(ID_rs1_v),
        .rdata2(ID_rs2_v),
        .imm32(ID_imm32),
        .funct3(ID_funct3)
        .funct7(ID_funct7)
        .rs1_addr(ID_rs1_addr),
        .rs2_addr(ID_rs2_addr),
    );

    Controller controller(
        .inst(ID_inst),
        .ALUResult(MEM_ALUResult),
        .zero(MEM_zero),

        .Branch(ID_Branch),
        .Jump(ID_Jump),
        .Jalr(ID_Jalr),
        .ALUOp(ID_ALUOp),
        .ALUSrc(ID_ALUSrc),
        .MemRead(ID_MemRead),
        .MemWrite(ID_MemWrite),
        .MemtoReg(ID_MemtoReg),
        .RegWrite(ID_RegWrite),
        .ioRead(ID_ioRead),
        .ioWrite(ID_ioWrite)
    );

    ForwardingController forward_ctrl(
    // Inputs
    input       MEM_RegWrite,
    input       WB_RegWrite,
    input [4:0] EX_rs1_addr,
    input [4:0] EX_rs2_addr,
    input [4:0] MEM_rs2_addr,
    input [4:0] MEM_rd_addr,
    input [4:0] WB_rd_addr,

    input [31:0] EX_rs1_v,
    input [31:0] EX_rs2_v,
    input [31:0] MEM_ALUResult,
    input [31:0] MEM_rs2_v,
    input [31:0] WB_mdata,

    // Outputs
    output reg [31:0] true_ReadData1, // mux result to ALU
    output reg [31:0] true_ReadData2, // mux result to ALU
    output reg [31:0] true_m_wdata    // mux result to dMem
    );

    ID_EX id_ex(
    // Inputs
    input clk, rstn, Pause, Flush,
    input        ID_Branch,     // Controller
    input        ID_Jump,
    input        ID_Jalr,
    input [1:0]  ID_ALUOp,
    input        ID_ALUSrc,
    input        ID_MemRead,
    input        ID_MemWrite,
    input        ID_MemtoReg,
    input        ID_RegWrite,
    input        ID_ioRead,
    input        ID_ioWrite,

    input [4:0]  ID_rs1_addr,   // ID
    input [4:0]  ID_rs2_addr,   // ID
    input [31:0] ID_rs1_v,      // ID
    input [31:0] ID_rs2_v,      // ID
    input [31:0] ID_imm32,      // ID
    input [2:0]  ID_funct3,     // ID
    input [6:0]  ID_funct7,     // ID

    // Outputs
    output reg        EX_Branch,
    output reg        EX_Jump,
    output reg        EX_Jalr,
    output reg [1:0]  EX_ALUOp,     // EX_MEM
    output reg        EX_ALUSrc,
    output reg        EX_MemRead,
    output reg        EX_MemWrite,
    output reg        EX_MemtoReg,
    output reg        EX_RegWrite,
    output reg        EX_ioRead,
    output reg        EX_ioWrite    // EX_MEM

    output reg [4:0]  EX_rs1_addr,  // EX_MEM
    output reg [4:0]  EX_rs2_addr,
    output reg [31:0] EX_ReadData1,
    output reg [31:0] EX_ReadData2,
    output reg [31:0] EX_imm32,
    output reg [2:0]  EX_funct3,
    output reg [6:0]  EX_funct7     // EX_MEM
    );

    ALU alu(
        .ReadData1(true_ReadData1),
        .ReadData2(true_ReadData2),
        .imm32(EX_imm32),
        .ALUSrc(EX_ALUSrc),
        .ALUOp(EX_ALUOp),
        .funct3(EX_funct3),
        .funct7(EX_funct7),
        .ALUResult(EX_ALUResult),
        .zero(EX_zero)
    );

    EX_MEM ex_mem(
    // Inputs
    input clk, rstn, Flush,
    input        EX_Branch,
    input        EX_Jump,
    input        EX_Jalr,
    input        EX_MemRead,
    input        EX_MemWrite,
    input        EX_MemtoReg,
    input        EX_RegWrite,
    input        EX_ioRead,
    input        EX_ioWrite,
    input [4:0]  EX_rs2_addr,
    input [4:0]  EX_rd_addr,
    input [31:0] EX_ALUResult,
    input [31:0] EX_rs2_v,

    input        EX_conf_btn_out,
    input [31:0] EX_addr_in,
    input [31:0] EX_m_rdata,
    input [11:0] EX_switch_data,
    input [3:0]  EX_key_data,
    input [31:0] EX_r_rdata,

    // Outputs
    output reg        MEM_Branch,
    output reg        MEM_Jump,
    output reg        MEM_Jalr,
    output reg        MEM_MemRead,
    output reg        MEM_MemWrite,
    output reg        MEM_MemtoReg,
    output reg        MEM_RegWrite,
    output reg        MEM_ioRead,
    output reg        MEM_ioWrite,
    output reg [4:0]  MEM_rs2_addr,
    output reg [4:0]  MEM_rd_addr,
    output reg [31:0] MEM_ALUResult,
    output reg [31:0] MEM_rs2_v,

    output reg        MEM_conf_btn_out,
    output reg [31:0] MEM_addr_in,
    output reg [31:0] MEM_m_rdata,
    output reg [11:0] MEM_switch_data,
    output reg [3:0]  MEM_key_data,
    output reg [31:0] MEM_r_rdata
    );

    DMem dmem(
        .clk(cpu_clk),
        .MemRead(MEM_MemRead),
        .MemWrite(MEM_MemWrite),
        .addr(addr_out),
        .din(MEM_rs2_v),
//        .upg_rst_i(upg_rst),
//        .upg_clk_i(upg_clk),
//        .upg_wen_i(upg_wen_w),
//        .upg_addr_i(upg_adr_w[13:0]),
//        .upg_data_i(upg_dat_w),
//        .upg_done_i(upg_done_w),
        .dout(MemData)
    );

    MemOrIO memorio(
        .mRead(MEM_MemRead),        // read from Mem
        .mWrite(MEM_MemWrite),      // write to Mem
        .ioRead(MEM_ioRead),       // read from IO
        .ioWrite(MEM_ioWrite),     // write to IO
        .conf_btn_out(MEM_conf_btn_out), 
        .addr_in(MEM_ALUResult),    // address from ALU         
        .m_rdata(MemData),
        .switch_data(MEM_switch_data),
        .key_data(MEM_key_data),
        .r_rdata(MEM_r_rdata),
        .addr_out(addr_out),   
        .r_wdata(MEM_MemData),
        .write_data(write_data),
        .LEDCtrl(MEM_LEDCtrl),
        .SegCtrl(MEM_SegCtrl)
    );



module MEM_WB(
    // Inputs
    input clk, rstn,
    input        MEM_MemtoReg,
    input        MEM_RegWrite,
    input        MEM_ioWrite,
    input        MEM_SegCtrl,
    input        MEM_LEDCtrl,

    input [4:0]  MEM_rd_addr
    input [31:0] MEM_ALUResult,
    input [31:0] MEM_MemData,

    // Outputs
    output reg        WB_MemtoReg,
    output reg        WB_RegWrite,
    output reg        WB_ioWrite,
    output reg        WB_SegCtrl,
    output reg        WB_LEDCtrl,

    output reg [4:0]  WB_rd_addr
    output reg [31:0] WB_ALUResult,
    output reg [31:0] WB_MemData,
    );

    LED_con led(
        .clk(cpu_clk),
        .rstn(rstn),
        .base(WB_base),
        .LEDCtrl(WB_LEDCtrl),
        .SegCtrl(WB_SegCtrl),
        .write_data(WB_MemData),
        .reg_LED(WB_reg_LED)
//        .digit_en(digit_en),
//        .sseg(sseg),
//        .sseg1(sseg1)
    );
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
    // seg seg(
    // .clk(cpu_clk),
    // .rstn(rstn),
    // .data(out),
    // .base(base),
    // .digit_en(digit_en),
    //         .sseg(sseg),
    //         .sseg1(sseg1)
    // );

    debounce conf_btn_deb(
        .clk(cpu_clk),
        .rstn(rstn),
        .key_in(conf_btn),
        .key_out(conf_btn_out)
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
        .rstn(rstn),
        .key_data(key_data_sub),
        .data_out(key_data),
        .done(key_done)
    );

//-------------------------------------------------------------
// direct connections
//-------------------------------------------------------------

    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];


endmodule
