
TOOLCHAIN = /usr/arm-none-eabi
PROJECT = main

AS      = arm-none-eabi-as
AS      = arm-none-eabi-ar
CC      = arm-none-eabi-gcc
CPP     = arm-none-eabi-g++
LD      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy



CPU = -mcpu=cortex-m3 -mthumb

C_FLAGS = $(CPU) -c -g -fno-common -fmessage-length=0 -Wall \
          -fno-exceptions -ffunction-sections -fdata-sections 

C_FLAGS += -MMD -MP

LD_FLAGS = -mcpu=cortex-m3 -mthumb -Wl,--gc-sections --specs=nano.specs \
-u _printf_float -u _scanf_float

C_SYMBOLS = -DTARGET_NUCLEO_F103RB -DTARGET_M3 -DTARGET_STM \
            -DTOOLCHAIN_GCC_ARM -DTOOLCHAIN_GCC -D__CORTEX_M3 \
            -DARM_MATH_CM3 -DMBED_BUILD_TIMESTAMP=1400548239.15 -D__MBED__=1

