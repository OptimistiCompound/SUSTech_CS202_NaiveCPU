
# ISA

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

# 进度记录

| Inst Name | FMT   | Opcode      | funct3  | funct7   | Description                              |
| --------- | ----- | ----------- | ------- | -------- | ---------------------------------------- |
| ~~add~~   | ~~R~~ | ~~0110011~~ | ~~0x0~~ | ~~0x00~~ | ~~rd = rs1 + rs2~~                       |
| ~~sub~~   | ~~R~~ | ~~0110011~~ | ~~0x0~~ | ~~0x20~~ | ~~rd = rs1 - rs2~~                       |
| ~~xor~~   | ~~R~~ | ~~0110011~~ | ~~0x4~~ | ~~0x00~~ | ~~rd = rs1 ^ rs2~~                       |
| ~~or~~    | ~~R~~ | ~~0110011~~ | ~~0x6~~ | ~~0x00~~ | ~~rd = rs1 \| rs2~~                      |
| ~~and~~   | ~~R~~ | ~~0110011~~ | ~~0x7~~ | ~~0x00~~ | ~~rd = rs1 & rs2~~                       |
| ~~sll~~   | ~~R~~ | ~~0110011~~ | ~~0x1~~ | ~~0x00~~ | ~~rd = rs1 << rs2~~                      |
| ~~srl~~   | ~~R~~ | ~~0110011~~ | ~~0x5~~ | ~~0x00~~ | ~~rd = rs1 >> rs2 (logical)~~            |
| ~~sra~~   | ~~R~~ | ~~0110011~~ | ~~0x5~~ | ~~0x20~~ | ~~rd = rs1 >> rs2 (arithmetic)~~         |
| ~~slt~~   | ~~R~~ | ~~0110011~~ | ~~0x2~~ | ~~0x00~~ | ~~rd = (rs1 < rs2) ? 1 : 0~~             |
| ~~sltu~~  | ~~R~~ | ~~0110011~~ | ~~0x3~~ | ~~0x00~~ | ~~rd = (rs1 < rs2) ? 1 : 0 (unsigned)~~  |
|           |       |             |         |          |                                          |
| ~~addi~~  | ~~I~~ | ~~0010011~~ | ~~0x0~~ | ~~-~~    | ~~rd = rs1 + imm~~                       |
| ~~xori~~  | ~~I~~ | ~~0010011~~ | ~~0x4~~ | ~~-~~    | ~~rd = rs1 ^ imm~~                       |
| ~~ori~~   | ~~I~~ | ~~0010011~~ | ~~0x6~~ | ~~-~~    | ~~rd = rs1 \| imm~~                      |
| ~~andi~~  | ~~I~~ | ~~0010011~~ | ~~0x7~~ | ~~-~~    | ~~rd = rs1 & imm~~                       |
| ~~slli~~  | ~~I~~ | ~~0010011~~ | ~~0x1~~ | ~~-~~    | ~~rd = rs1 << imm[4:0]~~                 |
| ~~srli~~  | ~~I~~ | ~~0010011~~ | ~~0x5~~ | ~~-~~    | ~~rd = rs1 >> imm[4:0] (logical)~~       |
| ~~srai~~  | ~~I~~ | ~~0010011~~ | ~~0x5~~ | ~~-~~    | ~~rd = rs1 >> imm[4:0] (arithmetic)~~    |
| ~~slti~~  | ~~I~~ | ~~0010011~~ | ~~0x2~~ | ~~-~~    | ~~rd = (rs1 < imm) ? 1 : 0~~             |
| ~~sltiu~~ | ~~I~~ | ~~0010011~~ | ~~0x3~~ | ~~-~~    | ~~rd = (rs1 < imm) ? 1 : 0 (unsigned)~~  |
|           |       |             |         |          |                                          |
| lb        | I     | 0000011     | 0x0     | -        | rd = sign-ext(M[rs1+imm][7:0])           |
| lh        | I     | 0000011     | 0x1     | -        | rd = sign-ext(M[rs1+imm][15:0])          |
| lw        | I     | 0000011     | 0x2     | -        | rd = M[rs1+imm][31:0]                    |
| lbu       | I     | 0000011     | 0x4     | -        | rd = zero-ext(M[rs1+imm][7:0])           |
| lhu       | I     | 0000011     | 0x5     | -        | rd = zero-ext(M[rs1+imm][15:0])          |
|           |       |             |         |          |                                          |
| sb        | S     | 0100011     | 0x0     | -        | M[rs1+imm][7:0] = rs2[7:0]               |
| sh        | S     | 0100011     | 0x1     | -        | M[rs1+imm][15:0] = rs2[15:0]             |
| sw        | S     | 0100011     | 0x2     | -        | M[rs1+imm][31:0] = rs2[31:0]             |
|           |       |             |         |          |                                          |
| ~~beq~~   | ~~B~~ | ~~1100011~~ | ~~0x0~~ | ~~-~~    | ~~if (rs1 == rs2) PC += imm~~            |
| ~~bne~~   | ~~B~~ | ~~1100011~~ | ~~0x1~~ | ~~-~~    | ~~if (rs1 != rs2) PC += imm~~            |
| ~~blt~~   | ~~B~~ | ~~1100011~~ | ~~0x4~~ | ~~-~~    | ~~if (rs1 < rs2) PC += imm~~             |
| ~~bge~~   | ~~B~~ | ~~1100011~~ | ~~0x5~~ | ~~-~~    | ~~if (rs1 >= rs2) PC += imm~~            |
| ~~bltu~~  | ~~B~~ | ~~1100011~~ | ~~0x6~~ | ~~-~~    | ~~if (rs1 < rs2) PC += imm (unsigned)~~  |
| ~~bgeu~~  | ~~B~~ | ~~1100011~~ | ~~0x7~~ | ~~-~~    | ~~if (rs1 >= rs2) PC += imm (unsigned)~~ |
|           |       |             |         |          |                                          |
| ~~jal~~   | ~~J~~ | ~~1101111~~ | ~~-~~   | ~~-~~    | ~~rd = PC+4; PC += imm~~                 |
| ~~jalr~~  | ~~I~~ | ~~1100111~~ | ~~0x0~~ | ~~-~~    | ~~rd = PC+4; PC = rs1 + imm~~            |
| ~~lui~~   | ~~U~~ | ~~0110111~~ | ~~-~~   | ~~-~~    | ~~rd = imm << 12~~                       |
| ~~auipc~~ | ~~U~~ | ~~0010111~~ | ~~-~~   | ~~-~~    | ~~rd = PC + (imm << 12)~~                |
|           |       |             |         |          |                                          |
| ecall     | I     | 1110011     | 0x0     | -        | 触发环境调用                                   |
| ebreak    | I     | 1110011     | 0x0     | -        | 触发调试断点                                   |






