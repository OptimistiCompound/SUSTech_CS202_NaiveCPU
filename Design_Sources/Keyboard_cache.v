module Keyboard_cache(
    input rst,
    input [3:0]key_data,
    output reg [7:0]data_out,
    output reg done
);
always @(key_data or rst) begin
    if (rst) begin
        data_out <= 0;
    end if (key_data == 4'b1011)begin
        done <= 1;
    end else if (key_data != 4'b1111)begin
        done <= 0;
        case(key_data)
            4'b1100:data_out >> 4 ;
            default:begin
                data_out << 4;
                data_out[3:0] <= key_data;
            end
        endcase 
    end
    end

endmodule