module transmonitor #(
  parameter NUM_MASTERS    = 16,
  parameter NUM_APU_POLICY = NUM_MASTERS,
  parameter NUM_DPU_POLICY = NUM_MASTERS)
 (
  input   wire        hclk,
  input   wire        hresetn,
// AHB-LITE MASTER PORT --------------
  input   wire [31:0] hmaster_m,             // AHB transfer: non-sequential only
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
  output wire [31:0] haddr_s,             // AHB transaction address
  output wire [31:0] hmaster_s,             // AHB transaction address
  output wire [ 2:0] hsize_s,             // AHB size: byte, half-word or word
  output wire [31:0] hwdata_s,            // AHB write-data
  output wire        hwrite_s,            // AHB write control
  input  wire [31:0] hrdata_s,            // AHB read-data
  input  wire        hready_s,            // AHB stall signal
  input  wire        hresp_s,             // AHB error response

  //------ APU --------------
  input   wire [NUM_APU_POLICY-1  :0][31:0]  apumid,
  input   wire [NUM_APU_POLICY-1  :0][31:0]  apuaddr,
  input   wire [NUM_APU_POLICY-1  :0][31:0]  apumask,
  input   wire [NUM_APU_POLICY-1  :0][31:0]  apuperm,

  //------ DPU --------------
  input   wire [NUM_DPU_POLICY-1  :0][31:0]  dpumid,
  input   wire [NUM_DPU_POLICY-1  :0][31:0]  dpuaddr,
  input   wire [NUM_DPU_POLICY-1  :0][31:0]  dpudata,
  input   wire [NUM_DPU_POLICY-1  :0][31:0]  dpumask,
  input   wire [NUM_DPU_POLICY-1  :0][31:0]  dpuamask

);

//----------------------------------
//wire and localparam declaration
//----------------------------------

 wire                      hsel_loc;
 wire                      hwrite_loc;
 wire [2:0]                hsize_loc;
 wire [31:0]               hrdata_loc;
 wire [31:0]               hwdata_loc;
 wire [31:0]               haddr_loc;
 wire [31:0]               hmaster_loc;

 wire                      pline_start;

 wire                      apu_err;
 wire                      gate_trans;
 wire                      dpu_check;

 reg                       hresp_loc;
 reg                       hready_loc;
 reg                       dpu_check_d;
 reg                       dpu_check_2d;
 reg                       dpu_err_d;
 reg [NUM_APU_POLICY-1:0]  valid_trans_apu;
 reg [NUM_DPU_POLICY-1:0]  valid_trans_dpu;


 reg [31:0] hmaster_m_d;
 reg [31:0] haddr_m_d;
 reg [2:0]  hsize_m_d;
 reg [3:0]  hprot_m_d;
 reg [31:0] hwdata_m_d;
 reg        hwrite_m_d;
 reg        hsel_m_d;


 reg [31:0] hmaster_m_1d;
 reg        hsel_m_1d;
 reg        hsel_m_2d;
 reg [31:0] haddr_m_1d;
 reg [2:0]  hsize_m_1d;
 reg [3:0]  hprot_m_1d;
 reg [31:0] hwdata_m_1d;
 reg        hwrite_m_1d;

 assign pline_start = hsel_m_1d & ~hsel_m_2d;
 assign hready_m    = hready_s  & hready_loc & ~pline_start;
 //assign hready_m    = hready_s  & hready_loc;
 assign hresp_m     = hresp_s   | hresp_loc;
 assign hrdata_m    = hrdata_s  | hrdata_loc;

 assign hsel_s    = dpu_check_d ? (hsel_m_d    & hsel_loc)    : (hsel_m_1d    & hsel_loc    &     hready_m);
 assign haddr_s   = dpu_check_d ? (haddr_m_d   & haddr_loc)   : (haddr_m_1d   & haddr_loc   & {32{hready_m}});
 assign hmaster_s = dpu_check_d ? (hmaster_m_d & hmaster_loc) : (hmaster_m_1d & hmaster_loc & {32{hready_m}});
 assign hsize_s   = dpu_check_d ? (hsize_m_d   & hsize_loc)   : (hsize_m_1d   & hsize_loc   &  {3{hready_m}});
 assign hwrite_s  = dpu_check_d ? (hwrite_m_d  & hwrite_loc)  : (hwrite_m_1d  & hwrite_loc  &     hready_m);

 assign hwdata_s  = dpu_check_2d ? (hwdata_m_d  & hwdata_loc & {32{hready_m & ~hresp_m}}) : (hwdata_m_1d  & hwdata_loc & {32{hready_m & ~hresp_m}});

//----------------------------------
//Error Response generation
//----------------------------------

  assign apu_err        = ~(|valid_trans_apu);
  assign dpu_err        = ~(&valid_trans_dpu);
  assign dpu_check      = hsel_m_1d & hready_m & hwrite_m_1d & ~apu_err & |hmaster_m_1d[31:1];
  assign gate_trans_apu = apu_err | dpu_check;
  assign gate_trans_dpu = dpu_err;
  assign gate_trans     = gate_trans_apu | gate_trans_dpu;

  assign hsel_loc     = ~gate_trans;
  assign haddr_loc    = {32{~gate_trans}};
  assign hmaster_loc  = {32{~gate_trans}};
  assign hwdata_loc   = {32{~(gate_trans | dpu_err_d)}};
  assign hwrite_loc   = ~gate_trans;
  assign hrdata_loc   = 32'b0;
  assign hsize_loc    = {3{~gate_trans}};

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      hready_loc <= 1'b1;
      hresp_loc  <= 1'b0;
    end
    else if (apu_err == 1'b1) begin
      hready_loc <= 1'b0;
      hresp_loc  <= 1'b1;
    end
    else if ((dpu_check_d == 1'b0) && (dpu_check == 1'b1)) begin
      hready_loc <= 1'b0;
      hresp_loc  <= 1'b0;
    end
    else if (dpu_err == 1'b1) begin
      hready_loc <= 1'b0;
      hresp_loc  <= 1'b1;
    end
    else if (hresp_loc & ~hready_loc) begin
      hready_loc <= 1'b1;
      hresp_loc  <= 1'b1;
    end
    else begin
      hready_loc <= 1'b1;
      hresp_loc  <= 1'b0;
    end
  end

//-----------------------------------------------------------------------------
//APU
//-----------------------------------------------------------------------------
//AHB Master Signal generation
genvar i;

generate
  for(i=0; i < NUM_APU_POLICY; i++) begin
    always @* begin
      if ((hsel_m_1d == 1'b1) && (hready_m == 1'b1)) begin
        if ((|hmaster_m_1d[31:1] == 1'b0) || ((apumid[i] == hmaster_m_1d) && (haddr_m_1d <= (apuaddr[i] | apumask[i])) && (haddr_m_1d >= (apuaddr[i] & ~apumask[i])))) begin
          if ((|hmaster_m_1d[31:1] == 1'b0) ||  ((apuperm[i][0] & ~hwrite_m_1d) || (apuperm[i][1] & hwrite_m_1d))) begin
            valid_trans_apu[i] <= 1'b1;
          end
          else begin
            valid_trans_apu[i] <= 1'b0;
          end
        end
        else begin
          valid_trans_apu[i] <= 1'b0;
        end
      end
      else begin
        valid_trans_apu[i] <= 1'b1;
      end
    end
  end
endgenerate
    
//-----------------------------------------------------------------------------
//DPU
//-----------------------------------------------------------------------------

generate
  for(i=0; i < NUM_DPU_POLICY; i++) begin
    always @* begin
      if (dpu_check_d == 1'b1) begin
        if ((dpumid[i] == hmaster_m_d) && ((hwdata_m_1d & ~dpumask[i]) == dpudata[i]) &&
                                           (haddr_m_d <= (dpuaddr[i] | dpuamask[i])) && (haddr_m_d >= (dpuaddr[i] & ~dpuamask[i]))) begin
            valid_trans_dpu[i] <= 1'b0;
        end
        else begin
          valid_trans_dpu[i] <= 1'b1;
        end
      end
      else begin
        valid_trans_dpu[i] <= 1'b1;
      end
    end
  end
endgenerate

always @* begin
  if (|valid_trans_dpu == 1'b0) begin
        hwdata_m_d <= 32'b0;
  end
  else begin
    hwdata_m_d <= hwdata_m_1d;
  end
end
  
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     hmaster_m_1d <= 32'b0;
     hsel_m_1d    <= 1'b0;
     hsel_m_2d    <= 1'b0;
     haddr_m_1d   <= 32'b0;
     hsize_m_1d   <= 3'b0;
     hprot_m_1d   <= 4'b0;
     hwdata_m_1d  <= 32'b0;
     hwrite_m_1d  <= 1'b0;
   end
   else begin
     if (hready_m == 1'b1) begin
       hmaster_m_1d <= hmaster_m;
       hsel_m_1d    <= hsel_m;
       haddr_m_1d   <= haddr_m;
       hsize_m_1d   <= hsize_m;
       hprot_m_1d   <= hprot_m;
       hwdata_m_1d  <= hwdata_m;
       hwrite_m_1d  <= hwrite_m;
     end
       hsel_m_2d    <= hsel_m_1d;
   end
 end
 
   

     
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     dpu_check_d <= 1'b0;
     hmaster_m_d <= 32'b0;
     hsel_m_d    <= 1'b0;
     haddr_m_d   <= 32'b0;
     hsize_m_d   <= 3'b0;
     hprot_m_d   <= 4'b0;
     hwrite_m_d  <= 1'b0;
   end
   else begin
     if (dpu_check == 1'b1) begin
       dpu_check_d <= 1'b1;
       hmaster_m_d <= hmaster_m_1d;
       hsel_m_d    <= hsel_m_1d;
       haddr_m_d   <= haddr_m_1d;
       hsize_m_d   <= hsize_m_1d;
       hprot_m_d   <= hprot_m_1d;
       hwrite_m_d  <= hwrite_m_1d;
     end
     else begin
       dpu_check_d <= 1'b0;
       hmaster_m_d <= 32'b0;
       hsel_m_d    <= 1'b0;
       haddr_m_d   <= 32'b0;
       hsize_m_d   <= 3'b0;
       hprot_m_d   <= 4'b0;
       hwrite_m_d  <= 1'b0;
     end
   end
 end
 
     
 always @ (posedge hclk or negedge hresetn) begin
   if (hresetn == 1'b0) begin
     dpu_check_2d <= 1'b0;
     dpu_err_d    <= 1'b0;
   end
   else begin
     dpu_check_2d <= dpu_check_d;
     dpu_err_d    <= dpu_err;
   end
 end
 


endmodule

