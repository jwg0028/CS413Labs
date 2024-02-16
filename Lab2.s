/*
r0- general use
r1- hex 1 input
r2- hex 2 input
r3- operation input
r4
r5
r6
r7
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
    ldr r0, =hexInput
    ldr r1, =hexNum1
    bl scanf

    ldr r8, [r1]
    
    push {r8}
    

hexInputCheck:
    @Check if input is valid
    pop {r0, r1, pc}
operationInput:

    push {r0, r1, lr}
    @Take user input
    ldr r0, =fmtInt
	ldr r1, =intInput
	bl scanf

    ldr r1, intInput




operationInputCheck:
    @Check if input is valid
    @Break to the corrosponding operation given from the input
    
    cmp r1, #1
    beq andOperation

    cmp r1, #2
    cmp r1, #3

    pop {r0, r1, pc}

andOperation:
    push {r8}
    pop {r4}
    ldr r9, =hexNum2

    and r4, r9

    pop {r0, r1, r4, r8, r9, pc}

orrOperation:
eorOperation:
bicOperation:

print:
    @print the output

exit:
    mov r7, #0x01
    mov r0, #0x00
    svc 0

.data

.balign 4
strWelcome.asciz "Welcome\n"

.balign 4
strHexPrompt: .asciz "Enter Hex\n"

.balign 4
strOperationPrompt: .asciz "Enter operation\n"

.balign 4
hexInput: .asciz "%x"

.balign 4
hexNum1: .word 0x0

.balign 4
hexNum2: .word 0xF0F0F0F0

.balign 4
operationInput: .word 0

.balign 4
fmtInt: .asciz "%d"

.balign 4
intInput: .word 0

@C library
.global printf

.global scanf