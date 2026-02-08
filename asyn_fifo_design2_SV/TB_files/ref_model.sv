class ref_model #(parameter N = 5);
  
   
  //calling transction 
  transaction #(N) wr_m_ref;
  transaction #(N) rd_m_ref; 
   //mail box 
  mailbox  #(transaction #(N)) gen2_wr;
  mailbox  #(transaction #(N)) duv_rd_ref;
  mailbox  #(transaction #(N)) ref_sb;
   
  
  logic [4:0] ref_mem[int];
  
   //constructor
  function new(mailbox  #(transaction #(N)) gen2_wr, mailbox #(transaction #(N)) duv_rd_ref,mailbox #(transaction #(N)) ref_sb);
    this.gen2_wr=gen2_wr;
    this.duv_rd_ref=duv_rd_ref;
    this.ref_sb=ref_sb;
  endfunction
  
  virtual task mem_write(transaction #(N) wr_m_ref);
    if(wr_m_ref.winc==1) begin
      ref_mem[wr_m_ref.waddr]=wr_m_ref.wdata;
    end    
endtask:mem_write
  virtual task mem_read(transaction #(N) rd_m_ref);
    if(rd_m_ref.rinc==1) begin
      ref_mem.rdata=ref_mem[rd_m_ref.raddr];
   end    
endtask:mem_read
  
  virtual task start (); 
  fork
   begin
     fork
         begin
           forever begin
             gen2_wr.get(wr_m_ref);
             mem_write(wr_m_ref);
           end
          end
          begin
            forever begin
             duv_rd_ref.get(rd_m_ref);
             mem_read(rd_m_ref);
             ref_sb.put(rd_m_ref);
          end
        end
     join
   end 
  join_none 
  
  endtask:start
  
  
  
endclass:ref_model