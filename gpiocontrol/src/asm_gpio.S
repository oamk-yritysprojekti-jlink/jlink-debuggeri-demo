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


.global configure_gpio_out,write_gpio_lo,write_gpio_hi

.type   configure_gpio_out,%function
.type   write_gpio_lo,%function
.type   write_gpio_hi,%function

.syntax unified

/* GPIO register base address for S  =   0x50842500
 * GPIO register base address for NS =   0x40842500 */
.equ GPIO_BASE, 0x50842500

/* GPIO 0.28-0.31 LED1-LED4 */
/* GPIO 0.23      BUTT 1
 * GPIO 0.24      BUTT 2
 * GPIO 0.08      BUTT 3
 * GPIO 0.09      BUTT 4 */


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

read_buttons:

    bx lr
    

/* r0 set to gpio # */
write_gpio_lo:
    push    {r1,r2}

    ldr     r2, =GPIO_BASE      
    mov     r1, #1              // set bit in r1
    lsl     r1, r0              // shift to pin we want

    str     r1, [r2, #0x00C]    // write gpio to low (led high);

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

