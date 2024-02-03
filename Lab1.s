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
ldr r0, =strHelloMessage
bl printf

@array initialization
ldr r8, =array1
ldr r9, =array2
ldr r10, =array3
bl getInput

bl addArrays
bl addArrays
bl printArrays

b exit

getInput:
push {r0, r1, r4, r9, lr}
mov r4, #0 @move 0 into r4 for counter
add r9, #40 @shift 10 over for user input

b userInputLoop

userInputLoop:
	ldr r0, =fmtInt
	ldr r1, =inputNum
	bl scanf
	
	ldr r1, =inputNum
	ldr r1, [r1]
	str r1, [r5], #4

	add r4, #1
	cmp r4, #10
	bne userInputLoop

	pop {r0, r1, r4, r9, pc}

addingStart:
	push {r0, r1, r2, r4, r8, r9, r10, lr}
	mov r4, #0
	
	b addingLoop

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

	b printingLoop

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

.balign 4
strHelloMessage: .asciz "Welcome to this array program. Enter 10 numbers for an array\n"

.balign 4
array1: .word -10, -9, -8, -7,-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

.balign 4
array2: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @Last 10 to be determined by user

.balign 4
array3: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @To be determined at runtime

.balign 4
fmtInt: .asciz "%d"

.balign 4
inputNum: .word 0

.balign 4
strPrintArray: .asciz "Here are the values of the 3 arrays: \nArray 1: %d \nArray 2: %d \nArray 3: %d\n"

@C functions
.global printf

.global scanf