date
set_host_options -max_cores 16
set compile_seqmap_propagate_constants     false
set compile_seqmap_propagate_high_effort   false
set compile_enable_register_merging        false
set write_sdc_output_net_resistance        false
set timing_separate_clock_gating_group     true
set verilogout_no_tri tru
set html_log_enable true
set hdlin_while_loop_iterations 8192

set no_cores      [getenv "NUM_CORES"]
set no_srams      [getenv "NUM_SRAMS"]
set no_64k_mem    [getenv "NUM_64K_MEM"]
set no_apu_policy [getenv "NUM_APU_POLICY"]
set no_dpu_policy [getenv "NUM_DPU_POLICY"]

set design        [getenv "DESIGN"]
set prj_name      [getenv "PROJECT_NAME"]
set prj_path      [getenv "PROJECT_MODULES"]
set target_lib    [getenv "SYNTH_LIBRARY"]
#set clkname  [getenv "CLKNAME"]

set run_date [date]
set abc      [regexp -inline -all -- {\S+} $run_date]
set date     [lindex $abc 2]  
set month    [lindex $abc 1]  
set time     [lindex $abc 3]  
set year     [lindex $abc 4]  
#set run_dir ${date}_${month}_${year}_${time}_${no_cores}X${no_srams}_${no_apu_policy}p
set run_dir ${date}_${month}_${year}_pipelined_${no_cores}X${no_srams}_${no_apu_policy}p

if {[file exist $run_dir]} {
sh rm -rf $run_dir
}

sh mkdir -p $run_dir/reports
sh mkdir -p $run_dir/netlist

set search_path [concat * $search_path]

sh rm -rf ./work
define_design_lib WORK -path ./run_dir/work

  set_svf hwrot.svf

  set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}

  set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db\
                     /home/projects/vlsi/libraries/65lpe/ref_lib/arm/memories/sram_sp_hde/timing_lib/USERLIB_ccs_ss_1p08v_1p08v_125c.db \
                   }

  analyze -library WORK -format sverilog { \
                            /home/projects/vlsi/hwrot/design/modules/hwrot/rtl/hwrot_define.v \
                            /home/projects/vlsi/hwrot/design/modules/chiplib/rtl/chiplib.v \
                            /home/projects/vlsi/hwrot/design/modules/cortexm0/rtl/CORTEXM0DS.v \
                            /home/projects/vlsi/hwrot/design/modules/cortexm0/rtl/cortexm0ds_logic.v \
                            /home/projects/vlsi/hwrot/design/modules/memss/rtl/pram.v \
                            /home/projects/vlsi/hwrot/design/modules/memss/rtl/sram_wrap.v \
                            /home/projects/vlsi/hwrot/design/modules/ahb_ic/rtl/ahb_ic_wrap.v \
                            /home/projects/vlsi/hwrot/design/modules/ahb_ic/rtl/transmonitor.v \
                            /home/projects/vlsi/hwrot/design/modules/ahb_ic/rtl/transmonitor_dummy.v \
                            /home/projects/vlsi/hwrot/design/modules/ahb_ic/rtl/ahb_ic.v \
                            /home/projects/vlsi/hwrot/design/modules/timer/rtl/timer.v \
                            /home/projects/vlsi/hwrot/design/modules/uartm/rtl/uartm.v \
                            /home/projects/vlsi/hwrot/design/modules/uartm/rtl/uartm_ahb.v \
                            /home/projects/vlsi/hwrot/design/modules/uartm/rtl/uartm_rx.v \
                            /home/projects/vlsi/hwrot/design/modules/uartm/rtl/uartm_tx.v \
                            /home/projects/vlsi/hwrot/design/modules/hwrot/rtl/CORTEXM0DS_wrap.v \
                            /home/projects/vlsi/hwrot/design/modules/hwrot/rtl/gpcfg.v \
                            /home/projects/vlsi/hwrot/design/modules/hwrot/rtl/gpcfg_rdata_mux.v \
                            /home/projects/vlsi/hwrot/design/modules/hwrot/rtl/gpcfg_rd_wr.v \
                            /home/projects/vlsi/hwrot/design/modules/hwrot/rtl/hwrot.v}


elaborate -param NUM_CORES=>$no_cores,NUM_SRAMS=>$no_srams,NUM_64K_MEM=>$no_64k_mem,NUM_APU_POLICY=>$no_apu_policy,NUM_DPU_POLICY=>$no_dpu_policy hwrot
date
 
set_dont_use [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*X0P*]


link
  #uniquify
  set_wire_load_model -name Medium
  set_max_area 0
  set_clock_gating_style -sequential_cell latch -positive_edge_logic {nand} -negative_edge_logic {nor} -minimum_bitwidth 5 -max_fanout 64

  create_clock [get_ports core_in[2]]  -name HCLK  -period 10  -waveform {0 5}

  set_input_transition -max 2 [get_ports core_in*]
  set_input_transition -min 0 [get_ports core_in*]

define_name_rules verilog -case_insensitive

  #compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
  compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -gate_clock
  write_file -hierarchy -format verilog -output "$run_dir/netlist/hwrot_hier.v"
  report_qor > $run_dir/reports/report_qor_hier.rpt
  compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -incremental

  change_names -hier -rule verilog

   write_file -hierarchy -format verilog -output "$run_dir/netlist/hwrot.v"
   write_sdc "$run_dir/netlist/hwrot.sdc"

   set_switching_activity -toggle_rate 5 -period 100  -static_probability 0.50 -type inputs
   propagate_switching_activity

   report_timing -delay max  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_max.rpt
   report_timing -delay min  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_min.rpt
   report_constraint -all_violators -verbose  -nosplit                             > $run_dir/reports/report_constraint.rpt
   check_design -nosplit                                                           > $run_dir/reports/check_design.rpt
   report_design                                                                   > $run_dir/reports/report_design.rpt
   report_area                                                                     > $run_dir/reports/report_area.rpt
   report_timing -loop                                                             > $run_dir/reports/timing_loop.rpt
   report_power -analysis_effort high                                              > $run_dir/reports/report_power.rpt
   report_qor                                                                      > $run_dir/reports/report_qor.rpt

exit
