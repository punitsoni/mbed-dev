#include "mbed.h"

DigitalOut myled(LED1);
Serial pc(USBTX, USBRX);

int main() {
    pc.baud(115200);
    pc.printf("Hello World !\n");
    while(1) {
        myled = 1;
        wait(0.1);
        myled = 0;
        wait(0.1);
    }
}