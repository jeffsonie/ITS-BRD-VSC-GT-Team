Primzahlsieb des Eratosthenes

Beschreibung

Implementierung des Siebs des Eratosthenes in ARM-Assembler.  
Ermittelt alle Primzahlen von 2 bis 1000 und speichert das Ergebnis in "sieb_liste".

Programmstruktur

Schritt 1 Initialisierung
- Zählschleife (for_01): Setzt alle Einträge der "sieb_liste" (Index 0–1000) auf "1".  
- Anschließend werden Index 0 und 1 manuell auf "0" gesetzt (keine Primzahlen).

Schritt 2 – Sieb (Eratosthenes)
- Äußere Schleife (while_01): läuft solange "i*i ≤ 1000", prüft ob "sieb_liste[i] == 1"
- Innere Schleife (while_02): streicht alle Vielfachen von "i" ab "i*i" aus der Liste

Schritt 3 – Abspeichern
Noch nicht gefordert. Speicher (ergebnis_liste) ist bereits reserviert.

Kontrollstrukturen

Äußere Schleife (while_01) / for i=2; i*i≤1000; i++
- Kopf: "MUL R6,R4,R4" -> "CMP R6,#1000" -> "BGT endwhile_01"
- Körper: "do_while_01"

Flalunterscheidung (if_01) / if sieb_liste[i] != 0
- LDRB R6,[R0,R4] -> CMP R6,#0 -> BEQ endif_01

Innere Schleife (while_02) / while j<=1000
- Kopf: CMP R5,#1000 -> BGT endwhile_02
- Körper: do_while_02
