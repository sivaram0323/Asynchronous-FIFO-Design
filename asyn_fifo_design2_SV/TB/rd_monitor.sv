class rd_monitor  #(parameter N = 5);
  
  virtual fifo_intf #(N).RD_MON vinf_rd_m;
  
  //calling transction 
  transaction #(N) tr_rd_m ;
  transaction #(N) tr_rd_rm ;
   
  
  //mail box 
  mailbox  #(transaction #(N)) duv_rd_ref;
  mailbox #(transaction #(N)) duv_rd_sb;


  
  //constructor
  function new (virtual fifo_intf #(N).RD_MON vinf_rd_m,
  mailbox  #(transaction #(N)) duv_rd_ref,
  mailbox #(transaction #(N)) duv_rd_sb); 
    this.duv_rd_ref=duv_rd_ref;
    this.duv_rd_sb=duv_rd_sb;
    this.vinf_rd_m=vinf_rd_m;
    this.tr_rd_m=new();
  endfunction
 // read monitor  
  virtual task monitor();
    @(vinf_rd_m.rd_mon_cb);
    wait(vinf_rd_m.rd_mon_cb.rinc==1)
    @(vinf_rd_m.rd_mon_cb);
    vinf_rd_m.raddr=vinf_rd_m.rd_mon_cb.raddr;
    vinf_rd_m.rinc=vinf_rd_m.rd_mon_cb.rinc;
    
    ///diplaying the values
    
    tr_w_m.display(RD_monitor);
  endtask:monitor  
  
    virtual task start();
    fork
      begin
        monitor(); 
        tr_rd_rm=new tr_rd_m;
        //write covergroups
        duv_rd_ref.put(tr_rd_rm);
        duv_rd_sb.put(tr_rd_rm);
       
      end  
    join_none  
     
  endtask:start  
  
  
endclass:rd_monitor