package FSM_pkg;

    typedef enum bit [1:0] {IDLE, ZERO, ONE, STORE} state_e;

    class fsm_transaction;
        rand bit rst, x; 
        bit y_exp;
        bit [9:0] users_count_exp;

        constraint rst_cst{
            rst dist {0:= 97, 1:=3};
        }

        constraint x_cst{
            x dist {0:= 67, 1:=33};
        }

    endclass
    
endpackage
