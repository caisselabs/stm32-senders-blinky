//
// Copyright (c) 2024 Michael Caisse
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
#include "blinky_concurrency.hpp"

#include <cstdint>


void init_clock() {

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


// LED at PB3

//            register           offset
constexpr int GPIOx_MODER      = 0x00;
constexpr int GPIOx_OTYPER     = 0x04;
constexpr int GPIOx_OSPEEDR    = 0x08;
constexpr int GPIOx_PUPDR      = 0x0c;
constexpr int GPIOx_ODR        = 0x14;

auto GPIOB_BASE    = (volatile std::uint8_t * const)(0x4800'0400);
auto GPIOB_MODER   = (volatile std::uint32_t * const)(GPIOB_BASE + GPIOx_MODER);
auto GPIOB_OTYPER  = (volatile std::uint32_t * const)(GPIOB_BASE + GPIOx_OTYPER);
auto GPIOB_OSPEEDR = (volatile std::uint32_t * const)(GPIOB_BASE + GPIOx_OSPEEDR);
auto GPIOB_PUPDR   = (volatile std::uint32_t * const)(GPIOB_BASE + GPIOx_PUPDR);
auto GPIOB_ODR     = (volatile std::uint32_t * const)(GPIOB_BASE + GPIOx_ODR);



// setting for PB3 as output                       14  12   10 9 8  7 6 5 4  3 2 1 0
constexpr std::uint32_t GPIOB3_MODER_VALUE   = 0b00000000'00000000'00000000'01000000;
constexpr std::uint32_t GPIOB3_OSPEEDR_VALUE = 0b00000000'00000000'00000000'00000000;
constexpr std::uint32_t GPIOB3_PUPDR_VALUE   = 0b00000000'00000000'00000000'00000000;
//                                                                              3210
constexpr std::uint32_t GPIOB3_OTYPER_VALUE  = 0b00000000'00000000'00000000'00000000;

// PB3 2bit value mask - items taking two bits     14  12   10 9 8  7 6 5 4  3 2 1 0
constexpr std::uint32_t GPIOB3_2BIT_MASK     = 0b00000000'00000000'00000000'11000000;
// PB3 1bit value mask - items taking one bit                                   3210
constexpr std::uint32_t GPIOB3_1BIT_MASK     = 0b00000000'00000000'00000000'00001000;

void initialize_board() {
  // power on and clock the GPIOA and GPIOB port
  rmw(RCC_AHB2, RCC_AHB2_GPIOABEN, RCC_AHB2_GPIOABEN);
  // power on and clock TIM2
  rmw(RCC_APB1, RCC_APB1_TIM2EN, RCC_APB1_TIM2EN);
  
  // setup the GPIO for PB3 (LED) to push-pull output with no PU/PD
  rmw(GPIOB_MODER  , GPIOB3_2BIT_MASK, GPIOB3_MODER_VALUE);
  rmw(GPIOB_OTYPER , GPIOB3_1BIT_MASK, GPIOB3_OTYPER_VALUE);
  rmw(GPIOB_OSPEEDR, GPIOB3_2BIT_MASK, GPIOB3_OSPEEDR_VALUE);
  rmw(GPIOB_PUPDR  , GPIOB3_2BIT_MASK, GPIOB3_PUPDR_VALUE);
}


void set_led(bool v) {
  rmw(GPIOB_ODR, GPIOB3_1BIT_MASK, v ? 0x0000'0008 : 0x0);
}
