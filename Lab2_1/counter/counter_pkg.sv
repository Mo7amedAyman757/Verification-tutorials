package counter_pkg;
    
    parameter COUNTER_WIDTH = 4;
    
    class counter_class;
        rand bit rst_n, load_n, up_down, ce;
        rand bit [COUNTER_WIDTH-1:0] data_load;

        constraint rst_cst{
            rst_n dist {0:= 5, 1:= 95};
        }

        constraint load_cst{
            load_n dist{0:= 70, 1:= 30};   
        }

        constraint ce_cst{
            ce dist{0:= 70, 1:= 30};   
        }

    endclass

endpackage
