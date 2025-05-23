`timescale 1ns / 1ps
`include "PARAMETER.v" 
module print_output(
    input en,
    input [3:0] sign7,
    input [3:0] sign6,
    input [3:0] sign5,
    input [3:0] sign4,
    input [3:0] sign3,
    input [3:0] sign2,
    input [3:0] sign1,
    input [3:0] sign0,
    input rst,
    input clk,
    output reg[7:0] seg_74,
    output reg[7:0] seg_30,
    output reg [7:0] tub_sel
);

    reg [24:0] clk_div; 

    reg [7:0]temp7,temp6,temp5,temp4,temp3,temp2,temp1,temp0;
    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            tub_sel <= 8'b00000001;  // Initialize with the rightmost light on
            clk_div <= 25'b0;
        end else begin
            // Set the frequency divider clk_div
            clk_div <= clk_div + 1;
            
            // Switch tub_sel while a period finished
            if (clk_div == 25'd25000) begin  // Set 1000Hz here(proper)//25000->25 help simulation
                clk_div <= 25'b0; // Reset
                tub_sel <= {tub_sel[6:0], tub_sel[7]};  // Implement digit-move operation here
            end
        end
        case(en)
            1'b1:begin
                case(sign0)
                    4'b0000: temp0 <= `DIGIT0;
                    4'b0001: temp0 <= `DIGIT1;
                    4'b0010: temp0 <= `DIGIT2;
                    4'b0011: temp0 <= `DIGIT3;
                    4'b0100: temp0 <= `DIGIT4;
                    4'b0101: temp0 <= `DIGIT5;
                    4'b0110: temp0 <= `DIGIT6;
                    4'b0111: temp0 <= `DIGIT7;
                    4'b1000: temp0 <= `DIGIT8;
                    4'b1001: temp0 <= `DIGIT9;
                    4'b1010: temp0 <= `DIGIT_;
                    4'b1011: temp0 <= `DIGITU;
                    4'b1100: temp0 <= `DIGITL;
                    4'b1110: temp0 <= `DIGITE;
                    4'b1111: temp0 <= `DIGITF;
                endcase
                
                case(sign1)
                    4'b0000: temp1 <= `DIGIT0;
                    4'b0001: temp1 <= `DIGIT1;
                    4'b0010: temp1 <= `DIGIT2;
                    4'b0011: temp1 <= `DIGIT3;
                    4'b0100: temp1 <= `DIGIT4;
                    4'b0101: temp1 <= `DIGIT5;
                    4'b0110: temp1 <= `DIGIT6;
                    4'b0111: temp1 <= `DIGIT7;
                    4'b1000: temp1 <= `DIGIT8;
                    4'b1001: temp1 <= `DIGIT9;
                    4'b1010: temp1 <= `DIGIT_;
                    4'b1110: temp1 <= `DIGITE;
                    4'b1011: temp1 <= `DIGITP;
                    4'b1100: temp1 <= `DIGITC;
                    4'b1111: temp1 <= `DIGITF;
                endcase
                
                case(sign2)
                    4'b0000: temp2 <= `DIGIT0;
                    4'b0001: temp2 <= `DIGIT1;
                    4'b0010: temp2 <= `DIGIT2;
                    4'b0011: temp2 <= `DIGIT3;
                    4'b0100: temp2 <= `DIGIT4;
                    4'b0101: temp2 <= `DIGIT5;
                    4'b0110: temp2 <= `DIGIT6;
                    4'b0111: temp2 <= `DIGIT7;
                    4'b1000: temp2 <= `DIGIT8;
                    4'b1001: temp2 <= `DIGIT9;
                    4'b1010: temp2 <= `DIGITA;
                endcase
                
                case(sign3)
                    4'b0000: temp3 <= `DIGIT0;
                    4'b0001: temp3 <= `DIGIT1;
                    4'b0010: temp3 <= `DIGIT2;
                    4'b0011: temp3 <= `DIGIT3;
                    4'b0100: temp3 <= `DIGIT4;
                    4'b0101: temp3 <= `DIGIT5;
                    4'b0110: temp3 <= `DIGIT6;
                    4'b0111: temp3 <= `DIGIT7;
                    4'b1000: temp3 <= `DIGIT8;
                    4'b1001: temp3 <= `DIGIT9;
                    4'b1010: temp3 <= `DIGITA;
                endcase
                
                case(sign4)
                    4'b0000: temp4 <= `DIGIT0;
                    4'b0001: temp4 <= `DIGIT1;
                    4'b0010: temp4 <= `DIGIT2;
                    4'b0011: temp4 <= `DIGIT3;
                    4'b0100: temp4 <= `DIGIT4;
                    4'b0101: temp4 <= `DIGIT5;
                    4'b0110: temp4 <= `DIGIT6;
                    4'b0111: temp4 <= `DIGIT7;
                    4'b1000: temp4 <= `DIGIT8;
                    4'b1001: temp4 <= `DIGIT9;
                    4'b1010: temp4 <= `DIGITA;
                endcase
                
                case(sign5)
                    4'b0000: temp5 <= `DIGIT0;
                    4'b0001: temp5 <= `DIGIT1;
                    4'b0010: temp5 <= `DIGIT2;
                    4'b0011: temp5 <= `DIGIT3;
                    4'b0100: temp5 <= `DIGIT4;
                    4'b0101: temp5 <= `DIGIT5;
                    4'b0110: temp5 <= `DIGIT6;
                    4'b0111: temp5 <= `DIGIT7;
                    4'b1000: temp5 <= `DIGIT8; 
                    4'b1001: temp5 <= `DIGIT9;
                    4'b1010: temp5 <= `DIGITA;
                endcase
                
                case(sign6)
                    4'b0000: temp6 <= `DIGIT0;
                    4'b0001: temp6 <= `DIGIT1;
                    4'b0010: temp6 <= `DIGIT2;
                    4'b0011: temp6 <= `DIGIT3;
                    4'b0100: temp6 <= `DIGIT4;
                    4'b0101: temp6 <= `DIGIT5;
                    4'b0110: temp6 <= `DIGIT6;
                    4'b0111: temp6 <= `DIGIT7;
                    4'b1000: temp6 <= `DIGIT8;
                    4'b1001: temp6 <= `DIGIT9;
                    4'b1010: temp6 <= `DIGITA;
                endcase
                
                case(sign7)
                    4'b0000: temp7 <= `DIGIT0;
                    4'b0001: temp7 <= `DIGIT1;
                    4'b0010: temp7 <= `DIGIT2;
                    4'b0011: temp7 <= `DIGIT3;
                    4'b0100: temp7 <= `DIGIT4;
                    4'b0101: temp7 <= `DIGIT5;
                    4'b0110: temp7 <= `DIGIT6;
                    4'b0111: temp7 <= `DIGIT7;
                    4'b1000: temp7 <= `DIGIT8;
                    4'b1001: temp7 <= `DIGIT9;
                    4'b1010: temp7 <= `DIGITA;
                endcase
            end
            1'b0:begin
                temp0 <= `DIGIT_NULL;
                temp1 <= `DIGIT_NULL;
                temp2 <= `DIGIT_NULL;
                temp3 <= `DIGIT_NULL;
                temp4 <= `DIGIT_NULL;
                temp5 <= `DIGIT_NULL;
                temp6 <= `DIGIT_NULL;
                temp7 <= `DIGIT_NULL;
            end
        endcase
    end

    always @(*)begin
        case (tub_sel)
            8'b10000000: seg_74 = temp7;
            8'b01000000: seg_74 = temp6;
            8'b00100000: seg_74 = temp5;
            8'b00010000: seg_74 = temp4;
            8'b00001000: seg_30 = temp3;
            8'b00000100: seg_30 = temp2;
            8'b00000010: seg_30 = temp1;
            8'b00000001: seg_30 = temp0;
            default: begin
                seg_74 = 8'b00000000;
                seg_30 = 8'b00000000;
            end
        endcase
    end
endmodule
