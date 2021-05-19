#!/bin/sh

function usage()
{
    echo "Script to run testcases for $PROJECT_NAME"
    echo "./run_test.sh --test <IAR workspace dir name presetnt @  $PROJECT_MODULES/ccs0001/sw/>"
    echo "\t-h --help"
    echo "\t--test=Enter the IAR workspace dir name presetnt @  $PROJECT_MODULES/ccs0001/sw/"
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
 mkdir  $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE
fi

if [ -L $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin ]
then
 rm $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin
fi



echo "---------------------Running hexdump-----------------"
#hexdump  -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin   | grep -v "*" | awk  '{print "uartm_write","\(" ".addr\(32'\h" $1 "\)\,", ".data\(32\'h" $2 "\)\);"}' > $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.hex
unzip -o $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.zip -d  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/
hexdump -n 200                 -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin >  $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt
hexdump -n 32768 -s 536870912  -v -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin >> $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt
$PROJECT_MODULES/ccs0001/verif/hexdump.py  $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.txt $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.hex

