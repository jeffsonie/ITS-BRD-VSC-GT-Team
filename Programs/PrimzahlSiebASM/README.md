1. Aufgabenstellung
Wir sollen ein Assembler-Programm schreiben, das alle Primzahlen von 2 bis 1000 findet. 
Dafür nutzen wir den Sieb des Eratosthenes. Das funktioniert wie folgt: Wir nehmen alle Zahlen und streichen nacheinander alle Vielfachen (von 2, von 3, von 5, und so weiter) durch. Was übrig bleibt, sind dann die Primzahlen.  

2. Welche Felder brauchen wir? 
Wir brauchen zwei Listen im Speicher:  
Das Sieb-Feld: Eine Liste mit 1000 Plätzen. Der Platz in der Liste steht für die Zahl (z.B Platz 4 steht für die Zahl 4).  
Das Ergebnis-Feld: Eine zweite Liste, wo wir am Ende die gefundenen Primzahlen reinschreiben. 

3. Welchen Typ haben die Elemente? 
Im Sieb-Feld speichern wir nicht die Zahlen, sondern nur Ja (Primzahl) oder Nein (keine Primzahl). 
Dafür reicht uns als Datentyp ein einzelnes Byte pro Platz. (1 oder 0)

4. Der Pseudocode:
Gehe zum Sieb-Feld und schreibe bei allen Zahlen von 2 bis 1000 ein Ja (eine 1) rein.
Nimm die erste Zahl (die 2). Gehe alle Vielfachen dieser Zahl durch (4, 6, 8 und so weiter) und schreibe dort ein Nein (eine 0) rein.
Gehe zur nächsten Zahl, bei der noch Ja steht (die 3). Streiche wieder alle Vielfachen durch. Wiederhole das, bis du am Ende der Liste bist. 
Gehe die Liste nochmal durch: Jede Zahl, die jetzt noch ein "Ja" hat, wird ins Ergebnis-Feld geschrieben.

5. Was uns noch schwerfällt:
Wir wissen noch nicht genau, wie man diese Listen (Arrays) im Speicher von Assembler richtig anlegt.
Wie genau wir die Schleifen bauen, um die Vielfachen durchzugehen, müssen wir im Praktikum noch klären.