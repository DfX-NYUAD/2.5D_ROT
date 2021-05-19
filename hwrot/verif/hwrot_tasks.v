task uartm_data_shift (input [7:0] data);
  begin
    tx_reg <= {1'b1, data, 1'b0, 1'b1};
    repeat(15) begin
      @(posedge UART_CLK);
      tx_reg <= {1'b1, tx_reg[9:1]};
    end
  end
endtask

task uartm_rx_data_capture ();
  begin
    rx_reg <= 8'b0;
    @(negedge uartm_rx_data);
    #UART_BAUD;
    repeat(8) begin
      @(posedge UART_CLK);
      rx_reg <= {uartm_rx_data, rx_reg[7:1]};
    end
  end
endtask



task uartm_write (input integer data,input integer addr);
  begin
    //Pass write pnemonic
    uartm_data_shift(8'h34);
    uartm_data_shift(8'h34);
    uartm_data_shift(8'h34);
    uartm_data_shift(8'h34);

    //Pass write Adddress
    uartm_data_shift(addr[7:0]);
    uartm_data_shift(addr[15:8]);
    uartm_data_shift(addr[23:16]);
    uartm_data_shift(addr[31:24]);

    //Pass write Data
    uartm_data_shift(data[7:0]);
    uartm_data_shift(data[15:8]);
    uartm_data_shift(data[23:16]);
    uartm_data_shift(data[31:24]);
  end
endtask

task uartm_read (input integer addr);
  begin
    fork
      begin
        //Pass write pnemonic
        uartm_data_shift(8'h4D);
        uartm_data_shift(8'h4D);
        uartm_data_shift(8'h4D);
        uartm_data_shift(8'h4D);
        //Pass write Adddress
        uartm_data_shift(addr[7:0]);
        uartm_data_shift(addr[15:8]);
        uartm_data_shift(addr[23:16]);
        uartm_data_shift(addr[31:24]);
      end
      begin
        //Sample RXdata
        uartm_rx_data_capture();
      end
    join
  end
endtask





