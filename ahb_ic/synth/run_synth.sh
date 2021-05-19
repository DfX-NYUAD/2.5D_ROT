#!/bin/sh

###function usage()
###{
###    echo "Script to run synthesis for design in ../src/"
###    echo "./run_synth.sh --design <design name in ../src/> --clk <clock port name of the design> --tech <for which technology synthesis need to be run>"
###    echo "-h       : Print this message"
###    echo "-design  : Design name in ../src/"
###    echo "-clkname : Clock port name of the design"
###    echo "-tech    : For which technology synthesis need to be run. Available options are 65 nm or 55nm"
###    echo ""
###}
###
###    #GUI=  `echo $3 | awk -F= '{print $1}'`
###while [ "$1" != "" ]; do
###    PARAM1=`echo $1 | awk -F= '{print $1}'`
###    VALUE1=`echo $2 | awk -F= '{print $1}'`
###
###    case $PARAM1 in
###        -h | --help)
###            usage
###            exit
###            ;;
###        -design | --design | -des | --design)
###            export DESIGN=$VALUE1
###            ;;
###        -clk | --clk | -clkname | --clkname | -clock | --clock)
###            export CLKNAME=$VALUE1
###            ;;
###        -tech | --tech | -technology | --technology | -techno | --techno)
###            export TECH=$VALUE1
###            ;;
###        *)
###            echo "ERROR: unknown parameter1 \"$PARAM1\""
###            usage
###            exit 1
###            ;;
###    esac
###
###    shift
###    shift
###done
###
###if [ "${TECH}" == "65nm" ]
###then
###  export SYNTH_LIBRARY=/home/mtn2/synth_lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db
###else
###  export SYNTH_LIBRARY=/home/mtn2/synth_lib/sc9_55lpe_base_hvt_ss_nominal_max_1p08v_125c.db
###fi
echo "Running synthesis for design : $DESIGN with clock port : $CLKNAME and technology $TECH"

dc_shell-t -no_gui -64bit -output_log_file ./synth_${DESIGN}_${TECH}.log -x "source -echo -verbose ./run_synth.tcl"
