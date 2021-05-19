parameter SYSRAM_BASE = 32'h20000000;
parameter GPCFG_BASE  = 32'h40020000;
parameter GPIO_BASE   = 32'h40030000;


parameter GPCFG_UARTMTX_PAD_CTL  = GPCFG_BASE + 16'h0000;
parameter GPCFG_UARTMRX_PAD_CTL  = GPCFG_BASE + 16'h0004;
parameter GPCFG_UARTSTX_PAD_CTL  = GPCFG_BASE + 16'h0008;
parameter GPCFG_UARTSRX_PAD_CTL  = GPCFG_BASE + 16'h000C;
parameter GPCFG_GPIO0_PAD_CTL    = GPCFG_BASE + 16'h0010;
parameter GPCFG_GPIO1_PAD_CTL    = GPCFG_BASE + 16'h0014;
parameter GPCFG_GPIO2_PAD_CTL    = GPCFG_BASE + 16'h0018;
parameter GPCFG_GPIO3_PAD_CTL    = GPCFG_BASE + 16'h001C;
parameter GPCFG_PAD11_PAD_CTL    = GPCFG_BASE + 16'h0020;
parameter GPCFG_PAD12_PAD_CTL    = GPCFG_BASE + 16'h0024;
parameter GPCFG_PAD13_PAD_CTL    = GPCFG_BASE + 16'h0028;
parameter GPCFG_PAD14_PAD_CTL    = GPCFG_BASE + 16'h002c;
parameter GPCFG_PAD15_PAD_CTL    = GPCFG_BASE + 16'h0030;
parameter GPCFG_PAD16_PAD_CTL    = GPCFG_BASE + 16'h0034;
parameter GPCFG_PAD17_PAD_CTL    = GPCFG_BASE + 16'h0038;
parameter GPCFG_PAD18_PAD_CTL    = GPCFG_BASE + 16'h003c;
parameter GPCFG_PAD19_PAD_CTL    = GPCFG_BASE + 16'h0040;
parameter GPCFG_UARTM_BAUD_CTL   = GPCFG_BASE + 16'h0044;
parameter GPCFG_UARTM_CTL        = GPCFG_BASE + 16'h0048;
parameter GPCFG_SP_ADDR          = GPCFG_BASE + 16'h004c;
parameter GPCFG_RESET_ADDR       = GPCFG_BASE + 16'h0050;
parameter GPCFG_NMI_ADDR         = GPCFG_BASE + 16'h0054;
parameter GPCFG_FAULT_ADDR       = GPCFG_BASE + 16'h0058;
parameter GPCFG_IRQ0_ADDR        = GPCFG_BASE + 16'h005c;
parameter GPCFG_IRQ1_ADDR        = GPCFG_BASE + 16'h0060;
parameter GPCFG_IRQ2_ADDR        = GPCFG_BASE + 16'h0064;
parameter GPCFG_IRQ3_ADDR        = GPCFG_BASE + 16'h0068;
parameter GPCFG_GPT_EN           = GPCFG_BASE + 16'h006c;
parameter GPCFG_GPTA_CFG         = GPCFG_BASE + 16'h0070;
parameter GPCFG_GPTB_CFG         = GPCFG_BASE + 16'h0074;
parameter GPCFG_GPTC_CFG         = GPCFG_BASE + 16'h0078;
parameter GPCFG_WDT_EN           = GPCFG_BASE + 16'h007c;
parameter GPCFG_WDT_CFG          = GPCFG_BASE + 16'h0080;
parameter GPCFG_WDT_NMI_CFG      = GPCFG_BASE + 16'h0084;
parameter GPCFG_UARTS_BAUD_CTL   = GPCFG_BASE + 16'h0088;
parameter GPCFG_UARTS_CTL        = GPCFG_BASE + 16'h008c;
parameter GPCFG_UARTS_TXDATA     = GPCFG_BASE + 16'h0090;
parameter GPCFG_UARTS_RXDATA     = GPCFG_BASE + 16'h0094;
parameter GPCFG_UARTS_TXSEND     = GPCFG_BASE + 16'h0098;
parameter GPCFG_SPARE0           = GPCFG_BASE + 16'h009c;
parameter GPCFG_SPARE1           = GPCFG_BASE + 16'h00a0;
parameter GPCFG_SPARE2           = GPCFG_BASE + 16'h00a4;
parameter GPCFG_SPARE3           = GPCFG_BASE + 16'h00a8;
parameter GPCFG_KEY_REG0         = GPCFG_BASE + 16'h00ac;
parameter GPCFG_KEY_REG1         = GPCFG_BASE + 16'h00b0;
parameter GPCFG_KEY_REG2         = GPCFG_BASE + 16'h00b4;
parameter GPCFG_KEY_REG3         = GPCFG_BASE + 16'h00b8;
parameter GPCFG_KEY_REG4         = GPCFG_BASE + 16'h00bc;
parameter GPCFG_KEY_REG5         = GPCFG_BASE + 16'h00c0;
parameter GPCFG_KEY_REG6         = GPCFG_BASE + 16'h00c4;
parameter GPCFG_KEY_REG7         = GPCFG_BASE + 16'h00c8;
parameter GPCFG_SIGNATURE        = GPCFG_BASE + 16'h00cc;

parameter GPCFG_APU0_MID         = GPCFG_BASE + 16'h1000;
parameter GPCFG_APU0_ADDR        = GPCFG_BASE + 16'h1004;
parameter GPCFG_APU0_MASK        = GPCFG_BASE + 16'h1008;
parameter GPCFG_APU0_PERM        = GPCFG_BASE + 16'h100C;

parameter GPCFG_APU1_MID         = GPCFG_BASE + 16'h1010;
parameter GPCFG_APU1_ADDR        = GPCFG_BASE + 16'h1014;
parameter GPCFG_APU1_MASK        = GPCFG_BASE + 16'h1018;
parameter GPCFG_APU1_PERM        = GPCFG_BASE + 16'h101C;

parameter GPCFG_APU2_MID         = GPCFG_BASE + 16'h1020;
parameter GPCFG_APU2_ADDR        = GPCFG_BASE + 16'h1024;
parameter GPCFG_APU2_MASK        = GPCFG_BASE + 16'h1028;
parameter GPCFG_APU2_PERM        = GPCFG_BASE + 16'h102C;

parameter GPCFG_APU3_MID         = GPCFG_BASE + 16'h1030;
parameter GPCFG_APU3_ADDR        = GPCFG_BASE + 16'h1034;
parameter GPCFG_APU3_MASK        = GPCFG_BASE + 16'h1038;
parameter GPCFG_APU3_PERM        = GPCFG_BASE + 16'h103C;

parameter GPCFG_APU4_MID         = GPCFG_BASE + 16'h1040;
parameter GPCFG_APU4_ADDR        = GPCFG_BASE + 16'h1044;
parameter GPCFG_APU4_MASK        = GPCFG_BASE + 16'h1048;
parameter GPCFG_APU4_PERM        = GPCFG_BASE + 16'h104C;

parameter GPCFG_APU5_MID         = GPCFG_BASE + 16'h1050;
parameter GPCFG_APU5_ADDR        = GPCFG_BASE + 16'h1054;
parameter GPCFG_APU5_MASK        = GPCFG_BASE + 16'h1058;
parameter GPCFG_APU5_PERM        = GPCFG_BASE + 16'h105C;

parameter GPCFG_APU6_MID         = GPCFG_BASE + 16'h1060;
parameter GPCFG_APU6_ADDR        = GPCFG_BASE + 16'h1064;
parameter GPCFG_APU6_MASK        = GPCFG_BASE + 16'h1068;
parameter GPCFG_APU6_PERM        = GPCFG_BASE + 16'h106C;

parameter GPCFG_APU7_MID         = GPCFG_BASE + 16'h1070;
parameter GPCFG_APU7_ADDR        = GPCFG_BASE + 16'h1074;
parameter GPCFG_APU7_MASK        = GPCFG_BASE + 16'h1078;
parameter GPCFG_APU7_PERM        = GPCFG_BASE + 16'h107C;

parameter GPCFG_APU8_MID         = GPCFG_BASE + 16'h1080;
parameter GPCFG_APU8_ADDR        = GPCFG_BASE + 16'h1084;
parameter GPCFG_APU8_MASK        = GPCFG_BASE + 16'h1088;
parameter GPCFG_APU8_PERM        = GPCFG_BASE + 16'h108C;

parameter GPCFG_APU9_MID         = GPCFG_BASE + 16'h1090;
parameter GPCFG_APU9_ADDR        = GPCFG_BASE + 16'h1094;
parameter GPCFG_APU9_MASK        = GPCFG_BASE + 16'h1098;
parameter GPCFG_APU9_PERM        = GPCFG_BASE + 16'h109C;

parameter GPCFG_APU10_MID        = GPCFG_BASE + 16'h10A0;
parameter GPCFG_APU10_ADDR       = GPCFG_BASE + 16'h10A4;
parameter GPCFG_APU10_MASK       = GPCFG_BASE + 16'h10A8;
parameter GPCFG_APU10_PERM       = GPCFG_BASE + 16'h10AC;

parameter GPCFG_APU11_MID        = GPCFG_BASE + 16'h10B0;
parameter GPCFG_APU11_ADDR       = GPCFG_BASE + 16'h10B4;
parameter GPCFG_APU11_MASK       = GPCFG_BASE + 16'h10B8;
parameter GPCFG_APU11_PERM       = GPCFG_BASE + 16'h10BC;

parameter GPCFG_APU12_MID        = GPCFG_BASE + 16'h10C0;
parameter GPCFG_APU12_ADDR       = GPCFG_BASE + 16'h10C4;
parameter GPCFG_APU12_MASK       = GPCFG_BASE + 16'h10C8;
parameter GPCFG_APU12_PERM       = GPCFG_BASE + 16'h10CC;

parameter GPCFG_APU13_MID        = GPCFG_BASE + 16'h10D0;
parameter GPCFG_APU13_ADDR       = GPCFG_BASE + 16'h10D4;
parameter GPCFG_APU13_MASK       = GPCFG_BASE + 16'h10D8;
parameter GPCFG_APU13_PERM       = GPCFG_BASE + 16'h10DC;

parameter GPCFG_APU14_MID        = GPCFG_BASE + 16'h10E0;
parameter GPCFG_APU14_ADDR       = GPCFG_BASE + 16'h10E4;
parameter GPCFG_APU14_MASK       = GPCFG_BASE + 16'h10E8;
parameter GPCFG_APU14_PERM       = GPCFG_BASE + 16'h10EC;

parameter GPCFG_APU15_MID        = GPCFG_BASE + 16'h10F0;
parameter GPCFG_APU15_ADDR       = GPCFG_BASE + 16'h10F4;
parameter GPCFG_APU15_MASK       = GPCFG_BASE + 16'h10F8;
parameter GPCFG_APU15_PERM       = GPCFG_BASE + 16'h10FC;

parameter GPCFG_APU16_MID        = GPCFG_BASE + 16'h1100;
parameter GPCFG_APU16_ADDR       = GPCFG_BASE + 16'h1104;
parameter GPCFG_APU16_MASK       = GPCFG_BASE + 16'h1108;
parameter GPCFG_APU16_PERM       = GPCFG_BASE + 16'h110C;

parameter GPCFG_APU17_MID        = GPCFG_BASE + 16'h1110;
parameter GPCFG_APU17_ADDR       = GPCFG_BASE + 16'h1114;
parameter GPCFG_APU17_MASK       = GPCFG_BASE + 16'h1118;
parameter GPCFG_APU17_PERM       = GPCFG_BASE + 16'h111C;

parameter GPCFG_APU18_MID        = GPCFG_BASE + 16'h1120;
parameter GPCFG_APU18_ADDR       = GPCFG_BASE + 16'h1124;
parameter GPCFG_APU18_MASK       = GPCFG_BASE + 16'h1128;
parameter GPCFG_APU18_PERM       = GPCFG_BASE + 16'h112C;

parameter GPCFG_APU19_MID        = GPCFG_BASE + 16'h1130;
parameter GPCFG_APU19_ADDR       = GPCFG_BASE + 16'h1134;
parameter GPCFG_APU19_MASK       = GPCFG_BASE + 16'h1138;
parameter GPCFG_APU19_PERM       = GPCFG_BASE + 16'h113C;

parameter GPCFG_APU20_MID        = GPCFG_BASE + 16'h1140;
parameter GPCFG_APU20_ADDR       = GPCFG_BASE + 16'h1144;
parameter GPCFG_APU20_MASK       = GPCFG_BASE + 16'h1148;
parameter GPCFG_APU20_PERM       = GPCFG_BASE + 16'h114C;

parameter GPCFG_APU21_MID        = GPCFG_BASE + 16'h1150;
parameter GPCFG_APU21_ADDR       = GPCFG_BASE + 16'h1154;
parameter GPCFG_APU21_MASK       = GPCFG_BASE + 16'h1158;
parameter GPCFG_APU21_PERM       = GPCFG_BASE + 16'h115C;

parameter GPCFG_APU22_MID        = GPCFG_BASE + 16'h1160;
parameter GPCFG_APU22_ADDR       = GPCFG_BASE + 16'h1164;
parameter GPCFG_APU22_MASK       = GPCFG_BASE + 16'h1168;
parameter GPCFG_APU22_PERM       = GPCFG_BASE + 16'h116C;

parameter GPCFG_APU23_MID        = GPCFG_BASE + 16'h1170;
parameter GPCFG_APU23_ADDR       = GPCFG_BASE + 16'h1174;
parameter GPCFG_APU23_MASK       = GPCFG_BASE + 16'h1178;
parameter GPCFG_APU23_PERM       = GPCFG_BASE + 16'h117C;

parameter GPCFG_APU24_MID        = GPCFG_BASE + 16'h1180;
parameter GPCFG_APU24_ADDR       = GPCFG_BASE + 16'h1184;
parameter GPCFG_APU24_MASK       = GPCFG_BASE + 16'h1188;
parameter GPCFG_APU24_PERM       = GPCFG_BASE + 16'h118C;

parameter GPCFG_APU25_MID        = GPCFG_BASE + 16'h1190;
parameter GPCFG_APU25_ADDR       = GPCFG_BASE + 16'h1194;
parameter GPCFG_APU25_MASK       = GPCFG_BASE + 16'h1198;
parameter GPCFG_APU25_PERM       = GPCFG_BASE + 16'h119C;

parameter GPCFG_APU26_MID        = GPCFG_BASE + 16'h11A0;
parameter GPCFG_APU26_ADDR       = GPCFG_BASE + 16'h11A4;
parameter GPCFG_APU26_MASK       = GPCFG_BASE + 16'h11A8;
parameter GPCFG_APU26_PERM       = GPCFG_BASE + 16'h11AC;

parameter GPCFG_APU27_MID        = GPCFG_BASE + 16'h11B0;
parameter GPCFG_APU27_ADDR       = GPCFG_BASE + 16'h11B4;
parameter GPCFG_APU27_MASK       = GPCFG_BASE + 16'h11B8;
parameter GPCFG_APU27_PERM       = GPCFG_BASE + 16'h11BC;

parameter GPCFG_APU28_MID        = GPCFG_BASE + 16'h11C0;
parameter GPCFG_APU28_ADDR       = GPCFG_BASE + 16'h11C4;
parameter GPCFG_APU28_MASK       = GPCFG_BASE + 16'h11C8;
parameter GPCFG_APU28_PERM       = GPCFG_BASE + 16'h11CC;

parameter GPCFG_APU29_MID        = GPCFG_BASE + 16'h11D0;
parameter GPCFG_APU29_ADDR       = GPCFG_BASE + 16'h11D4;
parameter GPCFG_APU29_MASK       = GPCFG_BASE + 16'h11D8;
parameter GPCFG_APU29_PERM       = GPCFG_BASE + 16'h11DC;

parameter GPCFG_APU30_MID        = GPCFG_BASE + 16'h11E0;
parameter GPCFG_APU30_ADDR       = GPCFG_BASE + 16'h11E4;
parameter GPCFG_APU30_MASK       = GPCFG_BASE + 16'h11E8;
parameter GPCFG_APU30_PERM       = GPCFG_BASE + 16'h11EC;

parameter GPCFG_APU31_MID        = GPCFG_BASE + 16'h11F0;
parameter GPCFG_APU31_ADDR       = GPCFG_BASE + 16'h11F4;
parameter GPCFG_APU31_MASK       = GPCFG_BASE + 16'h11F8;
parameter GPCFG_APU31_PERM       = GPCFG_BASE + 16'h11FC;

parameter GPCFG_APU32_MID        = GPCFG_BASE + 16'h1200;
parameter GPCFG_APU32_ADDR       = GPCFG_BASE + 16'h1204;
parameter GPCFG_APU32_MASK       = GPCFG_BASE + 16'h1208;
parameter GPCFG_APU32_PERM       = GPCFG_BASE + 16'h120C;

parameter GPCFG_APU33_MID        = GPCFG_BASE + 16'h1210;
parameter GPCFG_APU33_ADDR       = GPCFG_BASE + 16'h1214;
parameter GPCFG_APU33_MASK       = GPCFG_BASE + 16'h1218;
parameter GPCFG_APU33_PERM       = GPCFG_BASE + 16'h121C;

parameter GPCFG_APU34_MID        = GPCFG_BASE + 16'h1220;
parameter GPCFG_APU34_ADDR       = GPCFG_BASE + 16'h1224;
parameter GPCFG_APU34_MASK       = GPCFG_BASE + 16'h1228;
parameter GPCFG_APU34_PERM       = GPCFG_BASE + 16'h122C;

parameter GPCFG_APU35_MID        = GPCFG_BASE + 16'h1230;
parameter GPCFG_APU35_ADDR       = GPCFG_BASE + 16'h1234;
parameter GPCFG_APU35_MASK       = GPCFG_BASE + 16'h1238;
parameter GPCFG_APU35_PERM       = GPCFG_BASE + 16'h123C;

parameter GPCFG_APU36_MID        = GPCFG_BASE + 16'h1240;
parameter GPCFG_APU36_ADDR       = GPCFG_BASE + 16'h1244;
parameter GPCFG_APU36_MASK       = GPCFG_BASE + 16'h1248;
parameter GPCFG_APU36_PERM       = GPCFG_BASE + 16'h124C;

parameter GPCFG_APU37_MID        = GPCFG_BASE + 16'h1250;
parameter GPCFG_APU37_ADDR       = GPCFG_BASE + 16'h1254;
parameter GPCFG_APU37_MASK       = GPCFG_BASE + 16'h1258;
parameter GPCFG_APU37_PERM       = GPCFG_BASE + 16'h125C;

parameter GPCFG_APU38_MID        = GPCFG_BASE + 16'h1260;
parameter GPCFG_APU38_ADDR       = GPCFG_BASE + 16'h1264;
parameter GPCFG_APU38_MASK       = GPCFG_BASE + 16'h1268;
parameter GPCFG_APU38_PERM       = GPCFG_BASE + 16'h126C;

parameter GPCFG_APU39_MID        = GPCFG_BASE + 16'h1270;
parameter GPCFG_APU39_ADDR       = GPCFG_BASE + 16'h1274;
parameter GPCFG_APU39_MASK       = GPCFG_BASE + 16'h1278;
parameter GPCFG_APU39_PERM       = GPCFG_BASE + 16'h127C;

parameter GPCFG_APU40_MID        = GPCFG_BASE + 16'h1280;
parameter GPCFG_APU40_ADDR       = GPCFG_BASE + 16'h1284;
parameter GPCFG_APU40_MASK       = GPCFG_BASE + 16'h1288;
parameter GPCFG_APU40_PERM       = GPCFG_BASE + 16'h128C;

parameter GPCFG_APU41_MID        = GPCFG_BASE + 16'h1290;
parameter GPCFG_APU41_ADDR       = GPCFG_BASE + 16'h1294;
parameter GPCFG_APU41_MASK       = GPCFG_BASE + 16'h1298;
parameter GPCFG_APU41_PERM       = GPCFG_BASE + 16'h129C;

parameter GPCFG_APU42_MID        = GPCFG_BASE + 16'h12A0;
parameter GPCFG_APU42_ADDR       = GPCFG_BASE + 16'h12A4;
parameter GPCFG_APU42_MASK       = GPCFG_BASE + 16'h12A8;
parameter GPCFG_APU42_PERM       = GPCFG_BASE + 16'h12AC;

parameter GPCFG_APU43_MID        = GPCFG_BASE + 16'h12B0;
parameter GPCFG_APU43_ADDR       = GPCFG_BASE + 16'h12B4;
parameter GPCFG_APU43_MASK       = GPCFG_BASE + 16'h12B8;
parameter GPCFG_APU43_PERM       = GPCFG_BASE + 16'h12BC;

parameter GPCFG_APU44_MID        = GPCFG_BASE + 16'h12C0;
parameter GPCFG_APU44_ADDR       = GPCFG_BASE + 16'h12C4;
parameter GPCFG_APU44_MASK       = GPCFG_BASE + 16'h12C8;
parameter GPCFG_APU44_PERM       = GPCFG_BASE + 16'h12CC;

parameter GPCFG_APU45_MID        = GPCFG_BASE + 16'h12D0;
parameter GPCFG_APU45_ADDR       = GPCFG_BASE + 16'h12D4;
parameter GPCFG_APU45_MASK       = GPCFG_BASE + 16'h12D8;
parameter GPCFG_APU45_PERM       = GPCFG_BASE + 16'h12DC;

parameter GPCFG_APU46_MID        = GPCFG_BASE + 16'h12E0;
parameter GPCFG_APU46_ADDR       = GPCFG_BASE + 16'h12E4;
parameter GPCFG_APU46_MASK       = GPCFG_BASE + 16'h12E8;
parameter GPCFG_APU46_PERM       = GPCFG_BASE + 16'h12EC;

parameter GPCFG_APU47_MID        = GPCFG_BASE + 16'h12F0;
parameter GPCFG_APU47_ADDR       = GPCFG_BASE + 16'h12F4;
parameter GPCFG_APU47_MASK       = GPCFG_BASE + 16'h12F8;
parameter GPCFG_APU47_PERM       = GPCFG_BASE + 16'h12FC;

parameter GPCFG_APU48_MID        = GPCFG_BASE + 16'h1300;
parameter GPCFG_APU48_ADDR       = GPCFG_BASE + 16'h1304;
parameter GPCFG_APU48_MASK       = GPCFG_BASE + 16'h1308;
parameter GPCFG_APU48_PERM       = GPCFG_BASE + 16'h130C;

parameter GPCFG_APU49_MID        = GPCFG_BASE + 16'h1310;
parameter GPCFG_APU49_ADDR       = GPCFG_BASE + 16'h1314;
parameter GPCFG_APU49_MASK       = GPCFG_BASE + 16'h1318;
parameter GPCFG_APU49_PERM       = GPCFG_BASE + 16'h131C;

parameter GPCFG_APU50_MID        = GPCFG_BASE + 16'h1320;
parameter GPCFG_APU50_ADDR       = GPCFG_BASE + 16'h1324;
parameter GPCFG_APU50_MASK       = GPCFG_BASE + 16'h1328;
parameter GPCFG_APU50_PERM       = GPCFG_BASE + 16'h132C;

parameter GPCFG_APU51_MID        = GPCFG_BASE + 16'h1330;
parameter GPCFG_APU51_ADDR       = GPCFG_BASE + 16'h1334;
parameter GPCFG_APU51_MASK       = GPCFG_BASE + 16'h1338;
parameter GPCFG_APU51_PERM       = GPCFG_BASE + 16'h133C;

parameter GPCFG_APU52_MID        = GPCFG_BASE + 16'h1340;
parameter GPCFG_APU52_ADDR       = GPCFG_BASE + 16'h1344;
parameter GPCFG_APU52_MASK       = GPCFG_BASE + 16'h1348;
parameter GPCFG_APU52_PERM       = GPCFG_BASE + 16'h134C;

parameter GPCFG_APU53_MID        = GPCFG_BASE + 16'h1350;
parameter GPCFG_APU53_ADDR       = GPCFG_BASE + 16'h1354;
parameter GPCFG_APU53_MASK       = GPCFG_BASE + 16'h1358;
parameter GPCFG_APU53_PERM       = GPCFG_BASE + 16'h135C;

parameter GPCFG_APU54_MID        = GPCFG_BASE + 16'h1360;
parameter GPCFG_APU54_ADDR       = GPCFG_BASE + 16'h1364;
parameter GPCFG_APU54_MASK       = GPCFG_BASE + 16'h1368;
parameter GPCFG_APU54_PERM       = GPCFG_BASE + 16'h136C;

parameter GPCFG_APU55_MID        = GPCFG_BASE + 16'h1370;
parameter GPCFG_APU55_ADDR       = GPCFG_BASE + 16'h1374;
parameter GPCFG_APU55_MASK       = GPCFG_BASE + 16'h1378;
parameter GPCFG_APU55_PERM       = GPCFG_BASE + 16'h137C;

parameter GPCFG_APU56_MID        = GPCFG_BASE + 16'h1380;
parameter GPCFG_APU56_ADDR       = GPCFG_BASE + 16'h1384;
parameter GPCFG_APU56_MASK       = GPCFG_BASE + 16'h1388;
parameter GPCFG_APU56_PERM       = GPCFG_BASE + 16'h138C;

parameter GPCFG_APU57_MID        = GPCFG_BASE + 16'h1390;
parameter GPCFG_APU57_ADDR       = GPCFG_BASE + 16'h1394;
parameter GPCFG_APU57_MASK       = GPCFG_BASE + 16'h1398;
parameter GPCFG_APU57_PERM       = GPCFG_BASE + 16'h139C;

parameter GPCFG_APU58_MID        = GPCFG_BASE + 16'h13A0;
parameter GPCFG_APU58_ADDR       = GPCFG_BASE + 16'h13A4;
parameter GPCFG_APU58_MASK       = GPCFG_BASE + 16'h13A8;
parameter GPCFG_APU58_PERM       = GPCFG_BASE + 16'h13AC;

parameter GPCFG_APU59_MID        = GPCFG_BASE + 16'h13B0;
parameter GPCFG_APU59_ADDR       = GPCFG_BASE + 16'h13B4;
parameter GPCFG_APU59_MASK       = GPCFG_BASE + 16'h13B8;
parameter GPCFG_APU59_PERM       = GPCFG_BASE + 16'h13BC;

parameter GPCFG_APU60_MID        = GPCFG_BASE + 16'h13C0;
parameter GPCFG_APU60_ADDR       = GPCFG_BASE + 16'h13C4;
parameter GPCFG_APU60_MASK       = GPCFG_BASE + 16'h13C8;
parameter GPCFG_APU60_PERM       = GPCFG_BASE + 16'h13CC;

parameter GPCFG_APU61_MID        = GPCFG_BASE + 16'h13D0;
parameter GPCFG_APU61_ADDR       = GPCFG_BASE + 16'h13D4;
parameter GPCFG_APU61_MASK       = GPCFG_BASE + 16'h13D8;
parameter GPCFG_APU61_PERM       = GPCFG_BASE + 16'h13DC;

parameter GPCFG_APU62_MID        = GPCFG_BASE + 16'h13E0;
parameter GPCFG_APU62_ADDR       = GPCFG_BASE + 16'h13E4;
parameter GPCFG_APU62_MASK       = GPCFG_BASE + 16'h13E8;
parameter GPCFG_APU62_PERM       = GPCFG_BASE + 16'h13EC;

parameter GPCFG_APU63_MID        = GPCFG_BASE + 16'h13F0;
parameter GPCFG_APU63_ADDR       = GPCFG_BASE + 16'h13F4;
parameter GPCFG_APU63_MASK       = GPCFG_BASE + 16'h13F8;
parameter GPCFG_APU63_PERM       = GPCFG_BASE + 16'h13FC;

parameter GPCFG_DPU0_MID         = GPCFG_BASE + 16'h2000;
parameter GPCFG_DPU0_ADDR        = GPCFG_BASE + 16'h2004;
parameter GPCFG_DPU0_DATA        = GPCFG_BASE + 16'h2008;
parameter GPCFG_DPU0_MASK        = GPCFG_BASE + 16'h200C;
parameter GPCFG_DPU0_AMASK       = GPCFG_BASE + 16'h2010;

parameter GPCFG_DPU1_MID          = GPCFG_BASE + 16'h2014;
parameter GPCFG_DPU1_ADDR         = GPCFG_BASE + 16'h2018;
parameter GPCFG_DPU1_DATA         = GPCFG_BASE + 16'h201C;
parameter GPCFG_DPU1_MASK         = GPCFG_BASE + 16'h2020;
parameter GPCFG_DPU1_AMASK        = GPCFG_BASE + 16'h2024;

parameter GPCFG_DPU2_MID          = GPCFG_BASE + 16'h2028;
parameter GPCFG_DPU2_ADDR         = GPCFG_BASE + 16'h202C;
parameter GPCFG_DPU2_DATA         = GPCFG_BASE + 16'h2030;
parameter GPCFG_DPU2_MASK         = GPCFG_BASE + 16'h2034;
parameter GPCFG_DPU2_AMASK        = GPCFG_BASE + 16'h2038;

parameter GPCFG_DPU3_MID          = GPCFG_BASE + 16'h203C;
parameter GPCFG_DPU3_ADDR         = GPCFG_BASE + 16'h2040;
parameter GPCFG_DPU3_DATA         = GPCFG_BASE + 16'h2044;
parameter GPCFG_DPU3_MASK         = GPCFG_BASE + 16'h2048;
parameter GPCFG_DPU3_AMASK        = GPCFG_BASE + 16'h204C;

parameter GPCFG_DPU4_MID          = GPCFG_BASE + 16'h2050;
parameter GPCFG_DPU4_ADDR         = GPCFG_BASE + 16'h2054;
parameter GPCFG_DPU4_DATA         = GPCFG_BASE + 16'h2058;
parameter GPCFG_DPU4_MASK         = GPCFG_BASE + 16'h205C;
parameter GPCFG_DPU4_AMASK        = GPCFG_BASE + 16'h2060;

parameter GPCFG_DPU5_MID          = GPCFG_BASE + 16'h2064;
parameter GPCFG_DPU5_ADDR         = GPCFG_BASE + 16'h2068;
parameter GPCFG_DPU5_DATA         = GPCFG_BASE + 16'h206C;
parameter GPCFG_DPU5_MASK         = GPCFG_BASE + 16'h2070;
parameter GPCFG_DPU5_AMASK        = GPCFG_BASE + 16'h2074;

parameter GPCFG_DPU6_MID          = GPCFG_BASE + 16'h2078;
parameter GPCFG_DPU6_ADDR         = GPCFG_BASE + 16'h207C;
parameter GPCFG_DPU6_DATA         = GPCFG_BASE + 16'h2080;
parameter GPCFG_DPU6_MASK         = GPCFG_BASE + 16'h2084;
parameter GPCFG_DPU6_AMASK        = GPCFG_BASE + 16'h2088;

parameter GPCFG_DPU7_MID          = GPCFG_BASE + 16'h208C;
parameter GPCFG_DPU7_ADDR         = GPCFG_BASE + 16'h2090;
parameter GPCFG_DPU7_DATA         = GPCFG_BASE + 16'h2094;
parameter GPCFG_DPU7_MASK         = GPCFG_BASE + 16'h2098;
parameter GPCFG_DPU7_AMASK        = GPCFG_BASE + 16'h209C;

parameter GPCFG_DPU8_MID           = GPCFG_BASE + 16'h20A0;
parameter GPCFG_DPU8_ADDR          = GPCFG_BASE + 16'h20A4;
parameter GPCFG_DPU8_DATA          = GPCFG_BASE + 16'h20A8;
parameter GPCFG_DPU8_MASK          = GPCFG_BASE + 16'h20AC;
parameter GPCFG_DPU8_AMASK         = GPCFG_BASE + 16'h20B0;

parameter GPCFG_DPU9_MID           = GPCFG_BASE + 16'h20B4;
parameter GPCFG_DPU9_ADDR          = GPCFG_BASE + 16'h20B8;
parameter GPCFG_DPU9_DATA          = GPCFG_BASE + 16'h20BC;
parameter GPCFG_DPU9_MASK          = GPCFG_BASE + 16'h20C0;
parameter GPCFG_DPU9_AMASK         = GPCFG_BASE + 16'h20C4;

parameter GPCFG_DPU10_MID           = GPCFG_BASE + 16'h20C8;
parameter GPCFG_DPU10_ADDR          = GPCFG_BASE + 16'h20CC;
parameter GPCFG_DPU10_DATA          = GPCFG_BASE + 16'h20D0;
parameter GPCFG_DPU10_MASK          = GPCFG_BASE + 16'h20D4;
parameter GPCFG_DPU10_AMASK         = GPCFG_BASE + 16'h20D8;

parameter GPCFG_DPU11_MID          = GPCFG_BASE + 16'h20DC;
parameter GPCFG_DPU11_ADDR         = GPCFG_BASE + 16'h20E0;
parameter GPCFG_DPU11_DATA         = GPCFG_BASE + 16'h20E4;
parameter GPCFG_DPU11_MASK         = GPCFG_BASE + 16'h20E8;
parameter GPCFG_DPU11_AMASK        = GPCFG_BASE + 16'h20EC;

parameter GPCFG_DPU12_MID          = GPCFG_BASE + 16'h20F0;
parameter GPCFG_DPU12_ADDR         = GPCFG_BASE + 16'h20F4;
parameter GPCFG_DPU12_DATA         = GPCFG_BASE + 16'h20F8;
parameter GPCFG_DPU12_MASK         = GPCFG_BASE + 16'h20FC;
parameter GPCFG_DPU12_AMASK        = GPCFG_BASE + 16'h2100;

parameter GPCFG_DPU13_MID          = GPCFG_BASE + 16'h2104;
parameter GPCFG_DPU13_ADDR         = GPCFG_BASE + 16'h2108;
parameter GPCFG_DPU13_DATA         = GPCFG_BASE + 16'h210C;
parameter GPCFG_DPU13_MASK         = GPCFG_BASE + 16'h2110;
parameter GPCFG_DPU13_AMASK        = GPCFG_BASE + 16'h2114;

parameter GPCFG_DPU14_MID          = GPCFG_BASE + 16'h2118;
parameter GPCFG_DPU14_ADDR         = GPCFG_BASE + 16'h211C;
parameter GPCFG_DPU14_DATA         = GPCFG_BASE + 16'h2120;
parameter GPCFG_DPU14_MASK         = GPCFG_BASE + 16'h2124;
parameter GPCFG_DPU14_AMASK        = GPCFG_BASE + 16'h2128;

parameter GPCFG_DPU15_MID          = GPCFG_BASE + 16'h212C;
parameter GPCFG_DPU15_ADDR         = GPCFG_BASE + 16'h2130;
parameter GPCFG_DPU15_DATA         = GPCFG_BASE + 16'h2134;
parameter GPCFG_DPU15_MASK         = GPCFG_BASE + 16'h2138;
parameter GPCFG_DPU15_AMASK        = GPCFG_BASE + 16'h213C;

parameter GPCFG_DPU16_MID          = GPCFG_BASE + 16'h2140;
parameter GPCFG_DPU16_ADDR         = GPCFG_BASE + 16'h2144;
parameter GPCFG_DPU16_DATA         = GPCFG_BASE + 16'h2148;
parameter GPCFG_DPU16_MASK         = GPCFG_BASE + 16'h214C;
parameter GPCFG_DPU16_AMASK        = GPCFG_BASE + 16'h2150;

parameter GPCFG_DPU17_MID          = GPCFG_BASE + 16'h2154;
parameter GPCFG_DPU17_ADDR         = GPCFG_BASE + 16'h2158;
parameter GPCFG_DPU17_DATA         = GPCFG_BASE + 16'h215C;
parameter GPCFG_DPU17_MASK         = GPCFG_BASE + 16'h2160;
parameter GPCFG_DPU17_AMASK        = GPCFG_BASE + 16'h2164;

parameter GPCFG_DPU18_MID          = GPCFG_BASE + 16'h2168;
parameter GPCFG_DPU18_ADDR         = GPCFG_BASE + 16'h216C;
parameter GPCFG_DPU18_DATA         = GPCFG_BASE + 16'h2170;
parameter GPCFG_DPU18_MASK         = GPCFG_BASE + 16'h2174;
parameter GPCFG_DPU18_AMASK        = GPCFG_BASE + 16'h2178;

parameter GPCFG_DPU19_MID          = GPCFG_BASE + 16'h217C;
parameter GPCFG_DPU19_ADDR         = GPCFG_BASE + 16'h2180;
parameter GPCFG_DPU19_DATA         = GPCFG_BASE + 16'h2184;
parameter GPCFG_DPU19_MASK         = GPCFG_BASE + 16'h2188;
parameter GPCFG_DPU19_AMASK        = GPCFG_BASE + 16'h218C;

parameter GPCFG_DPU20_MID          = GPCFG_BASE + 16'h2190;
parameter GPCFG_DPU20_ADDR         = GPCFG_BASE + 16'h2194;
parameter GPCFG_DPU20_DATA         = GPCFG_BASE + 16'h2198;
parameter GPCFG_DPU20_MASK         = GPCFG_BASE + 16'h219C;
parameter GPCFG_DPU20_AMASK        = GPCFG_BASE + 16'h21A0;

parameter GPCFG_DPU21_MID          = GPCFG_BASE + 16'h21A4;
parameter GPCFG_DPU21_ADDR         = GPCFG_BASE + 16'h21A8;
parameter GPCFG_DPU21_DATA         = GPCFG_BASE + 16'h21AC;
parameter GPCFG_DPU21_MASK         = GPCFG_BASE + 16'h21B0;
parameter GPCFG_DPU21_AMASK        = GPCFG_BASE + 16'h21B4;

parameter GPCFG_DPU22_MID          = GPCFG_BASE + 16'h21B8;
parameter GPCFG_DPU22_ADDR         = GPCFG_BASE + 16'h21BC;
parameter GPCFG_DPU22_DATA         = GPCFG_BASE + 16'h21C0;
parameter GPCFG_DPU22_MASK         = GPCFG_BASE + 16'h21C4;
parameter GPCFG_DPU22_AMASK        = GPCFG_BASE + 16'h21C8;

parameter GPCFG_DPU23_MID          = GPCFG_BASE + 16'h21CC;
parameter GPCFG_DPU23_ADDR         = GPCFG_BASE + 16'h21D0;
parameter GPCFG_DPU23_DATA         = GPCFG_BASE + 16'h21D4;
parameter GPCFG_DPU23_MASK         = GPCFG_BASE + 16'h21D8;
parameter GPCFG_DPU23_AMASK        = GPCFG_BASE + 16'h21DC;

parameter GPCFG_DPU24_MID          = GPCFG_BASE + 16'h21E0;
parameter GPCFG_DPU24_ADDR         = GPCFG_BASE + 16'h21E4;
parameter GPCFG_DPU24_DATA         = GPCFG_BASE + 16'h21E8;
parameter GPCFG_DPU24_MASK         = GPCFG_BASE + 16'h21EC;
parameter GPCFG_DPU24_AMASK        = GPCFG_BASE + 16'h21F0;

parameter GPCFG_DPU25_MID          = GPCFG_BASE + 16'h21F4;
parameter GPCFG_DPU25_ADDR         = GPCFG_BASE + 16'h21F8;
parameter GPCFG_DPU25_DATA         = GPCFG_BASE + 16'h21FC;
parameter GPCFG_DPU25_MASK         = GPCFG_BASE + 16'h2200;
parameter GPCFG_DPU25_AMASK        = GPCFG_BASE + 16'h2204;

parameter GPCFG_DPU26_MID          = GPCFG_BASE + 16'h2208;
parameter GPCFG_DPU26_ADDR         = GPCFG_BASE + 16'h220C;
parameter GPCFG_DPU26_DATA         = GPCFG_BASE + 16'h2210;
parameter GPCFG_DPU26_MASK         = GPCFG_BASE + 16'h2214;
parameter GPCFG_DPU26_AMASK        = GPCFG_BASE + 16'h2218;

parameter GPCFG_DPU27_MID          = GPCFG_BASE + 16'h221C;
parameter GPCFG_DPU27_ADDR         = GPCFG_BASE + 16'h2220;
parameter GPCFG_DPU27_DATA         = GPCFG_BASE + 16'h2224;
parameter GPCFG_DPU27_MASK         = GPCFG_BASE + 16'h2228;
parameter GPCFG_DPU27_AMASK        = GPCFG_BASE + 16'h222C;

parameter GPCFG_DPU28_MID          = GPCFG_BASE + 16'h2230;
parameter GPCFG_DPU28_ADDR         = GPCFG_BASE + 16'h2234;
parameter GPCFG_DPU28_DATA         = GPCFG_BASE + 16'h2238;
parameter GPCFG_DPU28_MASK         = GPCFG_BASE + 16'h223C;
parameter GPCFG_DPU28_AMASK        = GPCFG_BASE + 16'h2240;

parameter GPCFG_DPU29_MID          = GPCFG_BASE + 16'h2244;
parameter GPCFG_DPU29_ADDR         = GPCFG_BASE + 16'h2248;
parameter GPCFG_DPU29_DATA         = GPCFG_BASE + 16'h224C;
parameter GPCFG_DPU29_MASK         = GPCFG_BASE + 16'h2250;
parameter GPCFG_DPU29_AMASK        = GPCFG_BASE + 16'h2254;

parameter GPCFG_DPU30_MID          = GPCFG_BASE + 16'h2258;
parameter GPCFG_DPU30_ADDR         = GPCFG_BASE + 16'h225C;
parameter GPCFG_DPU30_DATA         = GPCFG_BASE + 16'h2260;
parameter GPCFG_DPU30_MASK         = GPCFG_BASE + 16'h2264;
parameter GPCFG_DPU30_AMASK        = GPCFG_BASE + 16'h2268;

parameter GPCFG_DPU31_MID          = GPCFG_BASE + 16'h226C;
parameter GPCFG_DPU31_ADDR         = GPCFG_BASE + 16'h2270;
parameter GPCFG_DPU31_DATA         = GPCFG_BASE + 16'h2274;
parameter GPCFG_DPU31_MASK         = GPCFG_BASE + 16'h2278;
parameter GPCFG_DPU31_AMASK        = GPCFG_BASE + 16'h227C;

parameter GPCFG_DPU32_MID          = GPCFG_BASE + 16'h2280;
parameter GPCFG_DPU32_ADDR         = GPCFG_BASE + 16'h2284;
parameter GPCFG_DPU32_DATA         = GPCFG_BASE + 16'h2288;
parameter GPCFG_DPU32_MASK         = GPCFG_BASE + 16'h228C;
parameter GPCFG_DPU32_AMASK        = GPCFG_BASE + 16'h2290;

parameter GPCFG_DPU33_MID          = GPCFG_BASE + 16'h2294;
parameter GPCFG_DPU33_ADDR         = GPCFG_BASE + 16'h2298;
parameter GPCFG_DPU33_DATA         = GPCFG_BASE + 16'h229C;
parameter GPCFG_DPU33_MASK         = GPCFG_BASE + 16'h22A0;
parameter GPCFG_DPU33_AMASK        = GPCFG_BASE + 16'h22A4;

parameter GPCFG_DPU34_MID          = GPCFG_BASE + 16'h22A8;
parameter GPCFG_DPU34_ADDR         = GPCFG_BASE + 16'h22AC;
parameter GPCFG_DPU34_DATA         = GPCFG_BASE + 16'h22B0;
parameter GPCFG_DPU34_MASK         = GPCFG_BASE + 16'h22B4;
parameter GPCFG_DPU34_AMASK        = GPCFG_BASE + 16'h22B8;

parameter GPCFG_DPU35_MID          = GPCFG_BASE + 16'h22BC;
parameter GPCFG_DPU35_ADDR         = GPCFG_BASE + 16'h22C0;
parameter GPCFG_DPU35_DATA         = GPCFG_BASE + 16'h22C4;
parameter GPCFG_DPU35_MASK         = GPCFG_BASE + 16'h22C8;
parameter GPCFG_DPU35_AMASK        = GPCFG_BASE + 16'h22CC;

parameter GPCFG_DPU36_MID          = GPCFG_BASE + 16'h22D0;
parameter GPCFG_DPU36_ADDR         = GPCFG_BASE + 16'h22D4;
parameter GPCFG_DPU36_DATA         = GPCFG_BASE + 16'h22D8;
parameter GPCFG_DPU36_MASK         = GPCFG_BASE + 16'h22DC;
parameter GPCFG_DPU36_AMASK        = GPCFG_BASE + 16'h22E0;

parameter GPCFG_DPU37_MID          = GPCFG_BASE + 16'h22E4;
parameter GPCFG_DPU37_ADDR         = GPCFG_BASE + 16'h22E8;
parameter GPCFG_DPU37_DATA         = GPCFG_BASE + 16'h22EC;
parameter GPCFG_DPU37_MASK         = GPCFG_BASE + 16'h22F0;
parameter GPCFG_DPU37_AMASK        = GPCFG_BASE + 16'h22F4;

parameter GPCFG_DPU38_MID          = GPCFG_BASE + 16'h22F8;
parameter GPCFG_DPU38_ADDR         = GPCFG_BASE + 16'h22FC;
parameter GPCFG_DPU38_DATA         = GPCFG_BASE + 16'h2300;
parameter GPCFG_DPU38_MASK         = GPCFG_BASE + 16'h2304;
parameter GPCFG_DPU38_AMASK        = GPCFG_BASE + 16'h2308;

parameter GPCFG_DPU39_MID          = GPCFG_BASE + 16'h230C;
parameter GPCFG_DPU39_ADDR         = GPCFG_BASE + 16'h2310;
parameter GPCFG_DPU39_DATA         = GPCFG_BASE + 16'h2314;
parameter GPCFG_DPU39_MASK         = GPCFG_BASE + 16'h2318;
parameter GPCFG_DPU39_AMASK        = GPCFG_BASE + 16'h231C;

parameter GPCFG_DPU40_MID          = GPCFG_BASE + 16'h2320;
parameter GPCFG_DPU40_ADDR         = GPCFG_BASE + 16'h2324;
parameter GPCFG_DPU40_DATA         = GPCFG_BASE + 16'h2328;
parameter GPCFG_DPU40_MASK         = GPCFG_BASE + 16'h232C;
parameter GPCFG_DPU40_AMASK        = GPCFG_BASE + 16'h2330;

parameter GPCFG_DPU41_MID          = GPCFG_BASE + 16'h2334;
parameter GPCFG_DPU41_ADDR         = GPCFG_BASE + 16'h2338;
parameter GPCFG_DPU41_DATA         = GPCFG_BASE + 16'h233C;
parameter GPCFG_DPU41_MASK         = GPCFG_BASE + 16'h2340;
parameter GPCFG_DPU41_AMASK        = GPCFG_BASE + 16'h2344;

parameter GPCFG_DPU42_MID          = GPCFG_BASE + 16'h2348;
parameter GPCFG_DPU42_ADDR         = GPCFG_BASE + 16'h234C;
parameter GPCFG_DPU42_DATA         = GPCFG_BASE + 16'h2350;
parameter GPCFG_DPU42_MASK         = GPCFG_BASE + 16'h2354;
parameter GPCFG_DPU42_AMASK        = GPCFG_BASE + 16'h2358;

parameter GPCFG_DPU43_MID          = GPCFG_BASE + 16'h235C;
parameter GPCFG_DPU43_ADDR         = GPCFG_BASE + 16'h2360;
parameter GPCFG_DPU43_DATA         = GPCFG_BASE + 16'h2364;
parameter GPCFG_DPU43_MASK         = GPCFG_BASE + 16'h2368;
parameter GPCFG_DPU43_AMASK        = GPCFG_BASE + 16'h236C;

parameter GPCFG_DPU44_MID          = GPCFG_BASE + 16'h2370;
parameter GPCFG_DPU44_ADDR         = GPCFG_BASE + 16'h2374;
parameter GPCFG_DPU44_DATA         = GPCFG_BASE + 16'h2378;
parameter GPCFG_DPU44_MASK         = GPCFG_BASE + 16'h237C;
parameter GPCFG_DPU44_AMASK        = GPCFG_BASE + 16'h2380;

parameter GPCFG_DPU45_MID          = GPCFG_BASE + 16'h2384;
parameter GPCFG_DPU45_ADDR         = GPCFG_BASE + 16'h2388;
parameter GPCFG_DPU45_DATA         = GPCFG_BASE + 16'h238C;
parameter GPCFG_DPU45_MASK         = GPCFG_BASE + 16'h2390;
parameter GPCFG_DPU45_AMASK        = GPCFG_BASE + 16'h2394;

parameter GPCFG_DPU46_MID          = GPCFG_BASE + 16'h2398;
parameter GPCFG_DPU46_ADDR         = GPCFG_BASE + 16'h239C;
parameter GPCFG_DPU46_DATA         = GPCFG_BASE + 16'h23A0;
parameter GPCFG_DPU46_MASK         = GPCFG_BASE + 16'h23A4;
parameter GPCFG_DPU46_AMASK        = GPCFG_BASE + 16'h23A8;

parameter GPCFG_DPU47_MID          = GPCFG_BASE + 16'h23AC;
parameter GPCFG_DPU47_ADDR         = GPCFG_BASE + 16'h23B0;
parameter GPCFG_DPU47_DATA         = GPCFG_BASE + 16'h23B4;
parameter GPCFG_DPU47_MASK         = GPCFG_BASE + 16'h23B8;
parameter GPCFG_DPU47_AMASK        = GPCFG_BASE + 16'h23BC;

parameter GPCFG_DPU48_MID          = GPCFG_BASE + 16'h23C0;
parameter GPCFG_DPU48_ADDR         = GPCFG_BASE + 16'h23C4;
parameter GPCFG_DPU48_DATA         = GPCFG_BASE + 16'h23C8;
parameter GPCFG_DPU48_MASK         = GPCFG_BASE + 16'h23CC;
parameter GPCFG_DPU48_AMASK        = GPCFG_BASE + 16'h23D0;

parameter GPCFG_DPU49_MID          = GPCFG_BASE + 16'h23D4;
parameter GPCFG_DPU49_ADDR         = GPCFG_BASE + 16'h23D8;
parameter GPCFG_DPU49_DATA         = GPCFG_BASE + 16'h23DC;
parameter GPCFG_DPU49_MASK         = GPCFG_BASE + 16'h23E0;
parameter GPCFG_DPU49_AMASK        = GPCFG_BASE + 16'h23E4;

parameter GPCFG_DPU50_MID          = GPCFG_BASE + 16'h23E8;
parameter GPCFG_DPU50_ADDR         = GPCFG_BASE + 16'h23EC;
parameter GPCFG_DPU50_DATA         = GPCFG_BASE + 16'h23F0;
parameter GPCFG_DPU50_MASK         = GPCFG_BASE + 16'h23F4;
parameter GPCFG_DPU50_AMASK        = GPCFG_BASE + 16'h23F8;

