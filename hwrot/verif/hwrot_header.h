#include "core_cm0.h"


#define SYSRAM_BASE = 32'h20000000
#define GPCFG_BASE  = 32'h40020000
#define GPIO_BASE   = 32'h40030000


#define GPCFG_UARTMTX_PAD_CTL  (*(unit32_t *) (GPCFG_BASE + 16'h0000))
#define GPCFG_UARTMRX_PAD_CTL  (*(unit32_t *) (GPCFG_BASE + 16'h0004))
#define GPCFG_UARTSTX_PAD_CTL  (*(unit32_t *) (GPCFG_BASE + 16'h0008))
#define GPCFG_UARTSRX_PAD_CTL  (*(unit32_t *) (GPCFG_BASE + 16'h000C))
#define GPCFG_GPIO0_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0010))
#define GPCFG_GPIO1_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0014))
#define GPCFG_GPIO2_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0018))
#define GPCFG_GPIO3_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h001C))
#define GPCFG_PAD11_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0020))
#define GPCFG_PAD12_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0024))
#define GPCFG_PAD13_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0028))
#define GPCFG_PAD14_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h002c))
#define GPCFG_PAD15_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0030))
#define GPCFG_PAD16_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0034))
#define GPCFG_PAD17_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0038))
#define GPCFG_PAD18_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h003c))
#define GPCFG_PAD19_PAD_CTL    (*(unit32_t *) (GPCFG_BASE + 16'h0040))
#define GPCFG_UARTM_BAUD_CTL   (*(unit32_t *) (GPCFG_BASE + 16'h0044))
#define GPCFG_UARTM_CTL        (*(unit32_t *) (GPCFG_BASE + 16'h0048))
#define GPCFG_SP_ADDR          (*(unit32_t *) (GPCFG_BASE + 16'h004c))
#define GPCFG_RESET_ADDR       (*(unit32_t *) (GPCFG_BASE + 16'h0050))
#define GPCFG_NMI_ADDR         (*(unit32_t *) (GPCFG_BASE + 16'h0054))
#define GPCFG_FAULT_ADDR       (*(unit32_t *) (GPCFG_BASE + 16'h0058))
#define GPCFG_IRQ0_ADDR        (*(unit32_t *) (GPCFG_BASE + 16'h005c))
#define GPCFG_IRQ1_ADDR        (*(unit32_t *) (GPCFG_BASE + 16'h0060))
#define GPCFG_IRQ2_ADDR        (*(unit32_t *) (GPCFG_BASE + 16'h0064))
#define GPCFG_IRQ3_ADDR        (*(unit32_t *) (GPCFG_BASE + 16'h0068))
#define GPCFG_GPT_EN           (*(unit32_t *) (GPCFG_BASE + 16'h006c))
#define GPCFG_GPTA_CFG         (*(unit32_t *) (GPCFG_BASE + 16'h0070))
#define GPCFG_GPTB_CFG         (*(unit32_t *) (GPCFG_BASE + 16'h0074))
#define GPCFG_GPTC_CFG         (*(unit32_t *) (GPCFG_BASE + 16'h0078))
#define GPCFG_WDT_EN           (*(unit32_t *) (GPCFG_BASE + 16'h007c))
#define GPCFG_WDT_CFG          (*(unit32_t *) (GPCFG_BASE + 16'h0080))
#define GPCFG_WDT_NMI_CFG      (*(unit32_t *) (GPCFG_BASE + 16'h0084))
#define GPCFG_UARTS_BAUD_CTL   (*(unit32_t *) (GPCFG_BASE + 16'h0088))
#define GPCFG_UARTS_CTL        (*(unit32_t *) (GPCFG_BASE + 16'h008c))
#define GPCFG_UARTS_TXDATA     (*(unit32_t *) (GPCFG_BASE + 16'h0090))
#define GPCFG_UARTS_RXDATA     (*(unit32_t *) (GPCFG_BASE + 16'h0094))
#define GPCFG_UARTS_TXSEND     (*(unit32_t *) (GPCFG_BASE + 16'h0098))
#define GPCFG_SPARE0           (*(unit32_t *) (GPCFG_BASE + 16'h009c))
#define GPCFG_SPARE1           (*(unit32_t *) (GPCFG_BASE + 16'h00a0))
#define GPCFG_SPARE2           (*(unit32_t *) (GPCFG_BASE + 16'h00a4))
#define GPCFG_SPARE3           (*(unit32_t *) (GPCFG_BASE + 16'h00a8))
#define GPCFG_KEY_REG0         (*(unit32_t *) (GPCFG_BASE + 16'h00ac))
#define GPCFG_KEY_REG1         (*(unit32_t *) (GPCFG_BASE + 16'h00b0))
#define GPCFG_KEY_REG2         (*(unit32_t *) (GPCFG_BASE + 16'h00b4))
#define GPCFG_KEY_REG3         (*(unit32_t *) (GPCFG_BASE + 16'h00b8))
#define GPCFG_KEY_REG4         (*(unit32_t *) (GPCFG_BASE + 16'h00bc))
#define GPCFG_KEY_REG5         (*(unit32_t *) (GPCFG_BASE + 16'h00c0))
#define GPCFG_KEY_REG6         (*(unit32_t *) (GPCFG_BASE + 16'h00c4))
#define GPCFG_KEY_REG7         (*(unit32_t *) (GPCFG_BASE + 16'h00c8))
#define GPCFG_SIGNATURE        (*(unit32_t *) (GPCFG_BASE + 16'h00cc))

#define GPIO_GPIO0_CTL         (*(unit32_t *) (GPIO_BASE  + 16'h0000))
#define GPIO_GPIO0_OUT         (*(unit32_t *) (GPIO_BASE  + 16'h0004))
#define GPIO_GPIO0_IN          (*(unit32_t *) (GPIO_BASE  + 16'h0008))
#define GPIO_GPIO1_CTL         (*(unit32_t *) (GPIO_BASE  + 16'h000c))
#define GPIO_GPIO1_OUT         (*(unit32_t *) (GPIO_BASE  + 16'h0010))
#define GPIO_GPIO1_IN          (*(unit32_t *) (GPIO_BASE  + 16'h0014))
#define GPIO_GPIO2_CTL         (*(unit32_t *) (GPIO_BASE  + 16'h0018))
#define GPIO_GPIO2_OUT         (*(unit32_t *) (GPIO_BASE  + 16'h001c))
#define GPIO_GPIO2_IN          (*(unit32_t *) (GPIO_BASE  + 16'h0020))
#define GPIO_GPIO3_CTL         (*(unit32_t *) (GPIO_BASE  + 16'h0024))
#define GPIO_GPIO3_OUT         (*(unit32_t *) (GPIO_BASE  + 16'h0028))
#define GPIO_GPIO3_IN          (*(unit32_t *) (GPIO_BASE  + 16'h002c))

//------------------------------
/*Struct for each peripherals */
//-----------------------------
typedef struct {
 __IO uint32_t UARTMTX_PAD_CTL;
 __IO uint32_t UARTMRX_PAD_CTL;
 __IO uint32_t UARTSTX_PAD_CTL;
 __IO uint32_t UARTSRX_PAD_CTL;
 __IO uint32_t GPIO0_PAD_CTL;
 __IO uint32_t GPIO1_PAD_CTL;
 __IO uint32_t GPIO2_PAD_CTL;
 __IO uint32_t GPIO3_PAD_CTL;
 __IO uint32_t PAD11_PAD_CTL;
 __IO uint32_t PAD12_PAD_CTL;
 __IO uint32_t PAD13_PAD_CTL;
 __IO uint32_t PAD14_PAD_CTL;
 __IO uint32_t PAD15_PAD_CTL;
 __IO uint32_t PAD16_PAD_CTL;
 __IO uint32_t PAD17_PAD_CTL;
 __IO uint32_t PAD18_PAD_CTL;
 __IO uint32_t PAD19_PAD_CTL;
 __IO uint32_t UARTM_BAUD_CTL;
 __IO uint32_t UARTM_CTL;
 __IO uint32_t SP_ADDR;
 __IO uint32_t RESET_ADDR;
 __IO uint32_t NMI_ADDR;
 __IO uint32_t FAULT_ADDR;
 __IO uint32_t IRQ0_ADDR;
 __IO uint32_t IRQ1_ADDR;
 __IO uint32_t IRQ2_ADDR;
 __IO uint32_t IRQ3_ADDR;
 __IO uint32_t GPT_EN;
 __IO uint32_t GPTA_CFG;
 __IO uint32_t GPTB_CFG;
 __IO uint32_t GPTC_CFG;
 __IO uint32_t WDT_EN;
 __IO uint32_t WDT_CFG;
 __IO uint32_t WDT_NMI_CFG;
 __IO uint32_t UARTS_BAUD_CTL;
 __IO uint32_t UARTS_CTL;
 __IO uint32_t UARTS_TXDATA;
 __IO uint32_t UARTS_RXDATA;
 __IO uint32_t UARTS_TXSEND;
 __IO uint32_t SPARE0;
 __IO uint32_t SPARE1;
 __IO uint32_t SPARE2;
 __IO uint32_t SPARE3;
 __O  uint32_t KEY_REG0;
 __O  uint32_t KEY_REG1;
 __O  uint32_t KEY_REG2;
 __O  uint32_t KEY_REG3;
 __O  uint32_t KEY_REG4;
 __O  uint32_t KEY_REG5;
 __O  uint32_t KEY_REG6;
 __O  uint32_t KEY_REG7;
 __O  uint32_t SIGNATURE;
} GPCFG_TYPE;

typedef struct {
  __IO uint32_t GPIO0_CTL;
  __IO uint32_t GPIO0_OUT;
  __IO uint32_t GPIO0_IN;
  __IO uint32_t GPIO1_CTL;
  __IO uint32_t GPIO1_OUT;
  __IO uint32_t GPIO1_IN;
  __IO uint32_t GPIO2_CTL;
  __IO uint32_t GPIO2_OUT;
  __IO uint32_t GPIO2_IN;
  __IO uint32_t GPIO3_CTL;
  __IO uint32_t GPIO3_OUT;
  __IO uint32_t GPIO3_IN;
} GPIO_TYPE;

typedef struct {
   __I  uint32_t SYSROM[2048];
   __IO uint32_t SYSRAM[14336];
} SYSRAM_TYPE;


//---------------------------
/* Peripheral Declaration */
//---------------------------
#define GPCFG   ((GPCFG_TYPE  *)  GPCFG_BASE));
#define GPIO    ((GPIO_TYPE   *)  GPIO_BASE));
#define SYSRAM  ((SYSRAM_TYPE *)  SYSRAM_BASE));



