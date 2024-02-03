/*
File: Lab_1.s
Author: Jacob Wade Godwin

Run command lines
1) as -o Lab_1.o Lab_1.s -g gcc -o Lab_1 Lab_1.o -g
2) ./Lab_1

Debug lines
3) gdb ./Lab_1


Registers used
r0: General
r1: General
r2: General
r3: General
r4: Counter for loops
r8: array1
r9: array2
r10: array3
*/
.global main

main:
    @Welcome the user
    ldr r0, =strHelloMessage
    bl printf

    @Array 2 is getting the last 10 values set by user
    ldr r9, =array2
    bl getInput

    @All the arrays are being printed
    ldr r8, =array1
    ldr r9, =array2
    ldr r10, =array3
    bl addingStart
    bl addingStart
    bl printStart

    b exit

getInput:
    push {r0, r1, r4, r9, lr}
    mov r4, #0
    add r9, #40 @moving 10 words over

	@b userInputLoop

userInputLoop:
	ldr r0, =fmtInt
	ldr r1, =inputNum
	bl scanf
	
	ldr r1, =inputNum
	ldr r1, [r1]
	str r1, [r9], #4

	add r4, r4, #1
	cmp r4, #10
	bne userInputLoop

	pop {r0, r1, r4, r9, pc}

addingStart:
	push {r0, r1, r2, r4, r8, r9, r10, lr}
	mov r4, #0
	
	@b addingLoop

addingLoop:
	ldr r1, [r8], #4
	ldr r2, [r9], #4
	
	add r3, r1, r2
	str r3, [r10], #4
	
	add r4, #1
	cmp r4, #20
	bne addingLoop

	pop {r0, r1, r2, r4, r8, r9, r10, pc}

printStart:
	push {r0, r1, r2, r3, r4, r8, r9, r10, lr}
	mov r4, #0


	@b printingLoop

printingLoop:
	ldr r0, =strPrintArray
	ldr r1, [r8], #4
	ldr r2, [r9], #4
	ldr r3, [r10], #4
	bl printf

	add r4, #1
	cmp r4, #20
	bne printingLoop

	pop {r0, r1, r2, r3, r4, r8, r9, r10, pc}

exit:
    mov r7, #0x01
    mov r0, #0x00
    svc 0

.data

.balign 4
strHelloMessage: .asciz "Welcome to this array program. Enter 10 numbers for an array\n"

.balign 4
array1: .word -10, -9, -8, -7,-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

.balign 4
array2: .word 0, 2, 4, 6, 8, 10, 1, 3, 5, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.balign 4
array3: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.balign 4
fmtInt: .asciz "%d"

.balign 4
inputNum: .word 0

.balign 4
strPrintArray: .asciz "Array 1 | Array 2 | Array 3\n  %d    %d    %d\n"

.global printf

.global scanf