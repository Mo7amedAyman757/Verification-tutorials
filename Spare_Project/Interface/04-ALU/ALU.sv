module ALU_4_bit (ALU_if.DUT ALU_vif);

   reg signed [4:0] 	    Alu_out; // ALU output in 2's complement

   localparam 		    Add	           = 2'b00; // A + B
   localparam 		    Sub	           = 2'b01; // A - B
   localparam 		    Not_A	         = 2'b10; // ~A
   localparam 		    ReductionOR_B  = 2'b11; // |B

   // Do the operation
   always @* begin
      case (ALU_vif.Opcode)
      	Add:            Alu_out = ALU_vif.A + ALU_vif.B;
      	Sub:            Alu_out = ALU_vif.A - ALU_vif.B;
      	Not_A:          Alu_out = ~ALU_vif.A;
      	ReductionOR_B:  Alu_out = |ALU_vif.B;
        default:  Alu_out = 5'b0;
      endcase
   end // always @ *

   // Register output C
   always @(posedge ALU_vif.clk or posedge ALU_vif.reset) begin
      if (ALU_vif.reset)
	     ALU_vif.C <= 5'b0;
      else
	     ALU_vif.C <= Alu_out;
   end

endmodule
