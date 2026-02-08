
`include "package.sv"
import ram_pkg::*;
class env #(parameter N = 5);
 

 virtual fifo_intf #(N).WR_DRV vinf_wr;
  virtual fifo_intf #(N).RD_DRV vinf_rd;
  virtual fifo_intf #(N).WR_MON vinf_wr_m;
  virtual fifo_intf #(N).RD_MON vinf_rd_m;
  
  generator #(N) gen_h;
  wr_driver #(N) wrd_h;
  rd_driver #(N) rdd_h;
  wr_monitor #(N) wrm_h;
  rd_monitor #(N) rdm_h;
  ref_model #(N)  refm_h;
  scoreboard #(N) sb_h;
  
  
//gen
  mailbox  #(transaction #(N)) gen2_wr=new();
  mailbox  #(transaction #(N)) gen2_rd=new();
//monitor write
  mailbox  #(transaction #(N)) duv_ref=new();
 //read monitor
  mailbox  #(transaction #(N)) duv_rd_ref=new();
  mailbox  #(transaction #(N)) duv_rd_sb=new();
  //scoreboard
  mailbox #(transaction #(N)) ref_sb=new();
  
  function new (virtual fifo_intf #(N).WR_DRV vinf_wr,
                virtual fifo_intf #(N).RD_DRV vinf_rd,
                virtual fifo_intf #(N).WR_MON vinf_wr_m,
                virtual fifo_intf #(N).RD_MON vinf_rd_m);
    
    this.vinf_wr=vinf_wr;
    this.vinf_rd=vinf_rd;
    this.vinf_wr_m=vinf_wr_m;
    this.vinf_rd_m=vinf_rd_m;
  endfunction 
    
    function void build();
      gen_h=new(gen2_wr,gen2_rd);
      wrd_h=new(vinf_wr,gen2_wr);
      rdd_h=new(vinf_wr_m,gen2_rd);
      wrm_h=new(vinf_wr,duv_ref);
      rdm_h=new(vinf_rd_m,duv_rd_ref,duv_rd_ref);
      refm_h=new(duv_ref,duv_rd_ref,ref_sb);
      sb_h=new(ref_sb,duv_rd_sb);
    endfunction:build 
    
    
 virtual task reset_and_write();

  // -------------------------
  // Apply reset
  // -------------------------
  wr_drv_if.wr_drv_cb.wreset <= 0;
  wr_drv_if.wr_drv_cb.winc   <= 0;
  wr_drv_if.wr_drv_cb.wdata  <= 0;

  repeat (5)
    @(wr_drv_if.wr_drv_cb);

  // -------------------------
  // Release reset
  // -------------------------
  wr_drv_if.wr_drv_cb.wreset <= 1;

  repeat (2)
    @(wr_drv_if.wr_drv_cb);

  // -------------------------
  // Burst write sequence
  // -------------------------
  for (int i = 0; i < 16; i++) begin

    // Wait while FIFO is full
    while (wr_drv_if.wr_drv_cb.full)
      @(wr_drv_if.wr_drv_cb);

    wr_drv_if.wr_drv_cb.wdata <= i;
    wr_drv_if.wr_drv_cb.winc  <= 1;

    @(wr_drv_if.wr_drv_cb);

    // De-assert winc after one cycle
    wr_drv_if.wr_drv_cb.winc <= 0;

  end

  repeat (3)
    @(wr_drv_if.wr_drv_cb);

  endtask : reset_and_write
    
    
    
    virtual task start();
      gen_h.start();
      wrd_h.start();
      rdd_h.start();
      wrm_h.start();
      rdm_h.start();
      refm_h.start();
      sb_h.start();
    endtask:start
    
    
    virtual task stop;
      wait(sb_h.s.triggered);
    endtask:stop 
    
    
    virtual task run();
      reset_and_write();
      start();
      stop();
      sb_h.report();
      
    endtask:run
endclass:env 