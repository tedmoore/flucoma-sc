# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


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
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /media/psf/Home/dev/flucoma-sc

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /media/psf/Home/dev/flucoma-sc/linuxbuild

# Include any dependencies generated for this target.
include src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/depend.make

# Include the progress variables for this target.
include src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/progress.make

# Include the compile flags for this target's objects.
include src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/flags.make

src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.o: src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/flags.make
src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.o: ../src/FluidBufMFCC/FluidBufMFCC.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/media/psf/Home/dev/flucoma-sc/linuxbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.o"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidBufMFCC && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.o -c /media/psf/Home/dev/flucoma-sc/src/FluidBufMFCC/FluidBufMFCC.cpp

src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.i"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidBufMFCC && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /media/psf/Home/dev/flucoma-sc/src/FluidBufMFCC/FluidBufMFCC.cpp > CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.i

src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.s"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidBufMFCC && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /media/psf/Home/dev/flucoma-sc/src/FluidBufMFCC/FluidBufMFCC.cpp -o CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.s

# Object files for target FluidBufMFCC
FluidBufMFCC_OBJECTS = \
"CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.o"

# External object files for target FluidBufMFCC
FluidBufMFCC_EXTERNAL_OBJECTS =

../release-packaging/plugins/FluidBufMFCC.so: src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/FluidBufMFCC.cpp.o
../release-packaging/plugins/FluidBufMFCC.so: src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/build.make
../release-packaging/plugins/FluidBufMFCC.so: _deps/flucoma-core-build/libHISSTools_FFT.a
../release-packaging/plugins/FluidBufMFCC.so: src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/media/psf/Home/dev/flucoma-sc/linuxbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX shared module ../../../release-packaging/plugins/FluidBufMFCC.so"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidBufMFCC && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/FluidBufMFCC.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/build: ../release-packaging/plugins/FluidBufMFCC.so

.PHONY : src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/build

src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/clean:
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidBufMFCC && $(CMAKE_COMMAND) -P CMakeFiles/FluidBufMFCC.dir/cmake_clean.cmake
.PHONY : src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/clean

src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/depend:
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /media/psf/Home/dev/flucoma-sc /media/psf/Home/dev/flucoma-sc/src/FluidBufMFCC /media/psf/Home/dev/flucoma-sc/linuxbuild /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidBufMFCC /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/FluidBufMFCC/CMakeFiles/FluidBufMFCC.dir/depend

