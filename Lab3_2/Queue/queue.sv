module queue();

    int j = 1;
    int queue[$] = '{0,2,5};

    initial begin
        $display ("size=%0d queue=%p", queue.size(), queue);
        queue.insert(1,j);
        $display ("size=%0d queue=%p", queue.size(), queue);
        queue.delete(1);
        $display ("size=%0d queue=%p", queue.size(), queue);
        queue.push_front(7);
        $display ("size=%0d queue=%p", queue.size(), queue);
        queue.push_back(9);
        $display ("size=%0d queue=%p", queue.size(), queue);
        j = queue.pop_back();
        $display ("size=%0d queue=%p j = %0d", queue.size(), queue, j);
        j = queue.pop_front();
        $display ("size=%0d queue=%p j = %0d", queue.size(), queue, j);
        queue.sort();
        $display ("queue after sorting: %p ",queue);
        queue.reverse();
        $display ("queue after reversed: %p ",queue);
        queue.shuffle();
        $display ("queue after shuffled: %p ",queue);
    end

endmodule