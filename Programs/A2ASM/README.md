
1. Analyse von Anw01 bis Anw06 auf R0,R2,R3.

1. Analyse: 

Anw01: ldr R0, = VariableA
Effekt: R0 wird mit Speicheradresse der VariableA geladen. 

Anw02: ldrb R2, [R0]
Effekt: Der Befehl lädt exakt ein Byte von der adresse von R0(in R0 ist nur die adresse hinterlegt) auf  R2.

Anw03: ldrb R3, [R0,#1]
Effekt: Lädt das nächste Byte von der Adresse R0 +1. ef wäre 0 be wäre 1 also wäre es +1 also 0xbe

Anw04: lsl R2, #8.  
Effekt: Der Wert in R2 0xef wird  um 8 Bits nach links verschoben. 0xef00

Anw05: orr R2, R3
Effekt: Logische ODER Verknüpfung für Register 2 (0xef00) und 3 (0xbe) durch. Ergebnis wird in R2 gespeichert als (0xefbe). 

Anw06: strh R2, [R0] 
Effekt: Der befehl (Store Register Halfword) speichert das Halfword (strh, 16 Bit) aus R2 (0xefbe) an die adresse von R0. Das niedrigste Byte(0xbe) landes auf Startadresse und das hochwertige(0xef) die Folgeadresse. 
Ergebnis im speicher nun be ef steht 


