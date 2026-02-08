`include "interface.sv"

class wr_driver #(parameter N = 5);
  
 virtual fifo_intf #(N).WR_DRV vinf_wr;
  
  //calling transction 
  transaction #(N)  tr_w ;
  
  //mail box 
 mailbox  #(transaction #(N)) gen2_wr;
  
  
  //constructor
  function new (virtual fifo_intf #(N).WR_DRV vinf_wr,
  mailbox  #(transaction #(N)) gen2_wr); 
    this.gen2_wr=gen2_wr;
    this.tr_w=new();
    this.vinf_wr=vinf_wr;
  endfunction
  
  
  virtual task drive();
     begin
       @(vinf_wr.wr_drv_cb);
       vinf_wr.wr_drv_cb.waddr <= tr_w.waddr;
       vinf_wr.wr_drv_cb.wdata <= tr_w.wdata;
       vinf_wr.wr_drv_cb.winc <=  tr_w.winc;
       repeat(3) @(vinf_wr.wr_drv_cb);
       vinf_wr.wr_drv_cb.winc <=  0; // disabling writing operation

     end 
  endtask
  
  virtual task start();
    fork
     begin
       gen2_wr.get(tr_w);
       drive();
     end 
    join_none  
  endtask
  
endclass:wr_driver  