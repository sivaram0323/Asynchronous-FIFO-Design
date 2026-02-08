module dpram #(parameter N = 5) (fifo_intf.MEM intf);

  reg [3:0] mem [0 : (1<<(N-1))-1];

  always_ff @(posedge intf.wclk)
    if (intf.winc)
      mem[intf.waddr] <= intf.wdata;

  always_ff @(posedge intf.rclk)
    if (intf.rinc)
      intf.rdata <= mem[intf.raddr];

endmodule
