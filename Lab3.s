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

@r4: The value the user input
@r5: The total money input


main:
    mov r4, #0
    mov r5, #0


    ldr r0, =strWelcomeMessage
    bl printf

input:
    ldr r0, =strSelectionMessage
    bl printf
    ldr r0, =charInputMode
    ldr r1, =charInput
    bl scanf
    ldr r1, =charInput
    ldr r4, [r1]

    cmp r4, #'N'
    bleq addNickel
    cmp r4, #'D'
    bleq addDime
    cmp r4, #'Q'
    bleq addQuarter
    cmp r4, #'B'
    bleq addDollar

    cmp r4, #'C'
    bleq buyCoke
    cmp r4, #'S'
    bleq buySprite
    cmp r4, #'P'
    bleq buyDrPepper
    cmp r4, #'Z'
    bleq buyCokeZero

    cmp r4, #'X'
    bleq cancelPurchase

    b input



addNickel:
    add r5, r5, #5
    bx lr

addDime:
    add r5, r5, #10
    bx lr

addQuarter:
    add r5, r5, #25
    bx lr

addDollar:
    add r5, r5, #100
    bx lr

buyCoke:
    push {pc}
    bl checkMoney
    pop {lr}

buySprite:
    push {pc}
    bl checkMoney
    pop {lr}
buyDrPepper:
    push {pc}
    bl checkMoney
    pop {lr}

buyCokeZero:
    push {pc}
    bl checkMoney
    pop {lr}

cancelPurchase:
    b exit
    bx lr

checkMoney:
    cmp r5, #55
    bge end

    mov r6, #0
    sub r6, r5, #55
    rsblt r6, r6, #0

    ldr r0, =strNotEnoughMoney
    mov r1, r5
    mov r2, r6
    bl printf
    
end:bx lr


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
strSelectionMessage: .asciz "Please enter money, select a drink, or enter the secret password (L).\n\nYou may enter money in the form of nickels (N), dimes (D), quarters (Q), or dollar bills (B).\nYou may select a drink of Coke (C), Sprite (S), Dr. Pepper (P), Coke Zero (Z), or you may exit the machine with a refund (X).\n\n"

.balign 4
charInputMode: .asciz " %c"

.balign 4
charInput: .ascii "a"

.balign 4
strNotEnoughMoney: .asciz "You need 55 cents to buy this drink but you only have %d cents entered please enter %d more.\n"


.global printf
.global scanf
