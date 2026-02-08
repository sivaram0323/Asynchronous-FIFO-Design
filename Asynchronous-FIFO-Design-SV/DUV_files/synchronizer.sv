module synchronizer #(parameter N = 5) (fifo_intf.SYNC intf);

  logic [N-1:0] wq1, rq1;

  always_ff @(posedge intf.wclk or negedge intf.wresetn) begin
    if (!intf.wresetn) begin
      wq1 <= 0;
      intf.rq2wptr <= 0;
    end else begin
      wq1 <= intf.rptr;
      intf.rq2wptr <= wq1;
    end
  end

  always_ff @(posedge intf.rclk or negedge intf.rresetn) begin
    if (!intf.rresetn) begin
      rq1 <= 0;
      intf.wq2rptr <= 0;
    end else begin
      rq1 <= intf.wptr;
      intf.wq2rptr <= rq1;
    end
  end

endmodule
