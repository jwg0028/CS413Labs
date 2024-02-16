/*
File: Lab_1.s
Author: Jacob Wade Godwin

Run command lines
1) as -o Lab2.o Lab2.s -g && gcc -o Lab2 Lab2.o -g
2) ./Lab1

Debug lines
3) gdb ./Lab1

Important comment:
I can't get it to work. I think it has an okay foundation, but there are just some things I don't quite understand in practice that are holding me back.

Registers used:
r0: General
r1: General
r7: Used in exit function
r8: Hex from user input
r9: stored hex
*/

.global main

main:
    @generate welcome
    ldr r0, =strWelcome
    bl printf
    @Break into function for hex input
    ldr r0, =strHexPrompt
    bl printf

    bl hexInput
    @Break into function for operation input
    bl operationInput
    @Print function
    bl print

    @exit function
    b exit

hexInput:
    push {r0, r1, lr}
    @Take user input
    ldr r0, =hexRead
    ldr r1, =hexNum1
    bl scanf

    ldr r8, [r1]
    
    ldr r0, =strWelcome
    bl printf

    push {r8}
    

hexInputCheck:
    @Check if input is valid
    ldr r0, =strWelcome
    bl printf

    pop {r0, r1, pc}
operationInput:
    push {r0, r1, lr}
    @Take user input
    ldr r0, =fmtInt
	ldr r1, =intInput
	bl scanf

    ldr r1, =intInput




operationInputCheck:
    @Check if input is valid
    @Break to the corrosponding operation given from the input
    
    cmp r1, #1
    beq andOperation

    cmp r1, #2
    cmp r1, #3

    pop {r0, r1, pc}

andOperation:
    push {r0, r1, r8, r9, lr}

    ldr r9, =hexNum2

    and r8, r9

    pop {r0, r1, r8, r9, pc}

orrOperation:
    push {r0, r1, r8, r9, lr}

    ldr r9, =hexNum2

    orr r8, r9

    pop {r0, r1, r8, r9, pc}
eorOperation:
    push {r0, r1, r8, r9, lr}

    ldr r9, =hexNum2

    eor r8, r9

    pop {r0, r1, r8, r9, pc}
bicOperation:
    push {r0, r1, r8, r9, lr}

    ldr r9, =hexNum2

    bic r8, r9

    pop {r0, r1, r8, r9, pc}

print:
    @print the output
    ldr r0, =strPrint
    ldr r8, =hexNum1

exit:
    mov r7, #0x01
    mov r0, #0x00
    svc 0

.data

.balign 4
strWelcome: .asciz "Welcome\n"

.balign 4
strHexPrompt: .asciz "Enter Hex\n"

.balign 4
strOperationPrompt: .asciz "Enter operation\n"

.balign 4
strPrint: .asciz "Output %x\n"

.balign 4
hexRead: .asciz "%x"

.balign 4
hexNum1: .word 0x0

.balign 4
hexNum2: .word 0xF0F0F0F0

@.balign 4
@operationRead: .word 0

.balign 4
fmtInt: .asciz "%d"

.balign 4
intInput: .word 0

@C library
.global printf

.global scanf
