// Beaglebone PRU fun

.origin 0
.entrypoint START

#define GPIO0 				0x44e07000 // GPIO0 Controller
#define GPIO1 				0x4804c000 // GPIO1 Controller
#define EMERGENCY_SHUTDOWN	0x00000000 // Address of stop everything command
#define PIN_OFFSET 			0x00000004 // Offset to start reading PIN data at, 4 bytes in
// this is different from GPIO SET
#define GPIO_SET_OUT		0x194	   // Set 1s to OUT
#define GPIO_SET_CLEAR		0x190	   // Set 1s to CLEAR
#define GPIO_DATAOUT		0x13c	   // SET ALL bits to state specified
#define GPIO_DATAIN			0x138	   // Read state of Pins?
#define LOOP_COUNT r1 				   // Loop counter

#define SH_ESCAPE_OFFSET 0 // Offset for Escape Value
#define	SH_IO1_OFFSET	 12 // Offset for IO1 Pins
#define	SH_COUNT_OFFSET  4 // Offset for Counter
#define	SH_DUTY_OFFSET   8 // Offset for Duty Cycle


.macro SET_PINS
.mparam pins 
	MOV r3, GPIO1 | GPIO_DATAOUT
	LBBO r7, r0, SH_DUTY_OFFSET, 4	
.endm

START:
	// initialization
	LBCO r0, C4, 4, 4 // Load Byte Burst, mem -> register
	CLR r0, r0, 4	  // Clear r0
	SBCO r0, C4, 4, 4 // set b
	MOV r4, 

LOOP:
	MOV r0, 0 		  					// put shared ram address into r0
	MOV  r3, GPIO1 | GPIO_DATAOUT
	LBBO r2, r0, 0, 4 		// put data at address speced in r0 with offset into r2
	SBBO r2,r3, 0, 4 		// store byte burst, register -> mem, in this case we're writing GPIO

DELAY:
	SUB r4, r4, 1				  // subtract 1 from r0
	SBNE LOOP, r4, 0 			  // if R0 != 0 go to DELAY


FINISH:
//	MOV R31.b0, PRU0_ARM_INTERRUPT+16 // its done so send an interrupt 
HALT
