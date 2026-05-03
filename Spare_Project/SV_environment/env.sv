import pkg::*;

class environment;

    virtual alu_if vif;

    transaction tr;

    driver drv;
    monitor mon;
    sequencer sqr;
    scoreboard sb;
    subscriber sub;

    mailbox #(transaction) mb_sqr_drv, mb_mon_sb, mb_mon_sub;

    function new(virtual alu_if vif_top); // constructor
        this.vif = vif_top;
    endfunction

    task run_env(int num);
        mb_sqr_drv = new();
        mb_mon_sb = new();
        mb_mon_sub = new();

        sqr = new(mb_sqr_drv);
        drv = new(vif,mb_sqr_drv);
        mon = new(vif, mb_mon_sb, mb_mon_sub);
        sb = new(mb_mon_sb);
        sub = new(mb_mon_sub);

        fork 
            begin
                sqr.run(num);
            end 
            begin
                drv.run(num);
            end
            begin
                mon.run(num);
            end
            begin
                sb.run();
            end
            begin
                sub.run(num);
            end
        join

    endtask

endclass