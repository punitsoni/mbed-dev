#include "FreeRTOS.h"
#include "test1.h"
#include "mbed.h"
#include "task.h"

#define MS_TO_TICKS(ms) ((ms) / portTICK_RATE_MS)

DigitalOut myled(LED1);
Serial pc(USBTX, USBRX);
DigitalIn pb(USER_BUTTON);

int count=0;

void blink(int ms)
{
  myled = 1;
  vTaskDelay(MS_TO_TICKS(ms));
  myled = 0;
}

void task1(void* arg)
{
  int i;
  int period = 1000;
  while(1) {
    for(i=0; i<count; i++) {
      blink(50);
      vTaskDelay(MS_TO_TICKS(50));
    }
    vTaskDelay(MS_TO_TICKS(period - (i-1)*100));
  }
}

void task2(void* arg)
{
  static int prev_count=0;
  while(1) {
    if(count != prev_count) {
      pc.printf("count = %d\n", count);
      prev_count = count;
    }
    //count++;
    vTaskDelay(MS_TO_TICKS(100));
  }
}

void task3(void* arg)
{
  int old_pb=1;
  int new_pb;
  pb.mode(PullUp);
  vTaskDelay(MS_TO_TICKS(100));
  while(1) {
      new_pb = pb;
      if ((new_pb==0) && (old_pb==1)) {
        count++;
      }
      old_pb = new_pb;
      vTaskDelay(MS_TO_TICKS(10));
  }
}

void test_run()
{

  pc.baud(115200);

  pc.printf("RESET\n");

  xTaskHandle hTask1;
  xTaskHandle hTask2;
  xTaskHandle hTask3;

  xTaskCreate(task1, (signed char *) "t1", configMINIMAL_STACK_SIZE * 4,
              NULL, tskIDLE_PRIORITY + 3, &hTask1);

  xTaskCreate(task2, (signed char *) "t2", configMINIMAL_STACK_SIZE * 4,
              NULL, tskIDLE_PRIORITY + 3, &hTask2);

  xTaskCreate(task3, (signed char *) "t3", configMINIMAL_STACK_SIZE * 4,
              NULL, tskIDLE_PRIORITY + 3, &hTask3);

  pc.printf("Starting Scheduler\n");

  vTaskStartScheduler();
}