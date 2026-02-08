


class scoreboard  #(parameter N = 5);
  
  transaction #(N) ref_data;
  transaction #(N) rcvd_data;
  transaction #(N) cov_data;
  event s; 
  int data_correct_count;
  int rm_data_count;
  int mon_data_count;
  
  //mail box 
  mailbox #(transaction #(N)) ref_sb;
  mailbox #(transaction #(N)) duv_rd_sb;

function new(
    mailbox #(transaction #(N)) ref_sb,
    mailbox #(transaction #(N)) duv_rd_sb);
  this.ref_sb    = ref_sb;
  this.duv_rd_sb = duv_rd_sb;
endfunction

virtual task start();
    fork
      begin
        ref_sb.get(ref_data);
        rm_data_count ++;
         
        duv_rd_sb.get(rcvd_data);
        mon_data_count++;
        check(rcvd_data);
     end 
    join_none
    
  endtask
  
  
  
  virtual task check(transaction #(N) rm_data);
    bit diff;
    if(rm_data.rinc==1) begin
      if (rm_data.rdata==0) begin
        $display("The randomized values are not recieved"); 
      end
      if(rm_data.rdata !=0) 
        begin
          if(!ref_data.compare(rm_data,diff)) begin
            rm_data.display("sb reciived data");
            ref_data.display("actual data send to DUV");
            $display("Data mismatch detected");
          end 
          else
            $display("Data match successful"); 
        end
      data_correct_count++;
      cov_data = new ref_data;     
    end 
            
    if (data_correct_count >= 10)
      begin
        ->s; 
      end          
    endtask:check
    virtual function void report();
              
     $display("The total no of counts  ref:%0d, mon:%0d and total:%0d",rm_data_count,mon_data_count,data_correct_count);
    endfunction:report
    
  endclass:scoreboard

