
 /*
  localparam PRAM_BASE   = 32'h0000_0000;
  localparam SYSRAM_BASE = 32'h2000_0000;
  localparam WDOG_BASE   = 32'h4000_0000;
  localparam GPT_BASE    = 32'h4001_0000;
  localparam GPCFG_BASE  = 32'h4002_0000;
  localparam GPIO_BASE   = 32'h4003_0000;
  localparam UARTM_BASE  = 32'h4004_0000;
  localparam UARTS_BASE  = 32'h4005_0000;
  */


    
#include "stdio.h"
#include "stdint.h"    

#include "hwrot_header.h"
#include "hwrot_functions.h"
#include "core_cm0.h"


    
int main()
{   
 
  __enable_irq();
  NVIC_EnableIRQ(GPCFG39_IRQn);  
  NVIC_EnableIRQ(GPCFG40_IRQn);
  NVIC_EnableIRQ(GPCFG41_IRQn); 
   
 
  GPCFG->SPARE0            = 0x1;
  
  
  
  while (1) {
    GPCFG->SPARE1         |= 0x0000000F;
  };
  return 0;
  
}
