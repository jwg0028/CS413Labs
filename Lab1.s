/*
File: Lab1.s
Author: Lane Wright

To Run:
as -o Lab1.o Lab1.s -g
gcc -o Lab1 Lab1.o -g
./Lab1

To Dubug after compiled:
gdb ./Lab1
 */
.global main

main:
    @Welcome the user
    ldr r0, =strWelcomeMessage
    bl printf

    @Array 2 is getting the last 10 values set by user
    ldr r5, =array2
    bl getInput

    @All the arrays are being printed
    ldr r4, =array1
    ldr r5, =array2
    ldr r6, =array3
    bl addArrays
    bl addArrays
    bl printArrays

    b exit

/*
r5: The array to put the values into
 */
getInput:
    push {r0, r1, r5, r10, lr} @Save the values the regs had
    mov r10, #0 @counter
    add r5, #40 @Offset for there already being 10 elements in the array
inputLoop:
    ldr r0, =intInputMode @Inputing an integer
    ldr r1, =intInput @Address to store the input
    bl scanf
    ldr r1, =intInput
    ldr r1, [r1]
    str r1, [r5], #4 @Place the value into the array

    add r10, #1 @Add 1 to counter
    cmp r10, #10 @End condition
    bne inputLoop @Enter the 
    pop {r0, r1, r5, r10, pc} @Return the values back to the regs

/*
r4: Array 1
r5: Array 2
r6: Array 3
 */
printArrays:
    push {r0, r1, r2, r3, r4, r5, r6, r10, lr} @Save the values the regs had
    mov r10, #0 @counter

printLoop:
    ldr r0, =strPrint
    ldr r1, [r4], #4 @Next index in array1
    ldr r2, [r5], #4 @Next index in array2
    ldr r3, [r6], #4 @Next index in array3
    bl printf
    
    add r10, #1 @Add 1 to counter
    cmp r10, #20 @End condition
    bne printLoop
    pop {r0, r1, r2, r3, r4, r5, r6, r10, pc} @Return the values back to the regs

/*
r4: Array 1
r5: Array 2
r6: Array 3
 */
addArrays:
    push {r1, r2, r3, r4, r5, r6, r10, lr} @Save the values the regs had
    mov r10, #0 @counter

addLoop:
    ldr r1, [r4], #4 @Next index in array1
    ldr r2, [r5], #4 @Next index in array2

    @array3[i] = array1[i] + array2[i]
    add r3, r1, r2 
    str r3, [r6], #4

    add r10, #1 @Add 1 to counter
    cmp r10, #20 @End condition
    bne addLoop
    pop {r1, r2, r3, r4, r5, r6, r10, pc} @Return the values back to the regs

/*
Exit with code 0 (success)
 */
exit:
    mov r7, #0x01
    mov r0, #0x00
    svc 0

.data

.balign 4
strWelcomeMessage: .asciz "Please input 10 numbers (enter a number then hit enter)\n"

.balign 4
intInputMode: .asciz "%d"

.balign 4
strPrint: .asciz "Array 1: %d, Array 2: %d, Array 3: %d\n"

.balign 4
array1: .word -10, -9, -8, -7,-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

.balign 4
array2: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @Last 10 to be determined by user

.balign 4
array3: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @To be determined at runtime

.balign 4
intInput: .word 0


@C functions
.global printf

.global scanf