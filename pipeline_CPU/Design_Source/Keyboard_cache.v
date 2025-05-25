module Keyboard_cache(
    input rstn,
    input [3:0]key_data,
    output reg [31:0]data_out
);
always @(key_data or rstn) begin
    if (!rstn) begin
    end else if (key_data != 4'b1111)begin
        case(key_data)
            4'b1100: data_out <= data_out >> 4;
            default:begin
                data_out <= data_out << 4;
                data_out[3:0] <= key_data;
            end
        endcase 
    end
end

endmodule