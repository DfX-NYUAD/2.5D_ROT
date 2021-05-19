  create_clock $clkname  -name CLK  -period 2

  set input_ports  [remove_from_collection [all_inputs] $clkname]
  set output_ports [all_outputs]

  set_input_delay  -max 2   [get_ports $input_ports ]  -clock CLK
  set_input_delay  -min 0   [get_ports $input_ports ]  -clock CLK

  set_output_delay -max 2   [get_ports $output_ports ] -clock CLK
  set_output_delay -min 0.5 [get_ports $output_ports ] -clock CLK

##  set_input_transition -max 0.5 [get_ports $input_ports]
##  set_input_transition -min 0   [get_ports $input_ports]


##  set_load -max .001   [get_ports $output_ports]
##  set_load -min .0005  [get_ports $output_ports]


  group_path -name output_group -to   [all_outputs]
  group_path -name input_group  -from [all_inputs]

  set_max_delay 5.0 -from [all_inputs] -to [all_outputs] -group_path "io_group"

infer_switching_activity -apply
set_switching_activity [get_ports $input_ports]  -static_probability 0.5 -toggle_rate .1 -base_clock CLK
