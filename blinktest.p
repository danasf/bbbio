// Beaglebone PRU fun

.origin 0
.entrypoint START
#define GPIO0 				0x44e07000 // GPIO1 Controller
#define GPIO1 				0x4804c000 // GPIO1 Controller
#define EMERGENCY_SHUTDOWN	0x00000000 // Address of stop everything command
#define PIN_OFFSET 			0x00000004 // Offset to start reading PIN data at, 4 bytes in
// this is different from GPIO SET
#define GPIO_SET_OUT		0x194	   // Set 1s to OUT
#define GPIO_SET_CLEAR		0x190	   // Set 1s to CLEAR
#define GPIO_DATAOUT		0x13c	   // SET ALL bits to state specified
#define GPIO_DATAIN			0x138	   // Read state of Pins?
#define LOOP_COUNT r1 				   // Loop counter

START:
	// initialization
	LBCO r0, C4, 4, 4 // Load Byte Burst, mem -> register
	CLR r0, r0, 4	  // Clear r0
	SBCO r0, C4, 4, 4 // set b

	MOV r0, 0 		  					// put shared ram address into r0
	LBBO LOOP_COUNT, r0, 0, 4 			// load 4 bytes of memory at address speced in r0 into r1, no offset
	MOV r4, PIN_OFFSET 					// move starting address of pin data into r4
	MOV r6, EMERGENCY_SHUTDOWN
	LBBO r5, r6, 0, 4	// move data at emergency shutdown address into r5

SET_PINS:
	LBBO r2, r4, 0, 4 		// put data at address speced in r4 into r2
	MOV  r3, GPIO1 | GPIO_DATAOUT
	SBBO r2,r3, 0, 4 		// store byte burst, register -> mem, in this case we're writing GPIO
	ADD r4,r4,4				// advance 4 bytes
	LBBO r0, r4, 0, 4		// ok, next up is the delay, move that from address speced in r4 to r0
	QBEQ FINISH, r5, 0 		// if emergency shutdown is set halt

DELAY:
	SUB r0, r0, 1				  // subtract 1 from r0
	SBNE DELAY, r0, 0 			  // if R0 != 0 go to DELAY
	ADD r4,r4, 4				  // otherwise advance 4 bytes
	SUB LOOP_COUNT, LOOP_COUNT, 1 // subtract 1 from loop count
	QBNE SET_PINS, LOOP_COUNT,0   // if LOOP_COUNT != 0 go back to SET_PINS

FINISH:
	MOV R31.b0, PRU0_ARM_INTERRUPT+16 // its done so send an interrupt 
HALT

	
//
//