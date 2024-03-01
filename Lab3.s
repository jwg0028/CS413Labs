/*
File: Lab_1.s
Author: Jacob Wade Godwin

Run command lines
1) as -o Lab1.o Lab1.s -g && gcc -o Lab1 Lab1.o -g
2) ./Lab1

(I tried to name it Lab_1.s but I don't think the raspberry pi likes underscores)

Debug lines
3) gdb ./Lab1


Registers used
r0: General
r1: General
r2: General
r3: General
r4: Counter for loops
r7: Used in exit function
r8: array1
r9: array2
r10: array3
*/
.global main

main:
    @Welcomes the user on startup
    ldr r0, =strHelloMessage
    bl printf

    ldr r0, =strInputLoop
    bl printf

    bl takeInput

    b exit

takeInput:
    push {r0, r1, r3, r4, r5, r8, lr}

    ldr r3, =total
    ldr r5, =target

inputLoop:




    ldr r0, =fmtChar
	ldr r1, =inputChar
	bl scanf

    ldr r1, =inputChar

    @section for branching based on coin inputted

    cmp r1, #'n'
    beq nickelCase

    cmp r1, #'d'
    beq dimeCase

    cmp r1, #'q'
    beq quarterCase

    cmp r1, #'b'
    beq billCase
    
breakLoop:
    pop {r0, r1, r4, r5, r8, pc}


@section for breaking off and adding
nickelCase:
    ldr r3, =nickelValue
    add r3, r5
    pop {r3}
    b inputLoop

dimeCase:  
    ldr r3, =dimeValue
    add r3, r5
    pop {r3}
    b inputLoop

quarterCase:
    ldr r3, =quarterValue
    add r3, r5
    pop {r3}
    b inputLoop

billCase:
    ldr r3, =billValuealue
    add r3, r5
    pop {r3}
    b inputLoop


exit:
    mov r7, #0x01
    mov r0, #0x00
    svc 0


@variable section
.data

.balign 4
strHelloMessage: .asciz "Welcome to Mr. Zippy's soft drink vending machine.\nCost of Coke, Sprite, Dr. Pepper, and Coke Zero is 55 cents.\n\n"

.balign 4
strInputLoop: .asciz "Enter money nickel (N), dime (D), quarter (Q), and one dollar bill (B).\n"

.balign 4
fmtChar: .asciz "%c"

.balign 4
inputChar: .ascii ""

.balign 4
nickelValue: .double 0.05

.balign 4
dimeValue: .double 0.10

.balign 4
quarterValue: .double 0.25

.balign 4
billValue: .double 1

.balign 4
target: .double 0.55

.balign 4
total: .double 0

@C library
.global printf

.global scanf