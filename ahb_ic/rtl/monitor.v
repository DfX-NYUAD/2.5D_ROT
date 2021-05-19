module monitor #(
  parameter NUM_MASTERS  = 16
  )(  
  // CLOCK AND RESETS ------------------
  input  wire         hclk,              // Clock
  input  wire         hresetn,           // Asynchronous reset
  // MASTER PORT --------------
  input   wire [ 1:0] htrans_m[NUM_MASTERS-1 :0],      // AHB transfer: non-sequential only
  input   wire [31:0] haddr_m[NUM_MASTERS-1 :0],       // AHB transaction address
  input   wire [ 2:0] hsize_m[NUM_MASTERS-1 :0],       // AHB size: byte, half-word or word
  input   wire [31:0] hwdata_m[NUM_MASTERS-1 :0],      // AHB write-data
  input   wire        hwrite_m[NUM_MASTERS-1 :0],      // AHB write control
  output  reg  [31:0] hrdata_m[NUM_MASTERS-1 :0],      // AHB read-data
  output  reg         hready_m[NUM_MASTERS-1 :0],      // AHB stall signal
  output  reg         hresp_m[NUM_MASTERS-1 :0],       // AHB error response
  //Slave Port ---------------
  input   wire [31:0] start_addr[NUM_MASTERS-1 :0],       // AHB transaction address
  input   wire [31:0] start_addr[NUM_MASTERS-1 :0],       // AHB transaction address
  output  reg         hsel_s[NUM_SLAVES-1 :0],         // AHB transfer: non-sequential only
  output  reg  [31:0] haddr_s[NUM_SLAVES-1 :0],        // AHB transaction address
  output  reg  [ 2:0] hsize_s[NUM_SLAVES-1 :0],        // AHB size: byte, half-word or word
  output  reg         hwrite_s[NUM_SLAVES-1 :0],       // AHB write control
  output  reg  [31:0] hwdata_s[NUM_SLAVES-1 :0],       // AHB write-data
  input   wire [31:0] hrdata_s[NUM_SLAVES-1 :0],       // AHB read-data
  input   wire        hready_s[NUM_SLAVES-1 :0],       // AHB stall signal
  input   wire        hresp_s[NUM_SLAVES-1 :0]         // AHB error response
);

endmodule
