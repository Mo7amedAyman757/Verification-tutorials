import ALU_pkg::*;

module ALU_tb (ALU_if.TEST ALU_vif);

    ALU_transaction ALU_txn = new;

    int error_count , correct_count;
    logic signed [4:0] C_ref;

    initial begin
        initial_signals();

        assert_reset();

        repeat(10000) begin
            assert(ALU_txn.randomize());
            ALU_vif.reset = ALU_txn.reset;
            ALU_vif.Opcode = ALU_txn.Opcode;
            ALU_vif.A = ALU_txn.A;
            ALU_vif.B = ALU_txn.B;
            @(negedge  ALU_vif.clk);
            check_result(ALU_txn);
            ALU_txn.ALU_cvg.sample();
        end

        $display("Error Count = %0d",error_count);
        $display("Correct Count = %0d",correct_count);
        $stop;
    end

    task initial_signals;
        ALU_vif.reset = 0;
        ALU_vif.Opcode = 0;
        ALU_vif.A = 0; 
        ALU_vif.B = 0;
        repeat(2) @(negedge  ALU_vif.clk);
    endtask

    task assert_reset;
        ALU_vif.reset = 1;
        repeat(2) @(negedge ALU_vif.clk);
        ALU_vif.reset = 0;
    endtask

    task check_result(ALU_transaction ALU_txn);
        golden_model(ALU_txn);
        if(C_ref != ALU_vif.C) begin
            error_count++;
            $display("Failed");
        end else begin
            correct_count++;
            $display("Passed");
        end
    endtask

    task golden_model(ALU_transaction ALU_txn);
        if(ALU_txn.reset) 
            C_ref = 0;
        else begin
            case(ALU_txn.Opcode)
                Add:            C_ref = ALU_txn.A + ALU_txn.B;
                Sub:            C_ref = ALU_txn.A - ALU_txn.B;
                Not_A:          C_ref = ~ALU_txn.A;
                ReductionOR_B:  C_ref = |ALU_txn.B;
                default:  C_ref = 5'b0;
            endcase
        end    
    endtask

endmodule