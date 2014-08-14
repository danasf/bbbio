BeagleBone Black Experiments
========

Assorted Experiments with low level GPIO access on BBB

Writing to GPIOs via /dev/mem

* memory.c
* mem.py
* bbiolib_led.c (uses BBBIO lib)

Write to GPIOs via PRU

Use [pypruss](https://bitbucket.org/intelligentagent/pypruss/) to load firmware on PRU

Useful BBB Memory Locations

* GPIO0 0x44e07000 // GPIO0 Controller
* GPIO1 0x4804c000 // GPIO1 Controller
* GPIO2 0x481ac000 // GPIO2 Controller
* GPIO3 0x481ae000 // GPIO3 Controller
* GPIO_SET_OUT 0x194 // Set 1s to OUT
* GPIO_SET_CLEAR 0x190 // Set 1s to CLEAR
* GPIO_DATAOUT 0x13c // SET ALL bits to state specified
* GPIO_DATAIN 0x138 // Read state of all pins?
