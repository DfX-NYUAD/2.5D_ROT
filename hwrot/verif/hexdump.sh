#!/bin/sh

/usr/bin/hexdump  -e  '/4 "%08_ax "' -e '/4 "%08X" "\n"'  $PROJECT_MODULES/ccs0001/sw/$TEST_CASE/Debug/Exe/project.bin   | grep -v "*" | awk  '{print "uartm_write","(" ".addr(32\'h" $1 "),", ".data(32\'h" $2 "));"}' > $PROJECT_MODULES/ccs0001/verif/test_$TEST_CASE/test.hex
