.global main

main:
    @ Welcomes the user on startup
    ldr r0, =strHelloMessage
    bl printf

    ldr r0, =strInputLoop
    bl printf

    bl takeInput

    b exit

takeInput:
    push {r0, r1, r2, r3, r4, r5, lr}

inputLoop:
    ldr r0, =strYourTotal
    ldr r1, =total
    ldr r1, [r1]  @ Load the value of total
    bl printf

    ldr r0, =fmtChar
    ldr r1, =inputChar
    bl scanf

    ldrb r1, [inputChar]

    @ section for branching based on coin inputted
    cmp r1, #'n'
    beq nickelCase

    cmp r1, #'d'
    beq dimeCase

    cmp r1, #'q'
    beq quarterCase

    cmp r1, #'b'
    beq billCase

    b inputLoop

nickelCase:
    ldr r2, =5
    b addValueAndContinue

dimeCase:
    ldr r2, =10
    b addValueAndContinue

quarterCase:
    ldr r2, =25
    b addValueAndContinue

billCase:
    ldr r2, =100
    b addValueAndContinue

addValueAndContinue:
    ldr r3, =total
    ldr r4, [r3]
    add r4, r4, r2  @ Add coin value to total
    str r4, [r3]  @ Store the updated total
    b inputLoop  @ Continue input loop

exit:
    mov r7, #0x01
    mov r0, #0x00
    svc 0

@ variable section
.data
.balign 4
strHelloMessage: .asciz "Welcome to Mr. Zippy's soft drink vending machine.\nCost of Coke, Sprite, Dr. Pepper, and Coke Zero is 55 cents.\n\n"

.balign 4
strInputLoop: .asciz "Enter money nickel (N), dime (D), quarter (Q), and one dollar bill (B).\n"

.balign 4
strYourTotal: .asciz "Your total is: %d\n"

.balign 4
fmtChar: .asciz "%c"

.balign 4
inputChar: .space 1

.balign 4
total: .word 0

@ C library
.global printf
.global scanf