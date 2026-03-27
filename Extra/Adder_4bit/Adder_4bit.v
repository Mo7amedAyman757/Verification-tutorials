module full_adder(
        input clk,
        input rst,
        input [3:0] x,y,
        output reg [4:0] s
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s <= 5'b0;
        end else begin
            s <= x + y; // Perform addition with carry
        end
    end
    
endmodule
