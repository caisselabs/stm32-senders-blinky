//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
//
#pragma once

#include "interrupt.hpp"
#include "interrupt_scheduler.hpp"
//#include "stm32_timer.hpp"


#include <async/schedulers/time_scheduler.hpp>
#include <async/schedulers/timer_manager.hpp>
#include <async/sequence.hpp>
#include <async/then.hpp>
#include <async/repeat.hpp>
#include <async/start_detached.hpp>

#include <chrono>


// Tag for the interrupt scheduler to specify the Timer2 interrupt
struct Timer2Interrupt;

// ----------------------------------------------------------------------------
// Setup the timer HAL (hardware abstraction layer)
//
// The async::timer_manager requires a few functions which are provided by the
// "hal" type. See baremetal-sender-library docs for details.
//
namespace {
  // A HAL defines a time_point type and a task type,
  // and provides functions to control a timer interrupt
  struct hal {
    using time_point_t = std::chrono::local_time<
      std::chrono::duration<std::uint32_t,std::ratio<1, 16'000'000>>>;
    using task_t = async::timer_task<time_point_t>;

    static auto enable() -> void {
      //enable_timer();
    }
    
    static auto disable() -> void {
      //disable_timer();
    }
    
    static auto set_event_time(time_point_t tp) -> void {
      //start_timer(tp.time_since_epoch().count());
    }
    
    static auto now() -> time_point_t {
      return time_point_t{time_point_t::duration{0/*get_timer_value()*/}};
    }
  };

  // use the generic timer manager
  using timer_manager_t = async::generic_timer_manager<hal>;
} // namespace


// tell the library how to infer a time point type from a duration type by
// specializing time_point_for
namespace async::timer_mgr {
  template <typename Rep, typename Period>
  struct time_point_for<std::chrono::duration<Rep, Period>> {
    using type = hal::time_point_t;
  };
} // namespace async::timer_mgr


// Inject the timer_manager to be used by the async::time_scheduler
template <> inline auto async::injected_timer_manager<> = timer_manager_t{};


extern "C" {
  // When a TIM2 interrupt fires the interrupt vector points to this entry.
  // The actual actions for the ISR will be defined via the interrupt_scheduler
  // that we have created. This entry point simply calls the service_task
  // in the interrupt task manager with the tag for the appropriate interrupt.
  void TIM2_Handler(void) {
    async::interrupt_mgr::interrupt_task_manager<Timer2Interrupt>::service_task();
  }
}

// ----------------------------------------------------------------------------



// We are using the interrupt_scheduler to define a sender chain to handle
// our interrupt. This is the sender change for when a Timer2 interrupt
// occurs.
inline auto timer_interrupt =
    async::interrupt_scheduler<Timer2Interrupt>{}.schedule()
//  | async::seq(groov::write(stm32::tim2("sr.CC1IF"_f = false)))
  | async::then([](){
      async::timer_mgr::service_task();
    })
  | async::repeat()
  | async::start_detached();

