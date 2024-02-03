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

    @This is for initializing array2 (it takes user input for the last 10 entries in the array because it's easier)
    ldr r9, =array2
    bl getInput

    @This is the printing section
    ldr r8, =array1
    ldr r9, =array2
    ldr r10, =array3
    bl addingStart
    bl printStart

    @Finish code
    b exit

@Initializes for the userInputLoop
getInput:
    push {r0, r1, r4, r9, lr}
    mov r4, #0
    add r9, #40 @moving 10 words over

	@b userInputLoop

@Loops taking user inputted numbers 10 times and stores them in the later half array2
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

@Initializes addingLoop
addingStart:
	push {r0, r1, r2, r4, r8, r9, r10, lr}
	mov r4, #0
	
	@b addingLoop

@Loops adding every element in array 1 and 2 and outputing that into array 3
addingLoop:
	ldr r1, [r8], #4
	ldr r2, [r9], #4
	
	add r3, r1, r2
	str r3, [r10], #4
	
	add r4, #1
	cmp r4, #20
	bne addingLoop

	pop {r0, r1, r2, r4, r8, r9, r10, pc}

@Initializes printStart
printStart:
	push {r0, r1, r2, r3, r4, r8, r9, r10, lr}
	mov r4, #0

    ldr r0, =strFirstRow
    bl printf

	@b printingLoop

@Prints arrays 1-3 one element at a time
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


@variable section
.data

.balign 4
strHelloMessage: .asciz "Welcome to this array sum program. All arrays are 20 elements long. /nYou can enter the last 10 numbers for the second array by entering each number and pressing enter:\n"

.balign 4
array1: .word -10, -9, -8, -7,-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

.balign 4
array2: .word 2, 4, 6, 8, 10, 1, 3, 5, 7, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.balign 4
array3: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.balign 4
fmtInt: .asciz "%d"

.balign 4
inputNum: .word 0

.balign 4
strFirstRow: .asciz "Array 1 | Array 2 | Array 3\n"

.balign 4
strPrintArray: .asciz "%d    +    %d    =    %d\n"

@C library
.global printf

.global scanf