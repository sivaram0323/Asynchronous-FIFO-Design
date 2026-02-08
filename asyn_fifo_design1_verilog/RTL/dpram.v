module dpram #(parameter n=5)(
input wclk, rclk,
input wen, ren,
input [n-2:0] raddr_g, waddr_g,
output [3:0] rdata,
input [3:0] wdata );

wire [n-2:0] raddr_b, waddr_b;
reg  [3:0] mem [0 : 2**(n-1) - 1];

genvar i;
generate 
  for ( i=0; i<n-1; i=i+1 ) begin : block1
assign raddr_b[i] = ^(raddr_g>>i);
assign waddr_b[i] = ^(waddr_g>>i);
end
endgenerate

always @ (posedge wclk) begin
if (wen)
mem[waddr_b] <= wdata;
end

assign rdata = mem[raddr_b];
endmodule