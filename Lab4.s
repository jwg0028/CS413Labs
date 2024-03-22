/*
File: Lab_1.s
Author: Jacob Wade Godwin
Class: CS 413-02
Term: Spring 2024
Date: 3/1/2024

Software Description: This program simulates the process of using a vending machine.
You input how much money you wish to using coins, and then choose what drink you want.

Errors: That I know of, just the fact that entering multiple letters will read as multiple inputs.
However if they are incorrect the software will correctly react as such

Run command lines
1) as -o Lab3.o Lab3.s -g && gcc -o lab3 Lab3.o -g
2) ./lab3


Debug lines
3) gdb ./Lab3

Registers used:
r0: General
r1: General
r2: General
r3: General
r4: General
r5: user's total money
r6: number of cokes
r7: number of sprite
r8: number of dr. pepper
r9: number of coke zero
*/
.global main

main:
    adr r0, thumb + 1
    bx r0
    .thumb
    .syntax unified

@start function
start:
    @this section sets all the registers to their correct starting values
    mov r6, #1
    mov r7, #2
    mov r8, #2
    mov r9, #2

    @Welcomes the user on startup
    ldr r0, =strHelloMessage
    bl printf

    @jumpt to masterLoop
    bl masterLoop


masterLoop:
    @every return to the master loop will reset the coins back to 0
    mov r5, #0

    @check for if the entire machine is empty
    add r10, r6, r7
    add r10, r10, r8
    add r10, r10, r9

    cmp r10, #0
    it eq
    beq exit

    @start in the input loop
    bl inputLoop

    @continue with choice loop. This line is actually not used
    bl choiceLoop

@loop for taking input. This input section is for the coin input
inputLoop:

    @if r5 is greater than or equal to 55 cents, move to the choiceLoop
    cmp r5, #55
    it ge
    bge choiceLoop

    ldr r0, =strInputLoop
    bl printf

    ldr r0, =strYourTotal
    mov r1, r5  @ Load the value of total
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



@loop for choosing what drink you want. Only loops if the user either fails to input a correct answer, or the user choice in empty
choiceLoop:
    ldr r0, =strChoiceQuery
    mov r1, r5
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
    cmp r6, #0
    it eq
    beq emptyCase

    sub r5, r5, #55
    sub r6, r6, #1

    ldr r0, =strCoke
    mov r1, r5
    bl printf

    b masterLoop
spriteCase:
    cmp r7, #0
    it eq
    beq emptyCase

    sub r5, r5, #55
    sub r7, r7, #1

    ldr r0, =strSprite
    mov r1, r5
    bl printf

    b masterLoop
pepperCase:
    cmp r8, #0
    it eq
    beq emptyCase

    sub r5, r5, #55
    sub r8, r8, #1

    ldr r0, =strPepper
    mov r1, r5
    bl printf

    b masterLoop
zeroCase:
    cmp r9, #0
    it eq
    beq emptyCase

    sub r5, r5, #55
    sub r9, r9, #1

    ldr r0, =strZero
    mov r1, r5
    bl printf

    b masterLoop
leaveCase:
    ldr r0, =strLeave
    mov r1, r5
    bl printf

    b masterLoop

emptyCase:
    ldr r0, =strEmpty
    bl printf

    b choiceLoop

@inventoryCheck will check r5. If above 55, then the user came from choice loop. Less than 55, and they came from inputLoop
inventoryCheck:
    ldr r0, =strInventory
    mov r1, r6 
    mov r2, r7
    mov r3, r8
    push {r9}
    bl printf
    pop {r9}

    cmp r5, #55
    it ge
    bge choiceLoop
    blt inputLoop

@exit
exit:
    ldr r0, =strShutDown
    bl printf

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
strInventory: .asciz "Coke: %d\nSprite: %d\nPepsi: %d\nCoke Zero: %d\n"

.balign 4
strEmpty: .asciz "There is no more of this selection"

.balign 4
strShutDown: .asciz "There is no more inventory left. The machine will now shut down\n"

.balign 4
strTest: .asciz "Test"

.balign 4
fmtChar: .asciz " %c"

.balign 4
inputChar: .ascii "a"

.balign 4
total: .word 0

@C library
.global printf

.global scanf