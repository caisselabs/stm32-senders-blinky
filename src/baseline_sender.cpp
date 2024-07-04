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
#include "baseline_timer_scheduler.hpp"

#include <async/just.hpp>
#include <async/sequence.hpp>
#include <async/then.hpp>
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
void set_led(bool);


using namespace std::chrono_literals;


int main() {

  initialize_board();
  setup_interrupts();
  //initialize_timer();

  
  auto delay = [](auto v) {
    return
      async::continue_on(async::time_scheduler{v}); 
  };

  async::sender auto blinky =
      async::just()
    | async::then([](){set_led(true);})
    | delay(1s)
    | async::then([](){set_led(false);})
    | delay(300ms)
    ;

  auto s = blinky | async::repeat() | async::start_detached();

  while(true) {
    // spin little heater, spin
  }
  
}
