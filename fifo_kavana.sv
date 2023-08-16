virtual class fifo;
  int depth = 16;
  int count = 0;
  bit rd_en;
  bit wr_en;
  int arr[$];

  pure virtual function void fifo_read();
  pure virtual function void fifo_write();
  pure virtual function bit fifo_full();
  pure virtual function bit fifo_empty();
endclass

class fifo_imp extends fifo;
  function void fifo_read();
    if (count > 0) begin
      rd_en = 1;
      $display("read enabled");
      count--;
    end
  endfunction

  function void fifo_write();
    int data_in;
    if (fifo_full() == 0) begin
      wr_en = 1;
      data_in = $urandom_range(0, 50);
      arr.push_back(data_in);
      $display("write enabled and the data is: data_in=%0d", data_in);
      count++;
    end
  endfunction

  function bit fifo_full();
    if (count == depth) begin
      $display("FIFO IS FULL");
      return 1;
    end else begin
      return 0;
    end
  endfunction

  function bit fifo_empty();
    if (count == 0) begin
      $display("FIFO IS EMPTY");
      return 1;
    end else begin
      return 0;
    end
  endfunction
endclass

class fifo_peek extends fifo_imp;
  int peek_ptr = 0;

  function void fifo_read();
    if (count > 0) begin
      super.fifo_read(); // Call base class fifo_read
      if(peek_ptr == 0)
        begin
      peek_ptr = (peek_ptr ) % arr.size();
           $display("Peeked data: %0d", arr[peek_ptr]);
      peek_ptr++;
        end
      else
        peek_ptr = (peek_ptr +1) % arr.size();
      $display("Peeked data: %0d", arr[peek_ptr]);
    end
  endfunction
endclass

module top;
  fifo_peek input_fifo;

  initial begin
    input_fifo = new;
    for (int i = 0; i < 20; i++) begin
      if (input_fifo.fifo_full() == 0)
        input_fifo.fifo_write();
    end

    for (int i = 0; i < 20; i++) begin
      if (input_fifo.fifo_empty() == 0)
        input_fifo.fifo_read();
    end
  end
endmodule
