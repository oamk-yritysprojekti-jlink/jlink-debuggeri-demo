#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <stdint.h>

#define ever ;;

#define SLEEP_TIME_MS 200

#define LED0_NODE DT_ALIAS(led0)


#define BITSET(x, n) ((x) |= 1UL << (n))
#define BITCLR(x, n) ((x) |= ~(1UL << (n)))

#define GPIO_BASE   (volatile uint32_t*)(0x40842500)
#define CNF_OS(x)   (0x200 + (0x004 * (x)))

#define OUTSET_OS   0x008
#define OUTCLR_OS   0x00C

#define DIRSET_OS   0x018
#define DIRCLR_OS   0x01C

extern void entry_asm();
extern void configure_gpio_out(int);
extern void write_gpio_lo(int);
extern void write_gpio_hi(int);

int main(void){


    printk("Calling asm\n");
    for (int i = 28; i <= 31; ++i){
        configure_gpio_out(i);
        write_gpio_lo(i);
    }

    printk("Back from calling asm\n");
    k_msleep(2000);

    printk("Calling asm again\n");
    for (int i = 28; i <= 31; ++i){
        write_gpio_hi(i);
    }
    printk("Back from calling asm\n");

    for(ever){

        k_msleep(200);

    }



    return 0;
}
