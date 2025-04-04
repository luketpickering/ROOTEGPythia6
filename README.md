# ROOTEGPythia6

This is a standalone version of the [ROOT](https://root.cern.ch) EGPythia6 library, which was removed in ROOT v6.30.

The src/ and inc/ directories are copied from the ROOT source tree at version 6.28.00.

## Build

```bash
git clone https://github.com/luketpickering/ROOTEGPythia6.git
cd ROOTEGPythia6; mkdir build; cd build
cmake .. -DROOTEGPythia6_Pythia6_BUILTIN=<ON|OFF>
make install #installs to ROOTEGPythia6/build/Linux/ by default
```

## Use in your project

First add the build location to the CMake prefix path

```bash
export ROOTEGPythia6_ROOT=/path/to/ROOTEGPythia6/build/Linux
```

### CMake

```cmake
find_package(ROOTEGPythia6 REQUIRED)

target_link_libraries(tgt PUBLIC ROOT::EGPythia6)
```

### Non-CMake

```bash
gcc ... `${ROOTEGPythia6_ROOT}/bin/ROOTEGPythia6-config --cxxflags` ...
gcc ... `${ROOTEGPythia6_ROOT}/bin/ROOTEGPythia6-config --ldflags` ...
```