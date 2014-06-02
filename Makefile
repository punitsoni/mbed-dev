CWD = $(shell pwd)

SRC_DIR = $(CWD)
OUT_DIR = $(CWD)/out
OUT_DIR_OBJ = $(OUT_DIR)/obj

include common.mk

# List all required source files
CPP_SRC_FILES :=
CPP_SRC_FILES := main.cpp

SRC_FILES :=
SRC_FILES += os/FreeRTOS/croutine.c
SRC_FILES += os/FreeRTOS/portable/GCC/ARM_CM3/port.c
SRC_FILES += os/FreeRTOS/portable/MemMang/heap_4.c
SRC_FILES += os/FreeRTOS/list.c
SRC_FILES += os/FreeRTOS/queue.c
SRC_FILES += os/FreeRTOS/tasks.c
SRC_FILES += os/FreeRTOS/timers.c

# List all required include paths
INC_PATHS := ./os/FreeRTOS/portable/GCC/ARM_CM3
INC_PATHS += ./os/FreeRTOS/include
INC_PATHS += ./os/FreeRTOS
INC_PATHS += ./os
INC_PATHS += .
INC_PATHS += ./mbed
INC_PATHS += ./mbed/TARGET_NUCLEO_F103RB
INC_PATHS += ./mbed/TARGET_NUCLEO_F103RB/TARGET_STM/TARGET_NUCLEO_F103RB

# List all required lib paths
LIB_PATHS := ./mbed/TARGET_NUCLEO_F103RB/TOOLCHAIN_GCC_ARM

# prebuilt objects
BUILT_OBJS = $(wildcard ./mbed/TARGET_NUCLEO_F103RB/TOOLCHAIN_GCC_ARM/*.o)


LD_SCRIPT = ./mbed/TARGET_NUCLEO_F103RB/TOOLCHAIN_GCC_ARM/STM32F10X.ld

LD_LIBS = -lstdc++ -lmbed -lsupc++ -lm -lc -lgcc -lnosys

CC_INCS = $(addprefix -I, $(INC_PATHS))
LD_LIB_PATHS = $(addprefix -L, $(LIB_PATHS))

OBJ_FILES := $(addprefix $(OUT_DIR_OBJ)/, $(SRC_FILES:%.c=%.o))
OBJ_FILES += $(addprefix $(OUT_DIR_OBJ)/, $(CPP_SRC_FILES:%.cpp=%.o))
#$(info objs = $(OBJ_FILES))
#$(info buil_objs = $(BUILT_OBJS))
#$(info incs = $(CC_INCS))
#$(info ld_libs = $(LD_LIBS))

# create output directory structure
$(shell mkdir -p $(dir $(OBJ_FILES)))

all: $(OUT_DIR)/$(PROJECT).bin
	@printf " %-10s $@\n" [DONE]

# build object files
$(OUT_DIR_OBJ)/%.o: %.c
	@printf " %-10s $@\n" [CC]
	@$(CC) $(C_FLAGS) $(CC_INCS) -c $< -o $@

$(OUT_DIR_OBJ)/%.o: %.cpp
	@printf " %-10s $@\n" [CPP]
	@$(CPP) $(C_FLAGS) $(CC_INCS) -c $< -o $@

# build library from object files
$(OUT_DIR)/libfrt.a: $(OBJ_FILES)
	@printf " %-10s $@\n" [AR]
	@$(AR) ru $@ $^

$(OUT_DIR)/$(PROJECT).elf: $(OBJ_FILES) $(BUILT_OBJS)
	@printf " %-10s $@\n" [LD]
	@$(LD) $(LD_FLAGS) -T$(LD_SCRIPT) -o $@ $^ $(LD_LIB_PATHS) $(LD_LIBS)
	@$(SIZE) $@

$(OUT_DIR)/$(PROJECT).bin: $(OUT_DIR)/$(PROJECT).elf
	@printf " %-10s $@\n" [OBJCOPY]
	@$(OBJCOPY) -O binary $< $@

clean:
	rm -rf out

# include dependency rules for all objects
DEPS = $(OBJ_FILES:.o=.d)
-include $(DEPS)