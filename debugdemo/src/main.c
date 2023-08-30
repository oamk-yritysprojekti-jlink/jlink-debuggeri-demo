#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <stdint.h>

int main(void){
    /* Basic increment by one counter to demonstrate
     * accessing memory (r/w) and CPU registers (r/w) during execution */
    volatile int val=0;

    while(1){
        printk("val at %p = 0x%X\n",&val,val);
        ++val;
        k_msleep(1000);
    }
    return 0;
}
