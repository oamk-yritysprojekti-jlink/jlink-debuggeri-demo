#include <zephyr/kernel.h>

#define LED_PIN 28

extern void configure_gpio_out(unsigned int pin);
extern void write_gpio_hi(unsigned int pin);
extern void write_gpio_lo(unsigned int pin);


int main(){
    bool ledState = false;
    configure_gpio_out(LED_PIN);

    for(;;){
        if(ledState){
            // asettaa ledin pois päältä
            write_gpio_hi(LED_PIN);
            ledState = !ledState;
        }else{
            // asettaa ledin päälle
            write_gpio_lo(LED_PIN);
            ledState = !ledState;
        }

        k_msleep(200);

    }

}
