
c-and-assembly:     file format elf32-littleriscv


Disassembly of section .init:

00400000 <_start>:
    .extern __stack_init      # address of the initial top of C call stack (calculated externally 
                              # by linker)

	.globl _start
_start:                       # this is where CPU starts executing instructions after reset / power-on
	la sp,__stack_init        # initialise sp (with the value that points to the last word of RAM)
  400000:	0fc20117          	auipc	sp,0xfc20
  400004:	ffc10113          	addi	sp,sp,-4 # 1001fffc <__stack_init>
	li a0,0                   # populate optional main() parameters with dummy values (just in case)
  400008:	00000513          	li	a0,0
	li a1,0
  40000c:	00000593          	li	a1,0
	li a2,0
  400010:	00000613          	li	a2,0
	jal main                  # call C main() function
  400014:	008000ef          	jal	ra,40001c <main>

00400018 <exit>:
exit:
	j exit                    # keep looping forever after main() returns
  400018:	0000006f          	j	400018 <exit>

Disassembly of section .text:

0040001c <main>:

#include "lib.h"
#include "pictures.h"

int main()
{
  40001c:	fa010113          	addi	sp,sp,-96
  400020:	04112e23          	sw	ra,92(sp)
  400024:	04812c23          	sw	s0,88(sp)
    /* Start Screen */
	printstr("*** BREAKOUT! ***\n");
  400028:	00000517          	auipc	a0,0x0
  40002c:	58c50513          	addi	a0,a0,1420 # 4005b4 <initBrickLayer+0xc>
  400030:	170000ef          	jal	ra,4001a0 <printstr>
    printstr("Press START button\n");
  400034:	00000517          	auipc	a0,0x0
  400038:	59450513          	addi	a0,a0,1428 # 4005c8 <initBrickLayer+0x20>
  40003c:	164000ef          	jal	ra,4001a0 <printstr>
    while (pollkbd() != 255) {} // wait until START button is pressed
  400040:	0ff00413          	li	s0,255
  400044:	1f8000ef          	jal	ra,40023c <pollkbd>
  400048:	fe851ee3          	bne	a0,s0,400044 <main+0x28>
    printstr("Use the slider to move the paddle left or right!\n");
  40004c:	00000517          	auipc	a0,0x0
  400050:	59050513          	addi	a0,a0,1424 # 4005dc <initBrickLayer+0x34>
  400054:	14c000ef          	jal	ra,4001a0 <printstr>
    volatile int* display = (volatile int*) 0xffff8000; // Pointer to the monochrome display
    volatile int *rightLED = (volatile int *) 0xffff0010; // Right digit LED pointer
    volatile int *leftLED = (volatile int *) 0xffff0011; // Left digit LED pointer

    /* Ball Variables */
    int xPos = 15;
  400058:	00f00793          	li	a5,15
  40005c:	04f12623          	sw	a5,76(sp)
    int yPos = 15;
  400060:	04f12423          	sw	a5,72(sp)
    int xSpeed = 1;
  400064:	00100793          	li	a5,1
  400068:	04f12223          	sw	a5,68(sp)
    int ySpeed = 1;
  40006c:	04f12023          	sw	a5,64(sp)

    /* Paddle Variables */
    int paddleLSide = 0;
  400070:	02012e23          	sw	zero,60(sp)
    int newPaddlePos;
    
    // Brick Layer
    initBrickLayer(display); // Simple helper function written in assembly
  400074:	ffff8537          	lui	a0,0xffff8
  400078:	530000ef          	jal	ra,4005a8 <initBrickLayer>

    // Scoreboard
    int score = 0;
  40007c:	02012a23          	sw	zero,52(sp)
    const int numCodes[10] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x4F}; // Hex codes for 7-segment LED numbers
  400080:	00000797          	auipc	a5,0x0
  400084:	5bc78793          	addi	a5,a5,1468 # 40063c <initBrickLayer+0x94>
  400088:	0007ae03          	lw	t3,0(a5)
  40008c:	0047a303          	lw	t1,4(a5)
  400090:	0087a883          	lw	a7,8(a5)
  400094:	00c7a803          	lw	a6,12(a5)
  400098:	0107a503          	lw	a0,16(a5)
  40009c:	0147a583          	lw	a1,20(a5)
  4000a0:	0187a603          	lw	a2,24(a5)
  4000a4:	01c7a683          	lw	a3,28(a5)
  4000a8:	0207a703          	lw	a4,32(a5)
  4000ac:	0247a783          	lw	a5,36(a5)
  4000b0:	01c12623          	sw	t3,12(sp)
  4000b4:	00612823          	sw	t1,16(sp)
  4000b8:	01112a23          	sw	a7,20(sp)
  4000bc:	01012c23          	sw	a6,24(sp)
  4000c0:	00a12e23          	sw	a0,28(sp)
  4000c4:	02b12023          	sw	a1,32(sp)
  4000c8:	02c12223          	sw	a2,36(sp)
  4000cc:	02d12423          	sw	a3,40(sp)
  4000d0:	02e12623          	sw	a4,44(sp)
  4000d4:	02f12823          	sw	a5,48(sp)

    while(1)   // Game Loop
    {        
        newPaddlePos = readchar(); // read the slider position
  4000d8:	174000ef          	jal	ra,40024c <readchar>
  4000dc:	02a12c23          	sw	a0,56(sp)
        updatePaddle(display, &paddleLSide, &newPaddlePos); // update the position of the paddle accordingly
  4000e0:	03810613          	addi	a2,sp,56
  4000e4:	03c10593          	addi	a1,sp,60
  4000e8:	ffff8537          	lui	a0,0xffff8
  4000ec:	42c000ef          	jal	ra,400518 <updatePaddle>
        updateBall(display,&xPos,&yPos,&xSpeed,&ySpeed,&paddleLSide,&score); // update the position of the ball
  4000f0:	03410813          	addi	a6,sp,52
  4000f4:	03c10793          	addi	a5,sp,60
  4000f8:	04010713          	addi	a4,sp,64
  4000fc:	04410693          	addi	a3,sp,68
  400100:	04810613          	addi	a2,sp,72
  400104:	04c10593          	addi	a1,sp,76
  400108:	ffff8537          	lui	a0,0xffff8
  40010c:	258000ef          	jal	ra,400364 <updateBall>
        displayScore(&score, numCodes, leftLED, rightLED); // display the score on the LEDS
  400110:	ffff0637          	lui	a2,0xffff0
  400114:	01060693          	addi	a3,a2,16 # ffff0010 <__stack_init+0xeffd0014>
  400118:	01160613          	addi	a2,a2,17
  40011c:	00c10593          	addi	a1,sp,12
  400120:	03410513          	addi	a0,sp,52
  400124:	450000ef          	jal	ra,400574 <displayScore>
        if (yPos > 31) { // if the ball goes out of bounds
  400128:	04812703          	lw	a4,72(sp)
  40012c:	01f00793          	li	a5,31
  400130:	fae7d4e3          	bge	a5,a4,4000d8 <main+0xbc>
            printstr("*** GAME OVER ***\n");
  400134:	00000517          	auipc	a0,0x0
  400138:	4dc50513          	addi	a0,a0,1244 # 400610 <initBrickLayer+0x68>
  40013c:	064000ef          	jal	ra,4001a0 <printstr>
            break;
        }
    }
    printstr("You earned ");
  400140:	00000517          	auipc	a0,0x0
  400144:	4e450513          	addi	a0,a0,1252 # 400624 <initBrickLayer+0x7c>
  400148:	058000ef          	jal	ra,4001a0 <printstr>
    printint(score);
  40014c:	03412503          	lw	a0,52(sp)
  400150:	070000ef          	jal	ra,4001c0 <printint>
    printstr(" points!\n");
  400154:	00000517          	auipc	a0,0x0
  400158:	4dc50513          	addi	a0,a0,1244 # 400630 <initBrickLayer+0x88>
  40015c:	044000ef          	jal	ra,4001a0 <printstr>

    return 1;
}
  400160:	00100513          	li	a0,1
  400164:	05c12083          	lw	ra,92(sp)
  400168:	05812403          	lw	s0,88(sp)
  40016c:	06010113          	addi	sp,sp,96
  400170:	00008067          	ret

00400174 <abs>:
 */

#include "lib.h"

// returns absolute value of its integer argument - a replacement of the standard library function abs() 
inline int abs(int n) { return (n < 0) ? (-n) : n; }
  400174:	41f55793          	srai	a5,a0,0x1f
  400178:	00a7c533          	xor	a0,a5,a0
  40017c:	40f50533          	sub	a0,a0,a5
  400180:	00008067          	ret

00400184 <printchar>:

// prints single character to console - a substitute for the standard library funciton putch(int chr)
inline void printchar(char chr) { *(TDR) = chr; }  // write into TDR 
  400184:	ffff07b7          	lui	a5,0xffff0
  400188:	00a78623          	sb	a0,12(a5) # ffff000c <__stack_init+0xeffd0010>
  40018c:	00008067          	ret

00400190 <println>:
  400190:	ffff07b7          	lui	a5,0xffff0
  400194:	00a00713          	li	a4,10
  400198:	00e78623          	sb	a4,12(a5) # ffff000c <__stack_init+0xeffd0010>

// prints newline character to console
void println() { printchar('\n'); }
  40019c:	00008067          	ret

004001a0 <printstr>:

// prints given string of characters to console - a substitute for the standard library function puts(char *s)
void printstr(char *str)
{
    while (*str != '\0') 
  4001a0:	00054783          	lbu	a5,0(a0)
  4001a4:	00078c63          	beqz	a5,4001bc <printstr+0x1c>
inline void printchar(char chr) { *(TDR) = chr; }  // write into TDR 
  4001a8:	ffff0737          	lui	a4,0xffff0
  4001ac:	00f70623          	sb	a5,12(a4) # ffff000c <__stack_init+0xeffd0010>
    {
        printchar(*str);
        str += 1;
  4001b0:	00150513          	addi	a0,a0,1
    while (*str != '\0') 
  4001b4:	00054783          	lbu	a5,0(a0)
  4001b8:	fe079ae3          	bnez	a5,4001ac <printstr+0xc>
    }
}
  4001bc:	00008067          	ret

004001c0 <printint>:

// prints given integer as a signed decimal number
void printint(int n)
{
  4001c0:	ff010113          	addi	sp,sp,-16
    {
        sign = '-';
    }
    else
    {
        sign = '\0';
  4001c4:	41f55813          	srai	a6,a0,0x1f
  4001c8:	02d87813          	andi	a6,a6,45
  4001cc:	00410713          	addi	a4,sp,4
  4001d0:	00900613          	li	a2,9
    
    // produce decimal digits of the number going from right to left, keep them in num[] array.
    do 
    {
        i = i - 1;
        num[i] = abs(n % 10) + '0';
  4001d4:	00a00593          	li	a1,10
        i = i - 1;
  4001d8:	fff60613          	addi	a2,a2,-1
        num[i] = abs(n % 10) + '0';
  4001dc:	02b567b3          	rem	a5,a0,a1
  4001e0:	41f7d693          	srai	a3,a5,0x1f
  4001e4:	00f6c7b3          	xor	a5,a3,a5
  4001e8:	40d787b3          	sub	a5,a5,a3
  4001ec:	03078793          	addi	a5,a5,48
  4001f0:	00f70423          	sb	a5,8(a4)
        n = n / 10;
  4001f4:	02b54533          	div	a0,a0,a1
    } while (n != 0);
  4001f8:	fff70713          	addi	a4,a4,-1
  4001fc:	fc051ee3          	bnez	a0,4001d8 <printint+0x18>
    
    //now print the sign of the number and its digits left-to-right.
    if (sign) 
  400200:	00080663          	beqz	a6,40020c <printint+0x4c>
inline void printchar(char chr) { *(TDR) = chr; }  // write into TDR 
  400204:	ffff07b7          	lui	a5,0xffff0
  400208:	01078623          	sb	a6,12(a5) # ffff000c <__stack_init+0xeffd0010>
    {
        printchar(sign);
    }
    
    while(i < MAX_INT_DIGITS)
  40020c:	00900793          	li	a5,9
  400210:	02c7c263          	blt	a5,a2,400234 <printint+0x74>
  400214:	00410793          	addi	a5,sp,4
  400218:	00c787b3          	add	a5,a5,a2
  40021c:	00e10693          	addi	a3,sp,14
inline void printchar(char chr) { *(TDR) = chr; }  // write into TDR 
  400220:	ffff0637          	lui	a2,0xffff0
    {
        printchar(num[i]);
  400224:	0007c703          	lbu	a4,0(a5)
inline void printchar(char chr) { *(TDR) = chr; }  // write into TDR 
  400228:	00e60623          	sb	a4,12(a2) # ffff000c <__stack_init+0xeffd0010>
    while(i < MAX_INT_DIGITS)
  40022c:	00178793          	addi	a5,a5,1
  400230:	fed79ae3          	bne	a5,a3,400224 <printint+0x64>
        i=i+1;
    }
}
  400234:	01010113          	addi	sp,sp,16
  400238:	00008067          	ret

0040023c <pollkbd>:


// check if keyboard buffer has some data
inline int pollkbd() { return *(RCR); } // returns value of RCR  (don't forget to specify "volatile"!) 
  40023c:	ffff07b7          	lui	a5,0xffff0
  400240:	0007c503          	lbu	a0,0(a5) # ffff0000 <__stack_init+0xeffd0004>
  400244:	0ff57513          	andi	a0,a0,255
  400248:	00008067          	ret

0040024c <readchar>:

// read next character from keyboard buffer
//inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
inline int readchar() { return *(RDR); } // returns value of RDR  (don't forget to specify "volatile"!) 
  40024c:	ffff07b7          	lui	a5,0xffff0
  400250:	0047c503          	lbu	a0,4(a5) # ffff0004 <__stack_init+0xeffd0008>
  400254:	0ff57513          	andi	a0,a0,255
  400258:	00008067          	ret

0040025c <readstr>:

// read characters into provided buffer until either user presses enter or the buffer size is reached.
int readstr(char *buf, int size)
{
  40025c:	00050693          	mv	a3,a0
    int count;
    
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
  400260:	00100793          	li	a5,1
  400264:	04b7d463          	bge	a5,a1,4002ac <readstr+0x50>
  400268:	fff58613          	addi	a2,a1,-1
    
    count = 0;
  40026c:	00000513          	li	a0,0
inline int pollkbd() { return *(RCR); } // returns value of RCR  (don't forget to specify "volatile"!) 
  400270:	ffff0737          	lui	a4,0xffff0
       
       // read next character into the current element of the buffer
       *buf = (char)readchar();
       
       // if the user pressed Enter, stop reading
       if (*buf == ENTER_CHAR_CODE) 
  400274:	00a00593          	li	a1,10
inline int pollkbd() { return *(RCR); } // returns value of RCR  (don't forget to specify "volatile"!) 
  400278:	00074783          	lbu	a5,0(a4) # ffff0000 <__stack_init+0xeffd0004>
       while ((pollkbd() & RDR_READY_BIT) == 0) 
  40027c:	0017f793          	andi	a5,a5,1
  400280:	fe078ce3          	beqz	a5,400278 <readstr+0x1c>
inline int readchar() { return *(RDR); } // returns value of RDR  (don't forget to specify "volatile"!) 
  400284:	00474783          	lbu	a5,4(a4)
  400288:	0ff7f793          	andi	a5,a5,255
       *buf = (char)readchar();
  40028c:	00f68023          	sb	a5,0(a3)
       if (*buf == ENTER_CHAR_CODE) 
  400290:	00b78a63          	beq	a5,a1,4002a4 <readstr+0x48>
       {
           break;
       }
       
       // move pointer to the next element of the buffer
       buf += 1;
  400294:	00168693          	addi	a3,a3,1
       
       // increase the number of characters in the buffer
       count += 1;
  400298:	00150513          	addi	a0,a0,1
       
       // decrease the remaining space in the buffer
       size -= 1;
       
    } while(size > 1);  // keep going until one empty char remains (to hold the final '\0' character
  40029c:	fcc51ee3          	bne	a0,a2,400278 <readstr+0x1c>
       count += 1;
  4002a0:	00060513          	mv	a0,a2
    
    *buf = '\0';  // add the end-of-string marker '\0'
  4002a4:	00068023          	sb	zero,0(a3)
    
    return count; // return the number of characters in the read string
  4002a8:	00008067          	ret
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
  4002ac:	fff00513          	li	a0,-1
}
  4002b0:	00008067          	ret

004002b4 <readint>:

//read signed integer
int readint()
{
    int res = 0;
    int sign = 1;
  4002b4:	00100593          	li	a1,1
    int res = 0;
  4002b8:	00000513          	li	a0,0
inline int pollkbd() { return *(RCR); } // returns value of RCR  (don't forget to specify "volatile"!) 
  4002bc:	ffff0737          	lui	a4,0xffff0
           sign = -1;
       }
       else
       {
           // otherwise, if a non-digit is read, it signifies the end of the number
           if (chr < '0' || chr > '9') 
  4002c0:	00900613          	li	a2,9
       if (res == 0 && sign == 1 && chr == '-') 
  4002c4:	00100813          	li	a6,1
  4002c8:	02d00893          	li	a7,45
           sign = -1;
  4002cc:	fff00313          	li	t1,-1
  4002d0:	0200006f          	j	4002f0 <readint+0x3c>
           if (chr < '0' || chr > '9') 
  4002d4:	fd078693          	addi	a3,a5,-48
  4002d8:	04d66063          	bltu	a2,a3,400318 <readint+0x64>
           {
               break;
           }
           // incorporate the read digit into the number (N.B. chr - '0' gived the digit value).
           res = res * 10 + (chr - '0');
  4002dc:	00251693          	slli	a3,a0,0x2
  4002e0:	00a686b3          	add	a3,a3,a0
  4002e4:	00169693          	slli	a3,a3,0x1
  4002e8:	fd078793          	addi	a5,a5,-48
  4002ec:	00d78533          	add	a0,a5,a3
inline int pollkbd() { return *(RCR); } // returns value of RCR  (don't forget to specify "volatile"!) 
  4002f0:	00074783          	lbu	a5,0(a4) # ffff0000 <__stack_init+0xeffd0004>
       while ((pollkbd() & RDR_READY_BIT) == 0) 
  4002f4:	0017f793          	andi	a5,a5,1
  4002f8:	fe078ce3          	beqz	a5,4002f0 <readint+0x3c>
inline int readchar() { return *(RDR); } // returns value of RDR  (don't forget to specify "volatile"!) 
  4002fc:	00474783          	lbu	a5,4(a4)
  400300:	0ff7f793          	andi	a5,a5,255
       if (res == 0 && sign == 1 && chr == '-') 
  400304:	fc0518e3          	bnez	a0,4002d4 <readint+0x20>
  400308:	fd0596e3          	bne	a1,a6,4002d4 <readint+0x20>
  40030c:	fd1794e3          	bne	a5,a7,4002d4 <readint+0x20>
           sign = -1;
  400310:	00030593          	mv	a1,t1
  400314:	fddff06f          	j	4002f0 <readint+0x3c>
       }
    }
    
    // return the absolute value of the number (constructed from entered digits) multiplied by the sign.
    return sign * res;
}
  400318:	02a58533          	mul	a0,a1,a0
  40031c:	00008067          	ret

00400320 <showpic>:
    # as long as this function is not calling other functions.
    
    .globl showpic
    
showpic:
    li t0,0xffff8000    # starting address of the graphics display
  400320:	ffff82b7          	lui	t0,0xffff8
    li t1,32            # number of lines on the display (each word encodes one line) 
  400324:	02000313          	li	t1,32

00400328 <loop>:
loop:
    lw t2,0(a0)         # load next line (word) of the picture data
  400328:	00052383          	lw	t2,0(a0)
    sw t2,0(t0)         # write it to the corresponding line of the graphics display
  40032c:	0072a023          	sw	t2,0(t0) # ffff8000 <__stack_init+0xeffd8004>
    addi t0,t0,4        # move to the next line of the graphics display
  400330:	00428293          	addi	t0,t0,4
    addi a0,a0,4        # move to the next line of the picture data
  400334:	00450513          	addi	a0,a0,4
    addi t1,t1,-1       # reduce the number of remaining lines
  400338:	fff30313          	addi	t1,t1,-1
    bnez t1,loop        # keep going until all lines on the display are filled with data
  40033c:	fe0316e3          	bnez	t1,400328 <loop>
    jr ra               # return 
  400340:	00008067          	ret

00400344 <isBrickAt>:
        0b11111000000000000000000000000000,
        0b00000000000000000000000000000000     
};

int isBrickAt(volatile int* display, int *xPos, int *yPos) {
        if (display[*yPos] & (1 << *xPos)) return 1;
  400344:	00062783          	lw	a5,0(a2)
  400348:	00279793          	slli	a5,a5,0x2
  40034c:	00f50533          	add	a0,a0,a5
  400350:	00052503          	lw	a0,0(a0)
  400354:	0005a783          	lw	a5,0(a1)
  400358:	40f55533          	sra	a0,a0,a5
        else return 0;
}
  40035c:	00157513          	andi	a0,a0,1
  400360:	00008067          	ret

00400364 <updateBall>:

void updateBall(volatile int* display, int *xPos, int *yPos, int *xSpeed, int *ySpeed, int *paddleLSide, int *score) {
  400364:	fe010113          	addi	sp,sp,-32
  400368:	00112e23          	sw	ra,28(sp)
  40036c:	00812c23          	sw	s0,24(sp)
  400370:	00912a23          	sw	s1,20(sp)
  400374:	01212823          	sw	s2,16(sp)
  400378:	01312623          	sw	s3,12(sp)
  40037c:	01412423          	sw	s4,8(sp)
  400380:	00050913          	mv	s2,a0
  400384:	00058493          	mv	s1,a1
  400388:	00060413          	mv	s0,a2
  40038c:	00070993          	mv	s3,a4
  400390:	00080a13          	mv	s4,a6
        display[*yPos] &= ~(1 << *xPos); // only clear the row with the ball in it
  400394:	00062583          	lw	a1,0(a2)
  400398:	00259593          	slli	a1,a1,0x2
  40039c:	00b505b3          	add	a1,a0,a1
  4003a0:	0005a703          	lw	a4,0(a1)
  4003a4:	0004a503          	lw	a0,0(s1)
  4003a8:	00100613          	li	a2,1
  4003ac:	00a61633          	sll	a2,a2,a0
  4003b0:	fff64613          	not	a2,a2
  4003b4:	00e67633          	and	a2,a2,a4
  4003b8:	00c5a023          	sw	a2,0(a1)
	
    	*xPos += *xSpeed; // update the x position depending on the horizontal direction
  4003bc:	0004a703          	lw	a4,0(s1)
  4003c0:	0006a603          	lw	a2,0(a3)
  4003c4:	00c70733          	add	a4,a4,a2
  4003c8:	00e4a023          	sw	a4,0(s1)
    	*yPos += *ySpeed; // update the y position depending on the vertical direction
  4003cc:	00042703          	lw	a4,0(s0)
  4003d0:	0009a603          	lw	a2,0(s3)
  4003d4:	00c70733          	add	a4,a4,a2
  4003d8:	00e42023          	sw	a4,0(s0)

        // Border collision checks
    	if (*xPos <= 0 || *xPos >= SCREEN_WIDTH - 1) { // if the horizontal position is at either side of the border
  4003dc:	0004a703          	lw	a4,0(s1)
  4003e0:	fff70713          	addi	a4,a4,-1
  4003e4:	01d00613          	li	a2,29
  4003e8:	00e67863          	bgeu	a2,a4,4003f8 <updateBall+0x94>
                *xSpeed *= -1;
  4003ec:	0006a703          	lw	a4,0(a3)
  4003f0:	40e00733          	neg	a4,a4
  4003f4:	00e6a023          	sw	a4,0(a3)
    	}
    	if (*yPos <= 0) { // if the vertical position is at the top of the screen
  4003f8:	00042703          	lw	a4,0(s0)
  4003fc:	06e05a63          	blez	a4,400470 <updateBall+0x10c>
        	*ySpeed *= -1;
    	}
        
        // Paddle Collision Checks
        if (*yPos == SCREEN_HEIGHT - 1) { // if the ball is at the bottom row with the paddle
  400400:	00042603          	lw	a2,0(s0)
  400404:	01f00713          	li	a4,31
  400408:	06e60c63          	beq	a2,a4,400480 <updateBall+0x11c>
                        }
                }
        }

        // Brick Collision Checks
        if (isBrickAt(display,xPos,yPos)) {
  40040c:	00040613          	mv	a2,s0
  400410:	00048593          	mv	a1,s1
  400414:	00090513          	mv	a0,s2
  400418:	f2dff0ef          	jal	ra,400344 <isBrickAt>
  40041c:	00050863          	beqz	a0,40042c <updateBall+0xc8>
                if (*yPos == 8) { // if the ball position is on the same layer as the brick layer (8)
  400420:	00042703          	lw	a4,0(s0)
  400424:	00800793          	li	a5,8
  400428:	0af70263          	beq	a4,a5,4004cc <updateBall+0x168>
                        *yPos += (*ySpeed) * 2; // corrects the position of the ball 
                        (*score)++; // increment score
                }
        }

    	display[*yPos] |= (1 << *xPos); // update the row with this new position
  40042c:	00042503          	lw	a0,0(s0)
  400430:	00251513          	slli	a0,a0,0x2
  400434:	00a90933          	add	s2,s2,a0
  400438:	00092703          	lw	a4,0(s2)
  40043c:	0004a683          	lw	a3,0(s1)
  400440:	00100793          	li	a5,1
  400444:	00d797b3          	sll	a5,a5,a3
  400448:	00e7e7b3          	or	a5,a5,a4
  40044c:	00f92023          	sw	a5,0(s2)
}
  400450:	01c12083          	lw	ra,28(sp)
  400454:	01812403          	lw	s0,24(sp)
  400458:	01412483          	lw	s1,20(sp)
  40045c:	01012903          	lw	s2,16(sp)
  400460:	00c12983          	lw	s3,12(sp)
  400464:	00812a03          	lw	s4,8(sp)
  400468:	02010113          	addi	sp,sp,32
  40046c:	00008067          	ret
        	*ySpeed *= -1;
  400470:	0009a703          	lw	a4,0(s3)
  400474:	40e00733          	neg	a4,a4
  400478:	00e9a023          	sw	a4,0(s3)
  40047c:	f85ff06f          	j	400400 <updateBall+0x9c>
                for (int i = *paddleLSide; i < *paddleLSide + 5; i++) {
  400480:	0007a783          	lw	a5,0(a5)
  400484:	00478613          	addi	a2,a5,4
                        if (*xPos == i) { // if ball is at the same position as the paddle
  400488:	0004a703          	lw	a4,0(s1)
  40048c:	00f70863          	beq	a4,a5,40049c <updateBall+0x138>
                for (int i = *paddleLSide; i < *paddleLSide + 5; i++) {
  400490:	00178793          	addi	a5,a5,1
  400494:	fef65ce3          	bge	a2,a5,40048c <updateBall+0x128>
  400498:	f75ff06f          	j	40040c <updateBall+0xa8>
                                *ySpeed *= -1;
  40049c:	0009a783          	lw	a5,0(s3)
  4004a0:	40f007b3          	neg	a5,a5
  4004a4:	00f9a023          	sw	a5,0(s3)
                                *xPos -= *xSpeed;
  4004a8:	0004a783          	lw	a5,0(s1)
  4004ac:	0006a703          	lw	a4,0(a3)
  4004b0:	40e787b3          	sub	a5,a5,a4
  4004b4:	00f4a023          	sw	a5,0(s1)
                                *yPos += *ySpeed; // These two operations make it bounce off the paddle
  4004b8:	00042783          	lw	a5,0(s0)
  4004bc:	0009a703          	lw	a4,0(s3)
  4004c0:	00e787b3          	add	a5,a5,a4
  4004c4:	00f42023          	sw	a5,0(s0)
                                break;
  4004c8:	f45ff06f          	j	40040c <updateBall+0xa8>
                        display[*yPos] &= ~(1 << (*xPos+1)); // get rid of brick above the ball
  4004cc:	02092683          	lw	a3,32(s2)
  4004d0:	0004a783          	lw	a5,0(s1)
  4004d4:	00178713          	addi	a4,a5,1
  4004d8:	00100793          	li	a5,1
  4004dc:	00e797b3          	sll	a5,a5,a4
  4004e0:	fff7c793          	not	a5,a5
  4004e4:	00d7f7b3          	and	a5,a5,a3
  4004e8:	02f92023          	sw	a5,32(s2)
                        *ySpeed *= -1;
  4004ec:	0009a783          	lw	a5,0(s3)
  4004f0:	40f007b3          	neg	a5,a5
  4004f4:	00f9a023          	sw	a5,0(s3)
                        *yPos += (*ySpeed) * 2; // corrects the position of the ball 
  4004f8:	00179793          	slli	a5,a5,0x1
  4004fc:	00042703          	lw	a4,0(s0)
  400500:	00f707b3          	add	a5,a4,a5
  400504:	00f42023          	sw	a5,0(s0)
                        (*score)++; // increment score
  400508:	000a2783          	lw	a5,0(s4)
  40050c:	00178793          	addi	a5,a5,1
  400510:	00fa2023          	sw	a5,0(s4)
  400514:	f19ff06f          	j	40042c <updateBall+0xc8>

00400518 <updatePaddle>:
void updatePaddle(volatile int* display, int *paddleLSide, int *newPaddlePos) {
        display[SCREEN_HEIGHT - 1] = 0; // Clear the bottom row
  400518:	06052e23          	sw	zero,124(a0)
        *paddleLSide = *newPaddlePos;
  40051c:	00062783          	lw	a5,0(a2)
        
        if (*newPaddlePos > SCREEN_WIDTH - 5) { // ensures paddle doesn't go out of bounds
  400520:	01b00713          	li	a4,27
  400524:	02f75e63          	bge	a4,a5,400560 <updatePaddle+0x48>
                *paddleLSide = SCREEN_WIDTH - 5;
  400528:	01b00793          	li	a5,27
  40052c:	00f5a023          	sw	a5,0(a1)
void updatePaddle(volatile int* display, int *paddleLSide, int *newPaddlePos) {
  400530:	00000713          	li	a4,0
        } else if (*paddleLSide < 0) {
                *paddleLSide = 0;
        }
        
        for (int i = 0; i < 5; i++) { // redraw the paddle
                display[SCREEN_HEIGHT - 1] |= (1 << (*paddleLSide + i));
  400534:	00100813          	li	a6,1
        for (int i = 0; i < 5; i++) { // redraw the paddle
  400538:	00500613          	li	a2,5
                display[SCREEN_HEIGHT - 1] |= (1 << (*paddleLSide + i));
  40053c:	07c52683          	lw	a3,124(a0)
  400540:	0005a783          	lw	a5,0(a1)
  400544:	00f707b3          	add	a5,a4,a5
  400548:	00f817b3          	sll	a5,a6,a5
  40054c:	00d7e7b3          	or	a5,a5,a3
  400550:	06f52e23          	sw	a5,124(a0)
        for (int i = 0; i < 5; i++) { // redraw the paddle
  400554:	00170713          	addi	a4,a4,1
  400558:	fec712e3          	bne	a4,a2,40053c <updatePaddle+0x24>
        }
}
  40055c:	00008067          	ret
        } else if (*paddleLSide < 0) {
  400560:	0007c663          	bltz	a5,40056c <updatePaddle+0x54>
        *paddleLSide = *newPaddlePos;
  400564:	00f5a023          	sw	a5,0(a1)
  400568:	fc9ff06f          	j	400530 <updatePaddle+0x18>
                *paddleLSide = 0;
  40056c:	0005a023          	sw	zero,0(a1)
  400570:	fc1ff06f          	j	400530 <updatePaddle+0x18>

00400574 <displayScore>:
void displayScore(int *score, const int *numCodes, volatile int *leftLED, volatile int *rightLED) {
        int leftDigit = (*score) / 10;
  400574:	00052783          	lw	a5,0(a0)
  400578:	00a00513          	li	a0,10
  40057c:	02a7c733          	div	a4,a5,a0
        int rightDigit = (*score) % 10;
        
        *leftLED = numCodes[leftDigit];
  400580:	00271713          	slli	a4,a4,0x2
  400584:	00e58733          	add	a4,a1,a4
  400588:	00072703          	lw	a4,0(a4)
  40058c:	00e62023          	sw	a4,0(a2)
        int rightDigit = (*score) % 10;
  400590:	02a7e7b3          	rem	a5,a5,a0
        *rightLED = numCodes[rightDigit];
  400594:	00279793          	slli	a5,a5,0x2
  400598:	00f585b3          	add	a1,a1,a5
  40059c:	0005a783          	lw	a5,0(a1)
  4005a0:	00f6a023          	sw	a5,0(a3)
  4005a4:	00008067          	ret

004005a8 <initBrickLayer>:
	#	a0 - display array
	
	.globl initBrickLayer
	
initBrickLayer:
	li t0, 0xffffffff 	# load hex value with all bits set to 1
  4005a8:	fff00293          	li	t0,-1
	sw t0, 32(a0) 		# store this value in display[8]
  4005ac:	02552023          	sw	t0,32(a0)
	jr ra 				# exit function
  4005b0:	00008067          	ret
