////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT fifo_vif);
 
localparam max_fifo_addr = $clog2(fifo_vif.FIFO_DEPTH);

reg [fifo_vif.FIFO_WIDTH-1:0] mem [fifo_vif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
	if (!fifo_vif.rst_n) begin
		wr_ptr <= 0;
		fifo_vif.wr_ack <= 0; // this was added
		fifo_vif.overflow <= 0; // this was added
	end
	else if (fifo_vif.wr_en && count < fifo_vif.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_vif.data_in;
		fifo_vif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifo_vif.wr_ack <= 0; 
		if (fifo_vif.full & fifo_vif.wr_en)
			fifo_vif.overflow <= 1;
		else
			fifo_vif.overflow <= 0;
	end
end

always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
	if (!fifo_vif.rst_n) begin
		rd_ptr <= 0;
		fifo_vif.underflow <= 0;  // this was added 
		fifo_vif.data_out <= 0; // this was added
	end
	else if (fifo_vif.rd_en && count != 0) begin
		fifo_vif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifo_vif.underflow <= 0;  // this was added 
	end else begin
		if (fifo_vif.rd_en && fifo_vif.empty) // this synchronized
			fifo_vif.underflow <= 1;
		else
			fifo_vif.underflow <= 0;		
	end
end

always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
	if (!fifo_vif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b10) && !fifo_vif.full) 
			count <= count + 1;
		else if ( ({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b01) && !fifo_vif.empty)
			count <= count - 1;
		else if({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11) begin // this condition was added 
			if(fifo_vif.empty)
                    count <= count + 1;
            else if(fifo_vif.full)
                    count <= count - 1;
		end
	end
end

assign fifo_vif.full = (count == fifo_vif.FIFO_DEPTH)? 1 : 0;
assign fifo_vif.empty = (count == 0)? 1 : 0;
// assign fifo_vif.underflow = (fifo_vif.empty && fifo_vif.rd_en)? 1 : 0; // this was synchronized 
assign fifo_vif.almostfull = (count == fifo_vif.FIFO_DEPTH-1)? 1 : 0; 
assign fifo_vif.almostempty = (count == 1)? 1 : 0;

`ifdef SIM

	property Reset_Behavior;
		@(posedge fifo_vif.clk) (!fifo_vif.rst_n) |=> (count == 0 && wr_ptr == 0 && rd_ptr == 0);
	endproperty

	assert property(Reset_Behavior);
	cover property(Reset_Behavior);

	property Write_Acknowledge;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n) 
		(fifo_vif.wr_en && !fifo_vif.full) |=> (fifo_vif.wr_ack == 1);	
	endproperty

	assert property(Write_Acknowledge);
	cover property(Write_Acknowledge);

	property overflow_detection;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n) 
		(fifo_vif.wr_en && fifo_vif.full) |=> (fifo_vif.overflow == 1);	
	endproperty

	assert property(overflow_detection);
	cover property(overflow_detection);

	property underflow_detection;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n) 
		(fifo_vif.rd_en && fifo_vif.empty) |=> (fifo_vif.underflow == 1);	
	endproperty

	assert property(underflow_detection);
	cover property(underflow_detection);

	property Full_Flag;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n)
		(count == fifo_vif.FIFO_DEPTH) |-> (fifo_vif.full == 1);
	endproperty
	assert property(Full_Flag);
	cover  property(Full_Flag);

	property Empty_Flag;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n)
		(count == 0) |-> (fifo_vif.empty == 1);
	endproperty
	assert property(Empty_Flag);
	cover  property(Empty_Flag);

	property AlmostFull_Flag;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n)
		(count == fifo_vif.FIFO_DEPTH - 1) |-> (fifo_vif.almostfull == 1);
	endproperty
	assert property(AlmostFull_Flag);
	cover  property(AlmostFull_Flag);

	property AlmostEmpty_Flag;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n)
		(count == 1) |-> (fifo_vif.almostempty == 1);
	endproperty

	assert property(AlmostEmpty_Flag);
	cover  property(AlmostEmpty_Flag);

	property WrPtr_Wraparound;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n)
		(wr_ptr == fifo_vif.FIFO_DEPTH - 1 && fifo_vif.wr_en && !fifo_vif.full) 
		|=> (wr_ptr == 0);
	endproperty

	assert property(WrPtr_Wraparound);
	cover  property(WrPtr_Wraparound);

	property RdPtr_Wraparound;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n)
		(rd_ptr == fifo_vif.FIFO_DEPTH - 1 && fifo_vif.rd_en && !fifo_vif.empty) 
		|=> (rd_ptr == 0);
	endproperty
	assert property(RdPtr_Wraparound);
	cover  property(RdPtr_Wraparound);

	property Ptr_Threshold;
		@(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n)
		(wr_ptr < fifo_vif.FIFO_DEPTH) && 
		(rd_ptr < fifo_vif.FIFO_DEPTH) && 
		(count  <= fifo_vif.FIFO_DEPTH);
	endproperty
	assert property(Ptr_Threshold);
	cover  property(Ptr_Threshold);

`endif

endmodule