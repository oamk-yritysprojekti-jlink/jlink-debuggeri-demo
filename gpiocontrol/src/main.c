#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <stdint.h>

#define BITSET(x, n) ((x) |= 1UL << (n))
#define BITCLR(x, n) ((x) |= ~(1UL << (n)))

#define N_LEDS 4


extern void configure_gpio_out(int);
extern void write_gpio_lo(int);
extern void write_gpio_hi(int);

static int leds[N_LEDS] = {28,29,30,31};
static bool led_state[N_LEDS] = {0,0,0,0};

void toggleLed(int n){
    if( (n >= N_LEDS) || (n < 0)) return;

    if(led_state[n]){
        write_gpio_hi(leds[n]); // turn off if on
        led_state[n] = false;
    }else{
        write_gpio_lo(leds[n]); // turn on if off
        led_state[n] = true;
    }
}

int main(void){
    printk("Configuring gpios asm\n");
    for (int i = 28; i <= 31; ++i){
        configure_gpio_out(i);
    }

    for(;;){

        for(int i = 0; i < 4; ++i){
            toggleLed(i);
            k_msleep(200);
        }
    }

    return 0;
}
