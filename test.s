


.global main

main:
    mov r0, #0              @ File descriptor (0 for stdin)
    ldr r1, =buffer         @ Buffer to store user input
    mov r2, #32             @ Maximum number of bytes to read
    mov r7, #3              @ syscall number for read
    swi 0                   @ Invoke syscall

    @ Now you have the user input in the buffer
    @ You can convert it to a 32-bit hexadecimal integer if needed

    @ Example: Print the input
    ldr r0, =buffer         @ Load address of buffer
    bl puts                 @ Call puts to print the string
    b end

puts:
    push {lr}               @ Save link register
loop:
    ldrb r1, [r0], #1       @ Load byte from memory and increment address
    cmp r1, #0              @ Check if byte is null terminator
    beq done                @ If null terminator, exit loop
    mov r0, r1              @ Move byte to r0 for putchar
    bl putchar              @ Call putchar to print the character
    b loop
done:
    pop {lr}                @ Restore link register
    bx lr                   @ Return from puts

putchar:
    mov r7, #4              @ syscall number for write
    mov r0, #1              @ File descriptor (1 for stdout)
    svc 0                   @ Invoke syscall
    bx lr

end:
    mov r7, #1              @ syscall number for exit
    mov r0, #0              @ Return 0 status
    svc 0                   @ Invoke syscall

.data
buffer:     .space  32      @ Buffer to store user input
fmt:        .asciz  "%s"    @ Format string for scanf
newline:    .asciz  "\n"    @ Newline character for printing

@C library
.global printf

.global scanf