// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
`include "async_fifo.v"
`include "dpram.v"
`include "rptr_handler.v"
`include "wptr_handler.v"
`include "synchronizer.v"

module testbench;

reg wclk, rclk, winc, rinc, wresetn, rresetn;
reg [3:0] wdata;
wire[3:0] rdata;
wire full, empty;

async_fifo test ( .wclk(wclk), .rclk(rclk), .winc(winc), .rinc(rinc), .wresetn(wresetn), .rresetn(rresetn), 
.wdata(wdata), .rdata(rdata), .full(full), .empty(empty) );

initial begin
wclk = 1'b0;
rclk = 1'b0;
winc = 1'b0;
rinc = 1'b0;
wresetn = 1'b0;
rresetn = 1'b0;
end

always #10 wclk = ~wclk;
always #30 rclk = ~rclk;

initial begin
#9 wresetn = 1'b1;
end

initial begin
#9 rresetn = 1'b1;
end

initial begin
winc = 1'b1;
rinc = 1'b1;
end

initial begin
wdata = 4'd1;
#21 wdata = 4'd3; 
#21 wdata = 4'd5;
#21 wdata = 4'd7;
#21 wdata = 4'd9;
end
initial begin
  $dumpfile("dump.vcd"); // Creates the data file (must be named dump.vcd)
  $dumpvars(1);          // Records signals (1 = current module; 0 =modules)
end  
/*int op1;
op1 = $fopen("results.txt", "w"); // You can name this anything
$fdisplay(fd, "Data: %h", data);
$fclose(fd);
  */

initial #500 $stop;

endmodule