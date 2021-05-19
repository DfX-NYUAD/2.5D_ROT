#include "hwrot_header.h"
#include "hwrot_functions.h"
#include "stdint.h"

uint32_t delay (uint32_t uiter) {
    uint32_t ui = 0;
    while (ui < uiter) {
        ui++;
    }
    return (uiter);
};

double PI;
//extern double complex cplx;
 
void _fft(cplx buf[], cplx out[], int n, int step)
{
	if (step < n) {
		_fft(out, buf, n, step * 2);
		_fft(out + step, buf + step, n, step * 2);
 
		for (int i = 0; i < n; i += 2 * step) {
			cplx t = cexp(-I * PI * i / n) * out[i + step];
			buf[i / 2]     = out[i] + t;
			buf[(i + n)/2] = out[i] - t;
		}
	}
}
 
void fft(cplx buf[], int n)
{
  cplx out[] = {1, 1, 0, 0};
	for (int i = 0; i < n; i++) out[i] = buf[i];
 
	_fft(buf, out, n, 1);
}
 
 
//--------------------------------------------------
//                           a(GPIO03)
//                         ------
//              f(GPIO02) |   g   | b(GPIO0)
//                         ------
//             e(UARTMTX) |       | c (UARTSRX)
//                         ------
//                           d (UARTSTX)
//--------------------------------------------------

void seven_seg_disp_init () {
    GPCFG->GPIO3PADCTL   |= ALTFUNCSEL0;
    GPCFG->GPIO0PADCTL   |= ALTFUNCSEL0;
    GPCFG->UARTSRXPADCTL |= ALTFUNCSEL0;
    GPCFG->UARTSTXPADCTL |= ALTFUNCSEL0;
    GPCFG->UARTMTXPADCTL |= ALTFUNCSEL0;
    GPCFG->GPIO2PADCTL   |= ALTFUNCSEL0;
    GPCFG->GPIO1PADCTL   |= ALTFUNCSEL0;
    //Enable O/p Mode of the pads used for seven segment display
    GPCFG->GPIO3PADCTL   &= ~PADOEN;
    GPCFG->GPIO0PADCTL   &= ~PADOEN;
    GPCFG->UARTSRXPADCTL &= ~PADOEN;
    GPCFG->UARTSTXPADCTL &= ~PADOEN;
    GPCFG->UARTMTXPADCTL &= ~PADOEN;
    GPCFG->GPIO2PADCTL   &= ~PADOEN;
    GPCFG->GPIO1PADCTL   &= ~PADOEN;

    GPCFG->UARTMTXPADCTL |=  PADDRIVE0;
    GPCFG->UARTMTXPADCTL |=  PADDRIVE1;
};


void seven_seg_disp_off () {
    GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
    GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
    GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
    GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
    GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
    GPCFG->GPIO2PADCTL   |=   ALTFUNCGPIO;
    GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
};


uint8_t seven_seg_disp_int (uint8_t dig) {
    if (dig == 0U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (dig == 1U) {
        GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (dig == 2U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (dig == 3U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (dig == 4U) {
        GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (dig == 5U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (dig == 6U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (dig == 7U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (dig == 8U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (dig == 9U) {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else  {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }

    return(0);

};

void seven_seg_disp_char (char alpha) {
    if (alpha == 'A') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (alpha == 'B') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (alpha == 'C') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (alpha == 'D') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (alpha == 'E') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (alpha == 'F') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (alpha == 'G') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (alpha == 'H') {
        GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (alpha == 'I') {
        GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (alpha == 'J') {
        GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (alpha == 'L') {
        GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (alpha == 'O') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else if (alpha == 'P') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (alpha == 'S') {
        GPCFG->GPIO3PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=   ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   &=   ~ALTFUNCGPIO;
    }
    else if (alpha == 'U') {
        GPCFG->GPIO3PADCTL   |=   ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL &=   ~ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   &=   ~ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
    else  {
        GPCFG->GPIO3PADCTL   |=  ALTFUNCGPIO;
        GPCFG->GPIO0PADCTL   |=  ALTFUNCGPIO;
        GPCFG->UARTSRXPADCTL |=  ALTFUNCGPIO;
        GPCFG->UARTSTXPADCTL |=   ALTFUNCGPIO;
        GPCFG->UARTMTXPADCTL |=  ALTFUNCGPIO;
        GPCFG->GPIO2PADCTL   |=  ALTFUNCGPIO;
        GPCFG->GPIO1PADCTL   |=   ALTFUNCGPIO;
    }
};

