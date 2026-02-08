module rptr_handler #(parameter n=5)(
input clk, rresetn, rinc,
input [n-1:0] rq2_wptr,
output [n-2:0] raddr,
output [n-1:0] rptr,
output reg empty );

reg [n-1:0] gptr;
reg inv_msb;
wire [n-1:0] gptr_next, b1, b2;

assign rptr = gptr;
assign b2 = b1 + ( rinc & ~empty );
assign gptr_next = b2^(b2>>1);
assign raddr = {inv_msb, gptr[n-3:0]};

genvar i;
generate 
  for ( i=0; i<n; i=i+1 ) begin : block
assign b1[i] = ^(gptr>>i);
end
endgenerate

always @ (posedge clk, negedge rresetn) begin
if ( ~rresetn ) begin
gptr <= 0;
inv_msb <= 1'b0;
empty <= 1'b1;
end
else begin
gptr <= gptr_next;
inv_msb <= ^gptr_next[n-1:n-2];
empty <= ( gptr_next == rq2_wptr );
end
end
endmodule