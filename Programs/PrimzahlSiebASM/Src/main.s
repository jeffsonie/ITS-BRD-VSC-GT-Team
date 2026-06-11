;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : PrimzahlSieb
;* Author             : Arash Ghaboos, Dennis Jarmolinski
;* Version            : V4.0
;* Date               : 03.06.2026
;* Description        : Primzahlsieb des Eratosthenes für 2 bis 1000
;*                      mit Abspeichern der Primzahlen in ein eigenes Feld
;*******************************************************************************

    EXTERN initITSboard

;============================================================
; Datensegment
;============================================================
    AREA MyData, DATA, ALIGN=2

    EXPORT ergebnis_liste       ; damit Watch-Fenster das Label erkennt

sieb_liste      FILL 1001       ; Index 0..1000: 1 = Primzahl, 0 = keine

        ALIGN                   ; gerade Adresse, da wir 2-Byte STRH nutzen
ergebnis_liste  FILL 400        ; Platz für die Primzahlen (je 2 Byte)

;============================================================
; Codesegment
;============================================================
    AREA |.text|, CODE, READONLY, ALIGN=3

    EXPORT main [CODE]

main    PROC
        BL   initITSboard
        LDR  R0, =sieb_liste    ; R0 = Basisadresse Sieb

        ; ===== SCHRITT 1: alle Einträge auf 1 setzen =====

        MOV  R3, #1

for_01
        MOV  R1, #2             ; i = 2 (0 und 1 sind keine Primzahlen)
        MOV  R2, #1001        ; Endwert
until_01
        CMP  R1, R2             ; i >= 1001? (unsigned)
        BHS  enddo_01           ; HS = Higher or Same (>=)
do_01
        STRB R3, [R0, R1]       ; sieb_liste[i] = 1
step_01
        ADD  R1, R1, #1         ; i++
        B    until_01
enddo_01


        ; ===== SCHRITT 2: Vielfache streichen =====

        MOV  R4, #2             ; i = 2

while_01
        MUL  R6, R4, R4         ; i*i
        CMP  R6, #1000          ; i*i > 1000? (unsigned)
        BHI  endwhile_01        ; HI = Higher (>)
do_while_01
if_01
        LDRB R6, [R0, R4]       ; sieb_liste[i]
        CMP  R6, #0             ; keine Primzahl?
        BEQ  endif_01           ; dann überspringen
then_01
        MUL  R5, R4, R4         ; j = i*i
while_02
        CMP  R5, #1000          ; j > 1000? (unsigned)
        BHI  endwhile_02        ; HI = Higher (>)
do_while_02
        MOV  R6, #0
        STRB R6, [R0, R5]       ; sieb_liste[j] = 0
        ADD  R5, R5, R4         ; j += i
        B    while_02
endwhile_02
endif_01
        ADD  R4, R4, #1         ; i++
        B    while_01
endwhile_01


        ; ===== SCHRITT 3: Primzahlen abspeichern =====
        ; Sieb von 2 bis 1000 durchgehen. Wo eine 1 steht,
        ; ist der Index eine Primzahl und wird gespeichert.

        LDR  R4, =ergebnis_liste ; R4 = Basisadresse Ergebnisfeld
        MOV  R5, #0             ; Offset im Ergebnisfeld

for_02
        MOV  R1, #2             ; i = 2
        MOV  R2, #1001          ; Endwert
until_02
        CMP  R1, R2             ; i >= 1001? (unsigned)
        BHS  enddo_02
do_02
if_02
        LDRB R6, [R0, R1]       ; sieb_liste[i]
        CMP  R6, #1             ; ist i eine Primzahl?
        BNE  endif_02           ; nein -> nicht speichern
then_02
        STRH R1, [R4, R5]       ; Primzahl ablegen (2 Byte)
        ADD  R5, R5, #2         ; Offset um 2 erhöhen
endif_02
step_02
        ADD  R1, R1, #1         ; i++
        B    until_02
enddo_02

        MOV  R6, #0             ; Endemarkierung
        STRH R6, [R4, R5]       ; 0 hinter die letzte Primzahl

forever B    forever            ; Endlosschleife
        ENDP

        ALIGN
        END