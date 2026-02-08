class generator #(parameter N = 5);
  
//call the transction class
  transaction #(N) tr_g ;
  transaction #(N) gen2send;

  
//creating mail box 
  mailbox #(transaction #(N)) gen2_wr;
  mailbox #(transaction #(N)) gen2_rd;
 //constructor
  
  function new (mailbox  #(transaction #(N)) gen2_wr,mailbox  #(transaction #(N)) gen2_rd);
    
    this.gen2_wr=gen2_wr;
    this.gen2_rd=gen2_rd;
    this.tr_g=new();
  endfunction
  
//generating transctions
  
  virtual task start();
   // int no_of_trans=30;
    fork
     begin
        for (int i=0; i< no_of_trans;i++ ) begin
          assert(tr_g.randomize); $fatal("randomization failed")
          gen2send=new tr; // shallow copying
          gen2_wr.put(gen2send); // sending data to write driver
          gen2_rd.put(gen2send); // sending data to read driver

      end 
     end 
    join_none 
  endtask:start  
 
endclass:generator  