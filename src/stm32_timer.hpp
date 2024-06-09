//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
// This file contains methods for handling tim2 in the STM32 which will be
// used for our timer_scheduler.
//
#pragma once

#include <caisselabs/stm32/stm32l432.hpp>

#include <groov/config.hpp>
#include <groov/path.hpp>
#include <groov/resolve.hpp>
#include <groov/write.hpp>
#include <groov/write_spec.hpp>
#include <groov/read.hpp>
#include <groov/value_path.hpp>
#include <groov/mmio_bus.hpp>
#include <async/just.hpp>
#include <async/sync_wait.hpp>

#include <cstdint>

namespace stm32 = caisselabs::stm32;

using namespace groov::literals;

inline void initialize_timer() {

  auto init_tim2 =
    stm32::tim2 (
      "cr1.UIFREMAP"_f = false,
      "cr1.CKD"_f = 0x00,
      "cr1.ARPE"_f = true,
      "cr1.CMS"_f = 0x00,
      "cr1.DIR"_f = false,
      "cr1.OPM"_f = false,
      "cr1.URS"_f = false,
      "cr1.UDIS"_f = false,
      "cr1.CEN"_f = false,

      "dier.TIE"_f = true,
      "dier.CC1IE"_f = true,
      "dier.UIE"_f = false,

      "ccmr1_out.OC1M"_f = stm32::ocm_t::active_on_match,
      "ccmr1_out.OC1PE"_f = false,
      "ccmr1_out.OC1FE"_f = false,
      "ccmr1_out.OC1S"_f = stm32::ccsel_t::output,

      "ccer.CC1NP"_f = false,
      "ccer.CC1P"_f = false,
      "ccer.CC1E"_f = true
    );

  async::just(init_tim2) | groov::write | async::sync_wait();
}

inline void enable_timer() {
  async::just(stm32::tim2("cr1.CEN"_f = true)) | groov::write | async::sync_wait();
}  

inline void disable_timer() {
  async::just(stm32::tim2("cr1.CEN"_f = false)) | groov::write | async::sync_wait();
}

inline void reset_timer() {
  async::just(stm32::tim2("cnt.CNT"_f = 0x00)) | groov::write | async::sync_wait();
}

inline std::uint32_t get_timer_value() {
  std::uint32_t count{};
  
  async::just(stm32::tim2 / "cnt"_r)
    | groov::read
    | async::then([&count](auto v){ count = v; })
    | async::sync_wait();

  return count;
}

inline void start_timer(std::uint32_t target) {
  async::just(stm32::tim2("ccr1.CCR1"_f = target)) | groov::write | async::sync_wait();

  // get things counting again
  enable_timer();
}

