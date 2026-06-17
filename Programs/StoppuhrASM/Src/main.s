;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Arash Ghaboos, Dennis Jarmolinski
;* Version            : V2.9
;* Date               : 17.06.2026
;* Description        : Stoppuhr Woche 2 
;*******************************************************************************

PERIPH_BASE         equ 0x40000000
AHB1PERIPH_BASE     equ (PERIPH_BASE + 0x00020000)
APB1PERIPH_BASE     equ PERIPH_BASE

GPIOD_BASE          equ (AHB1PERIPH_BASE + 0x0C00)
GPIOF_BASE          equ (AHB1PERIPH_BASE + 0x1400)
TIM2_BASE           equ (APB1PERIPH_BASE + 0x0000)

GPIO_F_PIN          equ (GPIOF_BASE + 0x10)     ; Taster lesen
GPIO_D_PIN          equ (GPIOD_BASE + 0x10)     ; LED-Zustand lesen
GPIO_D_SET          equ (GPIOD_BASE + 0x18)     ; LEDs einschalten
GPIO_D_CLR          equ (GPIOD_BASE + 0x1A)     ; LEDs ausschalten

TIMER               equ (TIM2_BASE + 0x24)      ; Zeitstempel, 1 Tick = 10 µs
TIM2_PSC            equ (TIM2_BASE + 0x28)
TIM2_ERG            equ (TIM2_BASE + 0x14)

S5_MASK             equ 0x20                    ; Bit 5
S6_MASK             equ 0x40                    ; Bit 6
S7_MASK             equ 0x80                    ; Bit 7
LED_D8_D9           equ 0x03                    ; Bit 0 und Bit 1

ST_INIT             equ 0
ST_RUNNING          equ 1
ST_HOLD             equ 2

DISPLAY_STEP        equ 1000                    ; 1000 Ticks = 1 Hundertstel

    EXTERN initITSboard
    EXTERN GUI_init
    EXTERN TP_Init
    EXTERN initTimer
    EXTERN lcdSetFont
    EXTERN lcdGotoXY
    EXTERN lcdPrintS
    EXTERN lcdPrintC
    EXTERN Delay

;********************************************
; Datenbereich
;********************************************
    AREA MyData, DATA, READWRITE, ALIGN = 2

DEFAULT_BRIGHTNESS  DCW  800
MY_TEXT             DCB  "Hold down different buttons from S0 to S7 and watch D8 to D15.", 0
    ALIGN

gesamtZeit          DCD  0              ; laufende Zeit in 10-µs-Ticks
letzterStempel      DCD  0              ; Zeitstempel des letzten updateClk
letzteAnzeige       DCD  0xFFFFFFFF     ; erzwingt erste Anzeige

zustand             DCB  ST_INIT        ; aktueller FSM-Zustand
zeitText            DCB  "00:00.00", 0  ; wird von formatZeit beschrieben
alterText           DCB  "--------", 0  ; zuletzt angezeigter Wert
ledTab              DCB  0x00,0x01,0x03 ; LED-Muster: INIT, RUNNING, HOLD

;********************************************
; Codebereich
;********************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3

    EXPORT main [CODE]

main    PROC
        ; Hardware initialisieren
        BL    initITSboard

        LDR   R1, =DEFAULT_BRIGHTNESS
        LDRH  R0, [R1]
        BL    GUI_init

        BL    initTimer

        LDR   R1, =TIM2_PSC
        LDR   R0, =899                  ; 1 Tick = 10 µs
        STRH  R0, [R1]

        LDR   R1, =TIM2_ERG
        MOV   R0, #1
        STRH  R0, [R1]                  ; Update-Ereignis auslösen

        MOV   R0, #24
        BL    lcdSetFont

        ; Variablen initialisieren
        MOV   R0, #0
        LDR   R1, =gesamtZeit
        STR   R0, [R1]

        MOV   R0, #ST_INIT
        LDR   R1, =zustand
        STRB  R0, [R1]

        MVN   R0, #0
        LDR   R1, =letzteAnzeige
        STR   R0, [R1]                  ; erste Anzeige erzwingen

        BL    updateClk                 ; Startstempel setzen

        MOV   R0, #ST_INIT
        BL    updateLeds

        B     displayCheck


;--------------------------------------------
; Superloop
;--------------------------------------------
superloop
        ; Zeit weiterzählen, außer in INIT
        BL    updateClk                 ; R0 = vergangene Ticks

        LDR   R1, =zustand
        LDRB  R2, [R1]

        CMP   R2, #ST_INIT
        BEQ   keinAddieren

        LDR   R1, =gesamtZeit
        LDR   R3, [R1]
        ADD   R3, R3, R0                ; läuft auch in HOLD weiter
        STR   R3, [R1]


keinAddieren
        ; Taster lesen und neuen Zustand bestimmen
        BL    readTaster

        LDR   R2, =zustand
        LDRB  R1, [R2]                  ; R1 = alter Zustand
        BL    updateZustand             ; R0 = neuer Zustand

        CMP   R0, R1
        BEQ   displayCheck

        LDR   R2, =zustand
        STRB  R0, [R2]

        ; Bei INIT Zeit zurücksetzen
        CMP   R0, #ST_INIT
        BNE   zustandGewechselt

        MOV   R3, #0
        LDR   R2, =gesamtZeit
        STR   R3, [R2]

        MVN   R3, #0
        LDR   R2, =letzteAnzeige
        STR   R3, [R2]                  ; Anzeige nach Reset erzwingen


zustandGewechselt
        BL    updateLeds


;--------------------------------------------
; Anzeige
;--------------------------------------------
displayCheck
        LDR   R1, =zustand
        LDRB  R1, [R1]

        CMP   R1, #ST_HOLD
        BEQ   superloop                 ; Anzeige in HOLD einfrieren

        LDR   R0, =gesamtZeit
        LDR   R0, [R0]

        LDR   R1, =DISPLAY_STEP
        UDIV  R2, R0, R1                ; aktuelle Hundertstel

        LDR   R1, =letzteAnzeige
        LDR   R3, [R1]

        CMP   R2, R3
        BEQ   superloop                 ; unverändert, nicht neu zeichnen

        STR   R2, [R1]

        LDR   R0, =gesamtZeit
        LDR   R0, [R0]
        BL    formatZeit

        MOV   R4, #0                    ; Zeichenindex 0 bis 7


zeichenLoop
        CMP   R4, #8
        BEQ   superloop

        LDR   R1, =zeitText
        LDRB  R0, [R1, R4]              ; neues Zeichen

        LDR   R2, =alterText
        LDRB  R3, [R2, R4]              ; zuletzt angezeigtes Zeichen

        CMP   R0, R3
        BEQ   naechstesZeichen

        STRB  R0, [R2, R4]              ; neues Zeichen merken

        MOV   R0, R4
        MOV   R1, #0
        BL    lcdGotoXY

        LDR   R1, =zeitText
        LDRB  R0, [R1, R4]
        BL    lcdPrintC


naechstesZeichen
        ADD   R4, R4, #1
        B     zeichenLoop

        ENDP


;--------------------------------------------
; readTaster
; Eingang : keine
; Ausgang : R0 = Bitmuster, Bit i = 1 <=> Si gedrückt
;--------------------------------------------
readTaster  PROC
        LDR   R1, =GPIO_F_PIN
        LDRH  R0, [R1]                  ; Hardware: 0 = gedrückt
        MVN   R0, R0                    ; danach: 1 = gedrückt
        AND   R0, R0, #0xFF             ; nur S0 bis S7
        BX    LR
        ENDP


;--------------------------------------------
; updateClk
; Eingang : keine
; Ausgang : R0 = vergangene Ticks
;--------------------------------------------
updateClk   PROC
        LDR   R1, =TIMER
        LDR   R2, [R1]                  ; aktueller Zeitstempel

        LDR   R1, =letzterStempel
        LDR   R3, [R1]                  ; alter Zeitstempel

        SUB   R0, R2, R3
        STR   R2, [R1]                  ; für nächsten Aufruf merken

        BX    LR
        ENDP


;--------------------------------------------
; updateZustand
; Eingang : R0 = Taster, R1 = alter Zustand
; Ausgang : R0 = neuer Zustand
;--------------------------------------------
updateZustand PROC
        CMP   R1, #ST_INIT
        BEQ   uzInit

        TST   R0, #S5_MASK              ; S5 -> INIT
        BNE   uzToInit

        CMP   R1, #ST_RUNNING
        BEQ   uzRunning

        ; Verbleibender Zustand ist HOLD
        TST   R0, #S7_MASK              ; HOLD + S7 -> RUNNING
        BNE   uzToRunning

        MOV   R0, #ST_HOLD
        BX    LR


uzRunning
        TST   R0, #S6_MASK              ; RUNNING + S6 -> HOLD
        BNE   uzToHold

        MOV   R0, #ST_RUNNING
        BX    LR


uzInit
        TST   R0, #S7_MASK              ; INIT + S7 -> RUNNING
        BNE   uzToRunning

        MOV   R0, #ST_INIT
        BX    LR


uzToInit
        MOV   R0, #ST_INIT
        BX    LR


uzToRunning
        MOV   R0, #ST_RUNNING
        BX    LR


uzToHold
        MOV   R0, #ST_HOLD
        BX    LR

        ENDP


;--------------------------------------------
; updateLeds
; Eingang : R0 = Zustand
; Ausgang : keine
;--------------------------------------------
updateLeds  PROC
        CMP   R0, #ST_HOLD
        BLS   ledIndexOk

        MOV   R0, #ST_INIT

ledIndexOk
        LDR   R1, =ledTab
        LDRB  R0, [R1, R0]

        LDR   R1, =GPIO_D_SET
        STRH  R0, [R1]

        MVN   R2, R0
        AND   R2, R2, #LED_D8_D9

        LDR   R1, =GPIO_D_CLR
        STRH  R2, [R1]

        BX    LR
        ENDP

;--------------------------------------------
; formatZeit
; Eingang : R0 = Zeit in 10-µs-Ticks
; Ausgang : zeitText enthält mm:ss.nn
;--------------------------------------------
formatZeit  PROC
        LDR   R12, =zeitText

        LDR   R1, =1000
        UDIV  R0, R0, R1                ; Hundertstel gesamt

        MOV   R1, #100
        UDIV  R2, R0, R1                ; Sekunden gesamt
        MUL   R3, R2, R1
        SUB   R0, R0, R3                ; Hundertstel 0 bis 99

        MOV   R1, #10
        UDIV  R3, R0, R1
        MUL   R1, R3, R1
        SUB   R0, R0, R1

        ADD   R3, R3, #0x30
        ADD   R0, R0, #0x30

        STRB  R3, [R12, #6]
        STRB  R0, [R12, #7]

        MOV   R1, #60
        UDIV  R3, R2, R1                ; Minuten gesamt
        MUL   R0, R3, R1
        SUB   R2, R2, R0                ; Sekunden 0 bis 59

        MOV   R1, #10
        UDIV  R0, R2, R1
        MUL   R1, R0, R1
        SUB   R2, R2, R1

        ADD   R0, R0, #0x30
        ADD   R2, R2, #0x30

        STRB  R0, [R12, #3]
        STRB  R2, [R12, #4]

        MOV   R1, #100
        UDIV  R0, R3, R1
        MUL   R0, R0, R1
        SUB   R3, R3, R0                ; Minuten modulo 100

        MOV   R1, #10
        UDIV  R0, R3, R1
        MUL   R1, R0, R1
        SUB   R3, R3, R1

        ADD   R0, R0, #0x30
        ADD   R3, R3, #0x30

        STRB  R0, [R12, #0]
        STRB  R3, [R12, #1]

        BX    LR
        ENDP

        ALIGN
        END