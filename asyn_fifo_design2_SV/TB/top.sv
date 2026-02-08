

`include "test.sv"

module testbench;
parameter N=5;
  // ------------------------
  // Clock Declaration
  // ------------------------
  reg wclk, rclk;

  initial begin
    wclk = 0;
    rclk = 0;
  end

  always #10 wclk = ~wclk;
  always #20 rclk = ~rclk;

  // ------------------------
  // Interface Instance
  // ------------------------
  fifo_intf #(5) intf (wclk, rclk);

  // ------------------------
  // DUT Instance
  // ------------------------
  async_fifo DUV (
    .wclk     (wclk),
    .rclk     (rclk),
    .winc     (intf.winc),
    .wdata    (intf.wdata),
    .wresetn  (intf.wresetn),
    .rinc     (intf.rinc),
    .rdata    (intf.rdata),
    .rresetn  (intf.rresetn),
    .full     (intf.full),
    .empty    (intf.empty)
  );

  // ------------------------
  // Test Class
  // ------------------------
  test test_h;

  initial begin
    test_h = new(intf, intf, intf, intf);
    test_h.build_and_run();
  end

endmodule : testbench
