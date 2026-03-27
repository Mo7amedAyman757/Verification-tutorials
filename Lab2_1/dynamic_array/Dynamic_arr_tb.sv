module Dynamic_arr_tb();
    // declare two dynamic arrays dyn_arr1, dyn_arr2 of type int
    int  dyn_arr1 [], dyn_arr2 [];

    initial begin
        // initialize dyn_arr2 array elements with (9,1,8,3,4,4)
        dyn_arr2 = new[6];
        dyn_arr2 = '{9,1,8,3,4,4};

        // allocate six elements in array dyn_arr1 using new operator
        dyn_arr1 = new[6];

        // initialize array dyn_arr1 with index as its value using foreach
        foreach(dyn_arr1[i])
            dyn_arr1[i] = i;

        // display dyn_arr1 and its size
        foreach(dyn_arr1[i])
            $display("dyn_arr1[%0d] = %0d",i,dyn_arr1[i]);
        
        $display("dyn_arr1.size = %0d",dyn_arr1.size());
        // delete array dyn_arr1
        dyn_arr1.delete();

        //reverse, sort, reverse sort and shuffle the array dyn_arr2 and display dyn_arr2 after using each method
        dyn_arr2.reverse();
        $display("dyn_arr2.reverse = %p",dyn_arr2);

        dyn_arr2.sort();
        $display("dyn_arr2.sort = %p",dyn_arr2);

        dyn_arr2.rsort();
        $display("dyn_arr2.rsort = %p",dyn_arr2);

        for (int i =0 ; i < 3; i = i + 1) begin
            dyn_arr2.shuffle();
            $display("iteration: %0d --> dyn_arr2 = %p",i,dyn_arr2);
        end
    end

endmodule
