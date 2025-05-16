module debounce(
    input clk,            
    input rstn,          
    input key_in,         
    output reg key_out   
);
parameter CNT_MAX = 20'd999_999; 

reg [19:0] cnt; 
reg key_tmp; 


always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        key_out <= 0;
    end else begin
        key_tmp <= key_in;
            if (key_in!= key_tmp) begin
            cnt <= 0;
            end else begin
            if (cnt < CNT_MAX) begin
                cnt <= cnt + 1;
            end else begin
                key_out <= key_in;
            end
        end
    end
end

endmodule