#compiler
CC = gcc 

#flags 
FLAGS = -g -ansi -pedantic-errors -Wall -Wextra -Werror
#FLAGS = -ansi

#Header path
DS_DIR = /home/ayah/git/ds
DLL_DIR = $(DS_DIR)/WS9_DLL
SL_DIR = $(DS_DIR)/WS10_Sorted_List
PQ_DIR = $(DS_DIR)/WS12_PQ
TASK_DIR = $(DS_DIR)/WS13_task
UID_DIR = $(DS_DIR)/WS11_UID
SCHED_DIR = $(DS_DIR)/WS13_Schedular
LIB_DIR = $(SCHED_DIR)/lib
BIN_DIR = $(SCHED_DIR)/bin

HEADER = $(DLL_DIR) $(SL_DIR) $(UID_DIR) $(TASK_DIR) $(PQ_DIR) $(SCHED_DIR)

INCLUDES = $(foreach dot_h, $(HEADER), -I$(dot_h)/include)

SRCS = $(wildcard $(SCHED_DIR)/src/*.c)

OBJS = $(patsubst %.c, $(BIN_DIR)/%.o, $(notdir $(SRCS)))

all: $(SCHED_DIR)/sched.out

$(BIN_DIR)/%.o: $(SCHED_DIR)/src/%.c
	$(CC) -c $< $(FLAGS) $(INCLUDES) -fPIC -o $@

$(LIB_DIR)/libsched.so: $(OBJS)
	$(CC) -shared -o $@ $^
	
$(SCHED_DIR)/sched.out: $(SCHED_DIR)/test/sched_test.c $(LIB_DIR)/libsched.so
	$(CC) -o $@ $< -I$(SCHED_DIR)/include -I$(UID_DIR)/include\
	 -L$(LIB_DIR) $(LIB_DIR)/libsched.so

run: $(SCHED_DIR)/sched.out
	$<
	
clean:
	rm -rf $(BIN_DIR)/*.o $(LIB_DIR)/*.so $(SCHED_DIR)/*.out
	
print: 
	@echo $(SRCS)
	
