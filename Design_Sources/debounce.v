module debounce(
    input clk,            
    input rstn,           
    input key_in,         
    output reg key_out    
);
parameter CNT_MAX = 20'd999_999; 

reg [19:0] cnt; 
reg key_tmp; 
reg key_stable;    
reg key_stable_d;  
 
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        key_tmp    <= 1'b0;
        key_stable <= 1'b0;
        key_stable_d <= 1'b0;
        cnt        <= 20'd0;
        key_out    <= 1'b0;
    end 
    else begin
        key_tmp <= key_in;
        if (key_in != key_tmp) begin
            cnt <= 20'd0;
        end 
        else begin
            if (cnt < CNT_MAX) begin
                cnt <= cnt + 1;
            end 
            else begin
                key_stable <= key_in;
            end
            key_out <= key_stable & (~key_stable_d);
            key_stable_d <= key_stable;
        end
    end
end
endmodule