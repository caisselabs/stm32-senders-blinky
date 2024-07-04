#
# Copyright (c) 2024 Michael Caisse
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#
cmake_minimum_required(VERSION 3.25)

project(
    stm32-senders-blinky
    VERSION 0.1.0
    LANGUAGES CXX C ASM
    DESCRIPTION
        "blinky led using senders on an STM32 dev board")

include(cmake/get_cpm.cmake)
cpmaddpackage("gh:intel/cicd-repo-infrastructure#dev")

add_versioned_package("gh:intel/cpp-std-extensions#a51e2bf")
add_versioned_package("gh:intel/cpp-baremetal-concurrency#030f9f3")
add_versioned_package("gh:intel/cpp-baremetal-senders-and-receivers#768da1c")
add_versioned_package("gh:intel/generic-register-operation-optimizer#835b88c")
add_versioned_package("gh:caisselabs/stm32-groov#f1f39f7")


add_executable(blinky
	startup/startup_gcc.s
	src/blinky.cpp
	src/setup.cpp
      )
# the detection used by baremetal concurrency results in determining
# that this target is hosted. Just force with define.
target_compile_definitions(blinky PUBLIC SIMULATE_FREESTANDING)
target_link_libraries_system(blinky PUBLIC async stm32-groov)


# --------------------------------------------------
# --------------------------------------------------
# these target is used to baseline compile time
add_executable(baseline
	startup/startup_gcc.s
	src/baseline.cpp
      )


add_executable(baseline_sender
	startup/startup_gcc.s
	src/baseline_sender.cpp
	src/baseline_setup.cpp
      )
# the detection used by baremetal concurrency results in determining
# that this target is hosted. Just force with define.
target_compile_definitions(baseline_sender PUBLIC SIMULATE_FREESTANDING)
target_link_libraries_system(baseline_sender PUBLIC async)
# --------------------------------------------------
# --------------------------------------------------
