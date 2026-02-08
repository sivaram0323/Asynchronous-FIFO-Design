interface fifo_intf #(parameter N = 5)(input bit wclk, input bit rclk);

  // Write clock domain
//  logic               wclk;
logic               wresetn;
  logic               winc;
  logic [3:0]         wdata;
  logic               full;
  logic [N-1:0]       wptr;
  logic [N-2:0]       waddr;

  // Read clock domain
  //logic               rclk;
  logic               rresetn;
  logic               rinc;
  logic [3:0]         rdata;
  logic               empty;
  logic [N-1:0]       rptr;
  logic [N-2:0]       raddr;

  // Sync pointers
  logic [N-1:0]       wq2rptr;
  logic [N-1:0]       rq2wptr;
////Modports for design clarity and separation of concerns
  // Modports
  modport WR (
    input  wclk, wresetn, winc, wdata, rq2wptr,
    output wptr, waddr, full
  );

  modport RD (
    input  rclk, rresetn, rinc, wq2rptr,
    output rptr, raddr, empty, rdata
  );

  modport MEM (
    input  wclk, rclk, winc, rinc, waddr, raddr, wdata,
    output rdata
  );

  modport SYNC (
    input  wclk, rclk, wresetn, rresetn, wptr, rptr,
    output wq2rptr, rq2wptr
  );
  
  //Clocking Blocks
  
  //write drivercb
  clocking  wr_drv_cb@(posedge wclk) ;
   output #1  wresetn, winc,wdata;
   input #1 full ;
 endclocking
  // read driver cb
  clocking rd_drv_cb @(posedge rclk);
    output  #1 rreset, rinc;
    input  #1 empty;
  endclocking  

  
 //write monitor cb
  clocking wr_mon_cb @(posedge wclk);
   input #1 wresetn, winc, wdata,waddr,full;
   endclocking
  
 // read monitor cb
  clocking rd_mon_cb @(posedge rclk);
   input #1 rreset, rinc,raddr, empty,rdata;    
  endclocking  
///Modports for tetsbench environment

  modport WR_DRV( clocking wr_drv_cb );  // write drivevr
  modport RD_DRV( clocking rd_drv_cb ); // read drivevr
  modport WR_MON( clocking wr_mon_cb );  //write monitor
  modport RD_MON( clocking rd_mon_cb );    // read monitor
endinterface
