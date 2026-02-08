module async_fifo #(parameter N = 5) (fifo_intf intf);

  wptr_handler #(N) wptr_u (intf);
  rptr_handler #(N) rptr_u (intf);
  synchronizer #(N) sync_u (intf);
  dpram #(N) mem_u (intf);

endmodule
