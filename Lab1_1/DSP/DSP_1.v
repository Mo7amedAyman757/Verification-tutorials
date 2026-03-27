module DSP(A, B, C, D, clk, rst_n, P);
parameter OPERATION = "ADD";
input  [17:0] A, B, D;
input  [47:0] C;
input clk, rst_n;
output [47:0] P;

// Stage 1 registers
reg [17:0] S1_A,S1_B,S1_D;
reg [47:0] S1_C;

// Stage 2 registers
reg [18:0] S2_A, S2_add;
reg [47:0] S2_C;

// stage 3 registers
reg [36:0] S3_mul;
reg [47:0] S3_C;

// stage 4 registers
reg [47:0] S4_P;


// stage1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        S1_A <= 0;
        S1_B <= 0;
        S1_C <= 0;
        S1_D <= 0;
	end
    else begin
        S1_A <= A;
        S1_B <= B;
        S1_C <= C;
        S1_D <= D;
    end
end

// stage2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
	    S2_A <= 0;
        S2_add <= 0;
        S2_C <= 0;    	
	end
    else begin
        S2_A <= S1_A;
        if (OPERATION == "ADD") begin
            S2_add <= S1_B + S1_D;
        end
        else if (OPERATION == "SUBTRACT") begin
            S2_add <= S1_D - S1_B;
        end
        S2_C <= S1_C;
    end
end

// stage3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        S3_mul <= 0;
        S3_C <= 0;
	end
    else begin
        S3_mul <= S2_A * S2_add;
        S3_C <= S2_C;
    end
end

// stage4
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        S4_P <= 0;
	end
    else begin
        if (OPERATION == "ADD") begin
            S4_P <= S3_C + S3_mul;
        end
        else if (OPERATION == "SUBTRACT") begin 
        S4_P <= S3_C - S3_mul;
        end
    end
end

assign P = S4_P;
endmodule