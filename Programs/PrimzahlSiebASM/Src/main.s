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

        ; --------------------
        ; ERSTER SCHRITT
        ; ----------------------

        ; Basisadresse von der Sieb Liste in ein Register laden
        ; Die ganze Liste mit Einsen füllen

        ; ----------------------
        ; SIEBEN FUNKTION
        ; ----------------------

        ;-----------------------
        ; ÄUSSERE SCHLEIFE:
        ; ----------------------

        for (i = 2; i*i <= 1000; i++)

        ; ----------------------------------------
        ; INNERE SCHLEIFE (VIELFACHE STREICHEN)
        ; ----------------------------------------

        ; Abspeichern des Wertes
        if (sieb_liste[i] == 0) continue;

        ; Berechnet das Vierfache:
         j= i * i
        
        ; Wiederholen solange bis die Stelle 1000 erreicht ist und 0 eintragen
        while (j <= 1000)
             sieb_liste[j] = 0
         
        ; j ist die Stelle in der sieb_liste und wir springen immer weiter
            j = j + i;

        ; ---------------------
        ; 3. ABSPEICHERN
        ; ---------------------
        
        ; Ergebnis Variable
        ergebnis = 0;
        
        ; Plätze 2 bis 1000 durchgehen
        for (int i = 2; i <= 1000; i++)
        
        ; Wenn an der Stelle eine 1 steht
        if (siebListe[i] == 1)
        
        ; Den Platz in die Ergebnisliste speichern
        ergebnisListe[ergebnis] = i;

        ; Ergebnis für die nächste Primzahl erhören
        ergebnis++;



forever	b	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END