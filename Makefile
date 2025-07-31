#
# A flexible Makefile for building C projects with GLFW and GLAD.
#
# This Makefile automatically detects the operating system to apply the
# correct compiler and linker flags for maximum portability.
#

# --- Compiler and Flags ---
CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -std=c11 -g
LDFLAGS =

# --- Project Structure ---
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
TARGET = $(BIN_DIR)/game

# Find all .c files in the source directory.
SOURCES = $(wildcard $(SRC_DIR)/*.c)
# Create a list of corresponding object files in the object directory.
OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SOURCES))

# --- Platform-specific adjustments ---
# The LIBS variable is defined differently based on the OS.
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    # On macOS, use Homebrew's path for GLFW and add required frameworks.
    # The 'brew --prefix' command ensures this works for both Intel and Apple Silicon Macs.
    LDFLAGS += -L$(shell brew --prefix glfw)/lib
    
    # On macOS, OpenGL is a framework, not a library file.
    # We use -framework OpenGL instead of -lGL.
    LIBS = -lglfw -lm -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo
else
    # For other systems (like Linux), use the standard -lGL flag.
    # We assume libraries like libglfw.so and libGL.so are in the system's default path.
    LIBS = -lglfw -lGL -lm
endif

# --- Build Rules ---

# Default target: builds the final executable.
.PHONY: all
all: $(TARGET)

# Rule to link the final executable.
$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	@echo "Linking $(TARGET)..."
	$(CC) $(OBJECTS) $(LDFLAGS) $(LIBS) -o $(TARGET)
	@echo "Build complete: $(TARGET)"

# Rule to compile a source file into an object file.
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# --- Utility Rules ---

# Rule to clean up all generated files.
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(OBJ_DIR) $(BIN_DIR)

# Rule to build and run the game.
.PHONY: run
run: $(TARGET)
	@echo "Running $(TARGET)..."
	./$(TARGET)