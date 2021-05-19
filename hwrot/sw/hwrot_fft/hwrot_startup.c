
#include "hwrot_header.h"  
#include "core_cm0.h"
#include "hwrot_functions.h"

//extern cplx bufg;
extern int CSTACK$$Limit;
void   __iar_program_start(void);

//void Hardfault_Handler(void);
void NMI_Handler(void);
void HardFault_Handler (void); 
void SVC_Handler(void);
void PendSV_Handler(void);
void SysTick_Handler(void);

void GPIOIRQHandler(void);
void TIMAIRQHandler(void);
void TIMBIRQHandler(void);
void TIMCIRQHandler(void);
void UARTTXIRQ_Handler(void);
void UARTRXIRQ_Handler(void);
void GPCFG39IRQ_Handler(void);
void GPCFG40IRQ_Handler(void);
void GPCFG41IRQ_Handler(void);
void GPCFG39IRQ3_Handler(void);
void GPCFG39IRQ4_Handler(void);
void GPCFG39IRQ5_Handler(void);
void GPCFG39IRQ6_Handler(void);
void GPCFG39IRQ7_Handler(void);
void GPCFG39IRQ8_Handler(void);
void GPCFG39IRQ9_Handler(void);


int const __vector_table[] @ ".intvec" = {
  (int)&CSTACK$$Limit,                    //0x00
  (int)&__iar_program_start,              //0x04
  (int)&NMI_Handler,                      //0x08
  (int)&HardFault_Handler,                //0x0C
  0,
  0,                                      
  0,       
  0,       
  0,       
  0,       
  0,       
  (int)&SVC_Handler,                      //0x2C
  0,
  0,       
  (int)&PendSV_Handler,                   //0x38
  (int)&SysTick_Handler,                  //0x3C
  (int)&GPIOIRQHandler,                   //0x40
  (int)&TIMAIRQHandler,                   //0x44
  (int)&TIMBIRQHandler,                   //0x48
  (int)&TIMCIRQHandler,                   //0x4C
  (int)&UARTTXIRQ_Handler,                //0x50
  (int)&UARTRXIRQ_Handler,                //0x54
  (int)&GPCFG39IRQ_Handler,              //0x58
  (int)&GPCFG40IRQ_Handler,              //0x5C
  (int)&GPCFG41IRQ_Handler,              //0x60
  (int)&GPCFG39IRQ3_Handler,              //0x64
  (int)&GPCFG39IRQ4_Handler,              //0x68
  (int)&GPCFG39IRQ5_Handler,              //0x6C
  (int)&GPCFG39IRQ6_Handler,              //0x70
  (int)&GPCFG39IRQ7_Handler,              //0x74
  (int)&GPCFG39IRQ8_Handler,              //0x78
  (int)&GPCFG39IRQ9_Handler               //0x7C */
  };    

void HardFault_Handler (void) {
  while(1) {
  }
}

void NMI_Handler (void) {
  GPCFG->WDTEN |=  WDRST;
  GPCFG->WDTEN &= ~WDRST;
}

void SVC_Handler (void) {
  while(1) {
  }
}

void PendSV_Handler (void) {
  while(1) {
  }
}

void SysTick_Handler(void){
}

void GPIOIRQHandler(void) {
  while(1) {
  }
}

#ifdef ASIC
  #define COUNT_DELAY 10000000
#else
  #define COUNT_DELAY 8
#endif

void TIMAIRQHandler(void) {
   GPCFG->SPARE0 = 0x1;   
  }

void TIMBIRQHandler(void) {
  GPCFG->SPARE0 = 0x1;
}

void TIMCIRQHandler(void) {
    NVIC_DisableIRQ(GPTC_IRQn);
    GPCFG->GPTEN |= GPTIMCRST;
    delay(COUNT_DELAY/2);  
    NVIC_EnableIRQ(GPTA_IRQn);
}

void UARTTXIRQ_Handler(void) {
  GPCFG->UARTSTXDATA = GPCFG->UARTSRXDATA;
}

void UARTRXIRQ_Handler(void) {
  GPCFG->UARTSTXDATA = GPCFG->UARTSRXDATA;
}

void GPCFG39IRQ_Handler(void) {
  NVIC_DisableIRQ(GPCFG39_IRQn); 
  SYSMEM->SYSRAM[2000]     = 0X8;
  SYSMEM->SYSRAM[2001]     = 0X9;
  SYSMEM->SYSRAM[2002]     = 0XA;
  SYSMEM->SYSRAM[2003]     = 0XB;
  GPCFG->PWMVAL0           = 0x2;
  SYSMEM->SYSRAM[4000]     = 0XC;
  SYSMEM->SYSRAM[4001]     = 0XD;
  SYSMEM->SYSRAM[4002]     = 0XE;
  SYSMEM->SYSRAM[4003]     = 0XF;
  GPCFG->PWMVAL1           = 0x4;
  GPCFG->SPARE0            = 0x0;
  NVIC_EnableIRQ(GPCFG39_IRQn); 
}

void GPCFG40IRQ_Handler(void) {
  NVIC_DisableIRQ(GPCFG40_IRQn);
  cplx buf[] = {SYSMEM->SYSRAM[2000], SYSMEM->SYSRAM[2001], SYSMEM->SYSRAM[2002], SYSMEM->SYSRAM[2003]};
  fft(buf,4);
  GPCFG->PWMVAL0 = 0x0;
  NVIC_EnableIRQ(GPCFG40_IRQn);
}

void GPCFG41IRQ_Handler(void) {
  NVIC_DisableIRQ(GPCFG41_IRQn);
  cplx buf[] = {SYSMEM->SYSRAM[4000], SYSMEM->SYSRAM[4001], SYSMEM->SYSRAM[4002], SYSMEM->SYSRAM[4003]};
  fft(buf,4);
  GPCFG->PWMVAL1 = 0x0;
  NVIC_EnableIRQ(GPCFG41_IRQn);
}

void GPCFG39IRQ3_Handler(void) {
  GPCFG->SPARE0 = 0x4;
}

void GPCFG39IRQ4_Handler(void) {
  GPCFG->SPARE0 = 0x5;
}

void GPCFG39IRQ5_Handler(void) {
  GPCFG->SPARE0 = 0x6;
}

void GPCFG39IRQ6_Handler(void) {
  GPCFG->SPARE0 = 0x7;
}

void GPCFG39IRQ7_Handler(void) {
  GPCFG->SPARE0 = 0x8;
}

void GPCFG39IRQ8_Handler(void) {
  GPCFG->SPARE0 = 0x9;
}

void GPCFG39IRQ9_Handler(void) {
  GPCFG->SPARE0 = 0x10;
}
