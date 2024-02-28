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
@r9: Amount of Coke Zero


main:
    mov r4, #0
    mov r5, #0
    mov r6, #2
    mov r7, #2
    mov r8, #2
    mov r9, #2


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

    mov r2, #0

    cmp r4, #'N'
    moveq r1, #5
    moveq r2, #1
    bleq addMoney

    cmp r4, #'D'
    moveq r1, #10
    moveq r2, #1
    bleq addMoney

    cmp r4, #'Q'
    moveq r1, #25
    moveq r2, #1
    bleq addMoney

    cmp r4, #'B'
    moveq r1, #100
    moveq r2, #1
    bleq addMoney

    cmp r4, #'X'
    moveq r2, #1
    bleq returnMoney

    cmp r4, #'L'
    moveq r2, #1
    bleq admin

    cmp r5, #55
    blge drinkSelection


    cmp r2, #0
    bleq readError
    b input

admin:
    push {r2, lr}

    ldr r0, =strAmountLeft
    mov r1, r6
    mov r2, r7
    mov r3, r8
    push {r9}
    bl printf
    add sp, sp, #4

    pop {r2, pc}

addMoney:
    push {r2, lr}
    
    ldr r0, =strMoneyAdded
    add r5, r5, r1
    mov r2, r5
    bl printf

    pop {r2, pc}

drinkSelection:
    push {r2, lr}

    bl checkEmpty
    cmp r0, #4
    beq exit


    ldr r0, =strDrinkMessage
    bl printf
    ldr r0, =charInputMode
    ldr r1, =charInput
    bl scanf
    cmp r0, #0
    bleq readError
    ldr r1, =charInput
    ldr r4, [r1]

    mov r2, #0

    cmp r4, #'C'
    ldreq r1, =strCoke
    pusheq {r6}
    moveq r2, #1
    bleq buy
    moveq r6, r0

    cmp r4, #'S'
    ldreq r1, =strSprite
    pusheq {r7}
    moveq r2, #1
    bleq buy
    moveq r7, r0

    cmp r4, #'P'
    ldreq r1, =strDrPepper
    pusheq {r8}
    moveq r2, #1
    bleq buy
    moveq r8, r0

    cmp r4, #'Z'
    ldreq r1, =strCokeZero
    pusheq {r9}
    moveq r2, #1
    bleq buy
    moveq r9, r0

    cmp r4, #'X'
    moveq r2, #1
    bleq returnMoney

    cmp r2, #0
    bleq readError
    beq drinkSelection

    cmp r2, #2
    beq drinkSelection


    pop {r2, pc}

checkEmpty:
    push {lr}

    mov r0, #0

    cmp r6, #0
    addeq r0, #1
    cmp r7, #0
    addeq r0, #1
    cmp r8, #0
    addeq r0, #1
    cmp r9, #0
    addeq r0, #1

    pop {pc}


buy:
    pop {r3}
    push {r2, lr}

    cmp r3, #0
    beq outOfInventory


    bl confirmPurchase
    cmp r0, #'N'
    moveq r0, r3
    beq return
    cmp r0, #'Y'
    beq purchase

    bl confirmPurchase

    outOfInventory:
        ldr r0, =strOutOfInventory
        bl printf
        
        pop {r2}
        mov r2, #2
        push {r2}

        b return

    purchase:
        mov r2, #55
        sub r5, r5, r2
        bl completePurchase
        sub r0, r3, #1

    return:
        pop {r2, pc}

confirmPurchase:
    push {r1, r3, lr}

    ldr r0, =strConfirmBuy
    bl printf

    ldr r0, =charInputMode
    ldr r1, =charInput
    bl scanf
    cmp r0, #0
    bleq readError
    ldr r1, =charInput
    ldr r0, [r1]
    pop {r1, r3, pc}

completePurchase:
    push {r3, lr}

    ldr r0, =strPurchaseComplete
    mov r2, r5
    bl printf
    mov r5, #0

    pop {r3, pc}

returnMoney:
    push {r2, lr}

    ldr r0, =strChangeMessage
    mov r1, r5
    bl printf
    mov r5, #0

    pop {r2, pc}

readError:
    push {r2, lr}

    ldr r0, =strError
    bl printf

    ldr r0, =strInputMode
    ldr r1, =strInputError
    bl scanf

    pop {r2, pc}

/*
Exit with code 0 (success)
 */
exit:
    ldr r0, =strEmpty
    bl printf

    mov r7, #0x01
    mov r0, #0x00
    svc 0

.data

.balign 4
strWelcomeMessage: .asciz "Welcome to the vending machine. All drinks cost 55 cents.\n"

.balign 4
strMoneyMessage: .asciz "Please enter money or the secret password (L).\n\nYou may enter money in the form of nickels (N), dimes (D), quarters (Q), or dollar bills (B), or you may exit the machine with a refund (X).\n\n"

.balign 4
strDrinkMessage: .asciz "You may select a drink of Coke (C), Sprite (S), Dr. Pepper (P), Coke Zero (Z), or you may exit the machine with a refund (X).\n\n"

.balign 4
strChangeMessage: .asciz "You have recived %d cents back.\n\n\n"

.balign 4
strMoneyAdded: .asciz "You have entered %d cents and the total entered is %d cents.\n\n\n"

.balign 4
strConfirmBuy: .asciz "You have chosen %s. Is this correct? (Y or N)\n"

.balign 4
strPurchaseComplete: .asciz "You have bought a %s and have recived %d cents as change.\n"

.balign 4
strAmountLeft: .asciz "There are %d Coke(s), %d Sprite(s), %d Dr. Pepper(s), and %d Coke Zero(s) left.\n"

.balign 4
strOutOfInventory: .asciz "Sorry we are out of %s please select another drink.\n"

.balign 4
strEmpty: .asciz "We are out of drinks so the machine will shutdown now.\n"

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
