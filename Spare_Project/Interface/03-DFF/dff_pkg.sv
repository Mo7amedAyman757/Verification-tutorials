package dff_pkg;

    class dff_transaction;
        rand logic rst, d, en;
        logic q;

        constraint rst_cst{
            rst dist{ 1:= 4, 0:= 96};
        }

        constraint en_cst{
            en dist{ 0:= 20, 1:= 80};
        }

        constraint d_cst{
            d dist{ 0 := 40, 1 := 60};
        }

        covergroup dff_cfg;

            d_cvg : coverpoint d iff(en){
                bins d_bins[] = {[0:1]};
            }

        endgroup

        function new();
            dff_cfg = new();
        endfunction

    endclass

endpackage
