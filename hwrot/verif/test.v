module test (
    input  wire [31:0] x,
    input  wire [31:0] y,
    output wire        z
);

  assign  z = (x > y) ? 1'b1 :1'b0;

endmodule

