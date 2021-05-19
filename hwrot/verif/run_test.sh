#!/bin/sh

function usage()
{
    echo "Script to run testcases for $PROJECT_NAME"
    echo "./run_test.sh --test <IAR workspace dir name presetnt @  $PROJECT_MODULES/hwrot/sw/>"
    echo "\t-h --help"
    echo "\t--test=Enter the IAR workspace dir name presetnt @  $PROJECT_MODULES/hwrot/sw/"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $2 | awk -F= '{print $1}'`

    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -test | --test)
            TEST_CASE=$VALUE
            ;;
        -core | --core)
            CORE=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
    shift
done

#DIRNAME=`echo $HEX_FILE | sed 's/\.hex//'`


if [ ! -d test_$TEST_CASE ]
then
 mkdir  $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE
fi

if [ -L $PROJECT_MODULES/hwrot/verif/hex/test.hex ]
then
 rm $PROJECT_MODULES/hwrot/verif/hex/test.hex
fi

if [ -L $PROJECT_MODULES/hwrot/sw/$TEST_CASE/Debug/Exe/project.bin ]
then
 rm $PROJECT_MODULES/hwrot/sw/$TEST_CASE/Debug/Exe/project.bin
fi


if [ -L $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.txt ]
then
 rm $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.txt
fi

echo "---------------------Running hexdump for $CORE number of cores-----------------"
#hexdump  -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/hwrot/sw/$TEST_CASE/Debug/Exe/project.bin   | grep -v "*" | awk  '{print "uartm_write","\(" ".addr\(32'\h" $1 "\)\,", ".data\(32\'h" $2 "\)\);"}' > $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.hex
unzip -o $PROJECT_MODULES/hwrot/sw/$TEST_CASE/Debug/Exe/project.zip -d        $PROJECT_MODULES/hwrot/sw/$TEST_CASE/Debug/Exe/
hexdump -n 200                 -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'      $PROJECT_MODULES/hwrot/sw/$TEST_CASE/Debug/Exe/project.bin >  $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.txt
hexdump -n 32768 -s 536870912  -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'      $PROJECT_MODULES/hwrot/sw/$TEST_CASE/Debug/Exe/project.bin >> $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.txt
$PROJECT_MODULES/hwrot/verif/hexdump.py                                       $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.txt         $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.hex

if [ $CORE == 2 ]
then
echo "---------------------Running hexdump for core2-----------------"
  unzip -o $PROJECT_MODULES/hwrot/sw/core2_$TEST_CASE/Debug/Exe/project.zip -d  $PROJECT_MODULES/hwrot/sw/core2_$TEST_CASE/Debug/Exe/
  hexdump -n 200                 -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'      $PROJECT_MODULES/hwrot/sw/core2_$TEST_CASE/Debug/Exe/project.bin >  $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test_core2.txt
  hexdump -n 32768 -s 553648128  -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'      $PROJECT_MODULES/hwrot/sw/core2_$TEST_CASE/Debug/Exe/project.bin >> $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test_core2.txt
  $PROJECT_MODULES/hwrot/verif/hexdump_core2.py                                 $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test_core2.txt         $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test_core2.hex
fi




#cp     $PROJECT_MODULES/hwrot/verif/hex/$HEX_FILE           $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/test.hex
cat  $PROJECT_MODULES/hwrot/verif/test_$TEST_CASE/*.hex >  $PROJECT_MODULES/hwrot/verif/hex/test.hex

if [ -f inter.vpd ]
then
 rm -rf inter.vpd simv session.inter.vpd.tcl simv.log  vlogan.log vcs.log csrc ucli.key DVEfiles simv.daidir
fi

echo "---------------------Running vlogan-----------------"

vlogan -sverilog hwrot_tb.v  /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/verilog/sc9_cmos10lpe_base_hvt.v $PROJECT_MODULES/chiplib/rtl/chiplib.v  $PROJECT_MODULES/hwrot/rtl/hwrot.v  $PROJECT_MODULES/cortexm0/rtl/CORTEXM0DS.v $PROJECT_MODULES/cortexm0/rtl/cortexm0ds_logic.v $PROJECT_MODULES/uartm/rtl/uartm.v $PROJECT_MODULES/uartm/rtl/uartm_ahb.v  $PROJECT_MODULES/uartm/rtl/uartm_rx.v $PROJECT_MODULES/uartm/rtl/uartm_tx.v $PROJECT_MODULES/hwrot/rtl/gpcfg.v $PROJECT_MODULES/hwrot/rtl/gpcfg_rd_wr.v  $PROJECT_MODULES/hwrot/rtl/gpcfg_rdata_mux.v $PROJECT_MODULES/memss/rtl/sram_wrap.v $PROJECT_MODULES/memss/rtl/sram_sp_hde_64k.v $PROJECT_MODULES/ahb_ic/rtl/transmonitor.v $PROJECT_MODULES/ahb_ic/rtl/transmonitor_dummy.v  $PROJECT_MODULES/ahb_ic/rtl/ahb_ic_wrap.v  $PROJECT_MODULES/ahb_ic/rtl/ahb_ic.v $PROJECT_MODULES/memss/rtl/pram.v $PROJECT_MODULES/timer/rtl/timer.v $PROJECT_MODULES/hwrot/rtl/CORTEXM0DS_wrap.v  +incdir+/home/projects/vlsi/hwrot/design/modules/uartm/rtl   +incdir+/home/projects/vlsi/hwrot/design/modules/hwrot/rtl  | tee vlogan.log

echo "---------------------vlogan Done--------------------"
echo "---------------------Running VCS--------------------"
vcs -sverilog -debug hwrot_tb -o hwrot_simv | tee vcs.log

echo "---------------------VCS    Done--------------------"
./hwrot_simv -gui -i ./runtime.tcl | tee simv.log &
