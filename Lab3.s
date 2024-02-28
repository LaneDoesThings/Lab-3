/*
File: Lab3.s
Author: Lane Wright

To Run:
as -o Lab3.o Lab3.s -g
gcc -o Lab3 Lab3.o -g
./Lab3

To Dubug after compiled:
gdb ./Lab3
 */

.global main

main:
    ldr r0, =strWelcomeMessage
    bl printf

input:
    ldr r0, =strSelectionMessage
    bl printf




/*
Exit with code 0 (success)
 */
exit:
    mov r7, #0x01
    mov r0, #0x00
    svc 0

.data

.balign 4
strWelcomeMessage: .asciz "Welcome to the vending machine. All drinks cost 55 cents.\n"

.balign 4
strSelectionMessage: .asciz "Please enter money, select a drink, or enter the secret password (password).\n You may enter money in the form of nickels (N), dimes (D), or dollar bills (B).\n
You may select a drink of Coke (C), Sprite (S), Dr. Pepper (P), Coke Zero (Z), or you may exit the machine with a refund (X).\n"

.balign 4
charInputMode: .asciz "%c"

.balign 4
charInput: .byte 'a'


.global printf
.global scanf
