/* Toggle a GPIO pin at 1Hz
requires https://github.com/VegetableAvenger/BBBIOlib
 gcc -Wall led.c libBBBio.a -o led
*/
#include <stdio.h>
#include <stdlib.h>
#include "BBBiolib.h"

int main() {
	int i=0;
	iolib_init();
	iolib_setdir(9,12,1);
	while(i < 100) {
		pin_high(9,12);
		sleep(1);
		pin_low(9,12);
		sleep(1);
		i++;
	}
	iolib_free();
	return 0;

}
