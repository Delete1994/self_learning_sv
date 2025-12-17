# Makefile for DPI example
# Supports VCS, QuestaSim (ModelSim), and Xcelium

# ============== Configuration ==============
# Choose your simulator: vcs, questa, or xcelium
SIM ?= vcs

# Source files
SV_FILES = tb.sv
C_FILES = dpi_functions.c

# Output
SIM_EXECUTABLE = simv
WORK_DIR = work
DPI_LIB_NAME = dpi_functions
DPI_LIB = lib$(DPI_LIB_NAME).so

# Compiler flags
CFLAGS = -fPIC -shared -g -Wall
VCS_HOME ?= $(VCS_HOME)

# ============== VCS Configuration ==============
VCS = vcs
VCS_FLAGS = -full64 -sverilog -debug_access+all -LDFLAGS -Wl,-rpath,'$$ORIGIN'
VCS_RUN_FLAGS = 

# ============== Questa/ModelSim Configuration ==============
VLOG = vlog
VSIM = vsim
QUESTA_FLAGS = -sv -dpiheader dpi_header.h
QUESTA_RUN_FLAGS = -c -do "run -all; quit"

# ============== Xcelium Configuration ==============
XRUN = xrun
XCELIUM_FLAGS = -sv -access +rwc -dpiheader dpi_header.h

# ============== Targets ==============

.PHONY: all clean run help vcs vcs_svlib questa xcelium

# Default target
all: help

help:
	@echo "========================================"
	@echo "DPI Example Makefile"
	@echo "========================================"
	@echo "Available targets:"
	@echo "  make vcs         - Compile and run with VCS (C files directly)"
	@echo "  make vcs_svlib   - Compile and run with VCS (-sv_lib .so)"
	@echo "  make questa      - Compile and run with QuestaSim"
	@echo "  make xcelium     - Compile and run with Xcelium"
	@echo "  make clean       - Remove generated files"
	@echo ""
	@echo "Examples:"
	@echo "  make vcs"
	@echo "  make vcs_svlib"
	@echo "  make questa"
	@echo ""

# ============== VCS Build and Run ==============
vcs: clean
	@echo "========================================"
	@echo "Building with VCS (direct C files)..."
	@echo "========================================"
	$(VCS) $(VCS_FLAGS) $(SV_FILES) $(C_FILES) -o $(SIM_EXECUTABLE)
	@echo ""
	@echo "========================================"
	@echo "Running simulation with VCS..."
	@echo "========================================"
	./$(SIM_EXECUTABLE) $(VCS_RUN_FLAGS)

# ============== VCS with -sv_lib ==============
# Compile with shared library linked at compile time
vcs_svlib: clean $(DPI_LIB)
	@echo "========================================"
	@echo "Building with VCS using shared library..."
	@echo "========================================"
	$(VCS) $(VCS_FLAGS) $(SV_FILES) $(DPI_LIB) -o $(SIM_EXECUTABLE)
	@echo ""
	@echo "========================================"
	@echo "Running simulation with VCS..."
	@echo "========================================"
	./$(SIM_EXECUTABLE) $(VCS_RUN_FLAGS)

# Build with runtime loading using -sv_lib option
vcs_runtime: clean $(DPI_LIB)
	@echo "========================================"
	@echo "Building with VCS (runtime loading)..."
	@echo "========================================"
	$(VCS) $(VCS_FLAGS) $(SV_FILES) -o $(SIM_EXECUTABLE)
	@echo "Creating symlink for runtime loading..."
	ln -sf $(DPI_LIB) $(DPI_LIB_NAME).so
	@echo ""
	@echo "========================================"
	@echo "Running with -sv_lib option..."
	@echo "========================================"
	./$(SIM_EXECUTABLE) -sv_lib $(DPI_LIB_NAME) $(VCS_RUN_FLAGS)

# Build shared library for -sv_lib
$(DPI_LIB): $(C_FILES)
	@echo "========================================"
	@echo "Compiling C code to shared library..."
	@echo "========================================"
	gcc $(CFLAGS) -I$(VCS_HOME)/include $(C_FILES) -o $(DPI_LIB)
	@echo "Generated: $(DPI_LIB)"
	@ls -lh $(DPI_LIB)

# ============== QuestaSim/ModelSim Build and Run ==============
questa: clean
	@echo "========================================"
	@echo "Building with QuestaSim..."
	@echo "========================================"
	# Create work library
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)
	# Compile SV files
	$(VLOG) $(QUESTA_FLAGS) $(SV_FILES)
	# Compile C files
	gcc $(CFLAGS) $(C_FILES) -I$(MTI_HOME)/include -o dpi_functions.so
	@echo ""
	@echo "========================================"
	@echo "Running simulation with QuestaSim..."
	@echo "========================================"
	$(VSIM) $(QUESTA_RUN_FLAGS) -sv_lib dpi_functions work.tb

# ============== Xcelium Build and Run ==============
xcelium: clean
	@echo "========================================"
	@echo "Building and running with Xcelium..."
	@echo "========================================"
	$(XRUN) $(XCELIUM_FLAGS) $(SV_FILES) $(C_FILES)

# ============== Clean ==============
clean:
	@echo "Cleaning up..."
	rm -rf $(SIM_EXECUTABLE) $(SIM_EXECUTABLE).daidir csrc *.log DVEfiles
	rm -rf $(WORK_DIR) transcript vsim.wlf *.so *.o
	rm -rf xcelium.d *.shm *.diag INCA_libs dpi_header.h
	rm -rf ucli.key vc_hdrs.h .vlogansetup.args .vlogansetup.env
	rm -rf $(DPI_LIB)
	@echo "Clean complete."

# ============== Debug Info ==============
debug:
	@echo "SV Files: $(SV_FILES)"
	@echo "C Files: $(C_FILES)"
	@echo "Simulator: $(SIM)"
	@echo "VCS: $(VCS)"
	@echo "Work Dir: $(WORK_DIR)"
