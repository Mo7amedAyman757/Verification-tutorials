package counter_pkg;
    
    parameter WIDTH = 4;

    class counter_transaction;
        rand logic rst_n;
        rand logic load_n;
        rand logic up_down;
        rand logic ce;
        rand logic [WIDTH-1:0] data_load;
        bit [WIDTH-1:0] count_out;

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

        covergroup counter_cvg;

            load_cvg : coverpoint data_load iff(!load_n && rst_n);

            count_up_cvg : coverpoint count_out
                iff (rst_n && ce && up_down){
                    bins bin_trans[] = {[0: (2**WIDTH)-1]};
                }
            

            overflow_cfg : coverpoint count_out
                iff (rst_n && ce && up_down){
                    bins bin_overflow = ((2**WIDTH)-1 => 0);
                }
            

            count_down_cvg : coverpoint count_out
                iff (rst_n && ce && !up_down){
                    bins bin_trans[] = {[0: (2**WIDTH)-1]};
                }
            

            underflow_cfg : coverpoint count_out
                iff (rst_n && ce && !up_down){
                    bins bin_overflow = (0 => (2**WIDTH)-1);
                }
            
        endgroup

        function new();
            counter_cvg = new();
        endfunction

    endclass


endpackage