# The Generic system is used with CMake to specify bare metal
set( CMAKE_SYSTEM_NAME       Generic )
set( CMAKE_SYSTEM_PROCESSOR  arm )

# Setup the path where the toolchain is located
set( TC_PATH "/Applications/ArmGNUToolchain/13.2.Rel1/arm-none-eabi/bin/")


# The toolchain prefix for all toolchain executables
set( CROSS_COMPILE "arm-none-eabi-")

set( CMAKE_C_COMPILER   "${TC_PATH}${CROSS_COMPILE}gcc" )
set( CMAKE_CXX_COMPILER "${TC_PATH}${CROSS_COMPILE}g++" )
set( CMAKE_LINKER       "${TC_PATH}${CROSS_COMPILE}ld" )
set( CMAKE_AR           "${TC_PATH}${CROSS_COMPILE}ar" )

# We must set the OBJCOPY setting into cache so that it's available to the
# whole project. Otherwise, this does not get set into the CACHE and therefore
# the build doesn't know what the OBJCOPY filepath is
set( CMAKE_OBJCOPY      ${TC_PATH}${CROSS_COMPILE}objcopy
     CACHE FILEPATH "The toolchain objcopy command " FORCE )


set( CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY )

# don't search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


# setup the common CMAKE flags for both the C and C++ compilers
set( COMMON_FLAGS "${COMMON_FLAGS} -mthumb -mcpu=cortex-m4" )
set( COMMON_FLAGS "${COMMON_FLAGS} -mfloat-abi=hard" )
set( COMMON_FLAGS "${COMMON_FLAGS} -mfpu=fpv4-sp-d16" )
set( COMMON_FLAGS "${COMMON_FLAGS} -mtune=cortex-m4" )
set( COMMON_FLAGS "${COMMON_FLAGS} -ffunction-sections" )
set( COMMON_FLAGS "${COMMON_FLAGS} -fdata-sections" )
# temporary here
set( COMMON_FLAGS "${COMMON_FLAGS} -g -Os -flto" )
set( COMMON_FLAGS "${COMMON_FLAGS} -D__NO_SYSTEM_INIT" )

# Set the CMAKE C flags (which should also be used by the assembler!
set( CMAKE_C_FLAGS "${COMMON_FLAGS}")

# Set the CMAKE C++ flags
set( CMAKE_CXX_FLAGS "${COMMON_FLAGS}" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-usage" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-threadsafe-statics" )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --specs=nosys.specs" )
#set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --specs=nano.specs" )


set( CMAKE_EXE_LINKER_FLAGS "")
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${CMAKE_SOURCE_DIR}/ldscripts -T gcc.ld" )
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static" )
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections" )
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=foo.map" )
#set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${LINKER_SCRIPT} -Wl,--gc-sections -estart" )


# cache the flags for use
#set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "CFLAGS" )
#set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "CXXFLAGS" )
set( CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" )
#set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE STRING "" )

