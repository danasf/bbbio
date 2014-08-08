import pypruss
import time

"""Packet Description

	4 bytes - version / escape
	4 bytes - cycle count
	4 bytes - on/off ratio
	4 bytes - gpio1

"""

class IOCtrl(object):
	"""docstring for gpio0"""
	def __init__(self):
		self.data = 0x000000

	def setPin(self,pin,state):
		if state is 1:
			self.data = self.data | (1 << pin)
		else:
			self.data = self.data & ~(1 << pin)

	def getData(self):
		print bin(self.data)
		return self.data



# first 4 bytes = control code
# next 4 bytes GPIO0

# escape code
escape = 0x000000 # quit if FFFFFFFF
cycle_count = 0x000014 # 20 cycles
pwm_ratio = 0x0000000E # 16 cycles on
# new io object
io = IOCtrl()

io.setPin(22,1)
io.setPin(23,1)
io.setPin(24,1)
gpio=io.getData()


#

# write gpio data to memory

# mem type, offset, data, len*4
# pru memory, offset bytes, data
pypruss.modprobe()
pypruss.init()
pypruss.open(0)
pypruss.pruintc_init()

pypruss.pru_write_memory(0,0,escape)
pypruss.pru_write_memory(0,4,cycle_count)
pypruss.pru_write_memory(0,8,pwm_ratio)
pypruss.pru_write_memory(0,12,gpio)

print "running program!"

pypruss.exec_program(0,"./memtest.bin")
for x in xrange(1,10):
	if x % 2:
		
	time.sleep(2)
pypruss.clear_event(0)
pypruss.exit()

#pru_write_memory(0,4,gpio0)