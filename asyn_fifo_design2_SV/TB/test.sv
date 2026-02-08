`include "env.sv"
class test  #(parameter N = 5);
  

  virtual fifo_intf #(N).WR_DRV vinf_wr;
  virtual fifo_intf #(N).RD_DRV vinf_rd;
  virtual fifo_intf #(N).WR_MON vinf_wr_m;
  virtual fifo_intf #(N).RD_MON vinf_rd_m; 
  
  env #(N) env_h;
   
 function new (virtual fifo_intf #(N).WR_DRV vinf_wr,
                virtual fifo_intf #(N).RD_DRV vinf_rd,
                virtual fifo_intf #(N).WR_MON vinf_wr_m,
                virtual fifo_intf #(N).RD_MON vinf_rd_m);
    
    this.vinf_wr=vinf_wr;
    this.vinf_rd=vinf_rd;
    this.vinf_wr_m=vinf_wr_m;
    this.vinf_rd_m=vinf_rd_m;
    env_h=new(vinf_wr,vinf_rd,vinf_wr_m,vinf_rd_m);
  endfunction
 virtual task build_and_run;
   
   no_of_trans=20;
   env_h.build();
   env_h.run();
   $finish;
   
 endtask:build_and_run  
endclass:test