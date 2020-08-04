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
include src/FluidManipulation/CMakeFiles/FluidManipulation.dir/depend.make

# Include the progress variables for this target.
include src/FluidManipulation/CMakeFiles/FluidManipulation.dir/progress.make

# Include the compile flags for this target's objects.
include src/FluidManipulation/CMakeFiles/FluidManipulation.dir/flags.make

src/FluidManipulation/CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.o: src/FluidManipulation/CMakeFiles/FluidManipulation.dir/flags.make
src/FluidManipulation/CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.o: ../src/FluidManipulation/FluidManipulation.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/media/psf/Home/dev/flucoma-sc/linuxbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/FluidManipulation/CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.o"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidManipulation && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.o -c /media/psf/Home/dev/flucoma-sc/src/FluidManipulation/FluidManipulation.cpp

src/FluidManipulation/CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.i"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidManipulation && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /media/psf/Home/dev/flucoma-sc/src/FluidManipulation/FluidManipulation.cpp > CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.i

src/FluidManipulation/CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.s"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidManipulation && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /media/psf/Home/dev/flucoma-sc/src/FluidManipulation/FluidManipulation.cpp -o CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.s

# Object files for target FluidManipulation
FluidManipulation_OBJECTS = \
"CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.o"

# External object files for target FluidManipulation
FluidManipulation_EXTERNAL_OBJECTS =

../release-packaging/plugins/FluidManipulation.so: src/FluidManipulation/CMakeFiles/FluidManipulation.dir/FluidManipulation.cpp.o
../release-packaging/plugins/FluidManipulation.so: src/FluidManipulation/CMakeFiles/FluidManipulation.dir/build.make
../release-packaging/plugins/FluidManipulation.so: _deps/flucoma-core-build/libHISSTools_FFT.a
../release-packaging/plugins/FluidManipulation.so: src/FluidManipulation/CMakeFiles/FluidManipulation.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/media/psf/Home/dev/flucoma-sc/linuxbuild/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX shared module ../../../release-packaging/plugins/FluidManipulation.so"
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidManipulation && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/FluidManipulation.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/FluidManipulation/CMakeFiles/FluidManipulation.dir/build: ../release-packaging/plugins/FluidManipulation.so

.PHONY : src/FluidManipulation/CMakeFiles/FluidManipulation.dir/build

src/FluidManipulation/CMakeFiles/FluidManipulation.dir/clean:
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidManipulation && $(CMAKE_COMMAND) -P CMakeFiles/FluidManipulation.dir/cmake_clean.cmake
.PHONY : src/FluidManipulation/CMakeFiles/FluidManipulation.dir/clean

src/FluidManipulation/CMakeFiles/FluidManipulation.dir/depend:
	cd /media/psf/Home/dev/flucoma-sc/linuxbuild && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /media/psf/Home/dev/flucoma-sc /media/psf/Home/dev/flucoma-sc/src/FluidManipulation /media/psf/Home/dev/flucoma-sc/linuxbuild /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidManipulation /media/psf/Home/dev/flucoma-sc/linuxbuild/src/FluidManipulation/CMakeFiles/FluidManipulation.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/FluidManipulation/CMakeFiles/FluidManipulation.dir/depend

