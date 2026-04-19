package adder_pkg;

    typedef enum  {MAXNEG = -8, ZERO = 0, MAXPOS= 7} val_t;

    class adder_transaction;

        rand bit reset;
        rand bit signed [3:0] A, B;
        rand val_t AB_val;

        constraint reset_cst{
            reset dist{ 1 := 5, 0:= 95};
        }

        constraint AB_cst{
            A dist{AB_val := 90, [-7:-1] := 10, [1:6]:= 10};    
            B dist{AB_val := 90, [-7:-1] := 10, [1:6]:= 10};    
        }

        covergroup Covergrp_A;
            A_cvp_values : coverpoint A{
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins misc = default;
            }

            A_cvp_transitions: coverpoint A{
                bins A_data_0max = (ZERO => MAXPOS);
                bins A_data_maxmin = (MAXPOS => MAXNEG);
                bins A_data_minmax = (MAXNEG => MAXPOS);
            }

        endgroup

        covergroup Covergrp_B;
            B_cvp_values : coverpoint B{
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins misc = default;
            }

            B_cvp_transitions: coverpoint B{
                bins B_data_0max = (ZERO => MAXPOS);
                bins B_data_maxmin = (MAXPOS => MAXNEG);
                bins B_data_minmax = (MAXNEG => MAXPOS);
            }
        endgroup


        function new();
            Covergrp_A = new();
            Covergrp_B = new();
        endfunction


    endclass

endpackage