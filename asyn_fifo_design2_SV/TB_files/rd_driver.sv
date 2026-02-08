
class rd_driver #(parameter N = 5);
  
  virtual fifo_intf #(N).RD_DRV vinf_rd;
   //virtual fifo_intf #(N).WR_DRV vinf_wr;
  
  //calling transction 
  transaction #(N) tr_rd ;
  
  //mail box 
  mailbox  #(transaction #(N)) gen2_rd;
  
  
  //constructor
  function new (virtual fifo_intf #(N).RD_DRV vinf_rd,
                mailbox  #(transaction #(N)) gen2_rd); 
    this.gen2_rd=gen2_rd;
    this.vinf_rd=vinf_rd;
  endfunction
  
  
  virtual task drive();
     begin
       @(vinf_rd.rd_drv_cb);
       vinf_rd.rd_drv_cb.raddr <= tr_rd.raddr;
       vinf_rd.rd_drv_cb.rinc <= tr_rd.rinc;
       repeat(3) @(vinf_rd.rd_drv_cb);
       vinf_rd.rd_drv_cb.rinc <=  0; // disabling reading operation operation

     end 
  endtask:drive  
  virtual task start();
    fork
     begin
        gen2_rd.get(tr_rd);
       drive();
     end 
    join_none  
  endtask 
 
endclass:rd_driver  