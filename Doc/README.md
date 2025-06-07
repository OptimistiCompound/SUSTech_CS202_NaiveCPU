# SUSTech_CS202_NaiveCPU

源码托管于 GitHub，访问链接：
https://github.com/OptimistiCompound/SUSTech_CS202_NaiveCPU



## I. 开发者说明

| 开发者     | 贡献比 | 负责工作                          |
| --------- | ----- | -------------------------------- |
| 钟庸       | 33.3% | 单周期CPU子模块的硬件实现，流水线CPU的硬件实现，硬件仿真测试 |
| 吴鎏亿     | 33.3% | 测试场景汇编代码编写，仿真测试及上班测试 |
| 王朝贺     | 33.3% | IO及外设模块的编写，硬件仿真测试 |



## II. CPU特性 & 设计说明

### 1. ISA

| Inst Name | FMT | Opcode  | funct3 | funct7 | Description                          |
| --------- | --- | ------- | ------ | ------ | ------------------------------------ |
| add       | R   | 0110011 | 0x0    | 0x00   | rd = rs1 + rs2                       |
| sub       | R   | 0110011 | 0x0    | 0x20   | rd = rs1 - rs2                       |
| xor       | R   | 0110011 | 0x4    | 0x00   | rd = rs1 ^ rs2                       |
| or        | R   | 0110011 | 0x6    | 0x00   | rd = rs1 \| rs2                      |
| and       | R   | 0110011 | 0x7    | 0x00   | rd = rs1 & rs2                       |
| sll       | R   | 0110011 | 0x1    | 0x00   | rd = rs1 << rs2                      |
| srl       | R   | 0110011 | 0x5    | 0x00   | rd = rs1 >> rs2 (logical)            |
| sra       | R   | 0110011 | 0x5    | 0x20   | rd = rs1 >> rs2 (arithmetic)         |
| slt       | R   | 0110011 | 0x2    | 0x00   | rd = (rs1 < rs2) ? 1 : 0             |
| sltu      | R   | 0110011 | 0x3    | 0x00   | rd = (rs1 < rs2) ? 1 : 0 (unsigned)  |
| addi      | I   | 0010011 | 0x0    | -      | rd = rs1 + imm                       |
| xori      | I   | 0010011 | 0x4    | -      | rd = rs1 ^ imm                       |
| ori       | I   | 0010011 | 0x6    | -      | rd = rs1 \| imm                      |
| andi      | I   | 0010011 | 0x7    | -      | rd = rs1 & imm                       |
| slli      | I   | 0010011 | 0x1    | -      | rd = rs1 << imm[4:0]                 |
| srli      | I   | 0010011 | 0x5    | -      | rd = rs1 >> imm[4:0] (logical)       |
| srai      | I   | 0010011 | 0x5    | -      | rd = rs1 >> imm[4:0] (arithmetic)    |
| slti      | I   | 0010011 | 0x2    | -      | rd = (rs1 < imm) ? 1 : 0             |
| sltiu     | I   | 0010011 | 0x3    | -      | rd = (rs1 < imm) ? 1 : 0 (unsigned)  |
| lb        | I   | 0000011 | 0x0    | -      | rd = sign-ext(M[rs1+imm][7:0])       |
| lh        | I   | 0000011 | 0x1    | -      | rd = sign-ext(M[rs1+imm][15:0])      |
| lw        | I   | 0000011 | 0x2    | -      | rd = M[rs1+imm][31:0]                |
| lbu       | I   | 0000011 | 0x4    | -      | rd = zero-ext(M[rs1+imm][7:0])       |
| lhu       | I   | 0000011 | 0x5    | -      | rd = zero-ext(M[rs1+imm][15:0])      |
| sb        | S   | 0100011 | 0x0    | -      | M[rs1+imm][7:0] = rs2[7:0]           |
| sh        | S   | 0100011 | 0x1    | -      | M[rs1+imm][15:0] = rs2[15:0]         |
| sw        | S   | 0100011 | 0x2    | -      | M[rs1+imm][31:0] = rs2[31:0]         |
| beq       | B   | 1100011 | 0x0    | -      | if (rs1 == rs2) PC += imm            |
| bne       | B   | 1100011 | 0x1    | -      | if (rs1 != rs2) PC += imm            |
| blt       | B   | 1100011 | 0x4    | -      | if (rs1 < rs2) PC += imm             |
| bge       | B   | 1100011 | 0x5    | -      | if (rs1 >= rs2) PC += imm            |
| bltu      | B   | 1100011 | 0x6    | -      | if (rs1 < rs2) PC += imm (unsigned)  |
| bgeu      | B   | 1100011 | 0x7    | -      | if (rs1 >= rs2) PC += imm (unsigned) |
| jal       | J   | 1101111 | -      | -      | rd = PC+4; PC += imm                 |
| jalr      | I   | 1100111 | 0x0    | -      | rd = PC+4; PC = rs1 + imm            |
| lui       | U   | 0110111 | -      | -      | rd = imm << 12                       |
| auipc     | U   | 0010111 | -      | -      | rd = PC + (imm << 12)                |
| mul       | R   | 0110011 | 0x0    | 0x01   | rd = (rs1 * rs2)[31:0]               |
| fadd.s    | -   | -       | -      | -      | rd = rs1 + rs2                       |

- 参考ISA：RV32I, RV32F, RV32M
- 寻址空间：哈佛架构



### 2. 引脚说明

|引脚|规格|名称|功能|
| ---- | ---- | ---- | ---- |
|R11|input|start_pg|接收uart数据|
|V1|input|conf_btn|数据输入确认按键|
|P17|input|clk|时钟引脚|
|P15|input|rstn_fpga|系统复位按键|
|U4|input|btn1|debug模式暂时解绑按键|
|R15|input|btn2|debug模式永久解绑按键|
|R17|input|btn3|debug模式主动进入按键|
|K5|input|ps2_clk|PS2 接口时钟引脚|
|L4|input|ps2_data|PS2 接口数据引脚|
|T3|input|base|数码管显示进制(0 for hex, 1 for dex)|
|N5|input|rx|UART 接收引脚|
|T4|output|tx|UART 发送引脚|
|V5|input|switch_d[8]|测试场景编号输入 0 位|
|V2|input|switch_d[9]|测试场景编号输入 1 位|
|U2|input|switch_d[10]|测试场景编号输入 2 位|
|U3|input|switch_d[11]|测试场景编号输入 3 位|
|R1|input|switch_d[0]|测试数据输入 0 位|
|N4|input|switch_d[1]|测试数据输入 1 位|
|M4|input|switch_d[2]|测试数据输入 2 位|
|R2|input|switch_d[3]|测试数据输入 3 位|
|P2|input|switch_d[4]|测试数据输入 4 位|
|P3|input|switch_d[5]|测试数据输入 5 位|
|P4|input|switch_d[6]|测试数据输入 6 位|
|P5|input|switch_d[7]|测试数据输入 7 位|
|G2|output|digit_en[7]|七段数码管位选引脚 7|
|C2|output|digit_en[6]|七段数码管位选引脚 6|
|C1|output|digit_en[5]|七段数码管位选引脚 5|
|H1|output|digit_en[4]|七段数码管位选引脚 4|
|G1|output|digit_en[3]|七段数码管位选引脚 3|
|F1|output|digit_en[2]|七段数码管位选引脚 2|
|E1|output|digit_en[1]|七段数码管位选引脚 1|
|G6|output|digit_en[0]|七段数码管位选引脚 0|
|D4|output|sseg[6]|七段数码管段选引脚 6|
|E3|output|sseg[5]|七段数码管段选引脚 5|
|D3|output|sseg[4]|七段数码管段选引脚 4|
|F4|output|sseg[3]|七段数码管段选引脚 3|
|F3|output|sseg[2]|七段数码管段选引脚 2|
|E2|output|sseg[1]|七段数码管段选引脚 1|
|D2|output|sseg[0]|七段数码管段选引脚 0|
|H2|output|sseg[7]|七段数码管段选引脚 7|
|B4|output|sseg1[6]|七段数码管段选引脚 6（另一组）|
|A4|output|sseg1[5]|七段数码管段选引脚 5（另一组）|
|A3|output|sseg1[4]|七段数码管段选引脚 4（另一组）|
|B1|output|sseg1[3]|七段数码管段选引脚 3（另一组）|
|A1|output|sseg1[2]|七段数码管段选引脚 2（另一组）|
|B3|output|sseg1[1]|七段数码管段选引脚 1（另一组）|
|B2|output|sseg1[0]|七段数码管段选引脚 0（另一组）|
|D5|output|sseg1[7]|七段数码管段选引脚 7（另一组）|
|K3|output|reg_LED[0]|LED指示灯引脚 0|
|M1|output|reg_LED[1]|LED指示灯引脚 1|
|L1|output|reg_LED[2]|LED指示灯引脚 2|
|K6|output|reg_LED[3]|LED指示灯引脚 3|
|J5|output|reg_LED[4]|LED指示灯引脚 4|
|H5|output|reg_LED[5]|LED指示灯引脚 5|
|H6|output|reg_LED[6]|LED指示灯引脚 6|
|K1|output|reg_LED[7]|LED指示灯引脚 7|
|K2|output|reg_LED[8]|LED指示灯引脚 8|
|J2|output|reg_LED[9]|LED指示灯引脚 9|
|J3|output|reg_LED[10]|LED指示灯引脚 10|
|H4|output|reg_LED[11]|LED指示灯引脚 11|
|J4|output|reg_LED[12]|LED指示灯引脚 12|
|G3|output|reg_LED[13]|LED指示灯引脚 13|
|G4|output|reg_LED[14]|LED指示灯引脚 14|
|F6|output|reg_LED[15]|LED指示灯引脚 15|



### 3. 各模块接口定义


Controller

| Port                      | Description                         |
| --------------------      | ----------------------------------- |
| `input [31:0] inst`       | 32位指令输入                             |
| `input [31:0] ALUResult`  | ALU运算结果                               |
| `input zero`              | 分支跳转决定信号（1: 跳转）               |
| `output [1:0] ALUOp`      | 2位ALU操作码                            |
| `output ALUSrc`           | ALU操作数选择（0=寄存器ReadData2，1=立即数imm32） |
| `output MemRead`          | 内存读使能                               |
| `output MemWrite`         | 内存写使能                               |
| `output MemtoReg`         | 写回数据选择（0=ALU结果，1=内存数据）              |
| `output RegWrite`         | 寄存器写使能                              |
| `output ioRead`           | IO读使能                                  |
| `output ioWrite`          | IO写使能                                  |

IFetch

| Port                     | Description              |
|--------------------------|--------------------------|
| `input clk`              | 时钟信号                  |
| `input rst`              | 低电平有效复位信号           |
| `input [31:0] imm32`     | 扩展32位立即数            |
| `input Branch`           | 分支控制信号               |
| `input upg_rst_i`        | uart复位信号    |
| `input upg_clk_i`        | uart时钟信号         |
| `input upg_wen_i`        | uart写使能信号，高电平有效 |
| `input [14:0] upg_adr_i` | uart地址输入|
| `input [31:0] upg_dat_i` | uart数据输入|
| `input upg_done_i`       | uart当前命令输入完成       |
| `output [31:0] inst`     | 32位指令输出，送往译码阶段     |
| `output [31:0] pc4_i`    | 预计算的下一条指令地址（PC+4） |

Decoder

| Port                     | Description               |
| ------------------------ | ------------------------- |
| `input clk`              | 时钟信号输入，同步译码器操作            |
| `input rstn`             | 低电平有效复位信号                 |
| `input [31:0] ALUResult` | 来自ALU的32位运算结果             |
| `input [31:0] MemData`   | 来自数据存储器的32位读取数据           |
| `input [31:0] pc4_i`     | 当前指令地址+4的值                |
| `input regWrite`         | 寄存器写使能信号                  |
| `input MemtoReg`         | 回写数据选择信号（0=ALU结果，1=存储器数据） |
| `input [31:0] inst`      | 32位指令输入                   |
| `output [31:0] rdata1`   | rs1值                      |
| `output [31:0] rdata2`   | rs2值                      |
| `output [31:0] imm32`    | 扩展后32位立即数                 |


ALU

| Port                          | Description                                  |
| ----------------------------- | -------------------------------------------- |
| `input [31:0] ReadData1`      | 来自寄存器rs1的32位数据输入                             |
| `input [31:0] ReadData2`      | 来自寄存器rs2的32位数据输入                             |
| `input [31:0] imm32`          | 扩展后32位立即数                                    |
| `input ALUSrc`                | 多路选择器控制信号，决定第二个操作数来源（1: imm32, 0: ReadData2） |
| `input [1:0] ALUOp`           | 2位ALU操作控制信号                                  |
| `input [2:0] funct3`          | 来自指令的3位功能码                                   |
| `input [6:0] funct7`          | 来自指令的7位功能码                                   |
| `output reg [31:0] ALUResult` | 32位ALU运算结果输出                                 |
| `output zero`                 | 零标志位输出，用于分支指令判断（1: 要跳转）                     |


MemOrIO

| Port                     | Description                          |
|--------------------------|--------------------------------------|
| `input mRead`            | 读内存控制信号                        |
| `input mWrite`           | 写内存控制信号                        |
| `input ioRead`           | 读IO控制信号                         |
| `input ioWrite`          | 写IO控制信号                         |
| `input conf_btn_out`     | 读取自按键的信号                       |
| `input [31:0] addr_in`   | 读取自ALU的运算结果                       |
| `input [31:0] m_rdata`   | 读取自dMem的数据                     |
| `input [11:0] switch_data` | 读取自Switch的数据           |
| `input [3:0] key_data`   | 读取自Keyboard的数据          |
| `input [31:0] r_rdata`   | 读取自Reg的数据                      |
| `output [31:0] addr_out` | 输出地址，访问dMem                             |
| `output [31:0] r_wdata`  | 写回Reg的数据（Load）              |
| `output [31:0] write_data` | 写回Mem或者IO的数据（Store）                  |
| `output LEDCtrl`         | LED控制信号                         |
| `output SegCtrl`         | Seg控制信号                         |

DMem
|Port| Description|
|------ | ---------|
|`input clk`|时钟信号|
|`input MemRead`|读内存控制信号|
|`input MemWrite`|写内存控制信号|
|`input [14:0] addr`|读内存的地址|
|`input [31:0] din`|写内存的数据|
|`input upg_rst_i`|uart 复位信号|
|`input upg_clk_i`|uart 时钟信号|
|`input upg_wen_i`|uart 写使能信号|
|`input [13:0] upg_addr_i`|uart 输入内存的地址|
|`input [31:0] upg_data_i`|uart 输入内存的数据|
|`input [31:0] upg_done_i`|uart 写入完毕标识|
|`output [31:0] dout`|指令信息|

RegisterFile
|Port| Description|
|------ | ---------|
|`input clk`|时钟信号|
|`input rstn`|复位信号|
|`input [4:0] raddr1`|寄存器一地址|
|`input [4:0] raddr2`|寄存器二地址|
|`input [4:0] waddr`|目标寄存器地址|
|`input [31:0] wdata`|写入数据|
|`input regWrite`|寄存器写使能信号|
|`output [31:0] rdata1`|寄存器一值|
|`output [31:0] rdata2`|寄存器二值|

ImmGen
|Port| Description|
|------ | ---------|
|`input inst`|指令信息|
|`output [31:0] imm32`|经过拓展的立即数|

debounce
|Port| Description|
|------ | ---------|
|`input clk`|系统时钟|
|`input rstn`|复位信号|
|`input key_in`|输入键值|
|`output key_out`|消抖后键值|

clk_wiz

| Port     | Description                     |
| -------- | ------------------------------- |
| `input clk_in1`  | EGO1 的时钟信号，频率为 100MHz  |
| `output clk_out1` | 单周期时钟信号，频率为 23MHz    |
| `output clk_out2`| Uart 接口时钟信号，频率为 10MHz |

LED_con

| Port                        | Description |
| --------------------------- | ----------- |
| `input clk`                 | 时钟信号    |
| `input rstn`                | 复位信号    |
| `input base`                | 显示数字的进制|
| `input LEDCtrl`             | led显示控制信号|
| `input SegCtrl`             | 数码管显示控制信号|
| `input [31:0] write_data`   | 写入的显示数值|
| `output reg [15:0] reg_LED` | led显示信号|
| `output [7:0] digit_en`     |数码管位选信号 |
| `output [7:0] sseg`         |低位数码管段选信号|
| `output [7:0] sseg1`        |高位数码管段选信号|

seg

| Port                        | Description                      |
| --------------------------- | -------------------------------- |
| `input clk`                 | 时钟信号 |
| `input rstn`                | 复位信号|
| `input [31:0]data`          | 输入的即将显示的值 |
| `input base`                | 进制控制(0 for hex, 1 for dex)|
| `output reg [7:0] digit_en` | 数码管位选信号 |
| `output reg [7:0] sseg`     | 低位数码管段选信号|
| `output reg [7:0] sseg1`    | 高位数码管段选信号|



### 5. 对外设IO的支持
使用MMIO进行io，外设基地址如下，在汇编中采用轮询的方式进行访问。

|外设名称|基地址|
|-|-|
|`LED`|32'hFFFFFC60|
|`SWITCH`|32'hFFFFFC64|
|`KEY`|32'hFFFFFC68|
|`SEG`|32'hFFFFFC6C|
|`Btn`|32'hFFFFFC70|
|`KeyCtr`|32'hFFFFFC74|



## IV. 方案分析说明

#### 按键消抖

硬件上的按钮消抖和软件上的按钮消抖都进行过试验。

- 硬件按键消抖：思路是检测到按钮相连的信号发生变化时，对按键产生的抖动信号进行处理，检测到稳定按键信号时，才输出稳定的按键状态信号。
- 软件按钮消抖：采用如下的代码段，通过循环不断地读取按键引脚的状态，当按钮完成信号从 0-1-1 的变化时，确认按钮检测结束，执行接下来的指令。

```assembly
loop1_t1111:
    	lw a6, 112(a5)
    	beq a6, x0, loop1_t1111
loop2_t1111:
    	lw a6, 112(a5)
    	bne a6, x0, loop2_t1111
```

**分析比较**

​	硬件上响应速度块，不会因为软件的其他任务执行而受到影响。但需要额外的硬件电路，增加了硬件成本和复杂度。而软件上则不需要额外的硬件电路，节省硬件资源。但需要占用 CPU 的运行时间，可能会受到软件中其他任务执行的影响，导致消抖的响应速度相对较慢。

​	最终我们两种按钮消抖都采用。原因是在执行指令的过程中，若从第一次硬件上读取稳定的输入信号 1 就开始进行下一步执行，则有可能在按钮信号变为 0 之前就执行结束对应的指令，进入下一次需要读取按钮信号的步骤，最终导致连点。

>一种可行的解决方案是，每次读取到稳定的输入信号 1 后，将输入信号维持数个时钟周期后主动变为 0。但是需要考虑维持的时钟周期数量，和CPU运行速度相关，单周期和 Pipeline 不兼容。

#### 浮点数加减运算

#### 浮点数加减运算
硬件上的浮点数加减运算和软件上的浮点数加减运算都进行过试验。

- 硬件浮点数加减运算：思路是设计专门的硬件模块来处理浮点数的加减运算，将两个浮点数的各位进行对齐、加减等操作，并输出运算结果。下面是一个浮点加法的硬件模块代码示例：

```verilog
module Float_Addition(
    input [31:0]operand1,
    input [31:0]operand2,
    output reg [31:0]addition_result
);
```

我们需要在ALU中示例化对应的模块，然后在 `ALUop`、`ALU control` 中增加对应的case即可。

- 软件浮点数加减运算：采用如下的代码段，通过编写软件代码来实现浮点数的加减运算，将浮点数转换为整数或其他形式进行运算，最后再转换回浮点数格式。使用基础指令集即可实现。下面是一个浮点加法的软件代码示例：

```assembly
test1011_1:# addition of float

	lw s0, 128(x0)
	andi t0, s0, 0xFF     
	srli t1, t0, 7         
    	srli a0, t0, 4         
    	andi a0, a0, 0x07    
    	andi a1, t0, 0x0F     
    	slli a1, a1, 4       
    	addi a1, a1, 256         

    	li t2, 3         
   	sub a2, a0, t2   
    	bgez a2, shift_num1
    	neg a2, a2            
    	srl a1, a1, a2      
    	jal num1_done
shift_num1:
    	sll a1, a1, a2       
num1_done:
    	mv s2, a1             
    	mv s3, t1  
        ...
```

**分析比较**

​	硬件上运算速度快，可以在一个或几个时钟周期内完成运算，大大提高了浮点数运算的效率。但需要在硬件设计中增加相应的模块，增加了硬件的复杂性和设计难度，同时也会占用更多的硬件资源。而软件上不需要额外的硬件模块，能充分利用现有的 CPU 资源。但运算速度相对较慢，需要执行多条指令才能完成运算，相对来说耗时较多。

​	最终我们选择两个方案都实现了。在展示环节，选择了使用软件方案实现浮点数加减运算。原因是使用软件方案可以节省硬件资源，同时通过优化软件代码，也能满足项目对浮点数运算的需求，且具有更好的灵活性和可维护性。

## V. 系统上板使用说明

在开发板上，主要使用下方的拨码开关和右边的按钮进行控制。

**输入控制**

- 拨码开关 `sw0-R1`, `sw1-N4`, ... `sw7-P5` 表示输入整数（从低位到高位），
- 拨码开关 `sw7-sw4` 表示测试场景编号，
- 第一个拨码开关 `sw0` 开关表示 
- 第二个拨码开关 `sw1` 表示16进制和十进制转换
- 左边按钮 `S3` 表示输入数据确认按键
- 中间从上到下 `S4`, `S2`, `S1` 依次控制 debug
- 右边按钮 `S0` 控制 Uart 信号传输

**显示信息**

- 数码管信息，显示内存地址中 `32'hFFFFFC6C` 对应的数据
- LED灯信息，显示内存地址中 `32'hFFFFFC60`  对应的数据

![image](https://github.com/OptimistiCompound/SUSTech_CS202_NaiveCPU/blob/main/Doc/user_guide.jpg)

## VI. 自测试说明

>以表格的方式罗列出测试方法（仿真、上板）、测试类型（单元、集成）、测试用例描述、测试结果（通过、不通过）；以及最终的测试结论。

| 测试方法 | 测试类型 |      测试用例描述      | 测试结果 |                             备注                             |
| :------: | :------: | :--------------------: | :------: | :----------------------------------------------------------: |
|   仿真   |   单元   |        ALU单元         |   通过   | 使用Verilator，测试所有基础指令中 ALU 的返回结果（比 OJ 中有更多类型的指令） |
|   仿真   |   单元   |        Decoder         |   通过   |             使用Verilator，测试寄存器和控制信号              |
|   仿真   |   单元   |       MemIO单元        |   通过   |            使用Verilator，测试 MemIO 能否正常运行            |
|   仿真   |   单元   | 测试汇编代码中测试场景 |   通过   |      主要测试测试场景二，将需要输入的部分使用ecall代替       |
|   仿真   |   单元   | 测试键盘数据输入和显示 |   通过   |           可以通过键盘上的按键和 ENTER 键进行输入            |
|   上板   |   集成   |     测试单周期CPU      |  不通过  |                   没经过仿真，无法显示信息                   |
|   仿真   |   集成   |     测试单周期CPU      |   通过   |          发现主模块中有 wire 连接错误，或者名字错误          |
|   上板   |   集成   |     测试单周期CPU      |   通过   |             能过基础的测试场景，其中也经过 Debug             |
|   仿真   |   集成   |     测试 Pipeline      |  不通过  |                                                              |
|   仿真   |   集成   |     测试 Pipeline      |   通过   |                                                              |
|   上板   |   集成   |     测试 Pipeline      |  不通过  |                                                              |



## VII. 启发和帮助



流水线参考：

https://github.com/Azalea8/riscv_cpu

https://github.com/ultraembedded/riscv

## VIII. 问题及总结

**第一阶段的问题**

在准备阶段，我们由于没有完全理解单周期CPU的功能，一直没有理解如何让 CPU 能够实现测试场景的内容。后来经过学习和了解，我们才发现需要



**上板问题**

- 我们在使用 vivado 的过程中，经常会出现从 vivado 中导入 git 仓库中对应文件夹的代码时，往往没有和 Vscode中实时更新的保持一致，导致测试失败。
- 在仿真过程中



# Bonus


## 1. 其他外设：键盘

>其他说明见https://github.com/OptimistiCompound/SUSTech_CS202_NaiveCPU/Doc/Keyboard.md

TODO:


## 2. UART接口

TODO:


## 3. 流水线CPU

能够正确处理`Structure hazard`, `Data hazard`, `Control hazard`，实现了`MEM-EX`, `EX-EX`, `MEM-MEM`三种`forwarding`，实现了`stall`的控制停顿，实现了`flush`清空中间寄存器。


### 接口定义

> [!NOTE]
> 流水线CPU与单周期CPU大部分子模块是重合的，即使一些子模块增加了端口，其基本功能的实现是相同或相似的。中间寄存器的端口不言自明，遂不赘述。此处仅仅介绍与Data hazard处理相关的模块

ForwardingController

| Port                        | Description                      |
|-----------------------------|-----------------------------------|
| input MEM_RegWrite          | MEM阶段寄存器写使能信号（1表示需要写回寄存器） |
| input WB_RegWrite           | WB阶段寄存器写使能信号（1表示需要写回寄存器） |
| input [4:0] EX_rs1_addr     | EX阶段的源寄存器1地址             |
| input [4:0] EX_rs2_addr     | EX阶段的源寄存器2地址             |
| input [4:0] MEM_rs2_addr    | MEM阶段的源寄存器2地址（用于存储指令数据前递） |
| input [4:0] MEM_rd_addr     | MEM阶段的目标寄存器地址           |
| input [4:0] WB_rd_addr      | WB阶段的目标寄存器地址           |
| input [31:0] EX_rs1_v       | EX阶段从寄存器文件读取的rs1原始值  |
| input [31:0] EX_rs2_v       | EX阶段从寄存器文件读取的rs2原始值  |
| input [31:0] MEM_ALUResult  | MEM阶段的ALU计算结果（用于数据前递） |
| input [31:0] MEM_rs2_v      | MEM阶段的rs2寄存器值（用于存储数据前递） |
| input [31:0] WB_mdata       | WB阶段要写回寄存器文件的数据      |
| output reg [31:0] true_ReadData1 | 前递选择后的最终rs1值（送往ALU） |
| output reg [31:0] true_ReadData2 | 前递选择后的最终rs2值（送往ALU） |
| output reg [31:0] true_m_wdata | 前递选择后的存储数据（送往数据存储器） |

HazardDetector

| Port                        | Description                      |
| --------------------------- | -------------------------------- |
| input EX_memRead            | EX 阶段是否为 load 指令（1 表示 load） |
| input [4:0] ID_rs1_addr     | ID 阶段的源寄存器 1 地址         |
| input [4:0] ID_rs2_addr     | ID 阶段的源寄存器 2 地址         |
| input [4:0] EX_rd_addr      | EX 阶段的目标寄存器地址          |
| input [4:0] ID_rd_addr      | ID 阶段的目标寄存器地址          |
| output reg Pause            | 流水线暂停信号（1 表示需要暂停） |


## 流水线CPU特性

### **Data Hazard处理**

我们实现了三种forwarding以及一个stall控制，能够正确处理所有data hazard的情况。forwarding由`ForwardingController`控制，stall由`HazardDetector`输出的`Pause`信号控制


>三种forwarding: `MEM-EX`, `EX-EX`, `MEM-MEM`
>
>stall的检测：load之后的下一条指令的rs1或者rs2是load指令的rd，必须stall一个周期

#### 实现细节：

我们通过不同中间寄存器存储的`rd`,`rs1`,`rs2`寄存器的关系，以及`RegWrite`信号来判断是否以及如何forwarding。

`EX-EX` 在上一条指令的ALU结果是下一条指令的源寄存器的时候发生，即

> EX/MEM.rd = ID/EX.rs1 or ID/EX.rs2
>
> true_ReadData1 = MEM_ALUResult;
> 
> true_ReadData2 = MEM_ALUResult;

`EX-MEM` 在上一条指令的访存结果是隔一条指令的源寄存器，即

> MEM/WB.rd = ID/EX.rs1 or /EX.rs2
>
> true_ReadData1 = WB_mdata;
>
> true_ReadData2 = WB_mdata;

`MEM-MEM` 即`lw-sw forwarding`，上一条指令从MEM中读取的数据需要在下一条指令写回内存：

> MEM/WB.rd = EX/MEM.rs2，这里只有rs2是因为sw将rs2写回MEM

> [!WARNING]
> 当`EX-EX`和`EX-MEM`的条件同时满足的时候选择`EX-EX`，因为此时EX中的运算结果更新，所以EX/EX的赋值语句一定要在MEM/EX之后，即可覆盖MEM/EX的结果


``` verilog
always @(*) begin
    true_ReadData1 = EX_rs1_v;
    true_ReadData2 = EX_rs2_v;
    true_m_wdata   = MEM_rs2_v;

    if (WB_RegWrite  && WB_rd_addr  != 0 && (WB_rd_addr  == EX_rs1_addr) ) // MEM/EX forwarding to rs1
        true_ReadData1 = WB_mdata;
    if (WB_RegWrite  && WB_rd_addr  != 0 && (WB_rd_addr  == EX_rs2_addr) ) // MEM/EX forwarding to rs2
        true_ReadData2 = WB_mdata;
    if (MEM_RegWrite && MEM_rd_addr != 0 && (MEM_rd_addr == EX_rs1_addr) ) // EX/EX forwarding to rs1
        true_ReadData1 = MEM_ALUResult;
    if (MEM_RegWrite && MEM_rd_addr != 0 && (MEM_rd_addr == EX_rs2_addr) ) // EX/EX forwarding to rs2
        true_ReadData2 = MEM_ALUResult;
    if (WB_RegWrite  && WB_rd_addr  != 0 && (WB_rd_addr  == MEM_rs2_addr) )// MEM/MEM forwading to rs2
        true_m_wdata = WB_mdata;
end
```


Stall出现在上一条指令load的rd寄存器是下一条指令的rs1或者rs2寄存器，此时必须停顿一个周期，然后使用`MEM-EX`保证ALU拿到正确的源寄存器值。

``` verilog
    always @(*) begin
        if ( (EX_memRead) && (ID_rd_addr != 0) && (EX_rd_addr == ID_rs1_addr || EX_rd_addr == ID_rs2_addr) )
            Pause = 1'b1;
        else 
            Pause = 1'b0;
    end
```


#### **Control Hazard处理**

我们的CPU没有分支预测功能，而是采取直接“冲刷”的策略，通过`IFetch`模块中的`Flush`信号控制。当发生控制冒险的时候，简单地将`IF_ID`、`ID_EX`和`EX_MEM`中的寄存器置0，将之前正在执行的指令清空。

#### 实现细节：

在`IFetch`中给出`Flush`信号，当`Flush`为高电平时生效。此时，`IF-ID`，`ID-EX`，`EX-MEM`里的中间寄存器全部置0,相当于将原先取到的2条指令清除，然后`IFetch`根据PC跳转拿到实际执行的指令。

``` verilog
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
```