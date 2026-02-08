
class transaction #(parameter N=5);
 // write logic signlas 
 
 rand logic  winc;
  rand logic [N-1:0] waddr;
  rand logic [3:0] wdata;
 //read logic signals
  rand logic  rinc;
  rand logic [N-1:0] raddr;
  rand logic [3:0] rdata;
 // general output  signals
  logic full;
  logic empty;
  

 //display method
    static int trns_id;
    static int wr_trans;
    static int rd_trans;
    static int wr_and_rd_trans;
   
    function void display(string message = "TXN");
    $display("--------------------------------------------------");
    $display("[%0t] %s", $time, message);
      $display("[%0d] %s",trns_id, message);  
    $display("WRITE  : winc=%0b waddr=%0d wdata=%0d", winc, waddr, wdata);
    $display("READ   : rinc=%0b raddr=%0d rdata=%0d", rinc, raddr, rdata);
    $display("STATUS : full=%0b empty=%0b", full, empty);
    $display("COUNT  : wr=%0d rd=%0d both=%0d",
              wr_trans, rd_trans, wr_rd_trans);
    $display("--------------------------------------------------");
  endfunction:display
  
  // post randomization logic 
  function void post_randomize();
    begin
      
      if(winc==1 && rinc==0) begin
        wr_trans=wr_trans+1;
      end
         if(winc==0 && rinc==1) begin
        rd_trans=rd_trans+1;
      end
      if(winc==1 && rinc==1) begin
        wr_and_rd_trans=wr_and_rd_trans+1;
      end
           
      this.display();     
      
    end
    
    
  endfunction:post_randomize  
  
  
  
  
 ////comaprision logic
    
  function compare(input transaction #(N) t1, output bit com );
      com=0; 
      begin    
        if (this.waddr!=t1.raddr)begin
              $display("----The adress values is mismatched-----"); 
            return(0);
           end

        if (this.wdata != t1.rdata) begin
           $display("----The data values is mismatched-----");
           return(0);
          end
          begin
            
           $display("----Successfully completed-----");   
           return(1);
          end  
      
      end     
    endfunction:compare  
  
  
  
endclass:transaction  