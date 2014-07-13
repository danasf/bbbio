/* 
Toggle GPIO pins / make a LED blink via manipulating BBB registers. Why? Because you need really fast I/O toggling and don't want to use the PRU.

Step 1: Make sure selected pin is set to output. If not create a device tree overlay, include pins you need.

What's the device tree? http://xillybus.com/tutorials/device-tree-zynq-1

And a device tree overlay .... 

http://derekmolloy.ie/gpios-on-the-beaglebone-black-using-device-tree-overlays/
https://learn.adafruit.com/introduction-to-the-beaglebone-black-device-tree/

Step 2: Find the GPIO controller your pin is attached to, memory locations. 

Charts here are super helpful
http://derekmolloy.ie/beaglebone/beaglebone-gpio-programming-on-arm-embedded-linux/

I'm using GPIO1: 0x4804C000-0x4804DFFF
And offsets that set and clear data  0x194, 0x190

Other helpful resources relating to this:
https://github.com/MarkAYoder/BeagleBoard-exercises
http://chiragnagpal.com/examples.html

*/

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdbool.h>

#define GPIO1_START	0x4804C000
#define GPIO1_END	0x4804E000
#define GPIO1_SIZE (GPIO1_END-GPIO1_START)

#define GPIO_SET_OUT 0x194
#define GPIO_SET_CLEAR 0x190

#define USR3 (1<<24)
#define P9_12 (1<<28)

volatile void *gpio_addr;
volatile unsigned int *gpio_out_addr;
volatile unsigned int *gpio_clear_addr;

int main(int argc, char** argv)
{

	int fd = open ("/dev/mem",O_RDWR);
	gpio_addr = mmap(0,GPIO1_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO1_START);
	gpio_out_addr = gpio_addr + GPIO_SET_OUT;
	gpio_clear_addr = gpio_addr + GPIO_SET_CLEAR;

	while(1) {
		*gpio_out_addr = USR3;
		sleep(1);
		*gpio_clear_addr = USR3;
		sleep(1);
	}

	return 0;
}