############################# Makefile variables ###############################

# Compiler to use
CC = gcc

# Compiler flags
CFLAGS = -fPIC -g -pedantic-errors -Wall -Wextra -ansi

# Target
TARGET = calculator.out

# Objects
OBJS = $(BPATH)calculator.o

# Shared objects
SOBJS = $(LPATH)libsorted_list.so

# Additional shared library path
libstack_PATH = ./lib/

# Additional shared library flags
libstack_FLAG = -lstack

############################## Custom variables ################################

# Header Path
HPATH = -I ./include

# Bin Path
BPATH = ./bin/

# Src Path
SPATH = ./src/

# Test Path
TPATH = ./test/

# Lib Path
LPATH = ./lib/

################################### RULES ######################################

# Default target
all: $(TARGET)

$(TARGET): $(BPATH)calculator.o $(BPATH)calculator_test.o
	$(CC) $(CFLAGS) -o $@ $(BPATH)calculator.o $(BPATH)calculator_test.o -Wl,-rpath,$(libstack_PATH) -L$(libstack_PATH) $(libstack_FLAG)

$(BPATH)calculator.o: $(SPATH)calculator.c
	$(CC) $(CFLAGS) -c $<  $(HPATH) -o $@

$(BPATH)calculator_test.o: $(TPATH)calculator_test.c
	$(CC) $(CFLAGS) -c $<  $(HPATH) -o $@


clear: 
	rm $(BPATH)*.o

run:
	valgrind -s --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(TARGET)
