////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: ALU Design 
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_4_bit(ALU_if.DUT alu_inst);

   logic signed [4:0] Alu_out; // ALU output in 2's complement

   // Do the operation
   always @* begin
      case (alu_inst.Opcode)
      	alu_inst.Add:            Alu_out = alu_inst.A + alu_inst.B;
      	alu_inst.Sub:            Alu_out = alu_inst.A - alu_inst.B;
      	alu_inst.Not_A:          Alu_out = ~alu_inst.A;
      	alu_inst.ReductionOR_B:  Alu_out = |alu_inst.B;
        default:  Alu_out = 5'b0;
      endcase
   end // always @ *

   // Register output C
   always @(posedge alu_inst.clk or posedge alu_inst.reset) begin
      if (alu_inst.reset)
	     alu_inst.C <= 5'b0;
      else
	     alu_inst.C<= Alu_out;
   end
   
endmodule
