
.data
    array1: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
    array2: .space 80  // 20 * 4 bytes for the second array
    array3: .space 80  // 20 * 4 bytes for the third array
    welcome_msg: .asciz "Welcome! Please enter values for the second array:\n"

.text
.global main

main:
    // Print welcome message
    mov r0, #1   // File descriptor (stdout)
    ldr r1, =welcome_msg
    ldr r2, =welcome_msg_length
    mov r7, #4   // System call number for write
    swi 0

    // Initialize half of array2
    ldr r4, =array2
    ldr r5, =array1
    mov r6, #20
    bl initialize_array

    // Read user input for the other half of array2
    ldr r0, =array2
    ldr r1, =20
    bl read_user_input

    // Calculate array3 = array1 + array2
    ldr r0, =array1
    ldr r1, =array2
    ldr r2, =array3
    mov r3, #20
    bl calculate_array3

    // Print array1
    ldr r0, =array1
    bl print_array

    // Print array2
    ldr r0, =array2
    bl print_array

    // Print array3
    ldr r0, =array3
    bl print_array

    // Exit program
    mov r7, #1   // System call number for exit
    mov r0, #0   // Exit code
    swi 0

initialize_array:
    // r0: destination array
    // r1: source array
    // r6: number of elements
    loop_initialize:
        ldr r2, [r1], #4   // Load value from source array
        str r2, [r0], #4   // Store value in destination array
        subs r6, r6, #1
        bne loop_initialize
    bx lr

read_user_input:
    // r0: destination array
    // r1: number of elements
    loop_read_input:
        mov r7, #0   // System call number for read
        mov r2, r0   // Buffer address
        mov r3, #4   // Number of bytes to read (integer size)
        swi 0

        ldr r2, [r0]   // Convert string to integer
        str r2, [r0], #4   // Store integer in destination array

        subs r1, r1, #1
        bne loop_read_input
    bx lr

calculate_array3:
    // r0: array1
    // r1: array2
    // r2: array3
    // r3: number of elements
    loop_calculate:
        ldr r4, [r0], #4   // Load value from array1
        ldr r5, [r1], #4   // Load value from array2
        adds r4, r4, r5    // Calculate sum
        str r4, [r2], #4   // Store result in array3
        subs r3, r3, #1
        bne loop_calculate
    bx lr

print_array:
    // r0: array address
    // r6: number of elements
    mov r1, #1   // File descriptor (stdout)
    mov r7, #4   // System call number for write
    ldr r2, =array_format   // "%d "
    ldr r3, =array_format_length
    bl printf

    bx lr

printf:
    // r0: array address
    // r1: file descriptor
    // r2: format string
    // r3: format string length
    // r6: number of elements
    loop_printf:
        ldr r4, [r0], #4   // Load value from array
        mov r5, r4         // Copy value to register for printing
        mov r4, r1         // Copy file descriptor to register
        swi 0
        subs r6, r6, #1
        bne loop_printf
    bx lr

@.data
@    array_format: .asciz "%d "
@    array_format_length: .equ 3
@    welcome_msg_length: .equ 50
