/*
File: Lab4.s
Author: Jacob Wade Godwin
Class: CS 413-02
Term: Spring 2024
Date: 3/22/2024

Software Description: This program simulates the process of using a vending machine.
You input how much money you wish to using coins, and then choose what drink you want.

Errors: The program unfortunately does not run. I was getting the error:
"Program recieved signal SIGILL, Illegal instruction.
0x00010f54 in ?? ()"
I believe it was in my input function, however, I cannot find it. It will run, but
it will only include the welcome message, then I get an "Illegal instruction" error.
My main issue with thumb is that I kind of get the general idea of some things, but I'm
still bad at managing memory properly, so that may be the root of the problem. I'm sorry, but
just can't figure it out.

Run command lines:
1) as -o Lab4.o Lab4.s -g && gcc -o lab4 Lab4.o -g
2) ./lab4


Debug lines
3) gdb ./Lab4

Registers used:
r0: General
r1: General
r2: General
r3: User total money
r4: number of cokes
r5: number of sprite
r6: number of dr. pepper
r7: number of coke zero 
*/
.global main

main:
    adr r0, thumb + 1
    bx r0
    .thumb
    .syntax unified

@start function
thumb:
    @this section sets all the registers to their correct starting values
    movs r4, #1
    movs r5, #2
    movs r6, #2
    movs r7, #2

    @Welcomes the user on startup
    ldr r0, =strHelloMessage
    bl printf

    @jumpt to masterLoop
    bl masterLoop


masterLoop:
    @every return to the master loop will reset the coins back to 0
    movs r3, #0

    @check for if the entire machine is empty
    add r10, r4, r5
    add r10, r10, r6
    add r10, r10, r7

    ldr r0, =strTest
    bl printf

    cmp r10, #0
    it eq
    beq exit

    @start in the input loop
    bl inputLoop


@loop for taking input. This input section is for the coin input
inputLoop:

    @if r3 is greater than or equal to 55 cents, move to the choiceLoop
    cmp r3, #55
    it ge
    bge choiceLoop

    ldr r0, =strInputLoop
    bl printf

    ldr r0, =strYourTotal
    movs r1, r3  @ Load the value of total
    bl printf


    ldr r0, =fmtChar
	ldr r1, =inputChar
	bl scanf


    ldr r1, =inputChar

    ldr r1, [r1]



    @section for branching based on coin inputted

    cmp r1, #'N'
    it eq
    beq nickelCase

    cmp r1, #'D'
    it eq
    beq dimeCase

    cmp r1, #'Q'
    it eq
    beq quarterCase

    cmp r1, #'B'
    it eq
    beq billCase

    @inventory check
    cmp r1, #'I'
    it eq
    beq inventoryCheck

    ldr r0, =strInvalid
    bl printf
    
    b inputLoop


@section for breaking off and adding
nickelCase:
    add r3, r3, #5  @ Add nickel value to total
    b inputLoop  @ Continue input loop


dimeCase:  
    add r3, r3, #10  @ Add dime value to total
    b inputLoop  @ Continue input loop

quarterCase:
    add r3, r3, #25  @ Add quarter value to total
    b inputLoop  @ Continue input loop


billCase:
    add r3, r3, #100  @ Add bill value to total
    b inputLoop  @ Continue input loop



@loop for choosing what drink you want. Only loops if the user either fails to input a correct answer, or the user choice in empty
choiceLoop:
    ldr r0, =strChoiceQuery
    movs r1, r3
    bl printf


    ldr r0, =fmtChar
	ldr r1, =inputChar
	bl scanf


    ldr r1, =inputChar

    ldr r1, [r1]



    @section for branching based on coin inputted
    @after each break into a drink, if there is no more of that drink, it will return to the choiceLoop
    @If a drink is chosen and there is one, one is deducted from the total for that drink and the user will return to the inputLoop

    cmp r1, #'C'
    it eq
    beq cokeCase

    cmp r1, #'S'
    it eq
    beq spriteCase

    cmp r1, #'P'
    it eq
    beq pepperCase

    cmp r1, #'Z'
    it eq
    beq zeroCase

    @leaving just resets the program essentially, because it returns to the masterLoop
    cmp r1, #'X'
    it eq
    beq leaveCase

    @Check inventory
    cmp r1, #'I'
    it eq
    beq inventoryCheck

    @error message
    ldr r0, =strInvalid
    bl printf
    
    b inputLoop

cokeCase:
    cmp r4, #0
    it eq
    beq emptyCase

    sub r3, r3, #55
    sub r4, r4, #1

    ldr r0, =strCoke
    movs r1, r3
    bl printf

    b masterLoop
spriteCase:
    cmp r5, #0
    it eq
    beq emptyCase

    sub r3, r3, #55
    sub r5, r5, #1

    ldr r0, =strSprite
    movs r1, r3
    bl printf

    b masterLoop
pepperCase:
    cmp r6, #0
    it eq
    beq emptyCase

    sub r3, r3, #55
    sub r6, r6, #1

    ldr r0, =strPepper
    movs r1, r3
    bl printf

    b masterLoop
zeroCase:
    cmp r7, #0
    it eq
    beq emptyCase

    sub r3, r3, #55
    sub r7, r7, #1

    ldr r0, =strZero
    movs r1, r3
    bl printf

    b masterLoop
leaveCase:
    ldr r0, =strLeave
    movs r1, r3
    bl printf

    b masterLoop

emptyCase:
    ldr r0, =strEmpty
    bl printf

    b choiceLoop

@inventoryCheck will check r3. If above 55, then the user came from choice loop. Less than 55, and they came from inputLoop
inventoryCheck:
    ldr r0, =strInventory1
    movs r1, r4
    movs r2, r5
    bl printf

    ldr r0, =strInventory2
    movs r1, r6
    movs r2, r7
    bl printf


    cmp r3, #55
    it ge
    bge choiceLoop
    blt inputLoop

@exit
exit:
    ldr r0, =strShutDown
    bl printf

    movs r6, #0x01
    movs r0, #0x00
    svc 0


@variable section
.data

.balign 4
strHelloMessage: .asciz "Welcome to Mr. Zippy's soft drink vending machine.\nCost of Coke, Sprite, Dr. Pepper, and Coke Zero is 55 cents.\n\n"

.balign 4
strTest: .asciz "Test"

.balign 4
strInputLoop: .asciz "Enter money nickel (N), dime (D), quarter (Q), and one dollar bill (B).\n"

.balign 4
strInvalid: .asciz "This is an invalid input, try again\n"

.balign 4
strYourTotal: .asciz "Your total is: %d cents\n"

.balign 4
strChoiceQuery: .asciz "Make selection:\n(C) Coke, (S) Sprite, (P) Dr. Pepper, or (Z) Coke Zero (X) to cancel and return all money.\nAvailable Money: %d\n"

.balign 4
strCoke: .asciz "Coke Dispensed\nReturned %d cents\n"

.balign 4
strSprite: .asciz "Sprite Dispensed\nReturned %d cents\n"

.balign 4
strPepper: .asciz "Dr. Pepper Dispensed\nReturned %d cents\n"

.balign 4
strZero: .asciz "Coke Zero Dispensed\nReturned %d cents\n"

.balign 4
strLeave: .asciz "Nothing was chosen\nReturned %d cents\n"

.balign 4
strInventory1: .asciz "Coke: %d\nSprite: %d\nPepsi: %d\nCoke Zero: %d\n"

.balign 4
strInventory2: .asciz "Coke: %d\nSprite: %d\nPepsi: %d\nCoke Zero: %d\n"

.balign 4
strEmpty: .asciz "There is no more of this selection"

.balign 4
strShutDown: .asciz "There is no more inventory left. The machine will now shut down\n"

.balign 4
fmtChar: .asciz " %c"

.balign 4
inputChar: .ascii "a"

.balign 4
total: .word 0

@C library
.global printf

.global scanf