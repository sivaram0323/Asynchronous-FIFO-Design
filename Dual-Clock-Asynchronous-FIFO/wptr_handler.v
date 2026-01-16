module wptr_handler #(parameter n = 5)(
input clk,
input winc,
input wresetn,
input [n-1:0] wq2rptr,
output [n-2:0] wraddr,
output [n-1:0] wptr, 
output reg full );

reg [n-1:0] gptr;
reg inv_msb;
wire [n-1:0] gptr_next, b1, b2;

assign b2 = b1 + ( winc  & ~full );
assign gptr_next = b2^(b2>>1);
assign wraddr = {inv_msb, gptr[n-3:0]};
assign wptr = gptr;

genvar i;
generate 
  for ( i=0; i<n; i=i+1 ) begin : block
assign b1[i] = ^(gptr>>i);
end
endgenerate

always @ (posedge clk, negedge wresetn) begin
if ( !wresetn )
gptr <= 0;
else
gptr <= gptr_next;
end

always @ (posedge clk, negedge wresetn) begin
if ( !wresetn )
inv_msb <= 0;
else 
inv_msb <= ^gptr_next[n-1:n-2];
end

always @ (posedge clk, negedge wresetn) begin
if ( !wresetn )
full <= 0;
else
full <= ( gptr_next == {~wq2rptr[n-1:n-2], wq2rptr[n-3:0]} );
end
endmodule