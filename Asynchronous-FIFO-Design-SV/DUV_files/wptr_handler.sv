module wptr_handler #(parameter N = 5) (fifo_intf.WR intf);

  logic [N-1:0] bptr, bptr_next, gptr_next;

  assign bptr_next = bptr + (intf.winc & ~intf.full);
  assign gptr_next = (bptr_next >> 1) ^ bptr_next;

  assign intf.waddr = bptr[N-2:0];
  assign intf.wptr  = gptr_next;

  always_ff @(posedge intf.wclk or negedge intf.wresetn) begin
    if (!intf.wresetn)
      bptr <= '0;
    else
      bptr <= bptr_next;
  end

  assign intf.full =
    (gptr_next == {~intf.rq2wptr[N-1:N-2], intf.rq2wptr[N-3:0]});

endmodule
