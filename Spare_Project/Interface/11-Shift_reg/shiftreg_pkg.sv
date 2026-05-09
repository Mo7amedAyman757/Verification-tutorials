package shiftreg_pkg;

    class shiftreg;

        rand logic reset, serial_in, direction, mode;
        rand logic [5:0] datain;
        

        constraint reset_cst{
            reset dist {0 := 97, 1 := 3};
        }

        constraint mode_cst{
            mode dist {0 := 50, 1 := 50};
        }

        constraint direction_cst{
            direction dist {0 := 50, 1 := 50};
        }

        constraint datain_cst{
            datain dist {[0:15] :/ 70, [16:31] :/ 30};
        }

        covergroup shiftreg_cvg;

            mode_cvg : coverpoint mode{
                bins mode_1 = {0};
                bins mode_2 = {1};
            }
            direction_cvg : coverpoint direction{
                bins dir_1 = {0};
                bins dir_2 = {1};
            }
            datain_cvg : coverpoint datain{
                bins datain_1 = {[0:15]};
                bins datain_2 = {[16:31]};
            }

            cross mode_cvg, direction_cvg;

        endgroup

        function new();
            shiftreg_cvg = new();
        endfunction

    endclass
    
endpackage