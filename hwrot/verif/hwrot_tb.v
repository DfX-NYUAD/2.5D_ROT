`timescale 1 ns/1 ps
//`define RELEASE_M0_RESET

module hwrot_tb (
);

//---------------------------------
//Local param reg/wire declaration
//---------------------------------

localparam  CLK_PERIOD   = 4.167;   //24 Mhz
localparam  UART_BAUD    = 41.67; //9600 bps

wire [3:0] core_in;
wire       core_out;

reg     CLK; 
reg     nPORESET; 
reg     nRESET; 

reg       UART_CLK; 
reg [9:0] tx_reg = 10'h3FF; 
reg [7:0] rx_reg; 
wire uartm_rx_data;

integer no_of_clocks; 

reg [1023:0] mem [0:511];


//Address params
`include "./hwrot_header.v"

//Tasks
`include "./hwrot_tasks.v"

//Defines
`define ARM_UD_MODEL;

//integer meminit;
//integer read_meminit;
//meminit      = $fopen("./cm0.hex","r");
//read_meminit = $fscanf(meminit,"%h\n",mem);
initial $readmemh("./cm0.hex", mem);

//------------------------------
//Clock and Reset generation
//------------------------------

initial begin
  CLK      = 1'b0; 
  UART_CLK = 1'b0; 
end

always begin
  #(CLK_PERIOD/2) CLK = ~CLK; 
end

always begin
  #(UART_BAUD/2) UART_CLK = ~UART_CLK; 
end


initial begin
$display("Memory value check:%h",mem[0]); 
$display("Memory value check:%h",mem[511]); 

#0 nPORESET  = 1'b1;
   nRESET    = 1'b1;

  repeat (10) begin
    @(posedge CLK);
  end
force hwrot_tb.u_dut_inst.u_gpcfg_inst.gpcfg17_reg = 32'h9;
//force hwrot_tb.u_dut_inst.genblk2[1].u_sram_wrap_inst.genblk1[0].u_sram_inst.mem[0:16383] = mem;

   nPORESET  = 1'b0;
   nRESET    = 1'b0;


  repeat (20) begin
    @(posedge CLK);
  end

  nPORESET = 1'b1;

  force hwrot_tb.u_dut_inst.genblk3[1].u_sram_wrap_inst.genblk1[0].u_sram_inst.mem[0:511] = mem;
  repeat (10) begin
    @(posedge CLK);
  end
  release hwrot_tb.u_dut_inst.genblk3[1].u_sram_wrap_inst.genblk1[0].u_sram_inst.mem[0:511];
  $display("Memory value check:%h",hwrot_tb.u_dut_inst.genblk3[1].u_sram_wrap_inst.genblk1[0].u_sram_inst.mem[0]); 
  $display("Memory value check:%h",hwrot_tb.u_dut_inst.genblk3[1].u_sram_wrap_inst.genblk1[0].u_sram_inst.mem[511]); 

  repeat (25) begin
    @(posedge UART_CLK);
  end

uartm_write (.addr(32'h20000080), .data(32'h00000000));
uartm_write (.addr(32'h20000084), .data(32'h00000000));
uartm_write (.addr(32'h20000088), .data(32'h0000000C));


`include "./hex/test.hex"

uartm_write    (.addr(GPCFG_APU0_MID),    .data(32'h00000002));
uartm_write    (.addr(GPCFG_APU0_ADDR),   .data(32'h20000000));
//uartm_write    (.addr(GPCFG_APU0_MASK),   .data(32'h00007FFF));
uartm_write    (.addr(GPCFG_APU0_MASK),   .data(32'h0001FFFF));
uartm_write    (.addr(GPCFG_APU0_PERM),   .data(32'h00000003));

uartm_write    (.addr(GPCFG_APU1_MID),    .data(32'h00000003));
uartm_write    (.addr(GPCFG_APU1_ADDR),   .data(32'h20000000));
 //uartm_write    (.addr(GPCFG_APU1_MASK),   .data(32'h0000FFF0));
uartm_write    (.addr(GPCFG_APU1_MASK),   .data(32'h0001FFFF));
uartm_write    (.addr(GPCFG_APU1_PERM),   .data(32'h00000003));

 uartm_write    (.addr(GPCFG_APU2_MID),    .data(32'h00000002));
 //uartm_write    (.addr(GPCFG_APU2_ADDR),   .data(32'h4002006c));
 uartm_write    (.addr(GPCFG_APU2_ADDR),   .data(32'h40020000));
 //uartm_write    (.addr(GPCFG_APU2_MASK),   .data(32'h0000006c));
 uartm_write    (.addr(GPCFG_APU2_MASK),   .data(32'h0000FFFF));
 uartm_write    (.addr(GPCFG_APU2_PERM),   .data(32'h00000003));

 uartm_write    (.addr(GPCFG_APU3_MID),    .data(32'h00000003));
 //uartm_write    (.addr(GPCFG_APU3_ADDR),   .data(32'h40020074));
 uartm_write    (.addr(GPCFG_APU3_ADDR),   .data(32'h40020000));
 //uartm_write    (.addr(GPCFG_APU3_MASK),   .data(32'h00000F8b));
 uartm_write    (.addr(GPCFG_APU3_MASK),   .data(32'h0000FFFF));
 uartm_write    (.addr(GPCFG_APU3_PERM),   .data(32'h00000003));



 //uartm_write    (.addr(GPCFG_DPU0_MID),    .data(32'h00000002));
 //uartm_write    (.addr(GPCFG_DPU0_ADDR),   .data(32'h4002009c));
 //uartm_write    (.addr(GPCFG_DPU0_DATA),   .data(32'h00000000));
 //uartm_write    (.addr(GPCFG_DPU0_MASK),   .data(32'hFFFFFFFE));
 //uartm_write    (.addr(GPCFG_DPU0_AMASK),  .data(32'h00000000));
//
 uartm_write    (.addr(GPCFG_DPU1_MID),    .data(32'h00000002));
 uartm_write    (.addr(GPCFG_DPU1_ADDR),   .data(32'h2000FFFC));
 uartm_write    (.addr(GPCFG_DPU1_DATA),   .data(32'h0BADBEEF));
 uartm_write    (.addr(GPCFG_DPU1_MASK),   .data(32'h00000000));
 uartm_write    (.addr(GPCFG_DPU1_AMASK),  .data(32'h0FFFFFFF));

//uartm_write    (.addr(GPCFG_DPU3_MID),    .data(32'h00000002));
//uartm_write    (.addr(GPCFG_DPU3_ADDR),   .data(32'h4002009c));
//uartm_write    (.addr(GPCFG_DPU3_DATA),   .data(32'h00000000));
//uartm_write    (.addr(GPCFG_DPU3_MASK),   .data(32'hFFFFFFFE));
//uartm_write    (.addr(GPCFG_DPU3_AMASK),  .data(32'h00000000));

//`ifdef RELEASE_M0_RESET
  repeat (10) begin
    @(posedge UART_CLK);
  end

  nRESET   = 1'b1;
//`endif

end



//------------------------------
//DUT
//------------------------------
hwrot #(
  .NUM_CORES      (2),  
  .NUM_SRAMS      (1),
  .NUM_64K_MEM    (1),
  .NUM_APU_POLICY (8),
  .NUM_DPU_POLICY (8)
) u_dut_inst (
  .core_in   (core_in),
  .core_out  (core_out)
  );

//------------------------------
//Pad to functionality mapping
//------------------------------
//core_in0  nPORESET
//core_in1  nRESET
//core_in2  CLK
//core_in3  UARTM_TX
//core_in4  UARTM_RX
//------------------------------

assign core_in[0]  = nPORESET;
assign core_in[1]  = nRESET;
assign core_in[2]  = CLK;
assign core_in[3]  = tx_reg[0];

assign uartm_rx_data = core_out;


//------------------------------
//Track number of clocks
//------------------------------
initial begin
  no_of_clocks = 0; 
end
always@(posedge CLK)  begin
  no_of_clocks = no_of_clocks +1 ; 
  //$display($time, " << Number of Clocks value         %d", no_of_clocks);
  //$display($time, " << htrans_m[0] value              %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.htrans_m[0][1]);
  //$display($time, " << vlaid_trans_s_by_m[s][0] value %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.vlaid_trans_s_by_m[0][0]);
  //$display($time, " << vlaid_trans_s_by_m[s][1] value %b", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.vlaid_trans_s_by_m[1][0]);
  //$display($time, " << SLAVE_BASE[0] value            %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.SLAVE_BASE[0][31:16]);
  //$display($time, " << SLAVE_BASE[1] value            %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.SLAVE_BASE[1][31:16]);
  //$display($time, " << haddr_m[0]  value              %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_ahb_ic_inst.haddr_m[0][31:16]);
  //$display($time, " << memory dump              %h", ccs0001_tb.u_dut_inst.u_chip_core_inst.u_sram_wrap_inst.u_sram_inst.mem[0]);
end

endmodule
