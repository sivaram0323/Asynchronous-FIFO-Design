module async_fifo #(parameter n=5)(
input wclk, rclk, winc, rinc, wresetn, rresetn,
input [3:0] wdata,
output [3:0] rdata,
output full, empty );

wire [n-1:0] wptr, rptr, wq2rptr, rq2wptr;
wire [n-2:0] waddr, raddr;

wptr_handler #(n) wptr_handler_1 ( .clk(wclk), .winc(winc), .wresetn(wresetn), .wq2rptr(wq2rptr), 
.wraddr(waddr), .wptr(wptr), .full(full) );

rptr_handler #(n) rptr_handler_1 ( .clk(rclk), .rinc(rinc), .rresetn(rresetn), .rq2_wptr(rq2wptr), 
.raddr(raddr), .rptr(rptr), .empty(empty) );

synchronizer #(n) synchronizer_wr_domain ( .clk(wclk), .inp(rptr), .sync_outp(wq2rptr), .resetn(wresetn) );

synchronizer #(n) synchronizer_r_domain ( .clk(rclk), .inp(wptr), .sync_outp(rq2wptr), .resetn(rresetn) );

dpram #(n) dpram_1 ( .wclk(wclk), .rclk(rclk), .wen(winc & ~full), .ren(rinc & ~empty), .raddr_g(raddr),
.waddr_g(waddr), .rdata(rdata), .wdata(wdata) );

endmodule