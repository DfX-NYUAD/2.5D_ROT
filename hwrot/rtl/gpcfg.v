module gpcfg #(
  parameter NUM_SRAMS      = 2,
  parameter NUM_CORES      = 2,
  parameter NUM_APU_POLICY = 4,
  parameter NUM_DPU_POLICY = 4
  ) (  
  // CLOCK AND RESETS ------------------
  input  wire         hclk,              // Clock
  // AHB-LITE MASTER PORT --------------
  input   wire        hsel,              // AHB transfer: non-sequential only
  input   wire [31:0] hmaster,           // AHB transaction address
  input   wire [31:0] haddr,             // AHB transaction address
  input   wire [ 2:0] hsize,             // AHB size: byte, half-word or word
  input   wire [31:0] hwdata,            // AHB write-data
  input   wire        hwrite,            // AHB write control
  output  wire  [31:0] hrdata,            // AHB read-data
  output  reg         hready,            // AHB stall signal
  output  reg         hresp,             // AHB error response
  output  reg  [31:0] spaddr[NUM_CORES-1 :0],
  output  reg  [31:0] resetaddr[NUM_CORES-1 :0],
  output  reg  [31:0] nmiaddr[NUM_CORES-1 :0],
  output  reg  [31:0] faultaddr[NUM_CORES-1 :0],
  output  reg  [31:0] irqaddr[NUM_CORES-1 :0],
  output  reg  [31:0] gpcfg17_reg,
  output  reg  [31:0] gpcfg18_reg,
  output  reg  [31:0] gpcfg19_reg,
  output  reg  [31:0] gpcfg20_reg,
  output  reg  [31:0] gpcfg21_reg,
  output  reg  [31:0] gpcfg22_reg,
  output  reg  [31:0] gpcfg23_reg,
  output  reg  [31:0] gpcfg24_reg,
  output  reg  [31:0] gpcfg25_reg,
  output  reg  [31:0] gpcfg26_reg,
  output  reg  [31:0] gpcfg27_reg,
  output  reg  [31:0] gpcfg28_reg,
  output  reg  [31:0] gpcfg29_reg,
  output  reg  [31:0] gpcfg30_reg,
  output  reg  [31:0] gpcfg31_reg,
  output  reg  [31:0] gpcfg32_reg,
  output  reg  [31:0] gpcfg33_reg,
  output  reg  [31:0] gpcfg34_reg,
  output  reg  [31:0] gpcfg35_reg,
  output  reg  [31:0] gpcfg36_reg,
  input   wire [31:0] uarts_rx_data,
  output  reg  [31:0] gpcfg38_reg,
  output  reg  [31:0] gpcfg39_reg,
  output  reg  [31:0] gpcfg40_reg,
  output  reg  [31:0] gpcfg41_reg,
  output  reg  [31:0] gpcfg42_reg,
  output  reg  [31:0] gpcfg43_reg,
  output  reg  [31:0] gpcfg44_reg,
  output  reg  [31:0] gpcfg45_reg,
  output  reg  [31:0] gpcfg46_reg,
  output  reg  [31:0] gpcfg47_reg,
  output  reg  [31:0] gpcfg48_reg,
  output  reg  [31:0] gpcfg49_reg,
  output  reg  [31:0] gpcfg50_reg,
  output  reg  [31:0] gpcfg51_reg,
  output  reg  [31:0] gpcfg52_reg,
  output  reg  [31:0] gpcfg53_reg,
  output  reg  [31:0] gpcfg54_reg,
  output  reg  [31:0] gpcfg55_reg,
  output  reg  [31:0] gpcfg56_reg,
  output  reg  [31:0] gpcfg57_reg,
  output  reg  [31:0] gpcfg58_reg,
  output  reg  [31:0] gpcfg59_reg,
  output  reg  [31:0] gpcfg60_reg,
  output  reg  [31:0] gpcfg61_reg,
  output  reg  [31:0] gpcfg62_reg,
  output  reg  [31:0] gpcfg63_reg,

`ifndef NOTRANSMON
  //------ APU --------------
  output   wire [NUM_APU_POLICY-1 :0][31:0] apumid [NUM_SRAMS  :0],
  output   wire [NUM_APU_POLICY-1 :0][31:0] apuaddr[NUM_SRAMS  :0],
  output   wire [NUM_APU_POLICY-1 :0][31:0] apumask[NUM_SRAMS  :0],
  output   wire [NUM_APU_POLICY-1 :0][31:0] apuperm[NUM_SRAMS  :0],

  //------ DPU --------------
  output   wire [NUM_DPU_POLICY-1 :0][31:0] dpumid [NUM_SRAMS  :0],
  output   wire [NUM_DPU_POLICY-1 :0][31:0] dpuaddr[NUM_SRAMS  :0],
  output   wire [NUM_DPU_POLICY-1 :0][31:0] dpudata[NUM_SRAMS  :0],
  output   wire [NUM_DPU_POLICY-1 :0][31:0] dpumask[NUM_SRAMS  :0],
  output   wire [NUM_DPU_POLICY-1 :0][31:0] dpuamask[NUM_SRAMS :0],
`endif
  input  wire         hresetn           // Asynchronous reset
);

//----------------------------------------------
//localparameter, genva and wire/reg declaration
//----------------------------------------------
  `include "gpcfg_addr_params.v";
  localparam MAX_RDATA = (NUM_SRAMS + 1)*(4*NUM_APU_POLICY + 5*NUM_DPU_POLICY) + NUM_CORES*5;
  wire [31:0] rdata [0: MAX_RDATA-1];

  reg [31:0] read_data;
  reg [31:0] read_data_mon;


  reg [31:0] haddr_lat;
  reg        valid_wr_lat;
  reg        dec_err;

  reg [3:0]  wbyte_en;
  reg [3:0]  wbyte_en_lat;

  reg   [31:0] hrdata_loc;
  wire  [31:0] hrdata_mon;
//--------------------------
//Identify valid transaction
//--------------------------
  assign valid_wr = hsel &  hwrite & hready & ~dec_err;
  assign valid_rd = hsel & ~hwrite & hready & ~dec_err;

//--------------------------
//Capture write address
//--------------------------

  always @(posedge hclk or negedge hresetn) begin 
    if (hresetn == 1'b0) begin
      haddr_lat    <= 32'b0;
      wbyte_en_lat <= 3'b0;
    end
    else if (valid_wr == 1'b1) begin
      haddr_lat    <= haddr;
      wbyte_en_lat <= wbyte_en;
    end
  end

  always @(posedge hclk or negedge hresetn) begin 
    if (hresetn == 1'b0) begin
      valid_wr_lat <= 1'b0;
    end
    else begin
      valid_wr_lat <= valid_wr;
    end
  end


//----------------------------
// Logic for getting read data
//----------------------------

  always @*  begin
    if (hsel) begin
      case (haddr[15:0]) //synopsys parallel_case 
        GPCFG17_ADDR  : begin
          read_data  = gpcfg17_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG18_ADDR  : begin
          read_data  = gpcfg18_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG19_ADDR  : begin
          read_data  = gpcfg19_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG20_ADDR  : begin
          read_data  = gpcfg20_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG21_ADDR : begin
          read_data  = gpcfg21_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG22_ADDR : begin
          read_data  = gpcfg22_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG23_ADDR : begin
          read_data  = gpcfg23_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG24_ADDR : begin
          read_data  = gpcfg24_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG25_ADDR : begin
          read_data  = gpcfg25_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG26_ADDR : begin
          read_data  = gpcfg26_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG27_ADDR : begin
          read_data  = gpcfg27_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG28_ADDR : begin
          read_data  = gpcfg28_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG29_ADDR : begin
          read_data  = gpcfg29_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG30_ADDR : begin
          read_data  = gpcfg30_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG31_ADDR : begin
          read_data  = gpcfg31_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG32_ADDR : begin
          read_data  = gpcfg32_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG33_ADDR : begin
          read_data  = gpcfg33_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG34_ADDR : begin
          read_data  = gpcfg34_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG35_ADDR : begin
          read_data  = gpcfg35_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG36_ADDR : begin
          read_data  = gpcfg36_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG37_ADDR : begin
          read_data  = uarts_rx_data & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG38_ADDR : begin
          read_data  = gpcfg38_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG39_ADDR : begin
          read_data  = gpcfg39_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG40_ADDR : begin
          read_data  = gpcfg40_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG41_ADDR : begin
          read_data  = gpcfg41_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG42_ADDR : begin
          read_data  = gpcfg42_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG43_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG44_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG45_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG46_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG47_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG48_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG49_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG50_ADDR : begin
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
        GPCFG51_ADDR : begin
          read_data  = hmaster & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG52_ADDR : begin
          read_data  = gpcfg52_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG53_ADDR : begin
          read_data  = gpcfg53_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG54_ADDR : begin
          read_data  = gpcfg54_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG55_ADDR : begin
          read_data  = gpcfg55_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG56_ADDR : begin
          read_data  = gpcfg56_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG57_ADDR : begin
          read_data  = gpcfg57_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG58_ADDR : begin
          read_data  = gpcfg58_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG59_ADDR : begin
          read_data  = gpcfg59_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG60_ADDR : begin
          read_data  = gpcfg60_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG61_ADDR : begin
          read_data  = gpcfg61_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG62_ADDR : begin
          read_data  = gpcfg62_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        GPCFG63_ADDR : begin
          read_data  = gpcfg63_reg & {32{valid_rd}};
          dec_err    = 1'b0;
        end
        default      : begin
          //read_data  = read_data_mon;
          read_data  = 32'b0;
          dec_err    = 1'b0;
        end
      endcase
    end
    else begin
      read_data = 32'b0;
      dec_err    = 1'b0;
    end
  end

  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      hrdata_loc  <= 32'b0;
    end
    else if (valid_rd == 1'b1) begin
      hrdata_loc  <= read_data;
    end
    else begin
      hrdata_loc  <= 32'b0;
    end
  end


//----------------------------
// Logic for write byte enable
// hsize
// 0000 - byte
// 0001 - hword
// 0010 - word
//----------------------------
   always @* begin
     if (valid_wr == 1'b1) begin
       if (haddr[1:0] == 2'b00) begin
         case (hsize)
           3'b000 : wbyte_en = 4'b0001;
           3'b001 : wbyte_en = 4'b0011;
           3'b010 : wbyte_en = 4'b1111;
           default: wbyte_en = 4'b0000;
         endcase
       end
       else if((haddr[1:0] == 2'b01)) begin
         case (hsize)
           3'b000 : wbyte_en = 4'b0010;
           default: wbyte_en = 4'b0000;
         endcase
       end
       else if((haddr[1:0] == 2'b10)) begin
         case (hsize)
           3'b000 : wbyte_en = 4'b0100;
           3'b001 : wbyte_en = 4'b1100;
           default: wbyte_en = 4'b0000;
         endcase
       end
       else begin
         case (hsize)
           3'b000 : wbyte_en = 4'b1000;
           default: wbyte_en = 4'b0000;
         endcase
       end
     end
     else begin
       wbyte_en = 4'b0000;
     end
   end

//----------------------------
// Logic for write data
//----------------------------

     //.OEN  (pad_ctl[i][0]),  //Output Enable
     //.REN  (pad_ctl[i][1]),  //RX     Enable
     //.P1   (pad_ctl[i][2]),  //pull settting Z, pull up, pull down Repeater
     //.P2   (pad_ctl[i][3]),  //pull settting
     //.E1   (pad_ctl[i][4]),  //drive strength 2,4,8,12ma
     //.E2   (pad_ctl[i][5]),  //drive strength
     //.SMT  (pad_ctl[i][6]),  //Schmitt trigger
     //.SR   (pad_ctl[i][7]),  //Slew Rate Control
     //.POS  (pad_ctl[i][8]),  //Power on state control, state of pad when VDD goes down
     //
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin                                     //                      OEN       REN        Pull     Drive     Override

      gpcfg17_reg  <= 32'd2500;         //UARTM_BAUD Reset value for master clock of 24 Mhz and baud rate of 9600
      gpcfg18_reg  <= 32'h0;            //UARTM_CTL
      gpcfg19_reg  <= 32'h20001400;     //SP_ADDR   
      gpcfg20_reg  <= 32'h20000E31;     //RESET_ADDR
      gpcfg21_reg  <= 32'h20000BFD;     //NMI_ADDR  
      gpcfg22_reg  <= 32'h20000BF9;     //FAULT_ADDR
      gpcfg23_reg  <= 32'h20000C21;     //IRQ0_ADDR 
      gpcfg24_reg  <= 32'h20000C25;     //IRQ1_ADDR 
      gpcfg25_reg  <= 32'h20000CE1;     //IRQ2_ADDR 
      gpcfg26_reg  <= 32'h20000CEF;     //IRQ3_ADDR 
      gpcfg27_reg  <= 32'h0;             //GP TIMER ENABLE
      gpcfg28_reg  <= 32'h0;             //TIMERA CFG
      gpcfg29_reg  <= 32'h0;             //TIMERB CFG
      gpcfg30_reg  <= 32'h0;             //TIMERC CFG
      gpcfg31_reg  <= 32'h0;             //WD TIMER ENABLE
      gpcfg32_reg  <= 32'h0;             //WD TIMER CFG
      gpcfg33_reg  <= 32'h0;             //WD TIMER CFG2
      gpcfg34_reg  <= 32'h9C4;           //UARTS_BAUD Reset value for master clock of 24 Mhz and baud rate of 9600
      gpcfg35_reg  <= 32'h0;             //UARTS_CTL
      gpcfg36_reg  <= 32'h0;             //UARTS_TXDATA
      //gpcfg37_reg  <= 32'h0;             //UARTS_RXDATA
      gpcfg38_reg  <= 32'h0;             //UARTS_TX_SEND
      gpcfg39_reg  <= 32'h0;             //SPARE0
      gpcfg40_reg  <= 32'h0;             //SPARE1
      gpcfg41_reg  <= 32'hFFFF_0000;     //SPARE2
      gpcfg42_reg  <= 32'hFFFF_0000;     //SPARE3
      gpcfg43_reg  <= 32'h0;             //KEY_REG0
      gpcfg44_reg  <= 32'h0;             //KEY_REG1
      gpcfg45_reg  <= 32'h0;             //KEY_REG2
      gpcfg46_reg  <= 32'h0;             //KEY_REG3
      gpcfg47_reg  <= 32'h0;             //KEY_REG4
      gpcfg48_reg  <= 32'h0;             //KEY_REG5
      gpcfg49_reg  <= 32'h0;             //KEY_REG6
      gpcfg50_reg  <= 32'h0;             //KEY_REG7
      gpcfg51_reg  <= 32'h0DF7_020C;     //SIGNATURE
      gpcfg52_reg  <= 32'h20000CFD;      //IRQ4_ADDR
      gpcfg53_reg  <= 32'h20000D07;      //IRQ5_ADDR
      gpcfg54_reg  <= 32'h20000D11;      //IRQ6_ADDR
      gpcfg55_reg  <= 32'h20000D19;      //IRQ7_ADDR
      gpcfg56_reg  <= 32'h20000D21;      //IRQ8_ADDR
      gpcfg57_reg  <= 32'h20000D29;      //IRQ9_ADDR
      gpcfg58_reg  <= 32'h20000D31;      //IRQ10_ADDR
      gpcfg59_reg  <= 32'h20000D39;      //IRQ11_ADDR
      gpcfg60_reg  <= 32'h20000D41;      //IRQ12_ADDR
      gpcfg61_reg  <= 32'h20000D49;      //IRQ13_ADDR
      gpcfg62_reg  <= 32'h20000D51;      //IRQ14_ADDR
      gpcfg63_reg  <= 32'h20000D59;      //IRQ15_ADDR
    end
    else if (valid_wr_lat == 1'b1) begin // (
      if (haddr_lat[15:0] == GPCFG17_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg17_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg17_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg17_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg17_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG18_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg18_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg18_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg18_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg18_reg[31:24] <= hwdata[31:24];
        end
      end

      if (haddr_lat[15:0] == GPCFG19_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg19_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg19_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg19_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg19_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG20_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg20_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg20_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg20_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg20_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG21_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg21_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg21_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg21_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg21_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG22_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg22_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg22_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg22_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg22_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG23_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg23_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg23_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg23_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg23_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG24_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg24_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg24_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg24_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg24_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG25_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg25_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg25_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg25_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg25_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG26_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg26_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg26_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg26_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg26_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG27_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg27_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg27_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg27_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg27_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG28_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg28_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg28_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg28_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg28_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG29_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg29_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg29_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg29_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg29_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG30_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg30_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg30_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg30_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg30_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG31_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg31_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg31_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg31_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg31_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG32_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg32_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg32_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg32_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg32_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG33_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg33_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg33_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg33_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg33_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG34_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg34_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg34_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg34_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg34_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG35_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg35_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg35_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg35_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg35_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG36_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg36_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg36_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg36_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg36_reg[31:24] <= hwdata[31:24];
        end
      end
      //if (haddr_lat[15:0] == GPCFG37_ADDR) begin
      //  if (wbyte_en_lat[0] == 1'b1) begin
      //    gpcfg37_reg[7:0] <= hwdata[7:0];
      //  end
      //  if (wbyte_en_lat[1] == 1'b1) begin
      //    gpcfg37_reg[15:8] <= hwdata[15:8];
      //  end
      //  if (wbyte_en_lat[2] == 1'b1) begin
      //    gpcfg37_reg[23:16] <= hwdata[23:16];
      //  end
      //  if (wbyte_en_lat[3] == 1'b1) begin
      //    gpcfg37_reg[31:24] <= hwdata[31:24];
      //  end
      //end
      if (haddr_lat[15:0] == GPCFG38_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg38_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg38_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg38_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg38_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG39_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg39_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg39_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg39_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg39_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG40_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg40_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg40_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg40_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg40_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG41_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg41_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg41_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg41_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg41_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG42_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg42_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg42_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg42_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg42_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG43_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg43_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg43_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg43_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg43_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG44_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg44_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg44_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg44_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg44_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG45_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg45_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg45_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg45_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg45_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG46_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg46_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg46_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg46_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg46_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG47_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg47_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg47_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg47_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg47_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG48_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg48_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg48_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg48_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg48_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG49_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg49_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg49_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg49_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg49_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG50_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg50_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg50_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg50_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg50_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG52_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg52_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg52_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg52_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg52_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG53_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg53_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg53_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg53_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg53_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG54_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg54_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg54_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg54_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg54_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG55_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg55_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg55_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg55_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg55_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG56_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg56_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg56_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg56_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg56_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG57_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg57_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg57_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg57_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg57_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG58_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg58_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg58_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg58_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg58_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG59_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg59_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg59_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg59_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg59_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG60_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg60_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg60_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg60_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg60_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG61_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg61_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg61_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg61_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg61_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG62_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg62_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg62_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg62_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg62_reg[31:24] <= hwdata[31:24];
        end
      end
      if (haddr_lat[15:0] == GPCFG63_ADDR) begin
        if (wbyte_en_lat[0] == 1'b1) begin
          gpcfg63_reg[7:0] <= hwdata[7:0];
        end
        if (wbyte_en_lat[1] == 1'b1) begin
          gpcfg63_reg[15:8] <= hwdata[15:8];
        end
        if (wbyte_en_lat[2] == 1'b1) begin
          gpcfg63_reg[23:16] <= hwdata[23:16];
        end
        if (wbyte_en_lat[3] == 1'b1) begin
          gpcfg63_reg[31:24] <= hwdata[31:24];
        end
      end
    end // )
    else begin
      gpcfg38_reg  <= 32'h0;             //UARTS_TX_SEND
    end
  end

genvar i;
genvar j;

`ifndef NOTRANSMON
generate
  for (j =0; j <= NUM_SRAMS ; j =j +1) begin : apu_mon_gen
    for (i =0; i < NUM_APU_POLICY; i =i +1) begin : apu_gen
      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_APU_ADDR[0][15:0] + j*16*NUM_APU_POLICY + 16*i)) u_apumid_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (apumid[j][i]),             .rdata   (rdata[4*j*i][31:0]));

      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_APU_ADDR[1][15:0] + j*16*NUM_APU_POLICY  + 16*i)) u_apuaddr_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (apuaddr[j][i]),            .rdata   (rdata[1+4*j*i][31:0]));

      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_APU_ADDR[2][15:0] + j*16*NUM_APU_POLICY  + 16*i)) u_apumask_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (apumask[j][i]),            .rdata   (rdata[2+4*j*i][31:0]));

      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_APU_ADDR[3][15:0] + j*16*NUM_APU_POLICY  + 16*i)) u_apuperm_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (apuperm[j][i]),            .rdata   (rdata[3+4*j*i][31:0]));
    end
  end
endgenerate

localparam RD_INDX0 = (NUM_SRAMS +1) * NUM_APU_POLICY * 4;

generate
  for (j =0; j <= NUM_SRAMS ; j =j +1) begin : dpu_mon_gen
    for (i =0; i < NUM_DPU_POLICY; i =i +1) begin : dpu_gen
      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_DPU_ADDR[0][15:0] + j*20*NUM_APU_POLICY  + 20*i)) u_dpumid_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (dpumid[j][i]),             .rdata   (rdata[RD_INDX0+5*j*i][31:0]));

      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_DPU_ADDR[1][15:0] + j*20*NUM_APU_POLICY  + 20*i)) u_dpuaddr_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (dpuaddr[j][i]),            .rdata   (rdata[RD_INDX0+1+5*j*i][31:0]));

      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_DPU_ADDR[2][15:0] + j*20*NUM_APU_POLICY  + 20*i)) u_dpudata_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (dpudata[j][i]),            .rdata   (rdata[RD_INDX0+2+5*j*i][31:0]));


      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_DPU_ADDR[3][15:0] + j*20*NUM_APU_POLICY  + 20*i)) u_dpumask_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (dpumask[j][i]),            .rdata   (rdata[RD_INDX0+3+5*j*i][31:0]));

      gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_DPU_ADDR[4][15:0] + j*20*NUM_APU_POLICY  + 20*i)) u_dpuamask_reg_inst (
        .hclk    (hclk),                     .hresetn (hresetn),
        .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
        .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
        .rd_addr (haddr),                    .wdata   (hwdata),
        .wr_reg  (dpuamask[j][i]),           .rdata   (rdata[RD_INDX0+4+5*j*i][31:0]));


    end
  end
endgenerate
`endif


`ifdef NOTRANSMON
localparam RD_INDX1 = 0;
`endif

`ifndef NOTRANSMON
localparam RD_INDX1 = RD_INDX0 +  ((NUM_SRAMS +1)* NUM_DPU_POLICY * 5);
`endif

generate
  for (j =0; j < NUM_CORES; j =j +1) begin : pram_gen
    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_PRAM_ADDR[0][15:0] + 20*j)) u_spaddr_reg_inst (
      .hclk    (hclk),                     .hresetn (hresetn),
      .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
      .rd_addr (haddr),                    .wdata   (hwdata),
      .wr_reg  (spaddr[j]),                .rdata   (rdata[RD_INDX1+5*j][31:0]));

    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_PRAM_ADDR[1][15:0] + 20*j)) u_resetaddr_reg_inst (
      .hclk    (hclk),                     .hresetn (hresetn),
      .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
      .rd_addr (haddr),                    .wdata   (hwdata),
      .wr_reg  (resetaddr[j]),             .rdata   (rdata[RD_INDX1+5*j+1][31:0]));

    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_PRAM_ADDR[2][15:0] + 20*j)) u_nmiaddr_reg_inst (
      .hclk    (hclk),                     .hresetn (hresetn),
      .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
      .rd_addr (haddr),                    .wdata   (hwdata),
      .wr_reg  (nmiaddr[j]),               .rdata   (rdata[RD_INDX1+5*j+2][31:0]));

    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_PRAM_ADDR[3][15:0] + 20*j)) u_faultaddr_reg_inst (
      .hclk    (hclk),                     .hresetn (hresetn),
      .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
      .rd_addr (haddr),                    .wdata   (hwdata),
      .wr_reg  (faultaddr[j]),             .rdata   (rdata[RD_INDX1+5*j+3][31:0]));

    gpcfg_rd_wr #( .RESET_VAL (32'd0), .CFG_ADDR (GPCFG_PRAM_ADDR[4][15:0] + 20*j)) u_irqaddr_reg_inst (
      .hclk    (hclk),                     .hresetn (hresetn),
      .wr_en   (valid_wr_lat),             .rd_en   (valid_rd),
      .byte_en (wbyte_en_lat),             .wr_addr (haddr_lat),
      .rd_addr (haddr),                    .wdata   (hwdata),
      .wr_reg  (irqaddr[j]),               .rdata   (rdata[RD_INDX1+5*j+4][31:0]));
  end
endgenerate



integer k;
//always@* begin
//  read_data_mon  = 32'b0;
//`ifndef NOTRANSMON
//  for (k=0; k<MAX_RDATA; k=k+1) begin
//    read_data_mon  = rdata[k][31:0] | read_data_mon;
//  end
//`endif
//end

gpcfg_rdata_mux #(
  .NUM_RDATA (MAX_RDATA-1)) u_gpcfg_rdata_mux_inst (
  .hclk      (hclk),
  .hresetn   (hresetn),
  .rdata     (rdata[0 :MAX_RDATA-1]),
  .valid_rd  (valid_rd),
  .hrdata    (hrdata_mon)
);

assign hrdata = hrdata_loc | hrdata_mon;


//------------------------------------
// Logic to generate hresp and hready
//------------------------------------
   
  always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) begin
      hready <= 1'b1;
      hresp  <= 1'b0;
    end
    else if (dec_err == 1'b1) begin
      hready <= 1'b0;
      hresp  <= 1'b1;
    end
    else begin
      hready <= 1'b1;
      hresp  <= ~hready;
    end
  end
  


endmodule
