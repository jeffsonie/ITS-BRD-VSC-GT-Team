

1. Untersuchungen:

1. Bei Anw-10 wurde testweise der Offset von #2 auf #4 geändert.

1. Ergebnis: Es wurde nicht mehr das zweite Element 0x003e geladen, sondern das dritte Halbwort 0xffcc. Dadurch wurde klar, bei DCW hat jedes Element 2 Byte.

2. Bei Anw-13 wurde testweise das Ausrufezeichen entfernt: ldrh r5,[r0,#2] 

2. Ergebnis: r5 wurde weiterhin mit 0x003e geladen, aber r0 wurde nicht auf 0x20000016 erhöht. : Das ! bewirkt das Zurückschreiben der neuen Adresse in r0.

3. Bei Anw-19 wurde betrachtet, dass adds im Gegensatz zu add die Statusflags setzt.

3. Ergebnis: Nach der Addition wurde das N-Flag gesetzt, weil das Ergebnis im höchsten Bit eine 1 besitzt.

