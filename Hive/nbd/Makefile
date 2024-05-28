#compiler
CC = g++

#flags 
FLAGS = -std=c++11 -pedantic-errors -Wall -Wextra 

DEBUG_FLAGS = -DDEBUG -g

RELEASE_FLAGS = -O3

#Header path
CUR_DIR = .

BIN_DIR = ./bin

LIB_DIR = ./lib

HEADER = $(wildcard $(CUR_DIR)/include)

INCLUDE = $(foreach dot_h, $(HEADER), -I$(dot_h))

SRCS = $(wildcard $(CUR_DIR)/src/*.cpp)

SRC = $(wildcard $(CUR_DIR)/src/$*.cpp)

TEST = $(wildcard $(CUR_DIR)/test/$*.cpp)

OBJS = $(patsubst %.cpp, $(BIN_DIR)/%.o, $(notdir $(SRCS)))

LIB = $(LIB_DIR)/libfram_work.so

LIB_FLAG = $(patsubst lib%.so, -l%, $(notdir $(LIB)))

TARGET = $(patsubst %.cpp, ./%.out, $(notdir $(wildcard ./test/*.cpp)))

all: $(TARGET)

debug: FLAGS +=$(DEBUG_FLAGS)
debug: $(TARGET)
	
release: FLAGS +=$(RELEASE_FLAGS) 
release: $(TARGET)

$(BIN_DIR)/%.o: $(SRC)
	$(CC) -c -fPIC $(FLAGS) $(SRC) $(INCLUDE) -o $@
	
$(LIB): $(OBJS)
	$(CC) -shared -o $@ $^

$(TARGET): $(TEST) $(LIB)
	$(CC) $(FLAGS) -o $@ $(TEST) $(INCLUDE) -Wl,-rpath,$(LIB_DIR) -L$(LIB_DIR) $(LIB_FLAG)
	
clean:
	rm -rf $(BIN_DIR)/*.o $(DIP_DIR)/*.d ./*.out $(LIB_DIR)/*.so ./*.txt
	
run:
	./*.out

print: 
	@echo $(LIB)
	
