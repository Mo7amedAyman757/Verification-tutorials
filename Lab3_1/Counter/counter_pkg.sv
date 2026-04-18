package counter_pkg;
    
    class counter_class;

        parameter COUNTER_WIDTH = 4;
        rand bit rst_n, load_n, up_down, ce;
        rand bit [COUNTER_WIDTH-1:0] data_load;
        bit clk;
        bit [COUNTER_WIDTH-1:0] count_out;

        constraint rst_cst{
            rst_n dist {0:= 5, 1:= 95};
        }

        constraint load_cst{
            load_n dist{0:= 70, 1:= 30};   
        }

        constraint ce_cst{
            ce dist{0:= 30, 1:= 70};   
        }

        constraint up_down_cst{
            up_down dist{0:= 50, 1:= 50};   
        }

        covergroup counter_cvg @(posedge clk);

            // 1) Load data coverage
            load_cvg: coverpoint data_load iff (rst_n && !load_n);

            // 2) Count UP all values
            count_up_cvg: coverpoint count_out
                iff (rst_n && ce && up_down){
                    bins all_vals[] = {[0:(2**COUNTER_WIDTH) -1]};
                }

            // 3) Overflow transition
            overflow_cfg: coverpoint count_out
                iff (rst_n && ce && up_down){
                    bins overflow = ((2**COUNTER_WIDTH)-1 => 0);
                }

            // 4) Count DOWN all values
            count_down_cvg: coverpoint count_out 
                iff (rst_n && ce && !up_down){
                    bins all_vals[] = {[0:(2**COUNTER_WIDTH) -1]};
                }

            // 5) Underflow transition
            underflow_cfg: coverpoint count_out
                iff (rst_n && ce && !up_down){
                    bins underflow = (0 => (2**COUNTER_WIDTH)-1);
                }

        endgroup
        
        function new();
            counter_cvg = new();
        endfunction

    endclass

endpackage
