//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
// ----------------------------------------------------------------------------
//
// Timer interrupt hooked to a priority to a timer scheduler
//
//
// ----------------------------------------------------------------------------
#include "interrupt.hpp"  // for setup_interrupts

// a concurrency policy is needed by the async library
#include "blinky_concurrency.hpp"

#include "fixed_priority_scheduler.hpp"
#include "timer_scheduler.hpp"

#include <caisselabs/stm32/stm32l432.hpp>

#include <async/sequence.hpp>
#include <async/repeat.hpp>
#include <async/continue_on.hpp>
#include <async/start_detached.hpp>
#include <async/schedulers/priority_scheduler.hpp>
#include <async/schedulers/task_manager.hpp>
#include <async/schedulers/time_scheduler.hpp>

#include <cstdint>
#include <chrono>

// method to initialize basic board functionality
void initialize_board();


namespace stm32 = caisselabs::stm32;

using namespace std::chrono_literals;
using namespace groov::literals;


int main() {

  initialize_board();
  setup_interrupts();
  initialize_timer();

  
  auto delay = [](auto v) {
    return
      async::continue_on(async::time_scheduler{v});
  };

  auto led_on  = groov::write(stm32::gpiob("odr.3"_f=true));
  auto led_off = groov::write(stm32::gpiob("odr.3"_f=false));
  auto on_cycle  = led_on  | delay(1s);
  auto off_cycle = led_off | delay(300ms);

  
  async::sender auto blinky =
      on_cycle
    | async::seq(off_cycle)
    ;

  auto s = blinky | async::repeat() | async::start_detached();

  while(true) {
    // spin little heater, spin
  }
  
}
