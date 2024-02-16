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
    push {r0, r1}
    @Take user input
    ldr r0, =fmtInt
    ldr r1, =inputNum
    bl scanf


hexInputCheck:
    @Check if input is valid

operationInput:
    @Take user input
operationInputCheck:
    @Check if input is valid
    @Break to the corrosponding operation given from the input

andOperation:
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
fmtInt: .asciz "%d"

.balign 4
fmtInt: .ascii "0123456789ABCDEF"