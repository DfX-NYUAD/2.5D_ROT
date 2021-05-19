#include "stdint.h"
uint32_t delay               (uint32_t uiter);
void     seven_seg_disp_init ();
void     seven_seg_disp_off  ();
uint8_t  seven_seg_disp_int  (uint8_t dig); 
void     seven_seg_disp_char (char alpha);
void     fft                 (cplx buf[], int n);

