#include "stdio.h"
#include "unistd.h"
#include "xparameters.h"
#include "xbram.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "xtime_l.h"
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

u32 linear_layer[216] = {327428,4244897535,4294572036,4160750074,4261738494,4261609219,150996993,4261347071,393992,
    4210688504,4244635393,67240699,4261676289,4211017216,66977280,84081924,4227989759,4244569597,33488644,101056257,
    4227531266,4244374266,134282500,4059432702,67699193,4177070338,100530419,4228055293,724745,4278125307,101451009,
    4278322431,4143447036,83096059,134087933,16713733,4261676034,4160554496,50003192,68617725,100992265,4176873218,
    4294900218,4010017539,4227332344,4160815866,319816445,4244700167,16779011,33422340,184744708,17370644,4211342336,
    118162170,4244964605,16779013,4177524217,302777087,168161796,4244701698,167707901,4194959367,3927051515,4294897912,
    235209984,4260559646,4110747904,100993020,150732801,102108679,4194107396,3925277686,4294704113,4294836734,168626683,
    200932090,33228310,67502858,3910998305,66851308,4262731015,4194437630,3774676740,3774415853,4177594109,455208436,
    50526987,3908499451,83822839,435944696,4059759393,4127588607,252502261,16382719,85334534,117310213,4093446141,
    4245097718,336593158,117962751,3925867773,437062893,16581899,101712139,4277991421,4176541445,4228315889,218364676,
    4227995909,17039346,518912249,16710160,4193130490,4227401473,4109368071,67107067,4210164736,4259898354,167771649,
    67893770,4278126850,4159501568,116718341,553780993,4294240764,251723773,4228778227,50200828,65865474,4261611282,
    4009098489,3891788281,402458370,3857318689,4026793986,115998470,4261676299,67766016,83557114,3907715077,16643322,
    335413761,201785091,134283008,32634616,67502854,217709053,50264316,3975478016,4042589180,4076668151,4093381876,134414842,
    185472276,83560959,4226939898,4244176129,4111204614,117042664,218301698,336595463,263699,4093641473,67438589,150665986,
    50203414, 50789886,67438600,4194828540,4227135215,84477441,218563071,66585094,4244768260,4278385400,50135041,118230795,
    67370244,4126866166,394757,33750783,16843779,4261149955,4261216509,67174144,50855681,117702399,329986,4245227014,
    100270847,100467208,50726144,4278388228,83756288,67175162,4244438275,4244571133,4261410811,0,0,64000,0,131072,0,
    50331648,0,0,250,0,768,0,131072,0,4227858432,0,0};

u32 img[234] ={4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4278190335,4294967295,255,4294967295,4278255615,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4278190335,4294901760,255,4278190080,65535,0,0,0,0,0,0,4278190080,16711680,4294967040,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,16777215,16777216,0,4278255360,4294902015,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294902015,65280,0,0,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,65280,0,4278190080,4294902015,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,16777215,65280,0,0,4278190335,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,16776960,0,0,4294901760,16776960,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,16777215,4294967295,65535,4294967040,4294967295,4294967295,4294967295,4294967295,4294967295,
    4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,0,0,0,0,0,0,0,0,0} ;

u32 reading[3] = {0};

int matrix[30][30] = {{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  1,  0, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
       {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}};

int linear_lay[10][100] = {{  4,  -1,   4,   0,  -1,  -2,   3,  -3,   4,   4,  -1,  -2,   1,   1,
          -1,   5,   6,   2,   2,   4,   4,  -2,   0,   6,  -3,  -9,  -8,  -3,
           4,   5,  -3,   5,   7,   0,   1,  -7, -15,  -5,  -5,  -1,  -2,   1,
          -2,  -1,  -5,  33,   3,  -5, -15,  -1,   0,   6, -10, -11,   5,  25,
           2,  -4, -14,  -1,   3,   1,  -7, -13,   8,  14,  -4,  -4,   0,  -2,
           2,   2,  -8, -10, -15,   1,   6,   3,   6,   4,  -3,   1,   3,   0,
         -12,  -3,   7,   5,   4,   2,  -1,  -2,   2,   2,   3,   4,   1,   1,
           3,   0},
        { -8,  -7,  -1,  -6,   1,   0,  -8,  -2,  -9,   2,  -5,  -5,  -6,   2,
          -4,  -4,   4,  -3,  -4,  -6,   2,  -3,   5,  23,   4,   9,   5, -11,
          -1,  -8,  -1,   2,  12,  18,   4, -14,   9,  13,  10,  -6,  -6,  -7,
          11,  22,   6, -32,  12,  15,  -1,  -6,  -7,   0,   6,  26,  -8, -19,
          30,  16,  -6,  -2,   0,  -6,  23,   7, -19,   3,  18,   7,   3,  -2,
          -7,  -4,  -7,  -7,  12,  -4,  -8,  -2,   2,   0,  -5,  -5,  -6,   8,
          22,  11,  -2,   2,  -2,  -3,  -3,  -5,  -3,  -3,   0,  -3,  -3,   0,
          -1,  -6},
        {  4,  -2,   3,  -1,   2,  -2,   1,   8,   0,   0,   8,  -2,   6, -10,
         -15,  -7,   1,   9,   5,   6,   2,   7, -10,  -8,  -6,  -7,  -2,   5,
          10,   2,   2,   1,  -3,  -3,   4,  -1,  -5,   1,  10,   3,   6,   4,
          33,  25,  29,  22,   5,   5,   3,  -2,   6,  -3,   7,  -3, -18,  -7,
           1,   7,  -7,  -5,   7,  -5, -17, -11, -18,  -7,  -7,  -9, -25,   2,
           7,  -3, -12, -20,  -4,   3, -11, -16,  -9,   4,  -3,   6,   3,   8,
           8,   5,   4,  -4,   0,   8,   0,   4,   1,  -1,   7,   3,  -1,  -2,
           3,   2},
        {  9,  -1,  -2,  -2,  -3,   8,   3,   6,   0,   4,   2,   9,  -7,  -8,
         -13,  -8,  -3,   5,  -1,   3,   3,   4, -17,  -8,  -8,  -9,  -5,   9,
           7,   0,  10,  -6,  -5,  12,  18, -22, -23, -20,  17,  -4,   3,   7,
          29,  20,  -2, -13, -10,  12,   7,  -3,   6,   1,  16,  20, -12,  -5,
          -8,  -1,   3,   0,   4, -14,  -6,  23,  33,   3, -22, -27,   2,   0,
           4, -16, -14, -12,  12,  -4, -13,  -6,   1,   3,   8,  -6, -17, -10,
         -12,  -5,   1,   6,   9,   5,   7,   2,   9,   5,   0,   6,   6,   9,
          -3,   3},
        { -8,   1,  -6,  -6,   1,  -1,  -1,  -4,  -5,  -3,   0,   3,  -4,   9,
          15,  11,   0,  -5,  -6,   2,   1,  -8,  -3,   2,  16,  19,   7,  -8,
         -16,  -2,  -1,   0,   5,   5,  14,  30,  -2,   9,   2,  -6,   4,  -1,
          -4, -32, -19,  -1,  -9,   7,   7,  -3,  -4,  -1, -23, -19, -14, -29,
         -24,  -3,   1,  -2,  -1,   9,  10,   6,  -1, -23,   6,  11,   5,   4,
          -2,   0,  20,  21,  14,  11,  -1,   9,  -5,   4,  -6,  -1,   1,   7,
          13,   6,   2,  -8,   3,   4,  -1,   2,  -6,   5,   8,   2,  -3,   5,
           0,  -6},
        {  2,   2,   4,   1,   5,   4,  -2,   0,   6,   2,  -1,  -2,   1,   5,
          12,   6,  -1,   4,  -4,   0,  -3,   3,   7,   0,   1,   4,  -4,  -5,
         -14,  -3,   0,   9,   5, -11,  -4,   7,   3,  -7, -32,  -3,   6,   1,
          -7, -12, -19,  12,  13,  26,  11,   5,  -3,   0,  11,   1,  -6,  11,
           4,   2,   9,  -1,  -2,   0, -11,   7,  10,   4,  -6,  -6,  -6,   4,
           5,   0,  -5, -15,  -5,   1,  -3,  -8,  -4,   6,   1,   6,   2,  -3,
          -8,  -6,   2,  -1,   1,   0,   5,   6,   3,   4,   6,   3,  -1,   0,
           5,   3},
        { -1,  -6,   0,  -2,  -3,   3,   4,  -3,   2,   2,  -1,  -4,  -5,  -9,
         -10,  -5, -15, -13,  -3,   1,   4,  -5,   2,  11,  20,  14,   9,   5,
           6,   1,   0,  -4,   8,   7,  14,  22,  33,  27,  11,  -5,   2,   3,
          -5,  -9, -10,  16,   6,  -3,  -9,  -4,  -2,   5,  -9, -16, -20,  -9,
           5,  -5, -12,   6,   1,   7,   2, -21, -24,  -6, -12,  -3,   0,   1,
           2,  -2,  12, -11, -24, -19,  -7,   6,   2,   5,   3,  -3,   2,  11,
          15,  12,   7,   4,  -3,   3,  -2,   4,  -6,   2,   1,   4,   3,  -3,
          -4,   2},
        {  5,  -1,   0,   2,  -4,  -3,  -3,  -2,  -4,   4,  -3,   4,  -2,   7,
           5,   8,  -1,   0,   1,   0,  -4,   3,  -5,  -6,   2,  11,   7,   6,
           4,   0,  -3,  -7, -10,  -5, -10, -23, -24,  -9,   8,  -1,   4,  -8,
          -4,  -5,  25,  -8, -15,  -6,   6,  -4,   4,  -5,   3,  13,  33,  -4,
         -23, -12,  -1,  -3,  -1,   0,  15,  19,   3,  -1,   6,  12,   0,  -1,
           0,   8,  13,   7,  10,  16,  20,  19,   6,   4,   0,   4, -10,  -6,
          -6, -11,   5,   6,   6,   0,  -4,  -3,   3,  -1,  -4,  -5,  -9,  -1,
          -3,  -4},
        {  0,   5,   3,  -2,  -2,  -4,   3,   8,  -2,   2,   6,   2,   3,   3,
          -4,  -8,   8,   8,   4,  11,  -1,   7,   0,   3,  -4, -14,  -8,  -2,
           2,   7,  -1,   3,  -4, -19,  -4,  17,  -4, -13, -17,  -3,   4,  -2,
         -10,  -8, -19,  -5,   3, -16,  -9,   7,   2,  12,  20,  15, -32, -20,
           8,  25,   7,   3,   7,   5,   3, -25, -11,  10,   6,   3,   5,   1,
           9,   6, -12, -15,   1,  -1,  -4,  -7,   0,  -5,  11,   5,  12,   4,
         -17, -19,  -7,  -2,   9,   0,   2,   0,   6,   8,  -1,   3,   4,  -4,
           7,   4},
        { -1,   5,   0,  -7,   2,   0,  -5,   1,   2,   1,   3,  -4,  -1,  -5,
           0,  13,   1,  -3,  -4,  -3,  -3,  -4,  15,  12,  -4, -21,  -5,  15,
           5,   7,   7,   5,   7,  -8, -16, -12, -13,  -2,  15,  -6,   2,  -1,
         -20, -21,   7, -10, -32, -22,   9,   4,   1,  -3,  -5,   0,  -1, -17,
         -18,  16,  10,  -2,  -4,   5,  16,   3,  16,  -5,  10,  16,  10,   2,
          -3,  -4,  14,  22,  31,  28,  26,  12,  -3,  -4,  -4,   3,  -3,  -8,
          -5,  -4, -10, -17,   3,   5,  -4,  -1,   4,  -2,  -7,  -2,  -2,  -8,
           2,  -6}};

int weight[3][3] = {{-16, -16, -12},{-11, -8, -12},{-14, -11, -14}};

#define With_Accelerator

//Macro definition
#define SCUGIC_ID     XPAR_SCUGIC_0_DEVICE_ID	//Interrupt controller ID
#define GPIOPS_ID     XPAR_XGPIOPS_0_DEVICE_ID  //PS-side GPIO device ID
#define AXI_GPIO_ID   XPAR_AXI_GPIO_0_DEVICE_ID	//PL-side AXI GPIO device ID
#define DONE_GPIO_ID  XPAR_AXI_GPIO_1_DEVICE_ID	//PL-side AXI GPIO device ID
#define DONE_INT_ID   XPAR_FABRIC_GPIO_1_VEC_ID	//PL end AXI GPIO interrupt ID
#define KEY_MASK      XGPIO_IR_MASK     	//Bit definition of channel 1
#define F_AXI_CHANNEL 1   			//PL F_axi uses AXI GPIO channel 0
#define DONE_CHANNEL  1				//PL Done uses AXI GPIO channel 1
#define START_ADDR    0		                // RAM start address range: 0~1023
#define BRAM_DATA     4                         // Number of BRAM data bytes

// Function declaration
void instance_init();          				//Initialize device driver
void data_ready(void *CallbackRef);		        //interrupt service function
XScuGic 	  scugic_inst;				//Interrupt controller driver example
XScuGic_Config   *scugic_cfg_ptr; 			//Interrupt controller configuration information
XGpio             axi_gpio_inst;			//PL-side AXI GPIO driver example
XGpio             done_inst;			        //PL-side AXI GPIO driver example

XTime starting, end;
double elapsed_ns;
int counter = 0;

// Shadow register to hold current GPIO state
uint32_t gpio_state = 0x0000;
// used to write data to BRAM
static inline void BRAM_Write(u32 bram_bank, u32 address, u32 Data);
// used to read data to BRAM
static inline u32 BRAM_Read(u32 address, u32 bram_bank);
//reset the accelerator
static inline void reset();
// Function to write updated state to GPIO
static inline void gpio_write();
// Start the accelerator (set bit 5)
static inline void start();
// Select dequantization scale (bits 8-11)
static inline void dequantization(int8_t scale);
// Use accumulate mode (set bit 6)
static inline void acc();
// Rearrange/write back result (set bit 12)
static inline void rearrange();

// Helper function to calculate and print elapsed time
static inline double print_elapsed_time(XTime start, XTime end, const char* label) {
    double elapsed = 1.0 * (end - start) / COUNTS_PER_SECOND;
    printf("%s: %.9f s\n", label, elapsed);
    return elapsed;
}


int main(){
   // just some initialization you don't need this
    print("let's test our NPU\n");
    scugic_cfg_ptr = XScuGic_LookupConfig(SCUGIC_ID);// Initialize the interrupt controller driver
    XScuGic_CfgInitialize(&scugic_inst, scugic_cfg_ptr, scugic_cfg_ptr->CpuBaseAddress);
    XGpio_Initialize(&done_inst, DONE_GPIO_ID);//Initialize PL-side DONE GPIO driver
    XGpio_Initialize(&axi_gpio_inst, AXI_GPIO_ID);//Initialize the F_AXI gpio's
    //Configure F_AXI GPIO
    XGpio_SetDataDirection(&axi_gpio_inst, F_AXI_CHANNEL, 0); //Set F_AXI GPIO to output
    //Configure DONE GPIO
    XGpio_SetDataDirection(&done_inst, DONE_CHANNEL, 1);            //Set done AXI GPIO channel 1 is input
    XGpio_InterruptEnable(&done_inst, KEY_MASK);		    //Enable done channel 1 interrupt
    XGpio_InterruptGlobalEnable(&done_inst);			    //Enable done AXI GPIO global interrupt
    //Set interrupt priority and trigger type (high level trigger)
    XScuGic_SetPriorityTriggerType(&scugic_inst, DONE_INT_ID, 0xA0, 0x1);
    //Associate interrupt ID and interrupt handling function
    XScuGic_Connect(&scugic_inst, DONE_INT_ID, data_ready, &done_inst);
    // Enable DONE GPIO interrupt
    XScuGic_Enable(&scugic_inst, DONE_INT_ID);
    //Set and enable interrupt exception handling function
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
    		(Xil_ExceptionHandler)XScuGic_InterruptHandler, &scugic_inst);
    Xil_ExceptionEnable();
    XGpio_DiscreteWrite(&axi_gpio_inst, F_AXI_CHANNEL, 0);//making sure all signals are zero
    //we finished the initialization step

    #ifdef With_Accelerator
        // we start by reseting
        reset();

        // we'll start now filling our BRAM's with Data
        print("Now let's start to fill our BRAM\n");
        // tensor writing

        printf("Starting\n");
        XTime_GetTime(&starting);// just for calculating required time

        for (int address = 0; address < 13; address++){
            for (int bank = 0; bank < 18; bank++){
                BRAM_Write(bank, address, img[(address*18)+bank]);
            }
        }

        for (int address = 0; address < 13; address++){
            BRAM_Write(18, address, 0xF5F4F0F0);
            BRAM_Write(19, address, 0xF5F2F4F8);
            BRAM_Write(20, address, 0x000000F2);
        }

        //now real things happens we sent a start signal to the system
        dequantization(6);
        start();
        // waiting for an interrupt
        while(counter == 0);

        //dequantization(0);
        rearrange();
        // waiting for an interrupt
        while(counter == 1);

        for (int address = 0; address < 12; address++){
            for (int bank = 0; bank < 18; bank++){
                BRAM_Write(bank, address, linear_layer[(address*18)+bank]);
            }
        }
        acc();
        start();
        // waiting for an interrupt
        while(counter == 2);
        reading[0] = BRAM_Read(12, 21);
        reading[0] = BRAM_Read(12, 21);
        reading[1] = BRAM_Read(12, 22);
        reading[1] = BRAM_Read(12, 22);

        for (int address = 0; address < 12; address++){
            for (int bank = 0; bank < 5; bank++){
                BRAM_Write(bank, address, linear_layer[(address*5)+bank]);
            }
        }
        acc();
        start();
        // waiting for an interrupt
        while(counter == 3);

        reading[2] = BRAM_Read(12, 21);
        reading[2] = BRAM_Read(12, 21);

        int8_t max = -128;
        int8_t val[10] = {0};
        int8_t prediction = 0;
        for (int mask = 0; mask < 10; mask++){
        	val[mask] = ((reading[mask/4]) >>((8*mask)%32)) & 0xff;
        	if (val[mask] > max){
        		max = val[mask];
                prediction =  mask;
            }
        }
        elapsed_ns = 1.0 * (end - starting)  / COUNTS_PER_SECOND;
        printf("Execution Time: %.9f s\n", elapsed_ns);
        printf("Predicted digit is : %d\n",prediction);
        for (int mask = 0; mask < 10; mask++){
            printf("value %d : %d\n", mask, val[mask]);
        }

        printf("good bye\n");
    #elif defined(With_Accelerator_report)
        XTime time_start, time_end;
        XTime time_img_load_start, time_img_load_end;
        XTime time_constant_load_start, time_constant_load_end;
        XTime time_first_start_start, time_first_start_end;
        XTime time_rearrange_start, time_rearrange_end;
        XTime time_linear_load_start, time_linear_load_end;
        XTime time_second_start_start, time_second_start_end;
        XTime time_read_results_start, time_read_results_end;
        XTime time_final_linear_start, time_final_linear_end;
        XTime time_final_compute_start, time_final_compute_end;
        XTime time_prediction_start, time_prediction_end;
        // Start overall timing
        XTime_GetTime(&time_start);

        // Reset accelerator
        reset();

        // Start image loading timing
        print("Now let's start to fill our BRAM\n");
        printf("Starting\n");
        XTime_GetTime(&time_img_load_start);

        // Load image data to BRAM
        for (int address = 0; address < 13; address++){
            for (int bank = 0; bank < 18; bank++){
                BRAM_Write(bank, address, img[(address*18)+bank]);
            }
        }
        XTime_GetTime(&time_img_load_end);
        // XTime_GetTime(&time_start);
        // Time constant data loading
        XTime_GetTime(&time_constant_load_start);
        for (int address = 0; address < 13; address++){
            BRAM_Write(18, address, 0xF5F4F0F0);
            BRAM_Write(19, address, 0xF5F2F4F8);
            BRAM_Write(20, address, 0x000000F2);
        }
        XTime_GetTime(&time_constant_load_end);

        // Time first processing stage
        XTime_GetTime(&time_first_start_start);
        dequantization(6);
        start();
        // waiting for an interrupt
        while(counter == 0);
        XTime_GetTime(&time_first_start_end);

        // Time rearrangement operation
        XTime_GetTime(&time_rearrange_start);
        rearrange();
        // waiting for an interrupt
        while(counter == 1);
        XTime_GetTime(&time_rearrange_end);

        // Time linear layer loading
        XTime_GetTime(&time_linear_load_start);
        for (int address = 0; address < 12; address++){
            for (int bank = 0; bank < 18; bank++){
                BRAM_Write(bank, address, linear_layer[(address*18)+bank]);
            }
        }
        XTime_GetTime(&time_linear_load_end);

        // Time second processing stage
        XTime_GetTime(&time_second_start_start);
        acc();
        start();
        // waiting for an interrupt
        while(counter == 2);
        XTime_GetTime(&time_second_start_end);

        // Time reading results
        XTime_GetTime(&time_read_results_start);
        reading[0] = BRAM_Read(12, 21);
        reading[0] = BRAM_Read(12, 21);
        reading[1] = BRAM_Read(12, 22);
        reading[1] = BRAM_Read(12, 22);
        XTime_GetTime(&time_read_results_end);

        // Time final linear layer loading
        XTime_GetTime(&time_final_linear_start);
        for (int address = 0; address < 12; address++){
            for (int bank = 0; bank < 5; bank++){
                BRAM_Write(bank, address, linear_layer[(address*5)+bank]);
            }
        }
        XTime_GetTime(&time_final_linear_end);

        // Time final computation
        XTime_GetTime(&time_final_compute_start);
        acc();
        start();
        // waiting for an interrupt
        while(counter == 2);
        reading[2] = BRAM_Read(12, 21);
        reading[2] = BRAM_Read(12, 21);
        XTime_GetTime(&time_final_compute_end);

        // Time prediction calculation
        XTime_GetTime(&time_prediction_start);
        int8_t max = -128;
        int8_t val[10] = {0};
        int8_t prediction = 0;
        for (int mask = 0; mask < 10; mask++){
            val[mask] = ((reading[mask/4]) >>((8*mask)%32)) & 0xff;
            if (val[mask] > max){
                max = val[mask];
                prediction = mask;
            }
        }
        XTime_GetTime(&time_prediction_end);

        // End of overall timing
        XTime_GetTime(&time_end);

        // Calculate and print individual timings
        double total_time = print_elapsed_time(time_start, time_end, "Total execution time");
        double img_load_time = print_elapsed_time(time_img_load_start, time_img_load_end, "Image loading time");
        double constant_load_time = print_elapsed_time(time_constant_load_start, time_constant_load_end, "Filter data loading time");
        double first_proc_time = print_elapsed_time(time_first_start_start, time_first_start_end, "First processing stage time");
        double rearrange_time = print_elapsed_time(time_rearrange_start, time_rearrange_end, "Rearrangement operation time");
        double linear_load_time = print_elapsed_time(time_linear_load_start, time_linear_load_end, "Linear layer loading time");
        double second_proc_time = print_elapsed_time(time_second_start_start, time_second_start_end, "Second processing stage time");
        double read_results_time = print_elapsed_time(time_read_results_start, time_read_results_end, "Reading results time");
        double final_linear_time = print_elapsed_time(time_final_linear_start, time_final_linear_end, "Final linear layer loading time");
        double final_compute_time = print_elapsed_time(time_final_compute_start, time_final_compute_end, "Final computation time");
        double prediction_time = print_elapsed_time(time_prediction_start, time_prediction_end, "Prediction calculation time");

        // Print original timing info and results
        elapsed_ns = 1.0 * (end - starting) / COUNTS_PER_SECOND;
        printf("Original execution time: %.9f s\n", elapsed_ns);
        printf("Predicted digit is: %d\n", prediction);

        // Print summary percentages
        printf("\n--- TIME DISTRIBUTION SUMMARY ---\n");
        printf("Image loading: %.2f%%\n", (img_load_time/total_time)*100);
        printf("Constant data loading: %.2f%%\n", (constant_load_time/total_time)*100);
        printf("First processing: %.2f%%\n", (first_proc_time/total_time)*100);
        printf("Rearrangement: %.2f%%\n", (rearrange_time/total_time)*100);
        printf("Linear layer loading: %.2f%%\n", (linear_load_time/total_time)*100);
        printf("Second processing: %.2f%%\n", (second_proc_time/total_time)*100);
        printf("Reading results: %.2f%%\n", (read_results_time/total_time)*100);
        printf("Final linear loading: %.2f%%\n", (final_linear_time/total_time)*100);
        printf("Final computation: %.2f%%\n", (final_compute_time/total_time)*100);
        printf("Prediction calculation: %.2f%%\n", (prediction_time/total_time)*100);

        // Display individual values for clearer comparison
        for (int mask = 0; mask < 10; mask++){
            printf("value %d: %d\n", mask, val[mask]);
        }

        printf("good bye\n");
    #elif defined(Without_Accelerator)
        int size = 30;
        int result[10] = {0};
        int out_mat[10][10] = {0};
        int kernel_size = 3;
        int out_size = size/kernel_size ;
        XTime starting, end;
        double elapsed_ns;
        printf("Starting\n");
        XTime_GetTime(&starting);// just for calculating required time

        for (int i = 0; i < out_size; i++){
            for (int j = 0; j < out_size; j++){
                for (int k = 0; k < kernel_size; k++){
                    for (int l = 0; l < kernel_size; l++){
                        out_mat[i][j] = out_mat[i][j] + matrix[kernel_size*i + k][kernel_size*j + l]*weight[k][l];
                    }
                }
            }
        }

        for (int i = 0; i < out_size; i++){
            for (int j = 0; j < out_size; j++){
                out_mat[i][j] = (out_mat[i][j] >> 6);
            }
        }

        for (int i = 0; i < 10; i++) {
            result[i] = 0;  // Clear the result[i]
            for (int j = 0; j < 100; j++) {
                int row = j / out_size;
                int col = j % out_size;
                result[i] += out_mat[row][col] * linear_lay[i][j];
            }
        }

        int max_index = 0;
        int max_value = result[0];

        for (int i = 1; i < 10; i++) {
            if (result[i] > max_value) {
                max_value = result[i];
                max_index = i;
            }
        }

        // Stop measuring time
        XTime_GetTime(&end);
        elapsed_ns = 1.0 * (end - starting)  / COUNTS_PER_SECOND;
        printf("Execution Time: %.9f s\n", elapsed_ns);
        printf("Max Value: %d at Index: %d\n", max_value, max_index);
    #endif

    return 0;
}

//interrupt handling when done signal is generated an interrupt occurs where we read the resulting data
void data_ready(void *CallbackRef)
{
    XGpio *GpioPtr = (XGpio *)CallbackRef;
    XTime_GetTime(&end);
    XGpio_InterruptDisable(GpioPtr, KEY_MASK);				//Disable AXI GPIO interrupt enable
    counter ++;
    reset();
    XGpio_InterruptClear(GpioPtr, KEY_MASK);				// Clear interrupt
    XGpio_InterruptEnable(GpioPtr, KEY_MASK);				//Enable AXI GPIO interrupt
}

// used to write data to BRAM
static inline void BRAM_Write(u32 bram_bank, u32 address, u32 Data) {
    u32 address_BRAM = (address & 0x3FF) << 3;
    u32 address_FAXI = bram_bank & 0x1F;
    // Select the correct BRAM bank using GPIO
    XGpio_DiscreteWrite(&axi_gpio_inst, F_AXI_CHANNEL, address_FAXI);
    // Write data to the correct BRAM address
    XBram_WriteReg(XPAR_BRAM_0_BASEADDR, address_BRAM, Data);
}

// used to read data to BRAM
static inline u32 BRAM_Read(u32 address, u32 bram_bank) {
    u32 address_BRAM = (address & 0x3FF) << 3;
    u32 address_FAXI = bram_bank & 0x1F;
    XGpio_DiscreteWrite(&axi_gpio_inst, F_AXI_CHANNEL, address_FAXI);
    return XBram_ReadReg(XPAR_BRAM_0_BASEADDR, address_BRAM);
}

//reset the accelerator
static inline void reset() {
    gpio_state = 0x0000;
    XGpio_DiscreteWrite(&axi_gpio_inst, F_AXI_CHANNEL, 0x00);
    XGpio_DiscreteWrite(&axi_gpio_inst, F_AXI_CHANNEL, 0x80);
    XGpio_DiscreteWrite(&axi_gpio_inst, F_AXI_CHANNEL, 0x00);
}

// Function to write updated state to GPIO
static inline void gpio_write() {
    XGpio_DiscreteWrite(&axi_gpio_inst, F_AXI_CHANNEL, gpio_state);
}

// Start the accelerator (set bit 5)
static inline void start() {
    gpio_state |= 0x20;
    gpio_write();
}

// Select dequantization scale (bits 8-11)
static inline void dequantization(int8_t scale) {
    gpio_state &= ~0xF00; // Clear previous scale bits
    gpio_state |= (scale << 8) & 0xF00;
    gpio_write();
}

// Use accumulate mode (set bit 6)
static inline void acc() {
    gpio_state |= 0x40;
    gpio_write();
}

// Rearrange/write back result (set bit 12)
static inline void rearrange() {
    gpio_state |= 0x1000;
    gpio_write();
}
