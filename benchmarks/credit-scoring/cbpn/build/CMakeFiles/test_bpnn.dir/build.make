# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/build

# Include any dependencies generated for this target.
include CMakeFiles/test_bpnn.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/test_bpnn.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/test_bpnn.dir/flags.make

CMakeFiles/test_bpnn.dir/test_bpnn.c.o: CMakeFiles/test_bpnn.dir/flags.make
CMakeFiles/test_bpnn.dir/test_bpnn.c.o: ../test_bpnn.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/test_bpnn.dir/test_bpnn.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/test_bpnn.dir/test_bpnn.c.o   -c /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/test_bpnn.c

CMakeFiles/test_bpnn.dir/test_bpnn.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/test_bpnn.dir/test_bpnn.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/test_bpnn.c > CMakeFiles/test_bpnn.dir/test_bpnn.c.i

CMakeFiles/test_bpnn.dir/test_bpnn.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/test_bpnn.dir/test_bpnn.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/test_bpnn.c -o CMakeFiles/test_bpnn.dir/test_bpnn.c.s

CMakeFiles/test_bpnn.dir/test_bpnn.c.o.requires:

.PHONY : CMakeFiles/test_bpnn.dir/test_bpnn.c.o.requires

CMakeFiles/test_bpnn.dir/test_bpnn.c.o.provides: CMakeFiles/test_bpnn.dir/test_bpnn.c.o.requires
	$(MAKE) -f CMakeFiles/test_bpnn.dir/build.make CMakeFiles/test_bpnn.dir/test_bpnn.c.o.provides.build
.PHONY : CMakeFiles/test_bpnn.dir/test_bpnn.c.o.provides

CMakeFiles/test_bpnn.dir/test_bpnn.c.o.provides.build: CMakeFiles/test_bpnn.dir/test_bpnn.c.o


# Object files for target test_bpnn
test_bpnn_OBJECTS = \
"CMakeFiles/test_bpnn.dir/test_bpnn.c.o"

# External object files for target test_bpnn
test_bpnn_EXTERNAL_OBJECTS =

test_bpnn: CMakeFiles/test_bpnn.dir/test_bpnn.c.o
test_bpnn: CMakeFiles/test_bpnn.dir/build.make
test_bpnn: bpnn/libBPNN.a
test_bpnn: CMakeFiles/test_bpnn.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable test_bpnn"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/test_bpnn.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/test_bpnn.dir/build: test_bpnn

.PHONY : CMakeFiles/test_bpnn.dir/build

CMakeFiles/test_bpnn.dir/requires: CMakeFiles/test_bpnn.dir/test_bpnn.c.o.requires

.PHONY : CMakeFiles/test_bpnn.dir/requires

CMakeFiles/test_bpnn.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/test_bpnn.dir/cmake_clean.cmake
.PHONY : CMakeFiles/test_bpnn.dir/clean

CMakeFiles/test_bpnn.dir/depend:
	cd /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/build /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/build /home/weijliu/elf-respect/benchmarks/credit-scoring/cbpn/build/CMakeFiles/test_bpnn.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/test_bpnn.dir/depend

