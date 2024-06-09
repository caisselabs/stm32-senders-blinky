//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
//
#pragma once

#include <async/schedulers/priority_scheduler.hpp>
#include <async/schedulers/task_manager.hpp>

// ----------------------------------------------------------------------------
// fixed priority scheduler
//
namespace blinky_sched {
struct interrupt_scheduler {
  static auto schedule(async::priority_t p) -> void {
    trigger_interrupt(56);
  }
};

using task_manager_t = async::priority_task_manager<interrupt_scheduler, 1>;
} // namespace blinky

template <> inline auto async::injected_task_manager<> = blinky_sched::task_manager_t{};

extern "C" {
  // taking this interrupt over for our scheduler
  // DMA2_CH1 is interrupt 56 for our target
  inline void DMA2_CH1_Handler(void) {
    async::task_mgr::service_tasks<0>();
  }
}
// ----------------------------------------------------------------------------
