#include <zephyr/kernel.h>
#include <stdint.h>

void foo(volatile uint32_t arg){
    printk("%u\n",arg);

    return;
}

int main(void){
    volatile uint32_t var = 39;

    if(var > 20){
        printk("Hello world\n");
    }

    for(int i = 0; i < 10; ++i){
        foo(var++);
    }

    return 0;
}
