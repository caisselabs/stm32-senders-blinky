//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
#pragma once

#include <cstdint>
#include <atomic>


/**
 *  Enable the interrupts we will be using:
 *
 *  - TIM2 is used for the sender timer interrupt.
 *  - DMA2 is taken over for the scheduler, will be controlled via SW
 */
inline void setup_interrupts() {
  
  // interrupt set-enable register
  auto NVIC_ISER0 = (volatile std::uint32_t * const)(0xe000'e100);
  auto NVIC_ISER1 = (volatile std::uint32_t * const)(0xe000'e104);
  // interrupt clear-enable register
  auto NVIC_ICER0 = (volatile std::uint32_t * const)(0xe000'e180);
  auto NVIC_ICER1 = (volatile std::uint32_t * const)(0xe000'e184);

  // enable TIM2 interrupt for the timer
  // TIM2_Handler
  // interrupt 26 bit
  constexpr std::uint32_t INT28_BIT = 0x1000'0000;
  *NVIC_ISER0 = INT28_BIT;
  
  // use interrupt 56 for scheduler
  // DMA2_CH1_Handler
  // vector 0x0000'0120
  // interrupt 56 bit
  constexpr std::uint32_t INT56_BIT = 0x0100'0000;
  *NVIC_ISER1 = INT56_BIT;
}


namespace blinky::detail {

  inline constinit std::atomic<std::uint32_t> disable_count = {};
  
  inline void enable_interrupts() {
    if(disable_count.fetch_sub(1) == 1) {
      __asm__ __volatile__ ("cpsie i");
    }
    __asm__ __volatile__ ("" ::: "memory");  // compiler barrier
  }

  inline void disable_interrupts() {
    __asm__ __volatile__ ("" ::: "memory");  // compiler barrier
    if(disable_count.fetch_add(1) == 0) {
      __asm__ __volatile__ ("cpsid i");
    }
  }

  struct disable_interrupts_lock {
    disable_interrupts_lock() {
      disable_interrupts();
    }
    ~disable_interrupts_lock() {
      enable_interrupts();
    }
  };
}


inline void trigger_interrupt(int v) {
  // interrupt set-enable register
  auto NVIC_STIR = (volatile std::uint32_t * const)(0xe000'ef00);
  *NVIC_STIR = v;
}


