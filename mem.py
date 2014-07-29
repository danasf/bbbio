from mmap import mmap
import time, struct

GPIO1_base = 0x4804c000
GPIO1_size = 0x4804cfff-GPIO1_base
GPIO_OE = 0x134
GPIO_SETDATAOUT = 0x194
GPIO_CLEARDATAOUT = 0x190
USR = 7<<22 # turn on 3 USR Pins

with open("/dev/mem","r+b") as f:
	mem = mmap(f.fileno(), GPIO_size,offset=GPIO1_start)

# load register at output enable
packed_reg = mem[GPIO_OE:GPIO_OE+4]
reg_stat = struct.unpack("<L",packed_reg)[0]
# set USRs to output
reg_stat &= ~(USR) 

#while 0 to 10
for i in range(10):
	#set out
	mem[GPIO_SETDATAOUT:GPIO_SETDATAOUT+4] = struct.pack("<L",USR)
	time.sleep(1)
	#set clear
	mem[GPIO_CLEARDATAOUT:GPIO_CLEARDATAOUT+4] = struct.pack("<L",USR)
	time.sleep(1)
mem.close() 