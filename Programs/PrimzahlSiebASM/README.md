Primzahlsieb des Eratosthenes

Beschreibung
Sieb des Eratosthenes in ARM-Assembler. Findet alle Primzahlen von 2 bis 1000,
markiert sie in sieb_liste (Index = Zahl, Wert 1 = Primzahl, 0 = keine) und
speichert sie am Ende in ergebnis_liste ab.

Ablauf

Schritt 1 Initialisierung (for_01)
Alle Einträge auf 1 setzen (erstmal alle als Primzahl annehmen).
0 und 1 lassen wir aus, da keine Primzahlen.

Schritt 2 Sieb (while_01 / while_02)
- Äußere Schleife: i läuft ab 2, solange i*i kleiner gleich 1000
- Ist sieb_liste[i] noch 1, werden alle Vielfachen von i (ab i*i) auf 0 gesetzt

Schritt 3 Abspeichern (for_02)
Sieb von 2 bis 1000 durchgehen. Wo eine 1 steht, ist der Index eine Primzahl
und wird mit STRH (2 Byte) in ergebnis_liste geschrieben. Offset danach um 2
erhöhen. Am Ende eine 0 als Endemarkierung.

Warum STRH
1000 passt in 2 Byte, daher STRH statt STR (4 Byte). Das spart Platz. ALIGN vor
ergebnis_liste, damit das Feld auf gerader Adresse beginnt.

Register
 Reg / Bedeutung
-----/-----------
  R0 / Basisadresse sieb_liste
  R1 / i (aktuelle Zahl)
  R4 / i in Schritt 2, Basisadresse ergebnis_liste in Schritt 3
  R5 / j in Schritt 2, Offset in Schritt 3
  R6 / Hilfsregister

Hinweis
Vergleiche arbeiten im unsigned-Bereich (BHS / BHI), da alle Werte groesser gleich 0 sind.

Ergebnis prüfen im Watch-Fenster:
*((uint16_t *)&ergebnis_liste)@200
Zeigt 2, 3, 5, 7, 11 ... letzte ist 997, insgesamt 168 Primzahlen.