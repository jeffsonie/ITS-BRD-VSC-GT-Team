;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : PrimzahlSieb
;* Author             : Arash Ghaboos, Dennis Jarmolinski
;* Version            : V1.0
;* Date               : 27.05.2026
;* Description        : Primzahlsieb des Eratosthenes fuer 2 bis 1000
;*******************************************************************************

    EXTERN initITSboard

;============================================================
; Datensegment - hier legen wir unsere Variablen im RAM ab
;============================================================
    AREA MyData, DATA, ALIGN=2

; sieb_liste hat 1001 Einträge (Index 0 bis 1000)
; 1 bedeutet: diese Zahl ist eine Primzahl
; 0 bedeutet: diese Zahl ist KEINE Primzahl
sieb_liste      FILL 1001       ; 1001 Bytes fuer das Sieb

; hier kommen später die gefundenen Primzahlen rein (Schritt 3)
ergebnis_liste  FILL 1000       ; 1000 Bytes fuer die Ergebnisse

;============================================================
; Codesegment - hier steht unser Programm
;============================================================
    AREA |.text|, CODE, READONLY, ALIGN=3

    EXPORT main [CODE]

main    PROC
        ; Board initialisieren, das muss immer als erstes gemacht werden
        BL   initITSboard

        ; Basisadresse von sieb_liste in R0 laden
        ; R0 bleibt fuer den gesamten Algorithmus die Basisadresse
        LDR  R0, =sieb_liste

        ; ============================================================
        ; SCHRITT 1: INITIALISIERUNG
        ; Wir setzen alle Einträge in sieb_liste auf 1
        ; Am Anfang gehen wir davon aus, dass alle Zahlen Primzahlen sind
        ; Nicht-Primzahlen werden später auf 0 gesetzt
        ; ============================================================

        MOV  R3, #1             ; R3 = 1, das ist der Wert den wir reinschreiben

for_01                          ; Schleife starten: i = 0
        MOV  R1, #0             ; R1 = i = 0 (Laufvariable, faengt bei 0 an)
        MOV  R2, #1001        ; R2 = Endwert, Schleife läuft bis i < 1001

until_01
        CMP  R1, R2             ; ist i schon >= 1001?
        BGE  enddo_01           ; ja -> Schleife beenden

do_01
        STRB R3, [R0, R1]       ; sieb_liste[i] = 1

step_01
        ADD  R1, R1, #1         ; i = i + 1
        B    until_01           ; zurück zur Prüfung
enddo_01

        ; 0 und 1 sind keine Primzahlen
        ; deshalb setzen wir die beiden manuell auf 0
        MOV  R3, #0
        STRB R3, [R0, #0]       ; sieb_liste[0] = 0
        STRB R3, [R0, #1]       ; sieb_liste[1] = 0

        ; ============================================================
        ; SCHRITT 2: DAS SIEB
        ; Wir suchen alle Vielfachen von Primzahlen und streichen sie
        ; Äussere Schleife: i läuft von 2 bis i*i > 1000
        ; Innere Schleife:   alle Vielfachen von i ab i*i auf 0 setzen
        ; ============================================================

        MOV  R4, #2             ; R4 = i = 2, wir fangen bei 2 an

while_01
        ; Abbruchbedingung: wenn i*i grösser als 1000 ist, sind wir fertig
        MUL  R6, R4, R4         ; R6 = i * i
        CMP  R6, #1000        ; ist i*i > 1000?
        BGT  endwhile_01        ; ja -> äussere Schleife beenden

do_while_01
                                ; prüfen ob sieb_liste[i] noch eine Primzahl ist
                                ; wenn nicht, müssen wir nichts streichen
if_01
        LDRB R6, [R0, R4]       ; R6 = sieb_liste[i]
        CMP  R6, #0             ; ist sieb_liste[i] == 0 (keine Primzahl)?
        BEQ  endif_01           ; ja -> ueberspringen, nichts zu tun

then_01
                                ; i ist eine Primzahl, also alle Vielfachen von i streichen
                                ; wir fangen bei i*i an, weil kleinere Vielfache schon erledigt sind
        MUL  R5, R4, R4         ; R5 = j = i * i (Startwert der inneren Schleife)

while_02
        CMP  R5, #1000        ; ist j > 1000?
        BGT  endwhile_02        ; ja -> innere Schleife beenden

do_while_02
        ; dieses Vielfache ist keine Primzahl, auf 0 setzen
        MOV  R6, #0
        STRB R6, [R0, R5]       ; sieb_liste[j] = 0
        ADD  R5, R5, R4         ; j = j + i (nächstes Vielfaches)
        B    while_02           ; zurück zur Pruefung der inneren Schleife
endwhile_02

endif_01
        ADD  R4, R4, #1         ; i = i + 1
        B    while_01           ; zurück zur Pruefung der aeusseren Schleife
endwhile_01

        ; ============================================================
        ; SCHRITT 3: ABSPEICHERN (wird noch nicht verlangt)
        ; ============================================================

        ; Programm soll nicht einfach irgendwo weiterlaufen
        ; deshalb hängen wir es hier isn einer Endlosschleife auf
forever B    forever
        ENDP

        ALIGN
        END