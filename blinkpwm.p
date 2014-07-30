// Beaglebone PRU fun

// program entry point
.origin 0
.entrypoint START

#define GPIO0 				0x44e07000 // GPIO1 Controller
#define GPIO1 				0x4804c000 // GPIO1 Controller
#define PIN_OFFSET 			0x00000004 // Offset to start reading PIN data at, 4 bytes in
// this is different from GPIO SET
#define GPIO_SET_OUT		0x194	   // Set 1s to OUT
#define GPIO_SET_CLEAR		0x190	   // Set 1s to CLEAR
#define GPIO_DATAOUT		0x13c	   // SET ALL bits to state specified
#define GPIO_DATAIN			0x138	   // Read state of Pins?


// Registers we can define
#define LOOP_COUNTER r1 				   // Loop counter
#define SET_OFF 0x00000000			   // Set everything to off

// offsets for shared memory
#define SHARED_ESCAPE_OFFSET 0x00000000 // Offset for Escape Value
#define SHARED_IO0_OFFSET	 0x00000004	// Offset for IO0 Pins
#define	SHARED_IO1_OFFSET	 0x00000008 // Offset for IO1 Pins
#define	SHARED_COUNT_OFFSET  0x00000016 // Offset for Counter
#define	SHARED_DUTY_OFFSET   0x00000020 // Offset for Duty Cycle
#define	SHARED_PER_OFFSET    0x00000024 // Offset for PWM Period

#define SH_ESCAPE_OFFSET 0 // Offset for Escape Value
#define SH_IO0_OFFSET	 4	// Offset for IO0 Pins
#define	SH_IO1_OFFSET	 8 // Offset for IO1 Pins
#define	SH_COUNT_OFFSET  12 // Offset for Counter
#define	SH_DUTY_OFFSET   16 // Offset for Duty Cycle
#define	SH_PER_OFFSET    20 // Offset for PWM Period


#define 


START:
	// initialization, this is necessary to allow the PRU to access memory locations incl. GPIO
	LBCO r0, C4, 4, 4 // Load Byte Burst, mem -> register
	CLR r0, r0, 4	  // Clear r0
	SBCO r0, C4, 4, 4 // set b

	// setup some initial registers, we want the shutdown register, data for gpio1 and counter

	MOV r0, 0   									// move at address 0 into r0
	LBBO LOOP_COUNTER, r0, SH_COUNT_OFFSET, 4 		// load 4 bytes of memory at address speced in r0 into r1, offset 12
	LBBO r6, r0, SH_ESCAPE_OFFSET, 4				// move data at emergency shutdown address into r6
	LBBO r4, r0, SH_IO1_OFFSET, 4					// move IO data into r4
	LBBO r7, r0, SH_DUTY_OFFSET, 4					// ok, next up is the delay, move that from address speced in r4 to r0


NEXT_CYCLE:
	QBNE, FINISH, r6, 0 		// if emergency shutdown is set halt
	QBNE SET_OFF, r4,0 			// if r4 is not 0 set the pin off

SET_ON:
	LBBO r2, r4, 0, 4 		// put state data for IO1 into r2
	MOV  r3, GPIO1 | GPIO_DATAOUT // put GPIO into r3
	SBBO r2,r3, 0, 4 		// store byte burst, register -> mem, in this case we're writing GPIO
	JMP DELAY

SET_OFF:
	MOV r2, 0 		// put state data for IO1 into r2
	MOV  r3, GPIO1 | GPIO_DATAOUT // put GPIO into r3
	SBBO r2,r3, 0, 4 		// store byte burst, register -> mem, in this case we're writing GPIO
	LBBO r7, r0, SH_DUTY_OFFSET, 4	// ok, next up is the delay, move that from address speced in r4 to r0
	JMP DELAY

DELAY:
	SUB r7, r7, 1				  // subtract 1 from delay
	SBNE DELAY, r7, 0 			  // if R0 != 0 go to DELAY
	SUB LOOP_COUNTER, LOOP_COUNTER, 1 // subtract 1 from loop count
	QBNE NEXT_CYCLE, LOOP_COUNTER,0   // if LOOP_COUNT != 0 go back to SET_PINS

FINISH:
	MOV R31.b0, PRU0_ARM_INTERRUPT+16 // its done so send an interrupt 
HALT

	
//
//