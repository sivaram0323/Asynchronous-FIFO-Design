module synchronizer ( 
clk, inp, sync_outp, resetn );

parameter n = 5;
input clk, resetn;
input [n-1:0] inp;
output [n-1:0] sync_outp;

reg [n-1:0] reg1, reg2;

assign sync_outp = reg2;

always @ (posedge clk, negedge resetn) begin
if ( !resetn ) begin
reg1 <= 0;
reg2 <= 0;
end
else begin
reg1 <= inp;
reg2 <= reg1;
end
end
endmodule