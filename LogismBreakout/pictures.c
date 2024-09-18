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

#include "pictures.h"
#define SCREEN_HEIGHT (32)
#define SCREEN_WIDTH (32)

// Given below is an array of two arrays, where each of the sub-arrays contains a 32x32 picture for the graphics dislay 
// that can be displayed using showpic() function.

// Please note that because of the way demo.lds is written, .data section will be placed in ROM, 
// which effectively makes all *initialised* global variables *constant*, even if they are not declared as such!

int picture[32]=
{
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,     
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,     
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,     
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,     
        0b00000000000000000000000000000000, 
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,    
        0b00000000000000000000000000000000,    
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,    
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,     
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,     
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,    
        0b00000000000000000000000000000000,
        0b00000000000000000000000000000000,
        0b11111000000000000000000000000000,
        0b00000000000000000000000000000000     
};

int isBrickAt(volatile int* display, int *xPos, int *yPos) {
        if (display[*yPos] & (1 << *xPos)) return 1;
        else return 0;
}

void updateBall(volatile int* display, int *xPos, int *yPos, int *xSpeed, int *ySpeed, int *paddleLSide, int *score) {
        display[*yPos] &= ~(1 << *xPos); // only clear the row with the ball in it
	
    	*xPos += *xSpeed; // update the x position depending on the horizontal direction
    	*yPos += *ySpeed; // update the y position depending on the vertical direction

        // Border collision checks
    	if (*xPos <= 0 || *xPos >= SCREEN_WIDTH - 1) { // if the horizontal position is at either side of the border
                *xSpeed *= -1;
    	}
    	if (*yPos <= 0) { // if the vertical position is at the top of the screen
        	*ySpeed *= -1;
    	}
        
        // Paddle Collision Checks
        if (*yPos == SCREEN_HEIGHT - 1) { // if the ball is at the bottom row with the paddle
                for (int i = *paddleLSide; i < *paddleLSide + 5; i++) {
                        if (*xPos == i) { // if ball is at the same position as the paddle
                                *ySpeed *= -1;
                                *xPos -= *xSpeed;
                                *yPos += *ySpeed; // These two operations make it bounce off the paddle
                                break;
                        }
                }
        }

        // Brick Collision Checks
        if (isBrickAt(display,xPos,yPos)) {
                if (*yPos == 8) { // if the ball position is on the same layer as the brick layer (8)
                        display[*yPos] &= ~(1 << (*xPos+1)); // get rid of brick above the ball
                        *ySpeed *= -1;
                        *yPos += (*ySpeed) * 2; // corrects the position of the ball 
                        (*score)++; // increment score
                }
        }

    	display[*yPos] |= (1 << *xPos); // update the row with this new position
}
void updatePaddle(volatile int* display, int *paddleLSide, int *newPaddlePos) {
        display[SCREEN_HEIGHT - 1] = 0; // Clear the bottom row
        *paddleLSide = *newPaddlePos;
        
        if (*newPaddlePos > SCREEN_WIDTH - 5) { // ensures paddle doesn't go out of bounds
                *paddleLSide = SCREEN_WIDTH - 5;
        } else if (*paddleLSide < 0) {
                *paddleLSide = 0;
        }
        
        for (int i = 0; i < 5; i++) { // redraw the paddle
                display[SCREEN_HEIGHT - 1] |= (1 << (*paddleLSide + i));
        }
}
void displayScore(int *score, const int *numCodes, volatile int *leftLED, volatile int *rightLED) {
        int leftDigit = (*score) / 10;
        int rightDigit = (*score) % 10;
        
        *leftLED = numCodes[leftDigit];
        *rightLED = numCodes[rightDigit];
}