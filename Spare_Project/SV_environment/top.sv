`include "alu_if.sv"
`include "env.sv"
`include "pkg.sv"

module top();

    logic clk;
    logic rst_n;

    environment env_inst;

    // instantiate the interface
    alu_if alu_if_inst(clk,rst_n);

    // instantiate the dut
    alu DUT( 
            // signals
            .clk(alu_if_inst.clk),
            .reset(alu_if_inst.reset),
            .valid_in(alu_if_inst.valid_in),    //validate  signals
            .a(alu_if_inst.a),           //port A
            .b(alu_if_inst.b),           //port B 
            .cin(alu_if_inst.cin),         //carry  from carry flag register 
            .ctl(alu_if_inst.ctl),         //functionality control for ALU 
            //Output signals
            .valid_out(alu_if_inst.valid_out),   //validate output signals
            .alu(alu_if_inst.alu),         //the result 
            .carry(alu_if_inst.carry),       //carry output 
            .zero(alu_if_inst.zero)         //zero output 
           );

    virtual alu_if vif;

    initial begin
        vif = alu_if_inst;
    end

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        // reset generation
        rst_n = 0;
        #15;
        rst_n = 1;

        env_inst = new(vif);

        env_inst.run_env(10);

        $stop;
    end

endmodule