/* asm_gpio.S
 * 
 * Directly writes to GPIO registers to configure and control output
 * 
 * configure_gpio_out(int gpio) 
 *  configures gpio as output
 *
 * write_gpio_lo(int gpio)
 *  set gpio level to low
 *
 * write_gpio_hi(int gpio)
 *  set gpio level to high
 */

.section .text
.global configure_gpio_out,configure_gpio_in,write_gpio_lo,write_gpio_hi,read_gpio,_start

.type   configure_gpio_out,%function
.type   write_gpio_lo,%function
.type   write_gpio_hi,%function
.type   configure_gpio_in,%function
.type   read_gpio,%function
.type   _start,%function

.syntax unified

/* GPIO register base address for S  =   0x50842500
 * GPIO register base address for NS =   0x40842500 */
.equ GPIO_BASE, 0x50842500


/* GPIO 0.28-0.31 LED1-LED4 */
/* GPIO 0.23      BUTT 1
 * GPIO 0.24      BUTT 2
 * GPIO 0.08      BUTT 3
 * GPIO 0.09      BUTT 4 */


_start:
    push {r0-r5,lr}

    /* configure LEDs */
    mov     r0, 28
    bl      configure_gpio_out
    bl      write_gpio_hi

    mov     r0, 29
    bl      configure_gpio_out
    bl      write_gpio_hi

    mov     r0, 30
    bl      configure_gpio_out
    bl      write_gpio_hi

    mov     r0, 31
    bl      configure_gpio_out
    bl      write_gpio_hi


    /* configure buttons */
    mov     r0, 23
    bl      configure_gpio_in

    mov     r0, 24
    bl      configure_gpio_in

    mov     r0, 8
    bl      configure_gpio_in

    mov     r0, 9
    bl      configure_gpio_in


    readloop:
    mov     r0, #23
    bl      read_gpio
    cmp     r0, #0              // button pressed?
    mov     r0, #28             // load led1
    beq     write_gpio_lo       // yes, light led
    bl      write_gpio_hi       // no, turn led off
    bl      readloop            


    pop {r0-r5,pc}


/* r0 set to gpio # */
configure_gpio_out: 
    push    {r0-r2}
    mov     r1, #1              // set bit in r1
    lsl     r1, r0              // shift to pin we want

    /* r0 now contains # of pin and r1 the bit # of pin */

    mov     r2, #0x004          // 0x04*n Offset for n in PIN_CNF[n] reg
    mul     r2, r0              // get our offset
    add     r2, #0x200          // add PIN_CNF base offset 0x200
    
    /* r2 now contains PIN_CNF[n] offset */

    mov     r1, #1              // set as output bit
    orr     r1, r1, #3          // disconnect input buffer bit
    orr     r1, r1, #12         // enable pullup bit

    ldr     r0, =GPIO_BASE      
    str     r1, [r0, r2]        // write to PIN_CNF[n]

    pop     {r0-r2}
    mov     pc, lr


/* r0 set to gpio */
configure_gpio_in:
    push    {r0-r2}
    mov     r1, #1              // set bit in r1
    lsl     r1, r0              // shift to pin we want

    /*  r0 now contains # of pin and r1 the bit # of pin */

    mov     r2, #0x004          // 0x04*n offset for n in PIN_CNF[n] reg
    mul     r2, r0              // get our offset
    add     r2, #0x200          // add PIN_CNF base offset 0x200

    /* r2 now contains PIN_CNF[n] offset */

    mov     r1, #0              // set to 0 for IN dir and input buffer connect
    orr     r1, r1, #12         // enable pullup bits

    ldr     r0, =GPIO_BASE
    str     r1, [r0, r2]        // write to PIN_CNF[n]

    pop     {r0-r2}
    mov     pc, lr


/* r0 set to gpio */
read_gpio:
    push    {r1-r3}

    ldr     r3, =GPIO_BASE
    ldr     r2, [r3, #0x010]    // read GPIO in reg
    mov     r1, #1              // set bit in r1
    lsl     r1, r0              // shift to pin we want
    and     r2, r2, r1          // see if our pin is high

    lsr     r2, r0              // shift to 0th bit 
    mov     r0, r2              // our return value will be either 0 or 1

    pop     {r1-r3}
    mov     pc, lr


/* r0 set to gpio # */
write_gpio_lo:
    push    {r1,r2}

    ldr     r2, =GPIO_BASE      
    mov     r1, #1              // set bit in r1
    lsl     r1, r0              // shift to pin we want

    str     r1, [r2, #0x00C]    // write gpio to low (led on);

    pop     {r1,r2}
    mov     pc, lr


/* r0 set to gpio # */
write_gpio_hi:
    push    {r1,r2}

    ldr     r2, =GPIO_BASE      
    mov     r1, #1              // set bit in r1
    lsl     r1, r0              // shift to pin we want

    str     r1, [r2, #0x008]    // write gpio to high (led off);

    pop     {r1,r2}
    mov     pc, lr
