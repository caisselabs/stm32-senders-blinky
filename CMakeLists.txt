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
cpmaddpackage("gh:intel/cicd-repo-infrastructure#main")

add_versioned_package("gh:intel/cpp-std-extensions#f67b432")
add_versioned_package("gh:intel/cpp-baremetal-concurrency#659771e")
add_versioned_package("gh:intel/cpp-baremetal-senders-and-receivers#66be17b")
add_versioned_package("gh:intel/generic-register-operation-optimizer#b59207e")
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

