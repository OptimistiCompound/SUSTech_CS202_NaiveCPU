# SUSTech_CS202_NaiveCPU

源码托管于 GitHub，访问链接：
https://github.com/OptimistiCompound/SUSTech_CS202_NaiveCPU

## CPU特性

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
| ecall     | I   | 1110011 | 0x0    | -      | 触发环境调用                               |
| ebreak    | I   | 1110011 | 0x0    | -      | 触发调试断点                               |

- 参考ISA：RISC-V
- 寻址空间：哈佛架构

### 2. CPU接口定义

#TODO 引脚说明


## 各模块端口定义

Controller

| Port                 | Description                         |
| -------------------- | ----------------------------------- |
| `input [31:0] inst`  | 32位指令输入                             |
| `output Branch`      | beq分支控制                             |
| `output nBranch`     | bne分支控制                             |
| `output Branch_lt`   | blt，bltu分支控制                        |
| `output Branch_ge`   | bge，bgeu分支控制                        |
| `output Jump`        | jal跳转控制                             |
| `output [1:0] ALUOp` | 2位ALU操作码                            |
| `output ALUSrc`      | ALU操作数选择（0=寄存器ReadData2，1=立即数imm32） |
| `output MemRead`     | 内存读使能                               |
| `output MemWrite`    | 内存写使能                               |
| `output MemtoReg`    | 写回数据选择（0=ALU结果，1=内存数据）              |
| `output RegWrite`    | 寄存器写使能                              |

IFetch

| Port                     | Description              |
| ------------------------ | ------------------------ |
| `input clk`              | 时钟信号                     |
| `input rst`              | 低电平有效复位信号                |
| `input [31:0] imm32`     | 扩展32位立即数                 |
| `input zero`             | 标志位输入，用于条件分支判断          |
| `input Branch`           | beq分支控制                  |
| `output [31:0] inst`     | 32位指令输出，送往译码阶段           |

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
| `input ALUSrc`                | 多路选择器控制信号，决定第二个操作数来源（0: imm32, 1: ReadData2） |
| `input [1:0] ALUOp`           | 2位ALU操作控制信号                                  |
| `input [2:0] funct3`          | 来自指令的3位功能码                                   |
| `input [6:0] funct7`          | 来自指令的7位功能码                                   |
| `output reg [31:0] ALUResult` | 32位ALU运算结果输出                                 |
| `output zero`                 | 零标志位输出，用于分支指令判断（1: 结果为零）                     |
## 接口定义
|引脚|规格|名称|功能|
| ---- | ---- | ---- | ---- |
|T5|input|start_pg|接收uart数据|
|R15|input|conf_btn|数据输入确认按键|
|P17|input|clk|时钟引脚|
|S6|input|rstn|复位按键|
|K5|input|ps2_clk|PS2 接口时钟引脚|
|L4|input|ps2_data|PS2 接口数据引脚|
|L3|input|rx|UART 接收引脚|
|N2|output|tx|UART 发送引脚|
|V2|input|switch_d[8]|测试场景编号输入 0 位|
|U2|input|switch_d[9]|测试场景编号输入 1 位|
|U3|input|switch_d[10]|测试场景编号输入 2 位|
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
