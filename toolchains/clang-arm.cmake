# The Generic system is used with CMake to specify bare metal
set( CMAKE_SYSTEM_NAME       Generic )
set( CMAKE_SYSTEM_PROCESSOR  arm )

# Setup the path where the toolchain is located
set( TC_PATH "/Users/mjcaisse/tools/LLVMEmbeddedToolchainForArm-16.0.0-Darwin/bin/")


# The toolchain prefix for all toolchain executables
set( CROSS_COMPILE )

set( CMAKE_C_COMPILER   "${TC_PATH}${CROSS_COMPILE}clang" )
set( CMAKE_CXX_COMPILER "${TC_PATH}${CROSS_COMPILE}clang++" )
set( CMAKE_LINKER       "${TC_PATH}${CROSS_COMPILE}lld" )
set( CMAKE_AR           "${TC_PATH}${CROSS_COMPILE}llvm-ar" )

# We must set the OBJCOPY setting into cache so that it's available to the
# whole project. Otherwise, this does not get set into the CACHE and therefore
# the build doesn't know what the OBJCOPY filepath is
set( CMAKE_OBJCOPY      ${TC_PATH}${CROSS_COMPILE}llvm-objcopy
     CACHE FILEPATH "The toolchain objcopy command " FORCE )


set( CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY )

# don't search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


# Set the CMAKE C flags (which should also be used by the assembler!
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --target=arm-none-eabi" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-m4" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=hard" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=fpv4-sp-d16" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mtune=cortex-m4" )


set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --target=arm-none-eabi" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mcpu=cortex-m4" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfloat-abi=hard" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=fpv4-sp-d16" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mtune=cortex-m4" )

# use gcc's stdlib because the llvm is behind
set( GCC_TOOLPATH "/Applications/ArmGNUToolchain/13.2.Rel1/arm-none-eabi/arm-none-eabi/")
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --gcc-toolchain=${GCC_TOOLPATH}")
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++")
set(GCC_LINK_FLAGS "-Wl,-rpath -Wl,${GCC_TOOLPATH}/lib")

# cache the flags for use
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "CFLAGS" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "CXXFLAGS" )
set( CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" )
set( CMAKE_EXE_LINKER "${GCC_LINK_FLAGS}" CACHE STRING "" )

