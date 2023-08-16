//base class
virtual class fifo ;
  
  
  pure virtual function int fifo_read();
    pure virtual function void fifo_write(ref bit [2:0] queue1[$]);
  pure virtual function int fifo_full();
  pure virtual function int fifo_empty();
    
endclass
    
    class fifo1#(parameter WIDTH, parameter DEPTH) extends fifo ;
       static bit [4:0] counter;
      bit [WIDTH -1:0] queue1[$];
     rand  bit [WIDTH-1:0] data_in ;
      
      virtual function int fifo_read();
        bit read_enb =1;
        counter--;
        return read_enb;
  	  endfunction
  
      virtual function void fifo_write(ref bit [2:0] queue1[$]);
       bit write_enb = 1;
      
       std::randomize(data_in) ;  
       queue1.push_back(data_in);
//        $display("data that is written = %p",queue1);
       counter++;   
    endfunction
  
  	virtual function int fifo_full();
		bit full;
     	if (counter == DEPTH)
        full = 1;
      else 
        full =0;
    	return full;
    endfunction
   
 	virtual function int fifo_empty();
      bit empty ;
      if (counter == 0)
      empty =1;
      else 
        empty = 0;
      return empty;
  	endfunction
  
endclass
    
    class fifo2  extends fifo1#(3,15);
      bit [WIDTH -1:0] queue2[$];
      function int read(ref bit [2:0] queue[$]);
        if(fifo_read() == 1)
          queue2.push_back( queue.pop_front);
      endfunction
    endclass

module top;
//   fifo ff = new();
  fifo1#(3,15) input_fifo = new();
  fifo2 output_fifo = new();

  bit [2:0] queue[$];
  initial begin
    

    
    repeat(20)
     begin
       if(input_fifo.fifo_full() == 0)
         begin
           input_fifo.fifo_write(queue) ;
           $display("data that is written = %p",queue);
         end
      else
        $display(" fifo is full");
    end
    
    repeat(20)
      begin
      if(input_fifo.fifo_empty() ==0)
        begin
          output_fifo.read(queue);
          $display("data that is read = %p",output_fifo.queue2);
    	end
    else 
      $display(" fifo is empty");
    end
    
  end
endmodule
