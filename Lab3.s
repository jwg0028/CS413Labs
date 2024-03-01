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
r4: General
r5: user's total money
r6: number of cokes
r7: number of sprite
r8: number of dr. pepper
r9: number of coke zero
*/
.global main

main:
    mov r6, #1
    mov r7, #2
    mov r8, #2
    mov r9, #2

    @Welcomes the user on startup
    ldr r0, =strHelloMessage
    bl printf

    bl masterLoop


masterLoop:

    mov r5, #0

    add r10, r6, r7
    add r10, r10, r8
    add r10, r10, r9

    cmp r10, #0
    beq exit

    bl inputLoop

    bl choiceLoop

inputLoop:

    cmp r5, #55
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
    beq nickelCase

    cmp r1, #'D'
    beq dimeCase

    cmp r1, #'Q'
    beq quarterCase

    cmp r1, #'B'
    beq billCase

    cmp r1, #'I'
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

    cmp r1, #'C'
    beq cokeCase

    cmp r1, #'S'
    beq spriteCase

    cmp r1, #'P'
    beq pepperCase

    cmp r1, #'Z'
    beq zeroCase

    cmp r1, #'X'
    beq leaveCase

    cmp r1, #'I'
    beq inventoryCheck

    ldr r0, =strInvalid
    bl printf
    
    b inputLoop

cokeCase:
    cmp r6, #0
    beq emptyCase

    sub r5, r5, #55
    sub r6, r6, #1

    ldr r0, =strCoke
    mov r1, r5
    bl printf

    b masterLoop
spriteCase:
    cmp r7, #0
    beq emptyCase

    sub r5, r5, #55
    sub r7, r7, #1

    ldr r0, =strSprite
    mov r1, r5
    bl printf

    b masterLoop
pepperCase:
    cmp r8, #0
    beq emptyCase

    sub r5, r5, #55
    sub r8, r8, #1

    ldr r0, =strPepper
    mov r1, r5
    bl printf

    b masterLoop
zeroCase:
    cmp r9, #0
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

inventoryCheck:
    ldr r0, =strInventory
    mov r1, r6 
    mov r2, r7
    mov r3, r8
    push {r9}
    bl printf
    pop {r9}

    b choiceLoop


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