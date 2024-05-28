#compiler
CC = gcc

#flags 
FLAGS = -g -ansi -pedantic-errors -Wall -Wextra -Werror
#FLAGS = -ansi

#Header path
CUR_DIR = .

BIN_DIR = ./bin

LIB_DIR = ./lib

HEADER = $(wildcard $(CUR_DIR)/include)

INCLUDE = $(foreach dot_h, $(HEADER),-I$(dot_h))

# source files
SRCS = $(wildcard $(CUR_DIR)/src/*.c)
SRC = $(wildcard $(CUR_DIR)/src/$*.c)
# custom source files
WDC_SRC = $(CUR_DIR)/src/wd_process.c
KW_SRC = $(CUR_DIR)/src/keepwatching.c
WD_SRC = $(CUR_DIR)/src/watchdog.c

WD_TEST = $(CUR_DIR)/test/watchdog*.c
# object files
OBJS = $(patsubst %.c, $(BIN_DIR)/%.o, $(notdir $(SRCS)))
# custom object files
OBJ_KW = $(patsubst %.c, $(BIN_DIR)/%.o, $(notdir $(KW_SRC)))
OBJ_WD = $(patsubst %.c, $(BIN_DIR)/%.o, $(notdir $(WD_SRC)))

# libraries
COMMON_LIB = $(LIB_DIR)/libWDcommon.so
NEW_LIB_NAME = $(patsubst %.c,%, $(notdir $(SRCS)))
COMMON_LIB_FLAG = $(patsubst lib%.so,-l%, $(notdir $(COMMON_LIB)))
WD_STATIC_LIB_FLAG = $(patsubst lib%.a,-l%, $(notdir $(WD_STATIC_LIB)))
SCHED_LIB = $(LIB_DIR)/libsched.so

TARGET_WDP = $(patsubst %.c, ./%.out, $(notdir $(WDC_SRC)))
WD_STATIC_LIB = $(patsubst %.o, $(LIB_DIR)/lib%.a, $(notdir $(OBJ_WD)))
TEST = ./watchdog.out

all: $(TARGET_WDP) $(WD_STATIC_LIB) $(TEST)

# generate object files from the source files
$(BIN_DIR)/%.o: $(SRC)
	$(CC) -c -fPIC $(FLAGS) $(SRC) $(INCLUDE) -o $@

$(COMMON_LIB): $(OBJ_KW) $(SCHED_LIB)
	$(CC) -shared -o $@ $< -Wl,-rpath,$(LIB_DIR) -L$(LIB_DIR) -lsched

$(TARGET_WDP): $(WDC_SRC) $(COMMON_LIB)
	$(CC) $(FLAGS) -o $@ $(WDC_SRC) $(INCLUDE) -Wl,-rpath,$(LIB_DIR) -L$(LIB_DIR) $(COMMON_LIB_FLAG)

$(WD_STATIC_LIB): $(OBJ_WD)
	ar rcs -o $@ $<

$(TEST): $(WD_TEST) $(COMMON_LIB) $(WD_STATIC_LIB) 
	$(CC) $(FLAGS) -o $@ $< $(INCLUDE) -Wl,-rpath,$(LIB_DIR) -L$(LIB_DIR) $(WD_STATIC_LIB_FLAG) -Wl,-rpath,$(LIB_DIR) -L$(LIB_DIR) $(COMMON_LIB_FLAG)


clean:
	rm -rf $(BIN_DIR)/*.o $(DIP_DIR)/*.d ./*.out $(LIB_DIR)/libwatchdog.a $(LIB_DIR)/libWDcommon.so
	
run:
	./*.out

print: 
	
	@echo $(NEW_LIB_NAME)
	
	
