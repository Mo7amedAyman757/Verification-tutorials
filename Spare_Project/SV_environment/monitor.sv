class monitor;
    virtual alu_if vif;

    transaction tr;
    mailbox #(transaction) mb_mon_sb, mb_mon_sub;

    function new(virtual alu_if vif_env, mailbox #(transaction) mb_to_sb, mailbox #(transaction) mb_to_sub); // constructor
        this.vif = vif_env;
        this.mb_mon_sb = mb_to_sb;
        this.mb_mon_sub = mb_to_sub;
    endfunction

    task run(int num);
        
        for(int i=0; i<num; i++) begin
            $display("==========monitor started==========");
            tr = new();
            tr.valid_in = vif.valid_in;
            tr.a = vif.a;
            tr.b = vif.b;
            tr.cin = vif.cin;
            tr.ctl = vif.ctl;
            tr.transaction_id = vif.transaction_id;

            tr.valid_out = vif.valid_out;
            tr.alu = vif.alu;
            tr.carry = vif.carry;
            tr.zero = vif.zero;

            tr.display_transaction();

            mb_mon_sb.put(tr);
            mb_mon_sub.put(tr);

            #11;
        end

    endtask

endclass