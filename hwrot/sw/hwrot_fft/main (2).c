
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


#include "stdint.h"
#include "ccs00xx_functions.h"
#include "ccs00xx_header.h"    
#include "core_cm0.h"

 

    
 
int main()
{   
 //
  __enable_irq();
  NVIC_EnableIRQ(GPTA_IRQn);  
  NVIC_EnableIRQ(UARTSTX_IRQn);  
  NVIC_EnableIRQ(UARTSRX_IRQn);
  
  
  //NVIC->ISER[0] = 0xFFFF;
    
  
    
  //Enable All the seven segment display IOs for alternate function
  seven_seg_disp_init ();


//Configure WDT  
  GPCFG->WDTCFG      = 0x800;
  GPCFG->WDTNMICFG   = 0x400;
  GPCFG->WDTEN      |= WDEN;

//Configure GPCFG  
  GPCFG->PWMVAL0   = 0xCCCCCCCC;
  
//Configure GPT
#ifdef ASIC  
  GPCFG->GPTACFG    = 0x170FFFF;
  GPCFG->GPTEN     |= GPTIMAEN;
  
  GPCFG->GPTBCFG    = 0x170FFFF << 1;
  GPCFG->GPTEN     |= GPTIMBEN;
  
  GPCFG->GPTCCFG    = 0x170FFFF << 2;
  GPCFG->GPTEN     |= GPTIMCEN;
#else
  GPCFG->GPTACFG    = 0x0000063;
  GPCFG->GPTEN     |= GPTIMAEN;
  
  GPCFG->GPTBCFG    = 0x0000063 << 1;
  GPCFG->GPTEN     |= GPTIMBEN;
  
  GPCFG->GPTCCFG    = 0x0000063 << 2;
  GPCFG->GPTEN     |= GPTIMCEN;
#endif  
  
  
  while (1) {
  };
  return 0;
}
