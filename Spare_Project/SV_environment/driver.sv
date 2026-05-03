class driver;

    virtual alu_if vif;

    transaction tr;
    mailbox #(transaction) mb_sqr_drv;

    function new(virtual alu_if vif_env, mailbox #(transaction) mb_env); // constructor
        this.vif = vif_env;
        this.mb_sqr_drv = mb_env;
    endfunction

    task run(int num);
       

        for(int i=0; i<num; i++) begin
             $display("==========driver started==========");
            tr = new();
            mb_sqr_drv.get(tr);

            vif.valid_in = tr.valid_in;
            vif.a = tr.a;
            vif.b = tr.b;
            vif.cin = tr.cin;
            vif.ctl = tr.ctl;
            vif.transaction_id = tr.transaction_id;

            $display("Transaction ID: %0d, valid_in: %0d, a: %0d, b: %0d, cin: %0d, ctl: %0d"
                    ,vif.transaction_id, vif.valid_in, vif.a, vif.b, vif.cin ,vif.ctl);

            #10;
        end
        
        $display("Pass count = %0d", tr.pass_count);
        $display("Fail count  = %0d", tr.fail_count);
        $stop;
    endtask

endclass