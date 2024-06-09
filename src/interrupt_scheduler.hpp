//
// Copyright (c) 2024 Michael Caisse
//
// Based on intel/cpp-baremetal-senders-and-receivers priority_scheduler
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
#pragma once

#include <async/concepts.hpp>
#include <async/env.hpp>
#include <async/tags.hpp>
#include <async/schedulers/task.hpp>
#include <async/stop_token.hpp>
#include <async/type_traits.hpp>

#include <stdx/concepts.hpp>

#include <concepts>
#include <type_traits>
#include <utility>


// TODO: move into differencec namespace
namespace async {
  
namespace interrupt_mgr {

template <typename InterruptTag>
struct interrupt_task_manager {
  using task_t = async::task_base;

private:
  struct mutex;
  static inline constinit task_t* interrupt_task = nullptr;

public:
  // constexpr static auto create_task = async::create_task<task_t>;

  static inline auto set_task(task_t &t) -> bool {
    return conc::call_in_critical_section<mutex>([&]() -> bool {
      auto const now_pending = not std::exchange(t.pending, true);
      if (now_pending) {
	interrupt_task = std::addressof(t);
      }
      return now_pending;
    });
  }

  constexpr static auto valid_interrupt() -> bool {
    return true;
  }

  static inline auto service_task() -> void
    requires(valid_interrupt())
  {
    auto task = std::exchange(interrupt_task, nullptr);

    if (task and std::exchange(task->pending, false)) {
      task->run();
    }
  }
};


template <typename InterruptTag, typename Rcvr>
struct op_state final : async::task_base {
    template <stdx::same_as_unqualified<Rcvr> R>
    constexpr explicit(true) op_state(R &&r) : rcvr{std::forward<R>(r)} {}

    auto run() -> void final {
        if (not check_stopped()) {
            set_value(std::move(rcvr));
        }
    }

    [[no_unique_address]] Rcvr rcvr;

  private:
    auto check_stopped() -> bool {
        if constexpr (not unstoppable_token<stop_token_of_t<env_of_t<Rcvr>>>) {
            if (get_stop_token(get_env(rcvr)).stop_requested()) {
                set_stopped(std::move(rcvr));
                return true;
            }
        }
        return false;
    }

    template <stdx::same_as_unqualified<op_state> O>
    friend constexpr auto tag_invoke(start_t, O &&o) -> void {
        if (not std::forward<O>(o).check_stopped()) {
	  interrupt_task_manager<InterruptTag>::set_task(o);
        }
    }
};
} // namespace interrupt_mgr

template <typename InterruptTag>
class interrupt_scheduler {
    class env {
        [[nodiscard]] friend constexpr auto
        tag_invoke(get_completion_scheduler_t<set_value_t>, env) noexcept
            -> interrupt_scheduler {
            return {};
        }
    };

    struct sender {
        using is_sender = void;

      private:
        template <stdx::same_as_unqualified<sender> S, receiver_from<sender> R>
        [[nodiscard]] friend constexpr auto tag_invoke(connect_t, S &&, R &&r) {
            return interrupt_mgr::op_state<InterruptTag, std::remove_cvref_t<R>>{
                std::forward<R>(r)};
        }

        [[nodiscard]] friend constexpr auto tag_invoke(get_env_t,
                                                       sender) noexcept -> env {
            return {};
        }

        template <typename Env>
        [[nodiscard]] friend constexpr auto
        tag_invoke(get_completion_signatures_t, sender, Env const &) noexcept
            -> completion_signatures<set_value_t(), set_stopped_t()> {
            return {};
        }

        template <typename Env>
            requires unstoppable_token<stop_token_of_t<Env>>
        [[nodiscard]] friend constexpr auto
        tag_invoke(get_completion_signatures_t, sender, Env const &) noexcept
            -> completion_signatures<set_value_t()> {
            return {};
        }
    };

    [[nodiscard]] friend constexpr auto operator==(interrupt_scheduler,
                                                   interrupt_scheduler)
        -> bool = default;

  public:
    [[nodiscard]] constexpr static auto schedule() -> sender {
      static_assert(interrupt_mgr::interrupt_task_manager<InterruptTag>::valid_interrupt(),
                      "interrupt_scheduler has invalid interrupt level");
        return {};
    }
};
} // namespace async

