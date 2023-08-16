virtual class fifo;   
  pure virtual function void write(ref  bit[16:0] array[$]); 
  pure virtual function int read();
  pure virtual function bit fifo_full();
  pure virtual function bit fifo_empty();
 endclass
 
    class fifo_imp #(parameter DEPTH, WIDTH) extends fifo;
      static int counter;
      bit [WIDTH-1:0] data_in;
      bit [WIDTH:0] new_data_in; // data_in with crc bit
      
      function void write(ref bit[WIDTH:0] array[$]); 
       bit crc_bit;
       int wr_enb = 1;  
       counter = counter+1;    
       std::randomize(data_in);
       crc_bit = ^data_in;
        new_data_in = {crc_bit, data_in};
       array.push_back(new_data_in);
  endfunction
    
    function int read();
      int rd_enb = 1;
      counter = counter - 1;
      return 1;
    endfunction
      
      function bit fifo_full();
        bit full_signal;
        if(counter == DEPTH)
           full_signal = 1;
        return full_signal;
      endfunction
      
      function bit fifo_empty();
        bit empty_signal;
        if(counter == 0)
          empty_signal = 1;
        return empty_signal;
      endfunction
endclass
    
    class fifo_peak extends fifo_imp#(32, 16);
      function int read_data(ref bit [WIDTH:0] array[$]);
        read_data = array.pop_front();
      endfunction
    endclass      
      
 module test;
   bit [16:0] array[$];
   bit [16:0] data_out;
   
   fifo_imp#(32,16)  input_fifo= new();
   fifo_peak output_fifo = new();
   
   initial begin
     $display("-----Performing write operation 5 times---");
     repeat(5)
     input_fifo.write(array);
     $display("data that is written in order = %0p",array);
     $display("----Performing read operation 3 times------");
     repeat(3) begin
     data_out = output_fifo.read_data(array);
       $display("data being read %0d" ,data_out); 
     end
     $display("-----Performing write operation 1 time---");
     input_fifo.write(array);
     $display("data that is written in order = %0p",array);
     $display("----Performing read operation 1 time------");
     data_out = output_fifo.read_data(array);
     $display("data being read %0d" ,data_out); 
   end
 endmodule
