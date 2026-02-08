class wr_monitor #(parameter N = 5);
 
  virtual fifo_intf #(N).WR_MON vinf_wr_m;
  
  //calling transction 
   transaction #(N) tr_w_m;
   transaction #(N) tr_w_rm;
   transaction #(N) tr_w_cov;
   
  
  //mail box 
  mailbox  #(transaction #(N)) duv_ref;
  
  
  //constructor
  function new (virtual fifo_intf #(N).WR_MON vinf_wr_m,
  mailbox  #(transaction #(N)) duv_ref); 
    this.duv_ref=duv_ref;
    this.vinf_wr_m=vinf_wr_m;
    this.tr_w_m=new();
  endfunction
  
  
  virtual task monitor();
    @(vinf_wr_m.wr_mon_cb);
    wait(vinf_wr_m.wr_mon_cb.winc==1)
    @(vinf_wr_m.wr_mon_cb);
    tr_w_m.waddr=vinf_wr_m.wr_mon_cb.waddr;
    tr_w_m.waddr=vinf_wr_m.wr_mon_cb.wdata;
    tr_w_m.winc=vinf_wr_m.wr_mon_cb.winc;
    
    ///diplaying the values
    
    tr_w_m.display("WR_monitor");
  endtask:monitor 
  
  virtual task start();
    fork
      begin
        monitor(); 
        tr_w_rm=new tr_w_m;
        tr_w_cov= new tr_w_m;
        //write covergroups
        duv_ref.put(tr_w_rm);
       
      end  
    join_none  
     
  endtask:start  
  // write cover groups
  
endclass:wr_monitor  
