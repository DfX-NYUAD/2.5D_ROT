//---------------------------------------------------------------------------------------------------
//This module implements AHB-Lite Bus matrix interconnect. Arbitration is fixed priority where Master0
//have higher priority and Master[NUM_MASTERS-1] have least priority. Arbitration happens every cycle.
//Its a full crossbar where any master can access any slave and there can be multiple master accessing multiple slave
//in a given point of time unlike a bus , where only one transaction is allowed at a time.
//And if there is a contention between 2 masters accessing same slave higher priority master wins the arbitration.
//This module expects the hrdata from not selected slave to be 0
//The code is made generic to support any number of masters and slave. It has 3 main logic
//1. Decoder logic to identify which master is accessing which slave and muxing logic for address control singal
//   --Hsel to every slave is generated for all the masters. If there are N masters, there will be N hsel for each slave.
//   --If an higher priority master is accessing a slave hsel of that slave by a lower priority master is made 0
//   --Final Hsel to a slave is or of all the hsel from all the masters to this slave
//   --Based on Hsel address/control muxing is done
//2. Address/Ctl latching of the master who lost the arbitration
//   --For the masters who lost the arbitration, address control signals are latched.
//   --These latched values will partcipate in next arbitration cycle and will have priority over the new transaction by
//     the "same master". But will have lower priority compared to the new transaction by higher priority master.
//   --This latched value will be held until hready correspond to this latched transaction is recieved from the slave.
//2. Hwdata Muxing
//   --isel generated to each slave is latched to do the Hwdata muxing to the slave.
//   --Incase Hready is low from the slave in data phase, mux select for hwdata is extended until hready
//     from the slave is high.
//3. Hready, Hrdata and Hresp Muxing
//---------------------------------------------------------------------------------------------------


module ahb_ic_wrap #(
  parameter NUM_SLAVES     = 18,
  parameter NUM_SRAMS      = 18,
  parameter NUM_MASTERS    = 16,
  parameter NUM_CORES      = 16,
  parameter NUM_APU_POLICY = 16,
  parameter NUM_DPU_POLICY = 16,
  parameter [31:0] SLAVE_BASE_MASK [NUM_SLAVES-1 :0]   = '{32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF,
                                                           32'h0000_FFFF},
  parameter [31:0] SLAVE_BASE [NUM_SLAVES-1 :0]   = '{32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h4000_0000,
                                                      32'h2000_0000,
                                                      32'h2000_0000,
                                                      32'h2000_0000,
                                                      32'h2000_0000,
                                                      32'h2000_0000,
                                                      32'h2000_0000,
                                                      32'h2000_0000,
                                                      32'h2000_0000,
                                                      32'h0000_0000}
  )(  
  // CLOCK AND RESETS ------------------
  input  wire         hclk,              // Clock
  // MASTER PORT --------------
  input   wire [31:0] hmaster_m[NUM_MASTERS-1 :0],
  input   wire [ 1:0] htrans_m[NUM_MASTERS-1 :0],      // AHB transfer: non-sequential only
  input   wire [3:0]  hprot_m[NUM_MASTERS-1 :0],
  input   wire [31:0] haddr_m[NUM_MASTERS-1 :0],       // AHB transaction address
  input   wire [ 2:0] hsize_m[NUM_MASTERS-1 :0],       // AHB size: byte, half-word or word
  input   wire [31:0] hwdata_m[NUM_MASTERS-1 :0],      // AHB write-data
  input   wire        hwrite_m[NUM_MASTERS-1 :0],      // AHB write control
  output  reg  [31:0] hrdata_m[NUM_MASTERS-1 :0],      // AHB read-data
  output  reg         hready_m[NUM_MASTERS-1 :0],      // AHB stall signal
  output  reg         hresp_m[NUM_MASTERS-1 :0],       // AHB error response
  //Slave Port ---------------
  output  reg         hsel_s[NUM_SLAVES-1 :0],         // AHB transfer: non-sequential only
  output  reg  [31:0] haddr_s[NUM_SLAVES-1 :0],        // AHB transaction address
  output  reg  [31:0] hmaster_s[NUM_SLAVES-1 :0],      // AHB transaction address
  output  reg  [ 2:0] hsize_s[NUM_SLAVES-1 :0],        // AHB size: byte, half-word or word
  output  reg         hwrite_s[NUM_SLAVES-1 :0],       // AHB write control
  output  reg  [31:0] hwdata_s[NUM_SLAVES-1 :0],       // AHB write-data
  input   wire [31:0] hrdata_s[NUM_SLAVES-1 :0],       // AHB read-data
  input   wire        hready_s[NUM_SLAVES-1 :0],       // AHB stall signal
  input   wire        hresp_s[NUM_SLAVES-1 :0],         // AHB error response

`ifndef NOTRANSMON
  //------ APU --------------
  input   wire [NUM_APU_POLICY-1 :0][31:0] apumid [NUM_SRAMS :0],
  input   wire [NUM_APU_POLICY-1 :0][31:0] apuaddr[NUM_SRAMS :0],
  input   wire [NUM_APU_POLICY-1 :0][31:0] apumask[NUM_SRAMS :0],
  input   wire [NUM_APU_POLICY-1 :0][31:0] apuperm[NUM_SRAMS :0],

  //------ DPU --------------
  input   wire [NUM_DPU_POLICY-1 :0][31:0] dpumid [NUM_SRAMS :0],
  input   wire [NUM_DPU_POLICY-1 :0][31:0] dpuaddr[NUM_SRAMS :0],
  input   wire [NUM_DPU_POLICY-1 :0][31:0] dpudata[NUM_SRAMS :0],
  input   wire [NUM_DPU_POLICY-1 :0][31:0] dpumask[NUM_SRAMS :0],
  input   wire [NUM_DPU_POLICY-1 :0][31:0] dpuamask[NUM_SRAMS :0],
`endif

  input  wire         hresetn           // Asynchronous reset

);

wire        hsel_s_loc[NUM_SLAVES-1 :0];         // AHB transfer: non-sequential only
wire [31:0] hmaster_s_loc[NUM_SLAVES-1 :0];      // AHB transaction address
wire [31:0] haddr_s_loc[NUM_SLAVES-1 :0];        // AHB transaction address
wire [ 2:0] hsize_s_loc[NUM_SLAVES-1 :0];        // AHB size: byte, half-word or word
wire [ 3:0] hprot_s_loc[NUM_SLAVES-1 :0];        // AHB size: byte, half-word or word
wire        hwrite_s_loc[NUM_SLAVES-1 :0];       // AHB write control
wire [31:0] hwdata_s_loc[NUM_SLAVES-1 :0];       // AHB write-data
wire [31:0] hrdata_s_loc[NUM_SLAVES-1 :0];       // AHB read-data
wire        hready_s_loc[NUM_SLAVES-1 :0];       // AHB stall signal
wire        hresp_s_loc[NUM_SLAVES-1 :0];        // AHB error response


ahb_ic #(
  .NUM_SLAVES  (NUM_SLAVES),
  .NUM_MASTERS (NUM_MASTERS),
  .SLAVE_BASE_MASK (SLAVE_BASE_MASK),
  .SLAVE_BASE  (SLAVE_BASE)
  ) u_ahb_ic_inst (  
      .hclk      (hclk),          //input  wire          Clock
      .hresetn   (hresetn),       //input  wire          Asynchronous reset
      .hmaster_m (hmaster_m),     //input   wire [3:0]   // AHB transfer: non-sequential only
      .htrans_m  (htrans_m),      //input   wire [ 1:0]  AHB transfer: non-sequential only
      .hprot_m   (hprot_m),       //input   wire [3:0]  
      .haddr_m   (haddr_m),       //input   wire [31:0]  AHB transaction address
      .hsize_m   (hsize_m),       //input   wire [ 2:0]  AHB size: byte, half-word or word
      .hwdata_m  (hwdata_m),      //input   wire [31:0]  AHB write-data
      .hwrite_m  (hwrite_m),      //input   wire         AHB write control
      .hrdata_m  (hrdata_m),      //output  reg  [31:0]  AHB read-data
      .hready_m  (hready_m),      //output  reg          AHB stall signal
      .hresp_m   (hresp_m),       //output  reg          AHB error response
      .hsel_s    (hsel_s_loc),    //output  reg  [ 1:0]  AHB transfer: non-sequential only
      .haddr_s   (haddr_s_loc),   //output  reg  [31:0]  AHB transaction address
      .hsize_s   (hsize_s_loc),   //output  reg  [ 2:0]  AHB size: byte, half-word or word
      .hmaster_s (hmaster_s_loc),
      .hprot_s   (hprot_s_loc),
      .hwrite_s  (hwrite_s_loc),  //output  reg          AHB write control
      .hwdata_s  (hwdata_s_loc),  //output  reg  [31:0]  AHB write-data
      .hrdata_s  (hrdata_s_loc),  //input   reg  [31:0]  AHB read-data
      .hready_s  (hready_s_loc),  //input   reg          AHB stall signal
      .hresp_s   (hresp_s_loc)    //input   reg          AHB error response
      );


//-------------------------------------------
//Address Map
//-------------------------------------------
//32'h0000_0000 to 32'h0000_0FFF  program Ram
//32'h2000_0000 to 32'h2000_0FFF  On Chip Ram
//32'h4000_0000 to 32'h4000_0FFF  wdog
//32'h4001_0000 to 32'h4001_0FFF  gptimer
//32'h4002_0000 to 32'h4002_0FFF  gpcfg
//32'h4003_0000 to 32'h4003_0FFF  gpio
//32'h4004_0000 to 32'h4004_0FFF  uartm
//32'h4005_0000 to 32'h4005_0FFF  uarts
//--------------------------------------------

//------------------------------------------------------
//Hsel, haddr, hsize and hwrite generation for each slave for each master address
//------------------------------------------------------

  genvar s,m;

  //-----------------------------------------------------------
  //hsel, haddr, hsize and hwrite for each slave for MASTER[0] is checked first
  //-----------------------------------------------------------
transmonitor_dummy u_transmonitor_dummy_pram_inst (
         .hclk          (hclk),                   //input   wire         //            
         .hresetn       (hresetn),                //input   wire        
         .hmaster_m     (hmaster_s_loc[0]),       //input   wire [2:0]   // AHB transfer: non-sequential only
         .hsel_m        (hsel_s_loc[0]),          //input   wire [1:0]   // AHB transfer: non-sequential only
         .haddr_m       (haddr_s_loc[0]),         //input   wire [31:0]  // AHB transaction address
         .hsize_m       (hsize_s_loc[0]),         //input   wire [2:0]   // AHB size: byte, half-word or word
         .hprot_m       (hprot_s_loc[0]),         //input   wire [3:0]  
         .hwdata_m      (hwdata_s_loc[0]),        //input   wire [31:0]  // AHB write-data
         .hwrite_m      (hwrite_s_loc[0]),        //input   wire         // AHB write control
         .hrdata_m      (hrdata_s_loc[0]),        //output  reg  [31:0]  // AHB read-data
         .hready_m      (hready_s_loc[0]),        //output  reg          // AHB stall signal
         .hresp_m       (hresp_s_loc[0]),         //output  reg          // AHB error response
         .hsel_s        (hsel_s[0]),              //output wire [ 1:0]   // AHB transfer: non-sequential only
         .hmaster_s     (hmaster_s[0]),             //output wire [31:0]   // AHB transaction address
         .haddr_s       (haddr_s[0]),             //output wire [31:0]   // AHB transaction address
         .hsize_s       (hsize_s[0]),             //output wire [ 2:0]   // AHB size: byte, half-word or word
         .hwdata_s      (hwdata_s[0]),            //output wire [31:0]   // AHB write-data
         .hwrite_s      (hwrite_s[0]),            //output wire          // AHB write control
         .hrdata_s      (hrdata_s[0]),            //input  wire [31:0]   // AHB read-data
         .hready_s      (hready_s[0]),            //input  wire          // AHB stall signal
         .hresp_s       (hresp_s[0])              //input  wire          // AHB error response
       );

 
  generate
    for (s=1; s<=NUM_SRAMS; s=s+1) begin
    `ifdef NOTRANSMON
       transmonitor_dummy u_transmonitor_dummy_inst
    `else
       transmonitor #(
         .NUM_APU_POLICY (NUM_APU_POLICY),
         .NUM_DPU_POLICY (NUM_DPU_POLICY)
       ) u_transmonitor_inst
    `endif
        (
         .hclk          (hclk),                   //input   wire         //            
         .hmaster_m     (hmaster_s_loc[s]),       //input   wire [3:0]   // AHB transfer: non-sequential only
         .hsel_m        (hsel_s_loc[s]),          //input   wire [1:0]   // AHB transfer: non-sequential only
         .haddr_m       (haddr_s_loc[s]),         //input   wire [31:0]  // AHB transaction address
         .hsize_m       (hsize_s_loc[s]),         //input   wire [2:0]   // AHB size: byte, half-word or word
         .hprot_m       (hprot_s_loc[s]),         //input   wire [3:0]  
         .hwdata_m      (hwdata_s_loc[s]),        //input   wire [31:0]  // AHB write-data
         .hwrite_m      (hwrite_s_loc[s]),        //input   wire         // AHB write control
         .hrdata_m      (hrdata_s_loc[s]),        //output  reg  [31:0]  // AHB read-data
         .hready_m      (hready_s_loc[s]),        //output  reg          // AHB stall signal
         .hresp_m       (hresp_s_loc[s]),         //output  reg          // AHB error response
         .hsel_s        (hsel_s[s]),              //output wire [ 1:0]   // AHB transfer: non-sequential only
         .hmaster_s     (hmaster_s[s]),             //output wire [31:0]   // AHB transaction address
         .haddr_s       (haddr_s[s]),             //output wire [31:0]   // AHB transaction address
         .hsize_s       (hsize_s[s]),             //output wire [ 2:0]   // AHB size: byte, half-word or word
         .hwdata_s      (hwdata_s[s]),            //output wire [31:0]   // AHB write-data
         .hwrite_s      (hwrite_s[s]),            //output wire          // AHB write control
         .hrdata_s      (hrdata_s[s]),            //input  wire [31:0]   // AHB read-data
         .hready_s      (hready_s[s]),            //input  wire          // AHB stall signal
         .hresp_s       (hresp_s[s]),             //input  wire          // AHB error response
    `ifndef NOTRANSMON
         .apumid        (apumid[s-1]),              //[NUM_APU_POLICY-1  :0],                        //input   wire [3:0]  
         .apuaddr       (apuaddr[s-1]),             //[NUM_APU_POLICY-1 :0],                        //input   wire [31:0] 
         .apumask       (apumask[s-1]),             //[NUM_APU_POLICY-1 :0],                        //input   wire [31:0] 
         .apuperm       (apuperm[s-1]),             //[NUM_APU_POLICY-1 :0],                        //input   wire [1:0]  
         .dpumid        (dpumid[s-1]),              //[NUM_DPU_POLICY-1  :0],                        //input   wire [3:0]  
         .dpuaddr       (dpuaddr[s-1]),             //[NUM_DPU_POLICY-1 :0],                        //input   wire [31:0] 
         .dpudata       (dpudata[s-1]),             //[NUM_DPU_POLICY-1 :0],                        //input   wire [31:0] 
         .dpumask       (dpumask[s-1]),             //[NUM_DPU_POLICY-1 :0]                         //input   wire [31:0] 
         .dpuamask      (dpuamask[s-1]),             //[NUM_DPU_POLICY-1 :0]                         //input   wire [31:0] 
    `endif
         .hresetn       (hresetn)                   //input   wire        
       );

    end
  endgenerate
 
  generate
    for (s=(NUM_SRAMS+1); s<NUM_SLAVES; s=s+1) begin
    `ifdef NOTRANSMON
       transmonitor_dummy u_transmonitor_dummy_periph_inst
    `else
       transmonitor #(
         .NUM_APU_POLICY (NUM_APU_POLICY),
         .NUM_DPU_POLICY (NUM_DPU_POLICY)
       ) u_transmonitor_peiph_inst
    `endif
        (
         .hclk          (hclk),                   //input   wire         //            
         .hmaster_m     (hmaster_s_loc[s]),       //input   wire [3:0]   // AHB transfer: non-sequential only
         .hsel_m        (hsel_s_loc[s]),          //input   wire [1:0]   // AHB transfer: non-sequential only
         .haddr_m       (haddr_s_loc[s]),         //input   wire [31:0]  // AHB transaction address
         .hsize_m       (hsize_s_loc[s]),         //input   wire [2:0]   // AHB size: byte, half-word or word
         .hprot_m       (hprot_s_loc[s]),         //input   wire [3:0]  
         .hwdata_m      (hwdata_s_loc[s]),        //input   wire [31:0]  // AHB write-data
         .hwrite_m      (hwrite_s_loc[s]),        //input   wire         // AHB write control
         .hrdata_m      (hrdata_s_loc[s]),        //output  reg  [31:0]  // AHB read-data
         .hready_m      (hready_s_loc[s]),        //output  reg          // AHB stall signal
         .hresp_m       (hresp_s_loc[s]),         //output  reg          // AHB error response
         .hsel_s        (hsel_s[s]),              //output wire [ 1:0]   // AHB transfer: non-sequential only
         .hmaster_s     (hmaster_s[s]),           //output wire [31:0]   // AHB transaction address
         .haddr_s       (haddr_s[s]),             //output wire [31:0]   // AHB transaction address
         .hsize_s       (hsize_s[s]),             //output wire [ 2:0]   // AHB size: byte, half-word or word
         .hwdata_s      (hwdata_s[s]),            //output wire [31:0]   // AHB write-data
         .hwrite_s      (hwrite_s[s]),            //output wire          // AHB write control
         .hrdata_s      (hrdata_s[s]),            //input  wire [31:0]   // AHB read-data
         .hready_s      (hready_s[s]),            //input  wire          // AHB stall signal
         .hresp_s       (hresp_s[s]),              //input  wire          // AHB error response
    `ifndef NOTRANSMON
         .apumid        (apumid[s-1]),              //[NUM_APU_POLICY-1  :0],                        //input   wire [3:0]  
         .apuaddr       (apuaddr[s-1]),             //[NUM_APU_POLICY-1 :0],                        //input   wire [31:0] 
         .apumask       (apumask[s-1]),             //[NUM_APU_POLICY-1 :0],                        //input   wire [31:0] 
         .apuperm       (apuperm[s-1]),             //[NUM_APU_POLICY-1 :0],                        //input   wire [1:0]  
         .dpumid        (dpumid[s-1]),              //[NUM_DPU_POLICY-1  :0],                        //input   wire [3:0]  
         .dpuaddr       (dpuaddr[s-1]),             //[NUM_DPU_POLICY-1 :0],                        //input   wire [31:0] 
         .dpudata       (dpudata[s-1]),             //[NUM_DPU_POLICY-1 :0],                        //input   wire [31:0] 
         .dpumask       (dpumask[s-1]),             //[NUM_DPU_POLICY-1 :0]                         //input   wire [31:0] 
         .dpuamask      (dpuamask[s-1]),             //[NUM_DPU_POLICY-1 :0]                         //input   wire [31:0] 
    `endif
         .hresetn       (hresetn)                //input   wire        
       );
    end
  endgenerate



endmodule
