;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Arash Ghaboos, Dennis Jarmolinski
;* Version            : V1.1
;* Date               : 10.06.2026
;* Description        : Stoppuhr - Woche 1:
;*                      S5/S6/S7 einlesen, D8/D9 ansteuern
;*                      und Beispielzeit auf dem TFT anzeigen.
;*******************************************************************************

; Adressen der GPIO-Register
PERIPH_BASE         equ 0x40000000
AHB1PERIPH_BASE     equ (PERIPH_BASE + 0x00020000)

GPIOD_BASE          equ (AHB1PERIPH_BASE + 0x0C00)   ; LEDs
GPIOF_BASE          equ (AHB1PERIPH_BASE + 0x1400)   ; Taster

GPIO_F_PIN          equ (GPIOF_BASE + 0x10)           ; Taster einlesen
GPIO_D_SET          equ (GPIOD_BASE + 0x18)           ; LEDs einschalten
GPIO_D_CLR          equ (GPIOD_BASE + 0x1A)           ; LEDs ausschalten

; Bitmasken für die Taster
S5_MASK             equ 0x20                          ; Bit 5
S6_MASK             equ 0x40                          ; Bit 6
S7_MASK             equ 0x80                          ; Bit 7

; Bitmasken für die LEDs
LED_D8              equ 0x01                          ; Bit 0
LED_D9              equ 0x02                          ; Bit 1
LED_D8_D9           equ 0x03                          ; D8 und D9

    EXTERN initITSboard
    EXTERN GUI_init
    EXTERN lcdSetFont
    EXTERN lcdGotoXY
    EXTERN lcdPrintS

;********************************************
; Datenbereich
;********************************************
    AREA MyData, DATA, ALIGN = 2

DEFAULT_BRIGHTNESS  DCW  800

TITEL       DCB  "Stoppuhr - Woche 1", 0
INIT_TEXT   DCB  "INIT 00:00.00", 0
RUN_TEXT    DCB  "RUN  00:00.00", 0
HOLD_TEXT   DCB  "HOLD 00:00.00", 0

;********************************************
; Codebereich
;********************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3

    EXPORT main [CODE]

main    PROC
        BL    initITSboard

        LDR   R1, =DEFAULT_BRIGHTNESS
        LDRH  R0, [R1]
        BL    GUI_init

        MOV   R0, #24
        BL    lcdSetFont

        BL    ledsInit                         ; Start: D8 und D9 aus

        MOV   R0, #0
        MOV   R1, #0
        BL    lcdGotoXY
        LDR   R0, =TITEL
        BL    lcdPrintS

        MOV   R0, #0
        MOV   R1, #2
        BL    lcdGotoXY
        LDR   R0, =INIT_TEXT
        BL    lcdPrintS

superloop
        BL    readTaster                       ; R0 enthält die gedrückten Taster

        TST   R0, #S5_MASK                     ; S5 gedrückt?
        BNE   tasteS5

        TST   R0, #S6_MASK                     ; S6 gedrückt?
        BNE   tasteS6

        TST   R0, #S7_MASK                     ; S7 gedrückt?
        BNE   tasteS7

        B     superloop

tasteS5
        BL    ledsInit                         ; INIT: beide LEDs aus

        MOV   R0, #0
        MOV   R1, #2
        BL    lcdGotoXY
        LDR   R0, =INIT_TEXT
        BL    lcdPrintS

        B     superloop

tasteS6
        BL    ledsHold                         ; HOLD: D8 und D9 an

        MOV   R0, #0
        MOV   R1, #2
        BL    lcdGotoXY
        LDR   R0, =HOLD_TEXT
        BL    lcdPrintS

        B     superloop

tasteS7
        BL    ledsRunning                      ; RUNNING: D8 an, D9 aus

        MOV   R0, #0
        MOV   R1, #2
        BL    lcdGotoXY
        LDR   R0, =RUN_TEXT
        BL    lcdPrintS

        B     superloop

        ENDP


readTaster  PROC
        LDR   R1, =GPIO_F_PIN
        LDRH  R0, [R1]                         ; 0 bedeutet gedrückt
        MVN   R0, R0                           ; danach bedeutet 1 gedrückt
        AND   R0, R0, #0xFF                    ; nur S0 bis S7 behalten
        BX    LR
        ENDP


ledsInit    PROC
        MOV   R0, #LED_D8_D9
        LDR   R1, =GPIO_D_CLR
        STRH  R0, [R1]                         ; D8 und D9 aus
        BX    LR
        ENDP


ledsRunning PROC
        MOV   R0, #LED_D9
        LDR   R1, =GPIO_D_CLR
        STRH  R0, [R1]                         ; D9 aus

        MOV   R0, #LED_D8
        LDR   R1, =GPIO_D_SET
        STRH  R0, [R1]                         ; D8 an

        BX    LR
        ENDP


ledsHold    PROC
        MOV   R0, #LED_D8_D9
        LDR   R1, =GPIO_D_SET
        STRH  R0, [R1]                         ; D8 und D9 an
        BX    LR
        ENDP

        ALIGN
        END