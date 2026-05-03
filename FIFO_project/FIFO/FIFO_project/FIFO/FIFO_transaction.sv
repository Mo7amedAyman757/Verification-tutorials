package FIFO_transaction_pkg;
import shared_pkg::*;

    class FIFO_transaction #(FIFO_WIDTH = 16, FIFO_DEPTH = 8);
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        int RD_EN_ON_DIST = 0;
        int WR_EN_ON_DIST = 0;

        function new(int RD_EN_ON_DIST  = 30,int WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction

        // constraint
        constraint rst_cst{
            rst_n dist{0 := 2, 1 := 98};    
        }

        constraint wr_cst{
            wr_en dist{0 := 100 - WR_EN_ON_DIST, 1 := WR_EN_ON_DIST};    
        }

        constraint rd_cst{
            rd_en dist{0 := 100 - RD_EN_ON_DIST, 1 := RD_EN_ON_DIST};    
        }

    endclass
    
endpackage