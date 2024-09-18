/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This example shows how graphics display data can be specified using integer array initialisers and binary constants.
 */

/*
 * 28/02/2024
 * Introduction to Operating Systems - Assignment 1
 * Made By Elvin Jiby
 *
 * Code that simulates breakout in Logism
 */

#pragma once

// number of pictures in the array it is good practice to surround the entire #define'd value with ( ) to avoid
// problems arithmetic with operation precedence when #define'd value is used in some arithmetic expression
//#define PICTURES_TOTAL (2)  

// "extern" keyword declares picture array as defined in *some* .o file, not necessarily in the file where we use it.
// this way C compiler will not complain that pictures[] array is undefined, when we use it in the main program. 

extern int picture[32];

void updateBall(volatile int* display, int *xPos, int *yPos, int *xSpeed, int *ySpeed, int *paddleLSide, int *score);
void updatePaddle(volatile int* display, int *paddleLSide, int* newPaddlePos);
int isBrickAt(volatile int* display, int *xPos, int *yPos);
void displayScore(int *score, const int *numCodes, volatile int *leftLED, volatile int *rightLED);
void initBrickLayer(volatile int* display);