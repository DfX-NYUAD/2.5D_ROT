module test_tb (
);

reg [31:0] x;
reg [31:0] y;

  test dut_intst (
      .x  (x),
      .y  (y),
      .z  (z)
  );


  initial begin
    #0  x = 32'h0;
        y = 32'h0;
    #10 x = 32'h5;
        y = 32'hA;
    #20 x = 32'hA;
        y = 32'h5;
    #30 x = 32'h100;
        y = 32'h500;

  end
  endmodule
