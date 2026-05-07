;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- S t a r t des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; HW Initialisieren

; Lade die Konstante 0x12 in r0
                mov   r0,#0x12                      ; Anw-01
; Lade den Wert -128 in r1
                mov   r1,#-128                      ; Anw-02

; Lade die 32-bit konstante 0x12345678 in r2
                ldr   r2,=0x12345678                ; Anw-03

; Lade die Adresse von VariableA in r0
                ldr   r0,=VariableA                 ; Anw-04

; Lade ein Halbwort von VariableA in r1
                ldrh  r1,[r0]                       ; Anw-05

; Lade ein Wort von VariableA in r2
                ldr   r2,[r0]                       ; Anw-06

; Speichere das 32-bit wort aus r2 an der Adresse von VariableC
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07

; Lade die Adresse von MeinHalbwortFeld in r0 
                ldr   r0,=MeinHalbwortFeld          ; Anw-08

; Lade ein Halbwort von MeinHalbwortFeld in r1
                ldrh  r1,[r0]                       ; Anw-09

; Lade das zweite Halbwort von MeinHalbwortFeld in r2
                ldrh  r2,[r0,#2]                    ; Anw-10

; Lade den Offset 10 in r3
                mov   r3,#10                        ; Anw-11

; Lade das Halbwort an der Adresse r0 + r3 in r4
                ldrh  r4,[r0,r3]                    ; Anw-12

; Lade das Halbwort von r0 + 2 in r5 und erhöhe r0 auf diese adresse
                ldrh  r5,[r0,#2]!                   ; Anw-13

; Lade das Halbwort von r0 + 2 in r6 und erhöhe r0 auf diese adresse
                ldrh  r6,[r0,#2]!                   ; Anw-14

; Speichere das untere Halbwort aus r6 an r0 + 2 und erhöhe r0 auf diese adresse
                strh  r6,[r0,#2]!                   ; Anw-15

; Lade die Adresse von MeinWortFeld in r0
                ldr  r0,=MeinWortFeld               ; Anw-16

; Lade das erste Wort von MeinWortFeld in r1
                ldr  r1,[r0]                        ; Anw-17

; Lade das zweite Wort von MeinWortFeld in r2
                ldr  r2,[r0,#4]                     ; Anw-18

; Addiere r1 und r2 und speichere das Ergebnis in r3 und setzt die Flags
                adds r3,r1,r2                       ; Anw-19

; Lade das dritte Wort von MeinWortFeld in r4
                ldr  r4,[r0,#8]                     ; Anw-20

; Lade das vierte Wort von MeinWortFeld in r5
                ldr  r5,[r0,#12]                    ; Anw-21

; Subtrahiere r5 von r4 und speichere das Ergebnis in r6 und setze die Flags
                subs r6,r4,r5                       ; Anw-22

; Lade das fünfte Wort von MeinWortFeld in r7
                ldr  r7,[r0,#16]                    ; Anw-23

; Lade das sechste Wort von MeinWortFeld in r8
                ldr  r8,[r0,#20]                    ; Anw-24

; Subtrahiere r8 von r7 und speichere das Ergebnis in r9 und setze die Flags
                subs r9,r7,r8                       ; Anw-25

; Endlosschleife
forever         b   forever                         ; Anw-26
                ENDP
                END