;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : PrimzahlSieb
;* Author             : Arash Ghaboos, Dennis Jarmolinski 	
;* Version            : V1.0
;* Date               : 20.05.2026
;* Description        : Ein Primzahl Sieb was alle Zahlen "aussiebt"
;					  : und nur die Primzahlen im Speicher ablegt.
;
;*******************************************************************************
    EXTERN initITSboard
    EXTERN lcdPrintS            ;Display ausgabe
    EXTERN GUI_init
;	EXTERN TP_Init

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 2

	; Platzhalter für die sieb_liste (1000 Bytes)
    ; Platzhalter für die ergebnis_liste
	
	    GLOBAL text
DEFAULT_BRIGHTNESS DCW  800
	
text	DCB	"Hallo liebes TI-Labor (asm-project)",0

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
	
main	PROC
        BL initITSboard
		ldr r1, =DEFAULT_BRIGHTNESS
		ldrh r0, [r1]
		bl GUI_init
		mov r0, #0x00
;		bl TP_Init
		LDR	r0,=text
        BL  lcdPrintS

        ; ERSTER SCHRITT
        ; Basisadresse von der Sieb Liste in ein Register laden
        ; Die ganze Liste mit Einsen füllen

        ; SIEBEN
        ; äussere Schleife:
        ; Prüfen, ob i*i grösser als 1000 ist. Wenn ja -> Abbruch
        ; Wert an der Stelle i laden. Ist er 0? -> zum nächsten Durchlauf springen
        ; 
        ; innere Schleife (Vielfache streichen):
        ; j = i*i berechnen
        ; Ist j groesser als 1000? -> innere Schleife abbrechen
        ; An der Stelle j eine 0 reinschreiben
        ; j = j + i rechnen
        ; Wiederholen

        ; 3. ABSPEICHERN
        ; Basisadresse vom Sieb Liste laden
        ; Basisadresse vom Ergebnis Liste laden
        ; Plätze 2 bis 1000 durchgehen
        ; Wenn an der Stelle eine 1 steht, den Platz in der Ergebnis Liste speichern

forever	b	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END