module ALSU(ALSU_if.DUT ALSU_vif);

reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg cin_reg;
reg [2:0] opcode_reg;
reg signed [2:0] A_reg, B_reg;

wire invalid_red_op, invalid_opcode, invalid;

//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;

//Registering input signals
always @(posedge ALSU_vif.clk or posedge ALSU_vif.rst) begin
  if(ALSU_vif.rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;
  end else begin
     cin_reg <= ALSU_vif.cin;
     red_op_B_reg <=  ALSU_vif.red_op_B;
     red_op_A_reg <=  ALSU_vif.red_op_A;
     bypass_B_reg <=  ALSU_vif.bypass_B;
     bypass_A_reg <=  ALSU_vif.bypass_A;
     direction_reg <= ALSU_vif.direction;
     serial_in_reg <= ALSU_vif.serial_in;
     opcode_reg <= ALSU_vif.opcode;
     A_reg <= ALSU_vif.A;
     B_reg <= ALSU_vif.B;
  end
end

//ALSU_vif.leds ALSU_vif.output blinking 
always @(posedge ALSU_vif.clk or posedge ALSU_vif.rst) begin
  if(ALSU_vif.rst) begin
     ALSU_vif.leds <= 0;
  end else begin
      if (invalid)
        ALSU_vif.leds <= ~ALSU_vif.leds;
      else
        ALSU_vif.leds <= 0;
  end
end

//ALSU ALSU_vif.output processing
always @(posedge ALSU_vif.clk or posedge ALSU_vif.rst) begin
  if(ALSU_vif.rst) begin
    ALSU_vif.out <= 0;
  end
  else begin
    if (bypass_A_reg && bypass_B_reg)
      ALSU_vif.out <= (ALSU_vif.INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg)
      ALSU_vif.out <= A_reg;
    else if (bypass_B_reg)
      ALSU_vif.out <= B_reg;
    else if (invalid) 
        ALSU_vif.out <= 0;
    else begin
        case (opcode_reg)
          3'h0: begin 
            if (red_op_A_reg && red_op_B_reg)
              ALSU_vif.out <= (ALSU_vif.INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              ALSU_vif.out <= |A_reg;
            else if (red_op_B_reg)
              ALSU_vif.out <= |B_reg;
            else 
              ALSU_vif.out <= A_reg | B_reg;
          end
          3'h1: begin
            if (red_op_A_reg && red_op_B_reg)
              ALSU_vif.out <= (ALSU_vif.INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg) 
              ALSU_vif.out <= ^A_reg;
            else if (red_op_B_reg)
              ALSU_vif.out <= ^B_reg;
            else 
              ALSU_vif.out <= A_reg ^ B_reg;
          end
          3'h2: begin
            if (ALSU_vif.FULL_ADDER == "ON") begin
              ALSU_vif.out <= A_reg + B_reg + cin_reg;
            end else begin
              ALSU_vif.out <= A_reg + B_reg;
            end
          end
          3'h3: ALSU_vif.out <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              ALSU_vif.out <= {ALSU_vif.out[4:0], serial_in_reg};
            else
              ALSU_vif.out <= {serial_in_reg, ALSU_vif.out[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              ALSU_vif.out <= {ALSU_vif.out[4:0], ALSU_vif.out[5]};
            else
              ALSU_vif.out <= {ALSU_vif.out[0], ALSU_vif.out[5:1]};
          end
          default: ALSU_vif.out <= 0;
        endcase
    end 
  end
end

endmodule