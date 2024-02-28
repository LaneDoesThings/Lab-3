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
@r6: Amount of Coke
@r7: Amount of Sprite
@r8: Amount of Dr. Pepper
@r8: Amount of Coke Zero


main:
    mov r4, #0
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0


    ldr r0, =strWelcomeMessage
    bl printf

input:
    ldr r0, =strMoneyMessage
    bl printf
    ldr r0, =charInputMode
    ldr r1, =charInput
    bl scanf
    cmp r0, #0
    bleq readError
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
    bleq returnMoney

    cmp r5, #55
    blge drinkSelection

    b input



addNickel:
    push {lr}
    
    ldr r0, =strMoneyAdded
    mov r1, #5
    add r5, r5, r1
    bl printf

    pop {pc}

addDime:
    push {lr}

    ldr r0, =strMoneyAdded
    mov r1, #10
    add r5, r5, r1
    bl printf

    pop {pc}

addQuarter:
    push {lr}

    ldr r0, =strMoneyAdded
    mov r1, #25
    add r5, r5, r1
    bl printf

    pop {pc}

addDollar:
    push {lr}

    ldr r0, =strMoneyAdded
    mov r1, #100
    add r5, r5, r1
    bl printf

    pop {pc}

drinkSelection:
    push {lr}

    ldr r0, =strDrinkMessage
    bl printf
    ldr r0, =charInputMode
    ldr r1, =charInput
    bl scanf
    cmp r0, #0
    bleq readError
    ldr r1, =charInput
    ldr r4, [r1]

    cmp r4, #'C'
    ldr r1, =strCoke
    mov r2, #55
    bleq buy
    cmp r4, #'S'
    ldr r1, =strSprite
    mov r2, #55
    bleq buy
    cmp r4, #'P'
    ldr r1, =strDrPepper
    mov r2, #55
    bleq buy
    cmp r4, #'Z'
    ldr r1, =strCokeZero
    mov r2, #55
    bleq buy
    cmp r4, #'X'
    bleq returnMoney


    pop {pc}

buy:
    push {lr}

    bl confirmPurchase
    cmp r0, #'N'
    beq return
    cmp r0, #'Y'
    beq purchase

    bl confirmPurchase

    purchase:

        mov r2, #55
        sub r5, r5, r2
        ldr r1, =strCoke

    return:
        pop {pc}

confirmPurchase:
    push {lr}

    ldr r0, =strConfirmBuy
    bl printf

    ldr r0, =charInputMode
    ldr r1, =charInput
    bl scanf
    cmp r0, #0
    bleq readError
    ldr r1, =charInput
    ldr r0, [r1]
    pop {pc}

completePurchase:
    push {lr}

    ldr r0, =strPurchaseComplete
    mov r2, r5
    bl printf

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
strMoneyMessage: .asciz "Please enter money or enter the secret password (L).\n\nYou may enter money in the form of nickels (N), dimes (D), quarters (Q), or dollar bills (B), or you may exit the machine with a refund (X).\n\n"

.balign 4
strDrinkMessage: .asciz "You may select a drink of Coke (C), Sprite (S), Dr. Pepper (P), Coke Zero (Z), or you may exit the machine with a refund (X).\n\n"

.balign 4
strChangeMessage: .asciz "You have recived %d cents back.\n\n\n"

.balign 4
strMoneyAdded: .asciz "You have entered %d cents.\n\n\n"

.balign 4
strConfirmBuy: .asciz "You have Chosen %s. Is this correct? (Y or N)\n"

.balign 4
strPurchaseComplete: .asciz "You have bought a %s and have recived %d cents as change.\n"

.balign 4
strCoke: .asciz "Coke"

.balign 4
strSprite: .asciz "Sprite"

.balign 4
strDrPepper: .asciz "Dr. Pepper"

.balign 4
strCokeZero: .asciz "Coke Zero"

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
