import FSM_pkg::*;

module FSM_010_tb();

    //1- Delcare local wir and reg
    logic clk, rst, x;
	logic y;
	logic [9:0] users_count;

    fsm_transaction fsm_obj = new();

    integer error_count, correct_count;

    //2- Instantiate the module under test
    FSM_010 uut(
        clk, 
        rst, 
        x, 
        y, 
        users_count);

    //3- Generate clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //4- Stimulus generation
    initial begin
        error_count = 0;
        correct_count = 0;

        // Assert reset
        assert_reset();

        // Generate random transactions
        repeat (1000) begin
            assert(fsm_obj.randomize());
            rst = fsm_obj.rst;
            x = fsm_obj.x;
            check_result(fsm_obj);
        end

        // Generate random transactions
        repeat (10000) begin
            assert(fsm_obj.randomize());
            fsm_obj.rst = 0; // Ensure reset is deasserted for this part of the test
            rst = 0;
            x = fsm_obj.x;
            check_result(fsm_obj);
        end

        $display("Total tests: %d, Passed: %d, Failed: %d", error_count + correct_count, correct_count, error_count);
        $stop;    
    end

    task golden_model(input fsm_transaction fsm_obj1);
        state_e cs, ns;
        case (cs)
			IDLE: 
				if (fsm_obj.x)
					ns = IDLE;
				else 
					ns = ZERO;
			ZERO:
				if (fsm_obj.x)
					ns = ONE;
				else 
					ns = ZERO;
			ONE: 
				if (fsm_obj.x)
					ns = IDLE;
				else 
					ns = STORE;
			STORE: 
				if (fsm_obj.x)
					ns = IDLE;
				else 
					ns = ZERO;
			default: 	ns = IDLE;
		endcase

        @(posedge clk);
            if(fsm_obj.rst) begin
                cs = IDLE;
                fsm_obj.users_count_exp = 0;
            end
            else begin
                cs = ns;
                fsm_obj.users_count_exp =  (cs == STORE) ? fsm_obj.users_count_exp + 1 : fsm_obj.users_count_exp;
            end
        fsm_obj.y_exp = (cs == ONE) ? 1'b1 : 1'b0;
    endtask

    task assert_reset;
        rst = 1'b1;
        check_reset();
        rst = 1'b0;
    endtask 

    task check_result(input fsm_transaction fsm_obj2);
        golden_model(fsm_obj2);
        if (!fsm_obj2.rst) begin
            @(negedge clk);
            if ((fsm_obj2.y_exp !== y) || (fsm_obj2.users_count_exp !== users_count)) begin
                error_count += 1;
                $display("Test failed for y.Expected: %b, Y: %b", fsm_obj2.y_exp, y);
            end else begin
                correct_count += 1;
                $display("Test passed for y.Expected: %b, Y: %b", fsm_obj2.y_exp, y);
            end
        end else begin
            check_reset();    
        end
    endtask;

    task check_reset;
         @(negedge clk);
            if ((y !== 0) || (users_count !== 0)) begin
                error_count += 1;
                $display("Reset test failed. Expected y: 0, y: %b, Expected users_count: 0, users_count: %d", y, users_count);
            end else begin
                correct_count += 1;
                $display("Reset test passed. Expected y: 0, y: %b, Expected users_count: 0, users_count: %d", y, users_count);
            end
    endtask
   

endmodule
