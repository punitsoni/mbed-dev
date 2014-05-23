CWD = $(shell pwd)

SRC_DIR = $(CWD)
OUT_DIR = $(CWD)/out
OUT_DIR_OBJ = $(OUT_DIR)/obj

include ../common.mk

SRC_FILES := FreeRTOS/croutine.c
SRC_FILES += FreeRTOS/portable/GCC/ARM_CM3/port.c
SRC_FILES += FreeRTOS/portable/MemMang/heap_4.c
SRC_FILES += FreeRTOS/list.c
SRC_FILES += FreeRTOS/queue.c
SRC_FILES += FreeRTOS/tasks.c
SRC_FILES += FreeRTOS/timers.c

INC_PATHS := FreeRTOS/portable/GCC/ARM_CM3
INC_PATHS += FreeRTOS/include
INC_PATHS += .

LIB_PATHS := ../mbed/TARGET_NUCLEO_F103RB/TOOLCHAIN_GCC_ARM
LIB_PATHS += /usr/arm-none-eabi/lib

LD_LIBS = -lstdc++ -lmbed -lsupc++ -lm -lc -lgcc -lnosys

CC_SRCS = $(wildcard $(addsuffix /*.c, $(SRC_DIRS)))
CC_INCS = $(addprefix -I, $(INC_PATHS))
CC_LIBS = $(addprefix -L, $(LIB_PATHS))

OBJ_FILES := $(addprefix $(OUT_DIR)/,$(SRC_FILES:%.c=%.o))
#$(info objs = $(OBJ_FILES)

# create output directory structure
$(shell mkdir -p $(dir $(OBJ_FILES)))

all: $(OUT_DIR)/libfrt.a
	@echo "DONE"

# build object files
$(OUT_DIR)/%.o: %.c
	@printf " %-10s $@\n" [CC]
	@$(CC) $(C_FLAGS) $(CC_INCS) $(CC_LIBS) -c $< -o $@

# build library from object files
$(OUT_DIR)/libfrt.a: $(OBJ_FILES)
	@printf " %-10s $@\n" [AR]
	@$(AR) ru $@ $^

clean:
	rm -rf out