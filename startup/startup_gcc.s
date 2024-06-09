/* File: startup_ARMCM4.S
 * Purpose: startup file for Cortex-M4 devices. Should use with
 *   GCC for ARM Embedded Processors
 * Version: V2.0
 * Date: 16 August 2013
 *
/* Copyright (c) 2011 - 2013 ARM LIMITED

   All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:
   - Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
   - Neither the name of ARM nor the names of its contributors may be used
     to endorse or promote products derived from this software without
     specific prior written permission.
   *
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
   ---------------------------------------------------------------------------*/
	.syntax	unified
	.arch	armv7e-m

	.section .stack
	.align	3
#ifdef __STACK_SIZE
	.equ	Stack_Size, __STACK_SIZE
#else
	.equ	Stack_Size, 0xc00
#endif
	.globl	__StackTop
	.globl	__StackLimit
__StackLimit:
	.space	Stack_Size
	.size	__StackLimit, . - __StackLimit
__StackTop:
	.size	__StackTop, . - __StackTop

	.section .heap
	.align	3
#ifdef __HEAP_SIZE
	.equ	Heap_Size, __HEAP_SIZE
#else
	.equ	Heap_Size, 0
#endif
	.globl	__HeapBase
	.globl	__HeapLimit
__HeapBase:
	.if	Heap_Size
	.space	Heap_Size
	.endif
	.size	__HeapBase, . - __HeapBase
__HeapLimit:
	.size	__HeapLimit, . - __HeapLimit

	.section .isr_vector
	.align	2
	.globl	__isr_vector
__isr_vector:
	.long	__StackTop            /* Top of Stack */
	.long	Reset_Handler         /* Reset Handler */
	.long	NMI_Handler           /* NMI Handler */
	.long	HardFault_Handler     /* Hard Fault Handler */
	.long	MemManage_Handler     /* MPU Fault Handler */
	.long	BusFault_Handler      /* Bus Fault Handler */
	.long	UsageFault_Handler    /* Usage Fault Handler */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	SVC_Handler           /* SVCall Handler */
	.long	DebugMon_Handler      /* Debug Monitor Handler */
	.long	0                     /* Reserved */
	.long	PendSV_Handler        /* PendSV Handler */
	.long	SysTick_Handler       /* SysTick Handler */

	/* STM32-L41,L42,L43 */
	.long   WWDG_Handler             /* 0 - Window Watchdog */
	.long   PVD_PVM_Handler          /* 1 -  */
	.long   RTC_TAMP_STAMP_Handler   /* 2 - RTC Tamper or TimeStamp */
	.long   RTC_WKUP_Handler         /* 3 - RTC Wakeup timer */
	.long   FLASH_Handler            /* 4 - Flash global interrupt */
	.long   RCC_Handler              /* 5 - RCC global interrupt */
	.long   EXTI0_Handler            /* 6 - EXTI Line0 interrupt */
	.long   EXTI1_Handler            /* 7 - EXTI Line1 interrupt */
	.long   EXTI2_Handler            /* 8 - EXTI Line2 interrupt */
	.long   EXTI3_Handler            /* 9 - EXTI Line3 interrupt */
	.long   EXTI4_Handler            /* 10 - EXTI Line4 interrupt  */
	.long   DMA1_CH1_Handler         /* 11 -  */
	.long   DMA1_CH2_Handler         /* 12 -  */
	.long   DMA1_CH3_Handler         /* 13 -  */
	.long   DMA1_CH4_Handler         /* 14 -  */
	.long   DMA1_CH5_Handler         /* 15 -  */
	.long   DMA1_CH6_Handler         /* 16 -  */
	.long   DMA1_CH7_Handler         /* 17 -  */
	.long   ADC1_2_Handler           /* 18 -  */
	.long   CAN1_TX_Handler          /* 19 -  */
	.long   CAN1_RX0_Handler         /* 20 -  */
	.long   CAN1_RX1_Handler         /* 21 -  */
	.long   CAN1_SCE_Handler         /* 22 -  */
	.long   EXTI9_5_Handler          /* 23 -  */
	.long   TIM15_Handler            /* 24 -  */
	.long   TIM16_Handler            /* 25 -  */
	.long   TIM1_TRG_COM_Handler     /* 26 -  */
	.long   TIM1_CC_Handler          /* 27 -  */
	.long   TIM2_Handler             /* 28 -  */
	.long   TIM3_Handler             /* 29 -  */
	.long   0                        /* 30 - Reserved */
	.long   I2C1_EV_Handler          /* 31 -  */
	.long   I2C1_ER_Handler          /* 32 -  */
	.long   I2C2_EV_Handler          /* 33 -  */
	.long   I2C2_ER_Handler          /* 34 -  */
	.long   SPI1_Handler             /* 35 -  */
	.long   SPI2_Handler             /* 36 -  */
	.long   USART1_Handler           /* 36 -  */
	.long   USART2_Handler           /* 38 -  */
	.long   USART3_Handler           /* 39 -  */
	.long   EXTI15_10_Handler        /* 40 -  */
	.long   RTC_ALARM_Handler        /* 41 -  */
	.long   0                        /* 42 - Reserved */
	.long   0                        /* 43 - Reserved */
	.long   0                        /* 44 - Reserved */
	.long   0                        /* 45 - Reserved */
	.long   0                        /* 46 - Reserved */
	.long   0                        /* 47 - Reserved */
	.long   0                        /* 48 - Reserved */
	.long   SDMMC1_Handler           /* 49 -  */
	.long   0                        /* 50 - Reserved */
	.long   SPI3_Handler             /* 51 -  */
	.long   UART4_Handler            /* 52 -  */
	.long   0                        /* 53 - Reserved */
	.long   TIM6_DACUNDER_Handler    /* 54 -  */
	.long   TIM7_Handler             /* 55 -  */
	.long   DMA2_CH1_Handler         /* 56 -  */
	.long   DMA2_CH2_Handler         /* 57 -  */
	.long   DMA2_CH3_Handler         /* 58 -  */
	.long   DMA2_CH4_Handler         /* 59 -  */
	.long   DMA2_CH5_Handler         /* 60 -  */
	.long   DFSDM1_FLTO_Handler      /* 61 -  */
	.long   DFSDM1_FLT1_Handler      /* 62 -  */
	.long   0                        /* 63 - Reserved */
	.long   COMP_Handler             /* 64 -  */
	.long   LPTIM1_Handler           /* 65 -  */
	.long   LPTIM2_Handler           /* 66 -  */
	.long   USB_FS_Handler           /* 67 -  */
	.long   DMA2_CH6_Handler         /* 68 -  */
	.long   DMA2_CH7_Handler         /* 69 -  */
	.long   LPUART1_Handler          /* 70 -  */
	.long   QUADSPI_Handler          /* 71 -  */
	.long   I2C3_EV_Handler          /* 72 -  */
	.long   I2C3_ER_Handler          /* 73 -  */
	.long   SAI1_Handler             /* 74 -  */
	.long   0                        /* 75 - Reserved */
	.long   SWPMI1_Handler           /* 76 -  */
	.long   TSC_Handler              /* 77 -  */
	.long   LCD_Handler              /* 78 -  */
	.long   AES_Handler              /* 79 -  */
	.long   RNG_Handler              /* 80 -  */
	.long   FPU_Handler              /* 81 -  */
	.long   CRS_Handler              /* 82 -  */
	.long   I2C4_EV_Handler          /* 83 -  */
	.long   I2C4_ER_Handler          /* 84 -  */
	
	.size	__isr_vector, . - __isr_vector

	.text
	.thumb
	.thumb_func
	.align	2
	.globl	Reset_Handler
	.type	Reset_Handler, %function
Reset_Handler:
/*  Firstly it copies data from read only memory to RAM. There are two schemes
 *  to copy. One can copy more than one sections. Another can only copy
 *  one section.  The former scheme needs more instructions and read-only
 *  data to implement than the latter.
 *  Macro __STARTUP_COPY_MULTIPLE is used to choose between two schemes.  */

#ifdef __STARTUP_COPY_MULTIPLE
/*  Multiple sections scheme.
 *
 *  Between symbol address __copy_table_start__ and __copy_table_end__,
 *  there are array of triplets, each of which specify:
 *    offset 0: LMA of start of a section to copy from
 *    offset 4: VMA of start of a section to copy to
 *    offset 8: size of the section to copy. Must be multiply of 4
 *
 *  All addresses must be aligned to 4 bytes boundary.
 */
	ldr	r4, =__copy_table_start__
	ldr	r5, =__copy_table_end__

.L_loop0:
	cmp	r4, r5
	bge	.L_loop0_done
	ldr	r1, [r4]
	ldr	r2, [r4, #4]
	ldr	r3, [r4, #8]

.L_loop0_0:
	subs	r3, #4
	ittt	ge
	ldrge	r0, [r1, r3]
	strge	r0, [r2, r3]
	bge	.L_loop0_0

	adds	r4, #12
	b	.L_loop0

.L_loop0_done:
#else
/*  Single section scheme.
 *
 *  The ranges of copy from/to are specified by following symbols
 *    __etext: LMA of start of the section to copy from. Usually end of text
 *    __data_start__: VMA of start of the section to copy to
 *    __data_end__: VMA of end of the section to copy to
 *
 *  All addresses must be aligned to 4 bytes boundary.
 */
	ldr	r1, =__etext
	ldr	r2, =__data_start__
	ldr	r3, =__data_end__

.L_loop1:
	cmp	r2, r3
	ittt	lt
	ldrlt	r0, [r1], #4
	strlt	r0, [r2], #4
	blt	.L_loop1
#endif /*__STARTUP_COPY_MULTIPLE */

/*  This part of work usually is done in C library startup code. Otherwise,
 *  define this macro to enable it in this startup.
 *
 *  There are two schemes too. One can clear multiple BSS sections. Another
 *  can only clear one section. The former is more size expensive than the
 *  latter.
 *
 *  Define macro __STARTUP_CLEAR_BSS_MULTIPLE to choose the former.
 *  Otherwise efine macro __STARTUP_CLEAR_BSS to choose the later.
 */
#ifdef __STARTUP_CLEAR_BSS_MULTIPLE
/*  Multiple sections scheme.
 *
 *  Between symbol address __copy_table_start__ and __copy_table_end__,
 *  there are array of tuples specifying:
 *    offset 0: Start of a BSS section
 *    offset 4: Size of this BSS section. Must be multiply of 4
 */
	ldr	r3, =__zero_table_start__
	ldr	r4, =__zero_table_end__

.L_loop2:
	cmp	r3, r4
	bge	.L_loop2_done
	ldr	r1, [r3]
	ldr	r2, [r3, #4]
	movs	r0, 0

.L_loop2_0:
	subs	r2, #4
	itt	ge
	strge	r0, [r1, r2]
	bge	.L_loop2_0

	adds	r3, #8
	b	.L_loop2
.L_loop2_done:
#elif defined (__STARTUP_CLEAR_BSS)
/*  Single BSS section scheme.
 *
 *  The BSS section is specified by following symbols
 *    __bss_start__: start of the BSS section.
 *    __bss_end__: end of the BSS section.
 *
 *  Both addresses must be aligned to 4 bytes boundary.
 */
	ldr	r1, =__bss_start__
	ldr	r2, =__bss_end__

	movs	r0, 0
.L_loop3:
	cmp	r1, r2
	itt	lt
	strlt	r0, [r1], #4
	blt	.L_loop3
#endif /* __STARTUP_CLEAR_BSS_MULTIPLE || __STARTUP_CLEAR_BSS */

#ifndef __NO_SYSTEM_INIT
	bl	SystemInit
#endif

#ifndef __START
#define __START _start
#endif
/*	bl	__START */
	bl	_mainCRTStartup

	.pool
	.size	Reset_Handler, . - Reset_Handler

	.align	1
	.thumb_func
	.weak	Default_Handler
	.type	Default_Handler, %function
Default_Handler:
	b	.
	.size	Default_Handler, . - Default_Handler

/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
	.macro	def_irq_handler	handler_name
	.weak	\handler_name
	.set	\handler_name, Default_Handler
	.endm

	def_irq_handler	NMI_Handler
	def_irq_handler	HardFault_Handler
	def_irq_handler	MemManage_Handler
	def_irq_handler	BusFault_Handler
	def_irq_handler	UsageFault_Handler
	def_irq_handler	SVC_Handler
	def_irq_handler	DebugMon_Handler
	def_irq_handler	PendSV_Handler
	def_irq_handler	SysTick_Handler
	def_irq_handler	DEF_IRQHandler

	def_irq_handler WWDG_Handler
	def_irq_handler PVD_PVM_Handler
	def_irq_handler RTC_TAMP_STAMP_Handler
	def_irq_handler RTC_WKUP_Handler
	def_irq_handler FLASH_Handler
	def_irq_handler RCC_Handler
	def_irq_handler EXTI0_Handler
	def_irq_handler EXTI1_Handler
	def_irq_handler EXTI2_Handler
	def_irq_handler EXTI3_Handler
	def_irq_handler EXTI4_Handler
	def_irq_handler DMA1_CH1_Handler
	def_irq_handler DMA1_CH2_Handler
	def_irq_handler DMA1_CH3_Handler
	def_irq_handler DMA1_CH4_Handler
	def_irq_handler DMA1_CH5_Handler
	def_irq_handler DMA1_CH6_Handler
	def_irq_handler DMA1_CH7_Handler
	def_irq_handler ADC1_2_Handler
	def_irq_handler CAN1_TX_Handler
	def_irq_handler CAN1_RX0_Handler
	def_irq_handler CAN1_RX1_Handler
	def_irq_handler CAN1_SCE_Handler
	def_irq_handler EXTI9_5_Handler
	def_irq_handler TIM15_Handler
	def_irq_handler TIM16_Handler
	def_irq_handler TIM1_TRG_COM_Handler
	def_irq_handler TIM1_CC_Handler
	def_irq_handler TIM2_Handler
	def_irq_handler TIM3_Handler
	def_irq_handler I2C1_EV_Handler
	def_irq_handler I2C1_ER_Handler
	def_irq_handler I2C2_EV_Handler
	def_irq_handler I2C2_ER_Handler
	def_irq_handler SPI1_Handler
	def_irq_handler SPI2_Handler
	def_irq_handler USART1_Handler
	def_irq_handler USART2_Handler
	def_irq_handler USART3_Handler
	def_irq_handler EXTI15_10_Handler
	def_irq_handler RTC_ALARM_Handler
	def_irq_handler SDMMC1_Handler
	def_irq_handler SPI3_Handler
	def_irq_handler UART4_Handler
	def_irq_handler TIM6_DACUNDER_Handler
	def_irq_handler TIM7_Handler
	def_irq_handler DMA2_CH1_Handler
	def_irq_handler DMA2_CH2_Handler
	def_irq_handler DMA2_CH3_Handler
	def_irq_handler DMA2_CH4_Handler
	def_irq_handler DMA2_CH5_Handler
	def_irq_handler DFSDM1_FLTO_Handler
	def_irq_handler DFSDM1_FLT1_Handler
	def_irq_handler COMP_Handler
	def_irq_handler LPTIM1_Handler
	def_irq_handler LPTIM2_Handler
	def_irq_handler USB_FS_Handler
	def_irq_handler DMA2_CH6_Handler
	def_irq_handler DMA2_CH7_Handler
	def_irq_handler LPUART1_Handler
	def_irq_handler QUADSPI_Handler
	def_irq_handler I2C3_EV_Handler
	def_irq_handler I2C3_ER_Handler
	def_irq_handler SAI1_Handler
	def_irq_handler SWPMI1_Handler
	def_irq_handler TSC_Handler
	def_irq_handler LCD_Handler
	def_irq_handler AES_Handler
	def_irq_handler RNG_Handler
	def_irq_handler FPU_Handler
	def_irq_handler CRS_Handler
	def_irq_handler I2C4_EV_Handler
	def_irq_handler I2C4_ER_Handler
	
	.end
