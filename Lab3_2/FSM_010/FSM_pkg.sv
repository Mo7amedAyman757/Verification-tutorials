package FSM_pkg;

    typedef enum bit [1:0] {IDLE, ZERO, ONE, STORE} state_e;

    class fsm_transaction;
        rand bit rst, x; 
        bit y_exp;
        bit [9:0] users_count_exp;

        bit clk;

        constraint rst_cst{
            rst dist {0:= 97, 1:=3};
        }

        constraint x_cst{
            x dist {0:= 67, 1:=33};
        }

        covergroup fsm_cfg @(posedge clk);
            x_cvp: coverpoint x{
                bins x_trans = (0 => 1 => 0);
            }
        endgroup

        function new();
            fsm_cfg = new();
        endfunction

    endclass
    
endpackage
