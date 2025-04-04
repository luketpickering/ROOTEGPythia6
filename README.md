# ROOTTPythia6

This is a standalone version of the [ROOT](https://) TPythia6 library, which was deprecated in ROOT v6.30.

The src/ and inc/ directories are copied from the ROOT source tree at version 6.28.00.

## Build

```bash
git clone https://github.com/luketpickering/ROOTTPythia6.git
cd ROOTTPythia6; mkdir build; cd build
cmake .. -DROOTTPythia6_Pythia6_BUILTIN=<ON|OFF>
make install #installs to ROOTTPythia6/build/Linux/ by default
```

## Use in your project

### CMake

First add the build location to the CMake prefix path

```bash
export CMAKE_PREFIX_PATH=/path/to/ROOTTPythia6/build/Linux:${CMAKE_PREFIX_PATH}
```

Then, in your CMake project

```cmake
find_package(ROOTTPythia6 REQUIRED)

target_link_libraries(tgt PUBLIC ROOTTPythia6)
```

### Non-CMake

Add the compile/link flags:

```bash
gcc ... -I/path/to/ROOTTPythia6/build/Linux/include ...
gcc -L/path/to/ROOTTPythia6/build/Linux/lib -lROOTTPythia6
```