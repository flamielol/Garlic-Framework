CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -I$(shell brew --prefix glfw)/include -std=c11 -g
LDFLAGS =

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
TARGET = $(BIN_DIR)/game

SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SOURCES))

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -L$(shell brew --prefix glfw)/lib
    LIBS = -lglfw -lm -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo
    
    LIBS = -lglfw -lm -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo
else

    LIBS = -lglfw -lGL -lm
endif

.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	@echo "Linking $(TARGET)..."
	$(CC) $(OBJECTS) $(LDFLAGS) $(LIBS) -o $(TARGET)
	@echo "Build complete: $(TARGET)"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: run
run: $(TARGET)
	@echo "Running $(TARGET)..."
	./$(TARGET)