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
    ldr r0, =strMoneyMessage
    bl printf
    ldr r0, =charInputMode
    ldr r1, =charInput
    bl scanf
    cmp r0, #0
    beq readError
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
    cmp r4, #'X'
    bleq cancelPurchase

    cmp r5, #55
    bge drinkSelection

    b input



addNickel:
    push {lr}

    add r5, r5, #5

    pop {pc}

addDime:
    push {lr}

    add r5, r5, #10

    pop {pc}

addQuarter:
    push {lr}

    add r5, r5, #25

    pop {pc}

addDollar:
    push {lr}

    add r5, r5, #100

    pop {pc}

drinkSelection:
    push {lr}

    ldr r0, =strDrinkMessage
    bl printf

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


    pop {pc}

buyCoke:
    push {lr}

    pop {pc}

buySprite:
    push {lr}

    pop {pc}
buyDrPepper:
    push {lr}

    pop {pc}

buyCokeZero:
    push {lr}

    pop {pc}

cancelPurchase:
    push {lr}

    bl returnMoney

    pop {pc}

returnMoney:
    push {lr}

    ldr r0, =strChangeMessage
    mov r1, r5
    bl printf

    pop {pc}

readError:
    push {lr}

    ldr r0, =strError
    bl printf

    ldr r0, =strInputMode
    ldr r1, =strInputError
    bl scanf

    pop {pc}

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
strMoneyMessage: .asciz "Please enter money, select a drink, or enter the secret password (L).\n\nYou may enter money in the form of nickels (N), dimes (D), quarters (Q), or dollar bills (B), or you may exit the machine with a refund (X).\n\n"

.balign 4
strDrinkMessage: .asciz "You may select a drink of Coke (C), Sprite (S), Dr. Pepper (P), Coke Zero (Z), or you may exit the machine with a refund (X).\n\n"

.balign 4
strChangeMessage: .asciz "You have recived %d cents back.\n"

.balign 4
charInputMode: .asciz " %c"

.balign 4
charInput: .ascii "a"

.balign 4
strError: .asciz "Please enter a valid input.\n"

.balign 4
strInputError: .skip 100*4

.balign 4
strInputMode: .asciz "%[^\n]"

.global printf
.global scanf
