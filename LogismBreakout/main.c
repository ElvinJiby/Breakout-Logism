/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This example shows how graphics display can be used to dsisplay pictures.
 * 
 * the showpic() function that fills graphics display with the given picture is 
 * written in assembly language (it is in the file showpic.s). 
 * It is declared at the end of lib.h
 * 
 * The picture data for two pictures is defined in pictures.c file,
 * the pictures[] array is declared in pictures.h header file.
 */

/*
 * 28/02/2024
 * Introduction to Operating Systems - Assignment 1
 * Made By Elvin Jiby
 *
 * Code that simulates breakout in Logism
 */

#include "lib.h"
#include "pictures.h"

int main()
{
    /* Start Screen */
	printstr("*** BREAKOUT! ***\n");
    printstr("Press START button\n");
    while (pollkbd() != 255) {} // wait until START button is pressed
    printstr("Use the slider to move the paddle left or right!\n");


    volatile int* display = (volatile int*) 0xffff8000; // Pointer to the monochrome display
    volatile int *rightLED = (volatile int *) 0xffff0010; // Right digit LED pointer
    volatile int *leftLED = (volatile int *) 0xffff0011; // Left digit LED pointer

    /* Ball Variables */
    int xPos = 15;
    int yPos = 15;
    int xSpeed = 1;
    int ySpeed = 1;

    /* Paddle Variables */
    int paddleLSide = 0;
    int newPaddlePos;
    
    // Brick Layer
    initBrickLayer(display); // Simple helper function written in assembly

    // Scoreboard
    int score = 0;
    const int numCodes[10] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x4F}; // Hex codes for 7-segment LED numbers

    while(1)   // Game Loop
    {        
        newPaddlePos = readchar(); // read the slider position
        updatePaddle(display, &paddleLSide, &newPaddlePos); // update the position of the paddle accordingly
        updateBall(display,&xPos,&yPos,&xSpeed,&ySpeed,&paddleLSide,&score); // update the position of the ball
        displayScore(&score, numCodes, leftLED, rightLED); // display the score on the LEDS
        if (yPos > 31) { // if the ball goes out of bounds
            printstr("*** GAME OVER ***\n");
            break;
        }
    }
    printstr("You earned ");
    printint(score);
    printstr(" points!\n");

    return 1;
}
