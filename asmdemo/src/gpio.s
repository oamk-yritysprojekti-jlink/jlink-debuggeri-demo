.section .text

// Halutaan, että aliohjelmamme ovat näkyvissä C koodista
.global configure_gpio_out
.global write_gpio_hi
.global write_gpio_lo

// kaikki ovat funktioita
.type   configure_gpio_out,%function
.type   write_gpio_hi,%function
.type   write_gpio_lo,%function

.syntax unified

// #define GPIO_BASE 0x40842500
.equ    GPIO_BASE, 0x40842500

// r0 sisältää pinnin #
// configure_gpio_out(28);
configure_gpio_out:
    /* Configure pin as output
     * disconnect input buffer
     * set pullup */
    mov r1, #15
    
    /* laske PIN_CNF[n] offset */
    mov r2, #0x4
    mul r2, r0
    add r2, #0x200

    /* tallenna konfiguraatio PIN_CNF[n] rekisteriin */
    ldr r0, =GPIO_BASE
    str r1, [r0, r2]
    
    bx  lr

// r0 sisältää pinnin #
write_gpio_hi:
    mov r1, #1  // asetetaan 0. bitti r1 rekisterissä
    lsl r1, r0  // siirretään pin #. bitin paikalle

    // kirjataan OUTSET rekisteriin
    ldr r0, =GPIO_BASE
    str r1, [r0, #0x008]
    
    bx  lr


// r0 sisältää pinnin #
write_gpio_lo:
    mov r1, #1  // asetetaan 0. bitti r1 rekisterissä
    lsl r1, r0  // siirretään pin #. bitin paikalle
    
    // kirjataan OUTCLR rekisteriin
    ldr r0, =GPIO_BASE
    str r1, [r0, #0x00C]

    bx  lr
