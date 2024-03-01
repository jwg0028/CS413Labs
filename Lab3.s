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
    push {r0, r1, r3, r4, lr}

    ldr r5, =total


inputLoop:

    ldr r0, =strYourTotal
    ldr r1, [r5]  @ Load the value of total
    bl printf


    ldr r0, =fmtChar
	ldr r1, =inputChar
	bl scanf

    ldr r1, =inputChar



    @section for branching based on coin inputted

    cmp r5, #55
    beq breakLoop

    ldr r0, =strTest
    bl printf

    cmp r1, #'n'
    beq nickelCase

    cmp r1, #'d'
    beq dimeCase

    cmp r1, #'q'
    beq quarterCase

    cmp r1, #'b'
    beq billCase
    
    b inputLoop


@section for breaking off and adding
nickelCase:
    add r5, r5, #5  @ Add nickel value to total
    b inputLoop  @ Continue input loop


dimeCase:  
    add r5, r5, #10  @ Add dime value to total
    b inputLoop  @ Continue input loop


quarterCase:
    add r5, r5, #25  @ Add quarter value to total
    b inputLoop  @ Continue input loop


billCase:
    add r5, r5, #100  @ Add bill value to total
    b inputLoop  @ Continue input loop


breakLoop:
    pop {r0, r1, r3, r4, r5, r6, r8, r9, pc}

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
strYourTotal: .asciz "Your total is: %d\n"

.balign 4
strTest: .asciz "Test"

.balign 4
fmtChar: .asciz "%c"

.balign 4
inputChar: .ascii ""

.balign 4
total: .word 0

@C library
.global printf

.global scanf