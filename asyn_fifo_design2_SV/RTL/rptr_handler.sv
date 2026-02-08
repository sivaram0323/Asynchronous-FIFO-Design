module rptr_handler #(parameter N = 5) (fifo_intf.RD intf);

  logic [N-1:0] bptr, bptr_next, gptr_next;

  assign bptr_next = bptr + (intf.rinc & ~intf.empty);
  assign gptr_next = (bptr_next >> 1) ^ bptr_next;

  assign intf.raddr = bptr[N-2:0];
  assign intf.rptr  = gptr_next;

  always_ff @(posedge intf.rclk or negedge intf.rresetn) begin
    if (!intf.rresetn)
      bptr <= '0;
    else
      bptr <= bptr_next;
  end

  assign intf.empty = (gptr_next == intf.wq2rptr);

endmodule
