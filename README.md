# zephyr-base

Basic example for Zephyr OS including Github Actions and flashing the build project on Windows and Linux

## Downloading the compiled program

The compiled binaries are currently available at the Github Actions center. These files will also become available in the releases menu when there is a official release. The artifacts can be downloaded by clicking on a succesful workflow run. Download the *build* artifact.

## Flashing the files

Before you can flash the files you have to follow the [installation steps](flashing-compiled-binaries.md#installatie) as explained in flashing-compiled-binaries.md.

The artifact includes a script for Windows and Linux. This script should automatically flash the script to the connected ESP32 board. The correct port should automatically be picked up, however you can specify a port by adding the argument *-p*. For example `-p COM2` on Windows and `-p /dev/ttyUSB1` on Linux.

Because operating systems protect you from running scripts you have to run a command to allow the execution of the script.

### Windows

Allow the current logged in user to execute scripts. [more info](https://docs.microsoft.com/en-gb/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2)

```sh
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```

### Linux

Allow the selected file to be executed

```sh
chmod +x flash.sh
```

### Flash the file

Now the script can be executed.

```sh
./flash.sh -p /dev/ttyUSB1
```

## Building the project from source

Making local changes and compiling the source code can be done by editing the files in the *app* directory. You need to use CMake (CMakeLists.txt) to include new files. After you have made your modifications you can compile Zephyr OS by following the [tutorial](building-zephyr-os.md) in building-zephyr-os.md.

### CMakeLists.txt example structure

This section may not be 100% accurate and still needs some work.

#### Folder structure

![Zephyr OS file structure](file-structure.drawio.svg)

#### CMakeLists.txt in the app folder

```cmake
cmake_minimum_required(VERSION 3.20.0)

set(APP_TARGET zephyr-os)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})

project(${APP_TARGET})

target_sources(app PRIVATE src/main.c)

add_subdirectory(driver)

target_link_libraries(${APP_TARGET}
  driver
)
```

#### CMakeLists.txt in the driver folder

```cmake
add_library(driver INTERFACE)

target_include_directories(driver
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}
)

target_sources(driver
  INTERFACE
    src/driver.cpp
)

```
