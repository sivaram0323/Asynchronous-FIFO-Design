/*`timescale 1ns/1ps
`include "interface.sv"
`include "async_fifo.sv"
`include "dpram.sv"
`include "rptr_handler.sv"
`include "wptr_handler.sv"
`include "synchronizer.sv"

//module testbench;

  localparam int N = 5;

  // ----------------------------------
  // Clock declarations
  // ----------------------------------
  logic wclk = 0;
  logic rclk = 0;

  // ----------------------------------
  // Clock generation
  // ----------------------------------
  always #10 wclk = ~wclk;   // Write clock
  always #30 rclk = ~rclk;   // Read clock

  // ----------------------------------
  // Interface instance
  // ----------------------------------
  fifo_intf #(N) intf (wclk, rclk);

  // ----------------------------------
  // DUT
  // ----------------------------------
  async_fifo #(N) dut (intf);

  // ----------------------------------
  // Reset
  // ----------------------------------
  initial begin
    intf.wresetn = 0;
    intf.rresetn = 0;
    intf.winc    = 0;
    intf.rinc    = 0;
    intf.wdata   = '0;

    #25;
    intf.wresetn = 1;
    intf.rresetn = 1;
  end

  // ----------------------------------
  // Write stimulus
  // ----------------------------------
  initial begin
    wait(intf.wresetn);
    @(posedge intf.wclk);

    intf.winc = 1;

    repeat (8) begin
      @(posedge intf.wclk);
      if (!intf.full)
        intf.wdata <= intf.wdata + 1;
    end

    intf.winc = 0;
  end

  // ----------------------------------
  // Read stimulus
  // ----------------------------------
  initial begin
    wait(intf.rresetn);
    #100;

    intf.rinc = 1;

    repeat (8) begin
      @(posedge intf.rclk);
    end

    intf.rinc = 0;
  end

  // ----------------------------------
  // Monitor
  // ----------------------------------
  always @(posedge intf.rclk) begin
    if (intf.rinc && !intf.empty)
      $display("[%0t] READ DATA = %0d", $time, intf.rdata);
  end

  // ----------------------------------
  // Dump
  // ----------------------------------
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    $dumpvars(0, intf);
  end

  // ----------------------------------
  // Finish
  // ----------------------------------
  initial begin
    #500;
    $display("Simulation finished");
    $finish;
  end

endmodule  */
