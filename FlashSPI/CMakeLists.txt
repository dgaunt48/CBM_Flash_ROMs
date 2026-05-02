# Generated Cmake Pico project file

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Initialise pico_sdk from installed location
# (note this can come from environment, CMake cache etc)

# == DO NOT EDIT THE FOLLOWING LINES for the Raspberry Pi Pico VS Code Extension to work ==
if(WIN32)
    set(USERHOME $ENV{USERPROFILE})
else()
    set(USERHOME $ENV{HOME})
endif()
set(sdkVersion 2.1.1)
set(toolchainVersion 14_2_Rel1)
set(picotoolVersion 2.1.1)
set(picoVscode ${USERHOME}/.pico-sdk/cmake/pico-vscode.cmake)
if (EXISTS ${picoVscode})
    include(${picoVscode})
endif()
# ====================================================================================
set(PICO_BOARD pico2 CACHE STRING "Board type")

# Pull in Raspberry Pi Pico SDK (must be before project)
include(pico_sdk_import.cmake)

set(COMMON_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../RP2350/Common")

project(FlashSPI C CXX ASM)

# Initialise the Raspberry Pi Pico SDK
pico_sdk_init()

# Add executable. Default name is the project name, version 0.1

add_executable(FlashSPI
    FlashSPI.c
    ${COMMON_DIR}/vga111.c
    ${COMMON_DIR}/VicChars.c
    ${COMMON_DIR}/SpiNorFlash.c
)

pico_set_program_name(FlashSPI "FlashSPI")
pico_set_program_version(FlashSPI "0.1")

# Generate PIO header
pico_generate_pio_header(FlashSPI ${COMMON_DIR}/hsync.pio)
pico_generate_pio_header(FlashSPI ${COMMON_DIR}/vsync.pio)
pico_generate_pio_header(FlashSPI ${COMMON_DIR}/rgb.pio)

# Modify the below lines to enable/disable output over UART/USB
pico_enable_stdio_uart(FlashSPI 0)
pico_enable_stdio_usb(FlashSPI 0)

# Add the standard library to the build
target_link_libraries(FlashSPI
    pico_stdlib
)

# Add the standard include files to the build
target_include_directories(FlashSPI PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
    ${COMMON_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/.. # for our common lwipopts or any other standard includes, if required
)

# Add any user requested libraries
target_link_libraries(FlashSPI 
    hardware_spi
    hardware_dma
    hardware_pio
)

pico_add_extra_outputs(FlashSPI)

