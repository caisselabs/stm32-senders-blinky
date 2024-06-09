//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
#include "blinky_concurrency.hpp"
#include <caisselabs/stm32/stm32l432.hpp>

#include <groov/config.hpp>
#include <groov/path.hpp>
#include <groov/resolve.hpp>
#include <groov/write.hpp>
#include <groov/write_spec.hpp>
#include <groov/read.hpp>
#include <groov/value_path.hpp>

#include <async/just.hpp>
#include <async/then.hpp>
#include <async/sequence.hpp>
#include <async/sync_wait.hpp>
#include <async/repeat.hpp>

#include <cstdint>


using namespace groov::literals;
namespace stm32 = caisselabs::stm32;


void init_clock() {
  // TODO: refactor when the repeat_until gets the value channel
  bool hsirdy = false;
  auto read_hsirdy =
      groov::read(stm32::rcc / "cr.HSIRDY"_f)
    | async::then([&hsirdy](auto v){hsirdy = v;})
    ;
    
  groov::write(stm32::rcc("cr.HSION"_f = true))
    | async::seq(read_hsirdy)
    | async::repeat_until([&hsirdy](){return hsirdy;})
    | async::sync_wait();

  
  // TODO: refactor when the repeat_until gets the value channel
  stm32::rccx::sw_t sw_field = {};
  auto read_rcc_cfgr_sw =
      groov::read(stm32::rcc / "cfgr.SW"_f)
    | async::then([&sw_field](auto v){sw_field = v;})
    ;
    
  groov::write(stm32::rcc("cfgr.SW"_f = stm32::rccx::sw_t::hsi16))
    | async::seq(read_rcc_cfgr_sw)
    | async::repeat_until([&sw_field](){return sw_field == stm32::rccx::sw_t::hsi16;})
    | async::sync_wait();

  
  groov::write(stm32::rcc("apb2enr.SYSCFGEN"_f = true)) | async::sync_wait();
}


extern "C" {
// called by startup code prior to main  
void SystemInit()
{
  init_clock();  // get our clocks setup before doing other things
}
}



// Reset and clock control
// Need to supply clocks to the peripherials we want to use
//
//                      register          offset
constexpr std::uint32_t RCC_AHB2_OFFSET = 0x4c;
constexpr std::uint32_t RCC_APB1_OFFSET = 0x58;

auto RCC_BASE = (volatile std::uint8_t * const)(0x4002'1000);
auto RCC_AHB2 = (volatile std::uint32_t * const)(RCC_BASE + RCC_AHB2_OFFSET);
auto RCC_APB1 = (volatile std::uint32_t * const)(RCC_BASE + RCC_APB1_OFFSET);

constexpr std::uint32_t RCC_AHB2_GPIOABEN = 0x0000'0003;
constexpr std::uint32_t RCC_APB1_TIM2EN  = 0x0000'0001;

inline void rmw(volatile std::uint32_t * const address, std::uint32_t mask, std::uint32_t value) {
  *address = (*address & ~mask) | (value & mask);
}

void initialize_board() {
  // power on and clock the GPIOA and GPIOB port
  rmw(RCC_AHB2, RCC_AHB2_GPIOABEN, RCC_AHB2_GPIOABEN);
  // power on and clock TIM2
  rmw(RCC_APB1, RCC_APB1_TIM2EN, RCC_APB1_TIM2EN);
  
  
  constexpr auto gpiob_config =
    stm32::gpiob(
      // PB3 setup
      "moder.3"_f   = stm32::gpio::mode_t::output,
      "otyper.3"_f  = stm32::gpio::outtype_t::push_pull,
      "ospeedr.3"_f = stm32::gpio::speed_t::low_speed,
      "pupdr.3"_f   = stm32::gpio::pupd_t::none
    );
  
  async::just(gpiob_config) | groov::write | async::sync_wait();
}

