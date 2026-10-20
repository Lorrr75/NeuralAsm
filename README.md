# NeuralAsm

Una rete neurale scritta da zero in **Assembly x86 (MASM32)** per Windows, senza librerie di calcolo: ogni moltiplicazione, ogni ciclo e ogni byte in memoria sono scritti a mano.

> Stato: **lavori in corso** (v0.2). Il progetto cresce un piccolo passo alla volta, testando ogni blocco prima di passare al successivo.

## Obiettivo

Costruire una rete neurale completa (forward pass, backpropagation, training) partendo dall'esterno e arrivando al cuore:

```
 INPUT LAYER  -->  CORE (neuroni)  -->  OUTPUT LAYER
 (bit -> float)    (pesi, bias,         (risultato e
                    attivazione)         errore)
```

Primo traguardo: una rete **2-2-1** che impara la funzione **XOR**.

## Roadmap

- [x] v0.1 - Scheletro console che si avvia e si chiude
- [x] v0.2 - Input layer a singolo bit (bit -> `real4`), tabella XOR, `LoadSample`
- [ ] v0.3 - Input da tastiera
- [ ] v0.4 - Minicore: un neurone (prodotto scalare in SSE + bias)
- [ ] v0.5 - Funzione di attivazione
- [ ] v0.6 - Layer completo e forward pass
- [ ] v0.7 - Output layer e funzione di costo
- [ ] v0.8 - Backpropagation e ciclo di training su XOR
- [ ] Sperimentazione con tipi di neurone alternativi

## Requisiti

- Windows
- [MASM32 SDK](http://www.masm32.com) installato in `C:\masm32`

## Compilazione

Da prompt dei comandi nella cartella del progetto:

```
build.bat
```

oppure a mano:

```
\masm32\bin\ml /c /coff neural.asm
\masm32\bin\link /SUBSYSTEM:CONSOLE neural.obj
```

Il linker deve usare `/SUBSYSTEM:CONSOLE`: con `WINDOWS` il programma parte ma non mostra nulla.

## Output atteso (v0.2)

```
NeuralAsm v0.2 - test input layer
0 0 -> 0
0 1 -> 1
1 0 -> 1
1 1 -> 0
Controllo range: OK
Premi INVIO per uscire...
```

## Struttura del codice

| Procedura | Compito |
|-----------|---------|
| `ClearInputs` | azzera l'input layer |
| `SetInputBit(idx, bit)` | scrive un bit (0/1) come float nell'input layer; `eax=0` se `idx` fuori range |
| `LoadSample(n)` | carica il campione `n` della tabella XOR in input e uscita attesa |
| `PatternToChar(pat)` | converte `0.0f`/`1.0f` in carattere per il test a console |

## Licenza

Copyright (c) 2026 `<tuo nome>`

Distribuito con licenza **EUPL-1.2** (European Union Public Licence). Vedi il file `LICENSE`.
