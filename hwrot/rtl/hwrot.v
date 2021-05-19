module hwrot #(
 parameter NUM_CORES      = 33,
 parameter NUM_SRAMS      = 4,
 parameter NUM_64K_MEM    = 8,
 parameter NUM_APU_POLICY = 8,
 parameter NUM_DPU_POLICY = 8)
(
  input   wire [3  :0]  core_in,
  output  wire          core_out
);


//----------------------------------------------
//localparameter,genvar and reg/wire delcaration
//----------------------------------------------

  //localparam NUM_CORES          = 33;
  localparam NUM_MASTERS        = 1 + NUM_CORES;
  //localparam NUM_SRAMS          = 4;
  localparam NUM_SLAVES         = NUM_SRAMS + 2;

  //localparam NUM_64K_MEM        = 8;

  //localparam NUM_APU_POLICY     = 8;
  //localparam NUM_DPU_POLICY     = 8;

  localparam PRAM_S_ID          = 0;
  localparam GPCFG_S_ID         = NUM_SLAVES-1;

  localparam PRAM_BASE          = 32'h0000_0000;
  localparam SYSRAM0_BASE       = 32'h2000_0000;
  localparam SYSRAM1_BASE       = 32'h2100_0000;
  localparam SYSRAM2_BASE       = 32'h2200_0000;
  localparam SYSRAM3_BASE       = 32'h2300_0000;
  localparam GPCFG_BASE         = 32'h4002_0000;

  localparam GPCFG_BASE_MASK    = 32'h0000_FFFF;
  localparam SYSRAM0_BASE_MASK  = 32'h0001_FFFF;
  localparam PRAM_BASE_MASK     = 32'h0000_FFFF;

  localparam UARTM_M_ID         = 0;

wire        hclk;
wire        nreset;
wire        nporeset;

wire        nporeset_sync;
wire        nporeset_sync_wdt;
reg         nporeset_sync0;
reg         nporeset_sync1;
reg         nporeset_sync2;

wire        nreset_sync;
reg         nreset_sync0;
reg         nreset_sync1;
reg         nreset_sync2;

wire [1:0]  htrans_m0;
wire [31:0] haddr_m0;
wire [2:0]  hsize_m0;
wire [31:0] hwdata_m0;
wire [31:0] hrdata_m0;
wire [31:0] hrdata_gpcfg;
wire [31:0] hrdata_sram_wrap;

wire [31:0] spaddr[NUM_CORES-1 :0];
wire [31:0] resetaddr[NUM_CORES-1 :0];
wire [31:0] nmiaddr[NUM_CORES-1 :0];
wire [31:0] faultaddr[NUM_CORES-1 :0];
wire [31:0] irqaddr[NUM_CORES-1 :0];
wire [31:0] gpcfg_reg[63:17];
wire [31:0] i_val;

wire [ 1:0] htrans_m[NUM_MASTERS-1 :0];      // AHB transfer: non-sequential only
wire [31:0] haddr_m[NUM_MASTERS-1 :0];       // AHB transaction address
wire [31:0] haddr_m_loc[NUM_MASTERS-1 :0];       // AHB transaction address
wire [ 2:0] hsize_m[NUM_MASTERS-1 :0];       // AHB size: byte, half-word or word
wire [31:0] hmaster_m[NUM_MASTERS-1 :0];       // AHB size: byte, half-word or word
wire [ 3:0] hprot_m[NUM_MASTERS-1 :0];       // AHB size: byte, half-word or word
wire [31:0] hwdata_m[NUM_MASTERS-1 :0];      // AHB write-data
wire        hwrite_m[NUM_MASTERS-1 :0];      // AHB write control
wire [31:0] hrdata_m[NUM_MASTERS-1 :0];      // AHB read-data
wire        hready_m[NUM_MASTERS-1 :0];      // AHB stall signal
wire        hresp_m[NUM_MASTERS-1 :0];       // AHB error response
wire        hsel_s[NUM_SLAVES-1 :0];         // AHB transfer: non-sequential only
wire [31:0] haddr_s[NUM_SLAVES-1 :0];        // AHB transaction address
wire [31:0] hmaster_s[NUM_SLAVES-1 :0];        // AHB transaction address
wire [ 2:0] hsize_s[NUM_SLAVES-1 :0];        // AHB size: byte, half-word or word
wire        hwrite_s[NUM_SLAVES-1 :0];       // AHB write control
wire [31:0] hwdata_s[NUM_SLAVES-1 :0];       // AHB write-data
reg [31:0] hrdata_s[NUM_SLAVES-1 :0];       // AHB read-data
reg        hready_s[NUM_SLAVES-1 :0];       // AHB stall signal
reg        hresp_s[NUM_SLAVES-1 :0];        // AHB error response

`ifndef NOTRANSMON
wire [NUM_APU_POLICY-1 :0][31:0] apumid [NUM_SRAMS :0];
wire [NUM_APU_POLICY-1 :0][31:0] apuaddr[NUM_SRAMS :0];
wire [NUM_APU_POLICY-1 :0][31:0] apumask[NUM_SRAMS :0];
wire [NUM_APU_POLICY-1 :0][31:0] apuperm[NUM_SRAMS :0];
wire [NUM_DPU_POLICY-1 :0][31:0] dpumid [NUM_SRAMS :0];
wire [NUM_DPU_POLICY-1 :0][31:0] dpuaddr[NUM_SRAMS :0];
wire [NUM_DPU_POLICY-1 :0][31:0] dpudata[NUM_SRAMS :0];
wire [NUM_DPU_POLICY-1 :0][31:0] dpumask[NUM_SRAMS :0];
wire [NUM_DPU_POLICY-1 :0][31:0] dpuamask[NUM_SRAMS :0];
`endif


assign hprot_m[UARTM_M_ID] = 4'b0;
uartm u_uartm_inst (
  .hclk        (hclk),                 //input  wire            // Clock
  .hresetn     (nporeset_sync),        //input  wire            // Asynchronous reset
  .haddr       (haddr_m[UARTM_M_ID]),  //output reg  [31:0]     // AHB transaction address
  .hsize       (hsize_m[UARTM_M_ID]),  //output wire [ 2:0]     // AHB size: byte, half-word or word
  .htrans      (htrans_m[UARTM_M_ID]), //output reg  [ 1:0]     // AHB transfer: non-sequential only
  .hwdata      (hwdata_m[UARTM_M_ID]), //output reg  [31:0]     // AHB write-data
  .hwrite      (hwrite_m[UARTM_M_ID]), //output reg             // AHB write control
  .hrdata      (hrdata_m[UARTM_M_ID]), //input  wire [31:0]     // AHB read-data
  .hready      (hready_m[UARTM_M_ID]), //input  wire            // AHB stall signal
  .hresp       (hresp_m[UARTM_M_ID]),  //input  wire            // AHB error response
  .uartm_baud  (gpcfg_reg[17]),        //input  wire [31:0] 
  .uartm_ctl   (gpcfg_reg[18]),        //input  wire [31:0]   //1:0 : 00 => 8 bit, 01 => 16 bit, 10 => 32 bit, 11 => 8 bit
  .TX          (uartm_tx),             //output wire          // Event output (SEV executed)
  .RX          (uartm_rx)              //input  wire          // Event input
);

 assign hmaster_m[0] = 32'h0;

 assign core_out = uartm_tx;
 assign uartm_rx = core_in[3];


wire wdtimer_nmi, timerC_irq, timerB_irq, timerA_irq;

genvar i;

generate
  for (i=1; i<=NUM_CORES; i=i+1) begin
    CORTEXM0DS_wrap u_cortexm0_wrap_inst (
      .HCLK           (hclk),             //input  wire         Clock
      .HRESETn        (nreset_sync),      //input  wire         Asynchronous reset
      .HADDR          (haddr_m[i]),       //output wire [31:0]  AHB transaction address
      .HBURST         (),                 //output wire [ 2:0]  AHB burst: tied to single
      .HMASTLOCK      (),                 //output wire         AHB locked transfer (always zero)
      .HPROT          (hprot_m[i]),       //output wire [ 3:0]  AHB protection: priv; data or inst
      .HSIZE          (hsize_m[i]),       //output wire [ 2:0]  AHB size: byte, half-word or word
      .HTRANS         (htrans_m[i]),      //output wire [ 1:0]  AHB transfer: non-sequential only
      .HWDATA         (hwdata_m[i]),      //output wire [31:0]  AHB write-data
      .HWRITE         (hwrite_m[i]),      //output wire         AHB write control
      .HRDATA         (hrdata_m[i][31:0]),//input  wire [31:0]  AHB read-data
      .HREADY         (hready_m[i]),         //input  wire         AHB stall signal
      .HRESP          (hresp_m[i]),          //input  wire         AHB error response
      .NMI            (wdtimer_nmi),         //input  wire         Non-maskable interrupt input
      .IRQ            ({7'b0,gpcfg_reg[41][i-1], gpcfg_reg[40][i-1], gpcfg_reg[39][i-1], 2'b0, timerC_irq, timerB_irq, timerA_irq, 1'b0}),//input  wire [15:0]  Interrupt request inputs
      .TXEV           (),                  //output wire         Event output (SEV executed)
      .RXEV           (gpcfg_reg[39][10]), //input  wire         Event input                    TODO
      .LOCKUP         (),                  //output wire         Core is locked-up              TODO
      .SYSRESETREQ    (),                  //output wire         System reset request           TODO
      .SLEEPING       ()                   //output wire         Core and NVIC sleeping         TODO
    );
    assign hmaster_m[i] = i;
  end
endgenerate



ahb_ic_wrap #(
  .NUM_APU_POLICY  (NUM_APU_POLICY),
  .NUM_DPU_POLICY  (NUM_DPU_POLICY),
  .NUM_CORES       (NUM_CORES),
  .NUM_SRAMS       (NUM_SRAMS),
  .NUM_SLAVES      (NUM_SLAVES),
  .NUM_MASTERS     (NUM_MASTERS),
  .SLAVE_BASE_MASK ( {GPCFG_BASE_MASK,
                       SYSRAM0_BASE_MASK,
                       PRAM_BASE_MASK}),
  .SLAVE_BASE  ( {GPCFG_BASE,
                  SYSRAM0_BASE,
                  PRAM_BASE})
  ) u_ahb_ic_wrap_inst (  
  .hclk      (hclk),                              //input  wire          Clock
  .htrans_m  (htrans_m),      //input   wire [ 1:0]  AHB transfer: non-sequential only
  .hmaster_m (hmaster_m),
  .haddr_m   (haddr_m),       //input   wire [31:0]  AHB transaction address
  .hsize_m   (hsize_m),       //input   wire [ 2:0]  AHB size: byte, half-word or word
  .hprot_m   (hprot_m),       //output wire [ 3:0]  AHB protection: priv; data or inst
  .hwdata_m  (hwdata_m),      //input   wire [31:0]  AHB write-data
  .hwrite_m  (hwrite_m),      //input   wire         AHB write control
  .hrdata_m  (hrdata_m),      //output  reg  [31:0]  AHB read-data
  .hready_m  (hready_m),      //output  reg          AHB stall signal
  .hresp_m   (hresp_m),       //output  reg          AHB error response
  .hsel_s    (hsel_s),        //output  reg  [ 1:0]  AHB transfer: non-sequential only
  .hmaster_s (hmaster_s),
  .haddr_s   (haddr_s),       //output  reg  [31:0]  AHB transaction address
  .hsize_s   (hsize_s),       //output  reg  [ 2:0]  AHB size: byte, half-word or word
  .hwrite_s  (hwrite_s),      //output  reg          AHB write control
  .hwdata_s  (hwdata_s),      //output  reg  [31:0]  AHB write-data
  .hrdata_s  (hrdata_s),      //input   reg  [31:0]  AHB read-data
  .hready_s  (hready_s),      //input   reg          AHB stall signal
  .hresp_s   (hresp_s),        //input   reg          AHB error response
`ifndef NOTRANSMON
  .apumid    (apumid),
  .apuaddr   (apuaddr),
  .apumask   (apumask),
  .apuperm   (apuperm),
  .dpumid    (dpumid),
  .dpuaddr   (dpuaddr),
  .dpudata   (dpudata),
  .dpumask   (dpumask),
  .dpuamask   (dpuamask),
`endif
  .hresetn   (nporeset_sync)                         //input  wire          Asynchronous reset

);

wire [31:0] hrdata_pram [NUM_CORES-1 :0];
wire [NUM_CORES-1 :0] hready_pram ;
wire [NUM_CORES-1 :0] hresp_pram;

generate
  for (i=1; i<=NUM_CORES; i=i+1) begin
pram u_pram_inst (  
  .hclk               (hclk),                       //input   wire         Clock
  .hresetn            (nporeset_sync),              //input   wire         Asynchronous reset
  .hsel               (hsel_s[PRAM_S_ID] && (hmaster_s[PRAM_S_ID] == i)),          //input   wire         AHB transfer: non-sequential only
  .haddr              (haddr_s[PRAM_S_ID]),         //input   wire [31:0]  AHB transaction address
  .hsize              (hsize_s[PRAM_S_ID]),         //input   wire [ 2:0]  AHB size: byte, half-word or word
  .hwrite             (hwrite_s[PRAM_S_ID]),        //input   wire         AHB write control
  .hrdata             (hrdata_pram[i-1]),        //output  reg  [31:0]  AHB read-data
  .hready             (hready_pram[i-1]),        //output  reg          AHB stall signal
  .hresp              (hresp_pram[i-1]),         //output  reg          AHB error response
  .sp_addr            (spaddr[0]),
  .reset_addr         (resetaddr[0]),
  .nmi_addr           (nmiaddr[0]),
  .fault_addr         (faultaddr[0]),
  .irq0_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq1_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq2_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq3_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq4_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq5_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq6_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq7_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq8_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq9_addr          (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq10_addr         (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq11_addr         (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq12_addr         (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq13_addr         (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq14_addr         (irqaddr[0][31:0]),  //(irqaddr[i-1]),
  .irq15_addr         (irqaddr[0][31:0])   //(irqaddr[i-1])
);

  end
endgenerate

integer k;
 always@* begin
        hrdata_s[PRAM_S_ID]   = 32'b0;
        hresp_s[PRAM_S_ID]    = 1'b0;
        hready_s[PRAM_S_ID]   = 1'b1;
        for (k=0; k<NUM_CORES; k=k+1) begin
          hrdata_s[PRAM_S_ID] = hrdata_pram[k] | hrdata_s[PRAM_S_ID];
          hresp_s[PRAM_S_ID]  = hresp_pram[k]  | hresp_s[PRAM_S_ID];
          hready_s[PRAM_S_ID] = hready_pram[k] & hready_s[PRAM_S_ID];
        end
 end



generate
  for (i=1; i<(NUM_SRAMS+1); i=i+1) begin
    sram_wrap #(
      .NUM_64K_MEM (NUM_64K_MEM)
    ) u_sram_wrap_inst (  
      .hclk       (hclk),           // Clock                             input  wire         
      .hresetn    (nporeset_sync),  // Asynchronous reset                input  wire         
      .hsel       (hsel_s[i]),   // AHB transfer: non-sequential only input   wire [ 1:0] 
      .haddr      (haddr_s[i]),  // AHB transaction address           input   wire [31:0] 
      .hsize      (hsize_s[i]),  // AHB size: byte, half-word or word input   wire [ 2:0] 
      .hwdata     (hwdata_s[i]), // AHB write-data                    input   wire [31:0] 
      .hwrite     (hwrite_s[i]), // AHB write control                 input   wire        
      .hrdata     (hrdata_s[i]), // AHB read-data                     output  reg  [31:0] 
      .hready     (hready_s[i]), // AHB stall signal                  output  reg         
      .hresp      (hresp_s[i])   // AHB error response                output  reg         
    );
  end
endgenerate


gpcfg #(
  .NUM_SRAMS       (NUM_SRAMS),
  .NUM_CORES       (NUM_CORES),
  .NUM_APU_POLICY  (NUM_APU_POLICY),
  .NUM_DPU_POLICY  (NUM_DPU_POLICY)
) u_gpcfg_inst (
  .hclk           (hclk),                     //input  wire          Clock
  .hsel           (hsel_s[GPCFG_S_ID]),       //input   wire [ 1:0]  AHB transfer: non-sequential only
  .hmaster        (hmaster_s[GPCFG_S_ID]),      //input   wire [31:0]  AHB transaction address
  .haddr          (haddr_s[GPCFG_S_ID]),      //input   wire [31:0]  AHB transaction address
  .hsize          (hsize_s[GPCFG_S_ID]),      //input   wire [ 2:0]  AHB size: byte, half-word or word
  .hwdata         (hwdata_s[GPCFG_S_ID]),     //input   wire [31:0]  AHB write-data
  .hwrite         (hwrite_s[GPCFG_S_ID]),     //input   wire         AHB write control
  .hrdata         (hrdata_s[GPCFG_S_ID]),     //output  reg  [31:0]  AHB read-data
  .hready         (hready_s[GPCFG_S_ID]),     //output  wire         AHB stall signal
  .hresp          (hresp_s[GPCFG_S_ID]),      //output  wire         AHB error response
  .spaddr         (spaddr),
  .resetaddr      (resetaddr),
  .nmiaddr        (nmiaddr),
  .faultaddr      (faultaddr),
  .irqaddr        (irqaddr),
  .gpcfg17_reg    (gpcfg_reg[17]),
  .gpcfg18_reg    (gpcfg_reg[18]),
  .gpcfg19_reg    (gpcfg_reg[19]),    //output  reg  [31:0] 
  .gpcfg20_reg    (gpcfg_reg[20]),    //output  reg  [31:0] 
  .gpcfg21_reg    (gpcfg_reg[21]),    //output  reg  [31:0] 
  .gpcfg22_reg    (gpcfg_reg[22]),    //output  reg  [31:0] 
  .gpcfg23_reg    (gpcfg_reg[23]),    //output  reg  [31:0] 
  .gpcfg24_reg    (gpcfg_reg[24]),    //output  reg  [31:0] 
  .gpcfg25_reg    (gpcfg_reg[25]),    //output  reg  [31:0] 
  .gpcfg26_reg    (gpcfg_reg[26]),    //output  reg  [31:0] 
  .gpcfg27_reg    (gpcfg_reg[27]),    //output  reg  [31:0] 
  .gpcfg28_reg    (gpcfg_reg[28]),    //output  reg  [31:0] 
  .gpcfg29_reg    (gpcfg_reg[29]),    //output  reg  [31:0] 
  .gpcfg30_reg    (gpcfg_reg[30]),    //output  reg  [31:0] 
  .gpcfg31_reg    (gpcfg_reg[31]),    //output  reg  [31:0] 
  .gpcfg32_reg    (gpcfg_reg[32]),    //output  reg  [31:0] 
  .gpcfg33_reg    (gpcfg_reg[33]),    //output  reg  [31:0] 
  .gpcfg34_reg    (gpcfg_reg[34]),    //output  reg  [31:0] 
  .gpcfg35_reg    (gpcfg_reg[35]),    //output  reg  [31:0] 
  .gpcfg36_reg    (gpcfg_reg[36]),    //output  reg  [31:0] 
  .uarts_rx_data  (32'b0),
  .gpcfg38_reg    (gpcfg_reg[38]),    //output  reg  [31:0] 
  .gpcfg39_reg    (gpcfg_reg[39]),    //output  reg  [31:0] 
  .gpcfg40_reg    (gpcfg_reg[40]),    //output  reg  [31:0] 
  .gpcfg41_reg    (gpcfg_reg[41]),    //output  reg  [31:0] 
  .gpcfg42_reg    (gpcfg_reg[42]),    //output  reg  [31:0] 
  .gpcfg43_reg    (gpcfg_reg[43]),    //output  reg  [31:0] 
  .gpcfg44_reg    (gpcfg_reg[44]),    //output  reg  [31:0] 
  .gpcfg45_reg    (gpcfg_reg[45]),    //output  reg  [31:0] 
  .gpcfg46_reg    (gpcfg_reg[46]),    //output  reg  [31:0] 
  .gpcfg47_reg    (gpcfg_reg[47]),    //output  reg  [31:0] 
  .gpcfg48_reg    (gpcfg_reg[48]),    //output  reg  [31:0] 
  .gpcfg49_reg    (gpcfg_reg[49]),    //output  reg  [31:0] 
  .gpcfg50_reg    (gpcfg_reg[50]),    //output  reg  [31:0] 
  .gpcfg51_reg    (gpcfg_reg[51]),    //output  reg  [31:0] 
  .gpcfg52_reg    (gpcfg_reg[52]),    //output  reg  [31:0] 
  .gpcfg53_reg    (gpcfg_reg[53]),    //output  reg  [31:0] 
  .gpcfg54_reg    (gpcfg_reg[54]),    //output  reg  [31:0] 
  .gpcfg55_reg    (gpcfg_reg[55]),    //output  reg  [31:0] 
  .gpcfg56_reg    (gpcfg_reg[56]),    //output  reg  [31:0] 
  .gpcfg57_reg    (gpcfg_reg[57]),    //output  reg  [31:0] 
  .gpcfg58_reg    (gpcfg_reg[58]),    //output  reg  [31:0] 
  .gpcfg59_reg    (gpcfg_reg[59]),    //output  reg  [31:0] 
  .gpcfg60_reg    (gpcfg_reg[60]),    //output  reg  [31:0] 
  .gpcfg61_reg    (gpcfg_reg[61]),    //output  reg  [31:0] 
  .gpcfg62_reg    (gpcfg_reg[62]),    //output  reg  [31:0] 
  .gpcfg63_reg    (gpcfg_reg[63]),     //output  reg  [31:0] 
`ifndef NOTRANSMON
  .apumid         (apumid),
  .apuaddr        (apuaddr),
  .apumask        (apumask),
  .apuperm        (apuperm),
  .dpumid         (dpumid),
  .dpuaddr        (dpuaddr),
  .dpudata        (dpudata),
  .dpumask        (dpumask),
  .dpuamask        (dpuamask),
`endif
  .hresetn        (nporeset_sync)            //input  wire          Asynchronous reset
);


timer u_timer_inst (
  .hclk          (hclk),
  .hresetn       (nporeset_sync),
  .wdt_rstn      (nporeset_sync_wdt),
  .timerA_cfg    (gpcfg_reg[28]),
  .timerB_cfg    (gpcfg_reg[29]),
  .timerC_cfg    (gpcfg_reg[30]),
  .wdtimer_cfg   (gpcfg_reg[32]),
  .wdtimer_cfg2  (gpcfg_reg[33]),
  .timerA_en     (gpcfg_reg[27][0]),
  .timerB_en     (gpcfg_reg[27][8]),
  .timerC_en     (gpcfg_reg[27][16]),
  .wdtimer_en    (gpcfg_reg[31][0]),
  .timerA_rst    (gpcfg_reg[27][1]),
  .timerB_rst    (gpcfg_reg[27][9]),
  .timerC_rst    (gpcfg_reg[27][17]),
  .wdtimer_rst   (gpcfg_reg[31][1]),
  .pwm_val_tim0  (gpcfg_reg[40]),
  .pwm_val_tim1  (gpcfg_reg[41]),
  .timerA_irq    (timerA_irq),
  .timerB_irq    (timerB_irq),
  .timerC_irq    (timerC_irq),
  .wdtimer_irq   (wdtimer_irq),
  .wdtimer_nmi   (wdtimer_nmi),
  .pwm_out       ()
);




//------------------------------
//Pad to functionality mapping
//------------------------------
//pad0   nPORESET
//pad1   nRESET
//pad2   hclk
//------------------------------


    assign nporeset    = core_in[0]; 
    assign nreset      = core_in[1]; 

    `ifdef FPGA_SYNTH
       clock_div u_clk_div4_inst ( 
         .CLK_IN1(core_in[2]),
         .CLK_OUT1(hclk)
       );
    `else
      assign hclk        = core_in[2]; 
    `endif

 always @ (posedge hclk or negedge nporeset) begin
   if (nporeset == 1'b0) begin
     nporeset_sync0 <= 1'b0;
     nporeset_sync1 <= 1'b0;
     nporeset_sync2 <= 1'b0;
   end
   else begin
     nporeset_sync0 <= 1'b1;
     nporeset_sync1 <= nporeset_sync0;
     nporeset_sync2 <= nporeset_sync1;
   end
 end

 assign nporeset_sync     = nporeset_sync2 & nporeset_sync1 & nporeset_sync0 & nporeset & ~wdtimer_irq;
 assign nporeset_sync_wdt = nporeset_sync2 & nporeset_sync1 & nporeset_sync0 & nporeset;

 always @ (posedge hclk or negedge nreset) begin
   if (nreset == 1'b0) begin
     nreset_sync0 <= 1'b0;
     nreset_sync1 <= 1'b0;
     nreset_sync2 <= 1'b0;
   end
   else begin
     nreset_sync0 <= 1'b1;
     nreset_sync1 <= nreset_sync0;
     nreset_sync2 <= nreset_sync1;
   end
 end

 assign nreset_sync = nreset_sync2 & nreset_sync1 & nreset_sync0 & nreset & nporeset_sync;

endmodule
