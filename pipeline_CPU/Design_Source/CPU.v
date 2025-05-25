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
// 冒险
wire Pause; // 数据冒险停顿
wire Flush; // 控制冒险刷新

// IF 阶段
    wire [31:0] IF_pc4_i;
    wire [31:0] IF_pc_i;
    wire [31:0] IF_inst;

// ID 阶段
    wire [31:0] ID_pc_i;
    wire [31:0] ID_pc4_i;
    wire [31:0] ID_inst;

    wire        ID_Branch;
    wire        ID_Jump;
    wire        ID_Jalr;
    wire [1:0]  ID_Utype;
    wire [1:0]  ID_ALUOp;
    wire        ID_ALUSrc;
    wire        ID_MemRead;
    wire        ID_MemWrite;
    wire        ID_MemtoReg;
    wire        ID_RegWrite;
    // wire        ID_ioRead;
    // wire        ID_ioWrite; 
    wire [4:0]  ID_rs1_addr;
    wire [4:0]  ID_rs2_addr;
    wire [4:0]  ID_rd_addr;
    wire [31:0] ID_rs1_v;
    wire [31:0] ID_rs2_v;   
    wire [31:0] ID_imm32;   
    wire [2:0]  ID_funct3;  
    wire [6:0]  ID_funct7;  

// EX 阶段
    wire [31:0] EX_pc_i;
    wire [31:0] EX_pc4_i;
    wire        EX_Branch;
    wire        EX_zero;
    wire        EX_Jump;
    wire        EX_Jalr;
    wire [1:0]  EX_Utype;
    wire [1:0]  EX_ALUOp;
    wire        EX_ALUSrc;
    wire        EX_MemRead;
    wire        EX_MemWrite;
    wire        EX_MemtoReg;
    wire        EX_RegWrite;
    // wire        EX_ioRead;
    // wire        EX_ioWrite;

    wire [4:0]  EX_rs1_addr;
    wire [4:0]  EX_rs2_addr;
    wire [4:0]  EX_rd_addr;
    wire [31:0] EX_rs1_v;
    wire [31:0] EX_rs2_v;
    wire [31:0] EX_addr_in;
    wire [31:0] EX_m_rdata;
    wire [31:0] EX_r_rdata;
    wire [31:0] EX_ALUResult;
    wire [31:0] EX_imm32;
    wire [2:0]  EX_funct3;
    wire [6:0]  EX_funct7;

// MEM 阶段
    wire [31:0] MEM_pc_i;
    wire [31:0] MEM_pc4_i;
    wire        MEM_Branch;
    wire        MEM_zero;
    wire        MEM_Jump;
    wire        MEM_Jalr;
    wire        MEM_MemRead;
    wire        MEM_MemWrite;
    wire        MEM_MemtoReg;
    wire        MEM_RegWrite;
    // wire        MEM_ioRead;
    // wire        MEM_ioWrite;
    wire [4:0]  MEM_rs2_addr;
    wire [4:0]  MEM_rd_addr;
    wire [31:0] MEM_ALUResult;
    wire [31:0] MEM_rs2_v;
    wire [31:0] MEM_imm32;
    wire [2:0]  MEM_funct3;
    wire [31:0] MEM_addr_in;
    wire [31:0] MEM_m_rdata;
    wire [31:0] MEM_r_rdata;
    wire [31:0] MEM_MemData;

// WB 阶段
    wire [31:0] WB_pc_i;
    wire [31:0] WB_pc4_i;
    wire        WB_MemtoReg;
    wire        WB_RegWrite;
    wire [2:0]  WB_funct3;
    // wire        WB_ioWrite;
    wire [4:0]  WB_rd_addr;
    wire [31:0] WB_ALUResult;
    wire [31:0] WB_MemData;

// ForwardingController输出
    wire [31:0] true_ReadData1;
    wire [31:0] true_ReadData2;
    wire [31:0] true_m_wdata;

// MMIO and dMem
    wire [31:0] addr_out;
    wire [31:0] MemData;
    wire [31:0] write_data;
    wire        LEDCtrl;
    wire        SegCtrl;
    wire        conf_btn_out;  

// Keyboard
    wire [7:0] key_data_sub;
    wire [7:0] key_data;
    wire key_done;

    wire cpu_clk;
    wire upg_clk;   

//-------------------------------------------------------------
// Instantiation of modules
//-------------------------------------------------------------
    reg upg_rst;
    wire start_pg_debounce;
    wire upg_clk_w;
    wire upg_wen_w;
    wire [14:0] upg_addr_w;
    wire [31:0] upg_data_w;
    wire upg_done_w;
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

    clk_wiz cpuclk(
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
        .upg_adr_o(upg_addr_w[14:0]),
        .upg_dat_o(upg_data_w),
        .upg_done_o(upg_done_w),
        .upg_tx_o(tx)
    );

    IFetch ifetch(
        .clk(cpu_clk),
        .rstn(rstn),
        .Pause(Pause),
        .Branch(MEM_Branch),
        .zero(MEM_zero),
        .Jump(MEM_Jump),
        .Jalr(MEM_Jalr),
        .ALUResult(MEM_ALUResult),   // for Jalr
        .imm32(MEM_imm32),          // for Branch || Jump
        .MEM_pc_i(MEM_pc_i),        // for Branch || Jump
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_w),
        .upg_adr_i(upg_addr_w),
        .upg_dat_i(upg_data_w),
        .inst(IF_inst),
        .pc4_i(IF_pc4_i),
        .pc_i(IF_pc_i),
        .Flush(Flush)
    );


    IF_ID if_id(
        // in
        .clk(cpu_clk), .rstn(rstn), .Pause(Pause), .Flush(Flush),
        .IF_pc4_i(IF_pc4_i),
        .IF_pc_i(IF_pc_i),
        .IF_inst(IF_inst),
        // out
        .ID_pc4_i(ID_pc4_i),
        .ID_pc_i(ID_pc_i),
        .ID_inst(ID_inst)
    );

    Decoder decoder(
        .clk(cpu_clk),
        .rstn(rstn),
        .WB_funct3(WB_funct3),
        .WB_rd_addr(WB_rd_addr),
        .MemData(WB_MemData),
        .pc_i(WB_pc_i),
        .regWrite(WB_RegWrite),
        .MemtoReg(WB_MemtoReg),
        .inst(IF_inst),

        .rdata1(ID_rs1_v),
        .rdata2(ID_rs2_v),
        .imm32(ID_imm32),
        .funct3(ID_funct3),
        .funct7(ID_funct7),
        .rs1_addr(ID_rs1_addr),
        .rs2_addr(ID_rs2_addr),
        .rd_addr(ID_rd_addr)
    );

    Controller controller(
        .inst(IF_inst),
        // .ALUResult(EX_ALUResult),

        .Branch(ID_Branch),
        .Jump(ID_Jump),
        .Jalr(ID_Jalr),
        .Utype(ID_Utype),
        .ALUOp(ID_ALUOp),
        .ALUSrc(ID_ALUSrc),
        .MemRead(ID_MemRead),
        .MemWrite(ID_MemWrite),
        .MemtoReg(ID_MemtoReg),
        .RegWrite(ID_RegWrite)
        // .ioRead(ID_ioRead),
        // .ioWrite(ID_ioWrite)
    );

    ForwardingController forward_ctrl(
        // Inputs
        .MEM_RegWrite(MEM_RegWrite),
        .WB_RegWrite(WB_RegWrite),
        .EX_rs1_addr(EX_rs1_addr),
        .EX_rs2_addr(EX_rs2_addr),
        .MEM_rs2_addr(MEM_rs2_addr),
        .MEM_rd_addr(MEM_rd_addr),
        .WB_rd_addr(WB_rd_addr),

        .EX_rs1_v(EX_rs1_v),
        .EX_rs2_v(EX_rs2_v),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_rs2_v(MEM_rs2_v),
        .WB_mdata(WB_MemData),

        // Outputs
        .true_ReadData1(true_ReadData1), // mux result to ALU
        .true_ReadData2(true_ReadData2), // mux result to ALU
        .true_m_wdata(true_m_wdata)   // mux result to dMem
    );

    HazardDetector Hazard(
        .EX_memRead(EX_MemRead),
        // .MEM_ioRead(MEM_ioRead),
        .ID_rs1_addr(ID_rs1_addr),
        .ID_rs2_addr(ID_rs2_addr),
        .EX_rd_addr(EX_rd_addr),
        .ID_rd_addr(ID_rd_addr),

        .Pause(Pause)
    );

    ID_EX id_ex(
        .clk(cpu_clk),
        .rstn(rstn),
        .Pause(Pause),
        .Flush(Flush),
        .ID_pc_i(ID_pc_i),
        .ID_pc4_i(ID_pc4_i),
        .ID_Branch(ID_Branch),   
        .ID_Jump(ID_Jump),
        .ID_Jalr(ID_Jalr),
        .ID_Utype(ID_Utype),
        .ID_ALUOp(ID_ALUOp),
        .ID_ALUSrc(ID_ALUSrc),
        .ID_MemRead(ID_MemRead),
        .ID_MemWrite(ID_MemWrite),
        .ID_MemtoReg(ID_MemtoReg),
        .ID_RegWrite(ID_RegWrite),
        // .ID_ioRead(ID_ioRead),
        // .ID_ioWrite(ID_ioWrite),

        .ID_rs1_addr(ID_rs1_addr),   // ID
        .ID_rs2_addr(ID_rs2_addr),
        .ID_rs1_v(ID_rs1_v),      // ID
        .ID_rs2_v(ID_rs2_v),      // ID
        .ID_rd_addr(ID_rd_addr),
        .ID_imm32(ID_imm32),      // ID
        .ID_funct3(ID_funct3),     // ID
        .ID_funct7(ID_funct7),     // ID

        .EX_pc_i(EX_pc_i),
        .EX_pc4_i(EX_pc4_i),
        .EX_Branch(EX_Branch),
        .EX_Jump(EX_Jump),
        .EX_Jalr(EX_Jalr),
        .EX_Utype(EX_Utype),
        .EX_ALUOp(EX_ALUOp),     // EX_MEM
        .EX_ALUSrc(EX_ALUSrc),
        .EX_MemRead(EX_MemRead),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemtoReg(EX_MemtoReg),
        .EX_RegWrite(EX_RegWrite),
        // .EX_ioRead(EX_ioRead),
        // .EX_ioWrite(EX_ioWrite),    // EX_MEM

        .EX_rs1_addr(EX_rs1_addr),  // EX_MEM
        .EX_rs2_addr(EX_rs2_addr),
        .EX_rs1_v(EX_rs1_v),
        .EX_rs2_v(EX_rs2_v),
        .EX_rd_addr(EX_rd_addr),
        .EX_imm32(EX_imm32),
        .EX_funct3(EX_funct3),
        .EX_funct7(EX_funct7)     // EX_MEM
    );

    ALU alu(
        .ReadData1(true_ReadData1),
        .ReadData2(true_ReadData2),
        .imm32(EX_imm32),
        .ALUSrc(EX_ALUSrc),
        .ALUOp(EX_ALUOp),
        .Utype(EX_Utype),
        .pc4_i(EX_pc4_i),
        .funct3(EX_funct3),
        .funct7(EX_funct7),
        .ALUResult(EX_ALUResult),
        .zero(EX_zero)
    );

    EX_MEM ex_mem(
        // Inputs
        .clk(cpu_clk),
        .rstn(rstn),
        .Flush(Flush),
        .EX_pc_i(EX_pc_i),
        .EX_pc4_i(EX_pc4_i),
        .EX_Branch(EX_Branch),
        .EX_zero(EX_zero),
        .EX_Jump(EX_Jump),
        .EX_Jalr(EX_Jalr),
        .EX_MemRead(EX_MemRead),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemtoReg(EX_MemtoReg),
        .EX_RegWrite(EX_RegWrite),
        // .EX_ioRead(EX_ioRead),
        // .EX_ioWrite(EX_ioWrite),
        .EX_rs2_addr(EX_rs2_addr),
        .EX_rd_addr(EX_rd_addr),
        .EX_ALUResult(EX_ALUResult),
        .EX_rs2_v(EX_rs2_v),
        .EX_funct3(EX_funct3),
        .EX_imm32(EX_imm32),

        .EX_addr_in(EX_addr_in),
        .EX_m_rdata(EX_m_rdata),
        .EX_r_rdata(EX_r_rdata),

        // Outputs
        .MEM_pc_i(MEM_pc_i),
        .MEM_pc4_i(MEM_pc4_i),
        .MEM_Branch(MEM_Branch),
        .MEM_zero(MEM_zero),
        .MEM_Jump(MEM_Jump),
        .MEM_Jalr(MEM_Jalr),
        .MEM_MemRead(MEM_MemRead),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_MemtoReg(MEM_MemtoReg),
        .MEM_RegWrite(MEM_RegWrite),
        // .MEM_ioRead(MEM_ioRead),
        // .MEM_ioWrite(MEM_ioWrite),
        .MEM_rs2_addr(MEM_rs2_addr),
        .MEM_rd_addr(MEM_rd_addr),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_rs2_v(MEM_rs2_v),
        .MEM_funct3(MEM_funct3),
        .MEM_imm32(MEM_imm32),
        .MEM_addr_in(MEM_addr_in),
        .MEM_m_rdata(MEM_m_rdata),
        .MEM_r_rdata(MEM_r_rdata)
    );

    DMem dmem(
        .clk(cpu_clk),
        .MemRead(MEM_MemRead),
        .MemWrite(MEM_MemWrite),
        .addr(addr_out[15:2]),
        .din(write_data),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_w),
        .upg_addr_i(upg_addr_w[13:0]),
        .upg_data_i(upg_data_w),
        .upg_done_i(upg_done_w),
        .dout(MemData)
    );

    MemOrIO memorio(
        .mRead(MEM_MemRead),        // read from Mem
        .mWrite(MEM_MemWrite),      // write to Mem
        // .ioRead(MEM_ioRead),       // read from IO
        // .ioWrite(MEM_ioWrite),     // write to IO
        .conf_btn_out(conf_btn),     ///////////////////////////////////////debounce
        .ALUResult(MEM_ALUResult),    // address from ALU         
        .m_rdata(MemData),
        .switch_data(switch_data),
        .key_data(key_data),
        .r_rdata(true_m_wdata),
        .addr_out(addr_out),   
        .r_wdata(MEM_MemData),
        .write_data(write_data),
        .LEDCtrl(LEDCtrl),
        .SegCtrl(SegCtrl)
    );



    MEM_WB mem_wb(
    .clk(cpu_clk),
    .rstn(rstn),
    .MEM_pc_i(MEM_pc_i),
    .MEM_pc4_i(MEM_pc4_i),
    .MEM_MemtoReg(MEM_MemtoReg),
    .MEM_RegWrite(MEM_RegWrite),
    .MEM_funct3(MEM_funct3),
    // .MEM_ioWrite(MEM_ioWrite),

    .MEM_rd_addr(MEM_rd_addr),
    .MEM_ALUResult(MEM_ALUResult),
    .MEM_MemData(MEM_MemData),

    .WB_pc_i(WB_pc_i),
    .WB_pc4_i(WB_pc4_i),
    .WB_MemtoReg(WB_MemtoReg),
    .WB_RegWrite(WB_RegWrite),
    .WB_funct3(WB_funct3),
    // .WB_ioWrite(WB_ioWrite),

    .WB_rd_addr(WB_rd_addr),
    .WB_ALUResult(WB_ALUResult),
    .WB_MemData(WB_MemData)
    );

    LED_con led(
        .clk(cpu_clk),
        .rstn(rstn),
        .base(base),
        .LEDCtrl(LEDCtrl),
        .SegCtrl(SegCtrl),
        .write_data(write_data),
        .reg_LED(reg_LED),
        .digit_en(digit_en),
        .sseg(sseg),
        .sseg1(sseg1)
    );

//assign conf_btn_out = conf_btn;
    debounce conf_btn_deb(
        .clk(cpu_clk),
        .rstn(rstn),
        .key_in(conf_btn),
        .key_out(conf_btn_out)
    );

    debounce start_pg_deb(
        .clk(cpu_clk),
        .rstn(rstn),
        .key_in(start_pg),
        .key_out(start_pg_debounce)
    );

    // keyboard_driver keyboard(
    //     .clk(cpu_clk),
    //     .rstn(rstn),
    //     .ps2_clk(ps2_clk),
    //     .ps2_data(ps2_data),
    //     .data_out(key_data_sub)
    // );

    // Keyboard_cache key_cache(
    //     .rstn(rstn),
    //     .key_data(key_data_sub),
    //     .data_out(key_data)
    // );

//-------------------------------------------------------------
// direct connections
//-------------------------------------------------------------


endmodule
