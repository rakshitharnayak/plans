class pack;
//   bit [2:0] queue1[$:10];
rand  bit [2:0] data_in ;
  function void disp(ref bit [2:0] queue1[$:10] );
   bit wr_en = 1;
    
       std::randomize(data_in) ;  
       queue1.push_back(data_in);
//     queue1 ={1,2,3,4,5,6,7,8,9,3};
  endfunction
    endclass
    
    class pocket extends pack;
      bit [2:0] queue2[$:10];
      function void display(bit [2:0] queue[$:10]);
        queue2.push_back( queue.pop_front);
       $display(" queue2 = %0p",  queue2);
             $display(" queue1 = %0p",  queue);
      endfunction
    endclass
    
    module top;
      pack pk = new();
      pocket p = new();
      bit [2:0] queue[$:10];
      initial begin
        repeat(5)begin
        	pk.disp(queue);

			 $display(" queue1 = %0p",  queue);

        end

        repeat(5)begin
            p.display(queue);
          $display(" insidew repeat queue1 = %0p",  queue);
        end
        $display(" queue2 = %0p",  p.queue2);
      end
    endmodule
