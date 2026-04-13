package adder_pkg;
    
    typedef enum bit signed [3:0] {MAXNEG = 4'sb1000, ZERO = 4'sb000, MAXPOS = 4'sb0111} val_t;

    class adder_transaction;

      bit clk;
      rand bit reset;
      rand bit signed [3:0] A;
      rand bit signed [3:0] B;
      rand val_t AB_val;

        constraint reset_c{
            reset dist {1 := 2, 0 := 98};
        }

        constraint A_B_c{
            A dist{AB_val :/ 75, [-7:6] :/ 25};
            B dist{AB_val :/ 75, [-7:6] :/ 25};
        }

        covergroup A_cvg @(posedge clk);

            Covgrp_A: coverpoint A{
                bins A_data_0 = {ZERO};
                bins A_data_min = {MAXNEG};
                bins A_data_max = {MAXPOS};
                bins A_data_default = default;
            }

            Covpt_A_trans: coverpoint A{
                bins A_data_0max = (ZERO => MAXPOS); 
                bins A_data_maxmin = (MAXPOS => MAXNEG);
                bins A_data_minmax = (MAXNEG => MAXPOS);
            }

        endgroup

        covergroup B_cvg @(posedge clk);

            Covgrp_B: coverpoint B{
                bins B_data_0 = {ZERO};
                bins B_data_min = {MAXNEG};
                bins B_data_max = {MAXPOS};
                bins B_data_default = default;
            }

            Covpt_B_trans: coverpoint B{
                bins B_data_0max = (ZERO => MAXPOS); 
                bins B_data_maxmin = (MAXPOS => MAXNEG);
                bins B_data_minmax = (MAXNEG => MAXPOS);
            }

        endgroup

        function new();
                A_cvg = new();
                B_cvg = new();
        endfunction

        task sample_inputs();
            if(!reset) begin
                A_cvg.sample(); 
                B_cvg.sample();    
            end
        endtask

    endclass

endpackage