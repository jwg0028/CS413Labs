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
    push {r0, r1, r3, r4, r5, r6, r8, r9, lr}

    ldr r8, =total
    ldr r5, [r8]
    ldr r9, =target
    ldr r6, [r9]

inputLoop:




    ldr r0, =fmtChar
	ldr r1, =inputChar
	bl scanf

    ldr r1, =inputChar

    @section for branching based on coin inputted

    cmp r5, r6
    bge breakLoop

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
    ldr r3, =nickelValue
    ldr r4, [r3]  @ Load value of nickel
    add r8, r8, r4  @ Add nickel value to total
    b inputLoop  @ Continue input loop

dimeCase:  
    ldr r3, =dimeValue
    ldr r4, [r3]  @ Load value of dime
    add r8, r8, r4  @ Add dime value to total
    b inputLoop  @ Continue input loop

quarterCase:
    ldr r3, =quarterValue
    ldr r4, [r3]  @ Load value of quarter
    add r8, r8, r4  @ Add quarter value to total
    b inputLoop  @ Continue input loop

billCase:
    ldr r3, =billValue
    ldr r4, [r3]  @ Load value of bill
    add r8, r8, r4  @ Add bill value to total
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