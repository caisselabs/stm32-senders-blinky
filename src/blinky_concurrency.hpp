//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
// ----------------------------------------------------------------------------
#pragma once

#include <conc/concurrency.hpp>

#include "interrupt.hpp"

// ----------------------------------------------------------------------------
// concurrency policy
namespace blinky_sched {
struct concurrency_policy {
  template <typename = void, stdx::invocable F, stdx::predicate... Pred>
     requires(sizeof...(Pred) < 2)
  static inline auto call_in_critical_section(F &&f, auto &&...pred) -> decltype(auto) {
    while (true) {
      blinky::detail::disable_interrupts_lock lock{};
      if ((... and pred())) {
    	return std::forward<F>(f)();
      }
    }
  }
};
} // namespace blinky


template <> inline auto conc::injected_policy<> = blinky_sched::concurrency_policy{};
// ----------------------------------------------------------------------------
