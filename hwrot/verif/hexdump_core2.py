#!/usr/bin/python
import sys

print "--------------Starting Running hexdump.py Script-------------------\n"
inFile  = sys.argv[1]
outFile = sys.argv[2]

outFile_hw = sys.argv[2] + "uart_load"
print "hexdump.py:Starting Converting Memory Map file " + inFile + " to Uart load format\n"
print "hexdump.py:Ourput file will be saved @ " + outFile + " \n"

raw_armcode      = open(inFile,     'r', 0)
uartm_armcode    = open(outFile,    'w', 0)
uartm_armcode_hw = open(outFile_hw, 'w', 0)

for line in raw_armcode:
    addr_data = line.split()
    addr      = addr_data[0]
    data      = addr_data[1]
    if addr == "00000000" :
        addr = "4002C014"
    elif addr == "00000004" :
        addr = "4002C018"
    elif addr == "00000008" :
        addr = "4002C01C"
    elif addr == "0000000c" :
        addr = "4002C020"
    elif addr == "00000040" :
        addr = "4002C024"
    elif addr == "00000044" :
        addr = "4002C024"
    elif addr == "00000048" :
        addr = "4002C024"
    elif addr == "0000004c" :
        addr = "4002C024"
    elif addr == "00000050" :
        addr = "4002C024"
    elif addr == "00000054" :
        addr = "4002C024"
    elif addr == "00000058" :
        addr = "4002C024"
    elif addr == "0000005c" :
        addr = "4002C024"
    elif addr == "00000060" :
        addr = "4002C024"
    elif addr == "00000064" :
        addr = "4002C024"
    elif addr == "00000068" :
        addr = "4002C024"
    elif addr == "0000006c" :
        addr = "4002C024"
    elif addr == "00000070" :
        addr = "4002C024"
    elif addr == "00000074" :
        addr = "4002C024"
    elif addr == "00000078" :
        addr = "4002C024"
    elif addr == "0000007c" :
        addr = "4002C024"
    elif addr[0] == "0" :
        addr = "21000000"
    else :
        addr = addr



    uartm_armcode.write( "uartm_write " + "(.addr(32\'h" + addr + "), " +  ".data(32\'h" + data + "));" + "\n")
    uartm_armcode_hw.write( "write_serial " + "(\"\\x" + addr[6] + addr[7] + "\\x" + addr[4] + addr[5] + "\\x" + addr[2] + addr[3] + "\\x" + addr[0] + addr[1] + "\"," + "\"\\x" + data[6] + data[7] + "\\x" + data[4] + data[5] + "\\x" + data[2] + data[3] + "\\x" + data[0] + data[1] + "\")"   + "\n")
    uartm_armcode_hw.write( "read_serial "  + "(\"\\x" + addr[6] + addr[7] + "\\x" + addr[4] + addr[5] + "\\x" + addr[2] + addr[3] + "\\x" + addr[0] + addr[1] + "\")" + "\n")




raw_armcode.close
uartm_armcode.close

print "--------------hexdump.py done--------------------------------------\n"

