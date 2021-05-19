module transmonitor_dummy (
  input   wire        hclk,
  input   wire        hresetn,
// AHB-LITE MASTER PORT --------------
  input   wire [31:0] hmaster_m,           // AHB transfer: non-sequential only
  input   wire        hsel_m,
  input   wire [31:0] haddr_m,             // AHB transaction address
  input   wire [2:0]  hsize_m,             // AHB size: byte, half-word or word
  input   wire [3:0]  hprot_m,
  input   wire [31:0] hwdata_m,            // AHB write-data
  input   wire        hwrite_m,            // AHB write control
  output  reg  [31:0] hrdata_m,            // AHB read-data
  output  reg         hready_m,            // AHB stall signal
  output  reg         hresp_m,             // AHB error response

  // AHB-LITE SLAVE PORT --------------
  output wire        hsel_s,            // AHB transfer: non-sequential only
  output wire [31:0] hmaster_s,         // AHB transaction address
  output wire [31:0] haddr_s,             // AHB transaction address
  output wire [ 2:0] hsize_s,             // AHB size: byte, half-word or word
  output wire [31:0] hwdata_s,            // AHB write-data
  output wire        hwrite_s,            // AHB write control
  input  wire [31:0] hrdata_s,            // AHB read-data
  input  wire        hready_s,            // AHB stall signal
  input  wire        hresp_s              // AHB error response
);

//----------------------------------
//wire and localparam declaration
//----------------------------------

 wire                      hsel_loc;
 wire                      hwrite_loc;
 wire [31:0]               hrdata_loc;
 wire [31:0]               hwdata_loc;
 wire [31:0]               haddr_loc;

 reg                       hresp_loc;
 reg                       hready_loc;


 reg [7:0]  hmaster_d;
 reg [31:0] haddr_m_d;
 reg [2:0]  hsize_m_d;
 reg [3:0]  hprot_m_d;
 reg [31:0] hwdata_m_d;
 reg        hwrite_m_d;
 reg        hsel_m_d;

 assign hready_m = hready_s;
 assign hresp_m  = hresp_s;
 assign hrdata_m = hrdata_s;

 assign hsel_s    = hsel_m;
 assign haddr_s   = haddr_m;
 assign hmaster_s = hmaster_m;
 assign hwdata_s  = hwdata_m;
 assign hwrite_s  = hwrite_m;
 assign hsize_s   = hsize_m;


endmodule

