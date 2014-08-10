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
                #print bin(self.data)
                return self.data

# first 4 bytes = control code
# next 4 bytes GPIO0

# escape code
escape = 0x000000 # quit if FFFFFFFF
cycle_count = 0x000014 # 20 cycles
pwm_ratio = 0x0000000E # 16 cycles on
# new io object
io = IOCtrl()

io.setPin(21,1)
io.setPin(22,1)
io.setPin(23,1)
io.setPin(24,1)
gpio=io.getData()

cycles = 1000;
to_mem = [cycles,gpio]

# write gpio data to memory
# mem type, offset, data, len*4
# pru memory, offset bytes, data
pypruss.modprobe()
pypruss.init()
pypruss.open(0)
pypruss.pruintc_init()
pypruss.pru_write_memory(0,0,to_mem)
pypruss.exec_program(0,"./memtest.bin")

for x in xrange(1,10):
        if x % 2:
                io.setPin(23,0)
                io.setPin(24,0)
        else:
                io.setPin(23,1)
                io.setPin(24,1)
        gpio = io.getData()
        print bin(gpio)
        to_mem = [cycles,gpio]
        time.sleep(2)
        pypruss.pru_write_memory(0,0,to_mem)
        pypruss.exec_program(0,"./memtest.bin")
pypruss.wait_for_event(0)                                                       # Wait for event 0 which is connected to PRU0_ARM_INTERRUPT
pypruss.clear_event(0)                                                          # Clear the event
pypruss.pru_disable(0)                                                          # Disable PRU 0, this is already done by the firmware
pypruss.exit()