Primzahlsieb des Eratosthenes

Beschreibung
Sieb des Eratosthenes in ARM-Assembler. Findet alle Primzahlen von 2 bis 1000
und markiert sie in sieb_liste (Index = Zahl, Wert 1 = Primzahl, 0 = keine).

Ablauf

Schritt 1 Initialisierung (for_01)
Alle Einträge auf 1 setzen (erstmal alle als Primzahl annehmen).
Index 0 und 1 danach auf 0, da keine Primzahlen.

Schritt 2 Sieb (while_01 / while_02)
- Äußere Schleife: i läuft ab 2, solange i*i ≤ 1000
- Ist sieb_liste[i] noch 1, werden alle Vielfachen von i (ab i*i) auf 0 gesetzt

Schritt 3 Abspeichern
Noch nicht gefordert. Speicher (ergebnis_liste) ist reserviert.

Register
 Reg / Bedeutung 
-----/-----------
  R0 / Basisadresse sieb_liste 
  R1 / i (Schritt 1) 
  R4 / i (Schritt 2, äußere Schleife) 
  R5 / j (innere Schleife) 
  R6 / Hilfsregister 

Hinweis
Vergleiche arbeiten im unsigned-Bereich (BHS / BHI), da alle Werte größer gleich 0 sind.
