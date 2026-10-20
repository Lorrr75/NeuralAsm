;
; NeuralAsm - rete neurale in assebly x86(MASM32, Windows, cosole)
; v0.2 - input layer + tabella XOR + LoadSample (test a console)
;

.386
.model	flat, stdcall

option	casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc

includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib

INPUT_COUNT	equ 2
SAMPLE_COUNT	equ 4

.const
BitToFloat	real4 0.0, 1.0			; indice = bit (0/1) -> float

.data
szTitle			db "NeuralAsm v0.2 - test input layer", 13, 10, 0
szRangeOK		db "Controllo range: OK", 13, 10, 0
szRangeBad		db "Controllo range: ERRORE", 13, 10, 0
szExit			db "Premi INVIO per uscire...", 13, 10, 0
Line			db "? ? -> ?", 13, 10, 0		; posizioni 0, 2 = input; 7 = atteso

; tabella XOR: per ogni campione bit0, bit1, atteso ( 3DWORD = 12 byte)
XorTable		dd 0, 0, 0
			dd 0, 1, 1
			dd 1, 0, 1
			dd 1, 1, 0


.data?
InputLayer		real4 INPUT_COUNT dup(?)	; valori di input come float
Expected		real4 ?				; uscita del campione corrente
KeyBuf			db 8 dup(?)			; buffer di tastiera

.code

;
; ClearInputs: azzera l'input layer (0.0f = pattern 0000000h)
;
ClearInputs proc uses edi
	xor	eax, eax
	mov	ecx, INPUT_COUNT
	mov	edi, offset InputLayer
	rep	stosd
	ret
ClearInputs endp

;
; SetInputBit(idx, bit): eax = 1 ok, 0 se idx fuori range
;
SetInputBit proc idx:DWORD, bit:DWORD
	mov	eax, idx
	cmp	eax, INPUT_COUNT
	jae	@@bad
	mov	ecx, bit
	and	ecx, 1
	mov	edx, dword ptr BitToFloat[ecx*4]
	mov	dword ptr InputLayer[eax*4], edx
	mov	eax, 1
	ret
@@bad:
	xor	eax, eax
	ret
SetInputBit endp

;
; LoadSample(n): carica il campione n e nell'input layer e in Expected
; eax = 1 ok, o se fuori range
;
LoadSample proc uses esi n:DWORD
	mov	eax, n
	cmp	eax, SAMPLE_COUNT
	jae	@@bad
	lea	eax, [eax+eax*2]		; n*3
	lea	esi, XorTable[eax*4]		; n*12 byte
	invoke	SetInputBit, 0, dword ptr [esi]
	invoke	SetInputBit, 1, dword ptr [esi+4]
	mov	ecx, dword ptr [esi+8]
	and	ecx, 1
	mov	edx, dword ptr BitToFloat[ecx*4]
	mov	dword ptr Expected, edx
	mov	eax, 1
	ret

@@bad:
	xor	eax, eax
	ret
LoadSample endp

;
; PatternToChar(pat): eax = '0' se 0.0f, '1' se 1.0f, '?' altrimenti
;
PatternToChar proc pat:DWORD
	mov	eax, pat
	test	eax, eax
	jz	@@zero
	cmp	eax, 3F800000h
	je	@@one
	mov	eax, '?'
	ret
@@zero:
	mov	eax, '0'
	ret
@@one:
	mov	eax, '1'
	ret
PatternToChar endp

start:
	invoke	StdOut, offset szTitle		; scrive nella console

	xor	ebx, ebx			; ebx = indice campione
@@next:

	invoke	LoadSample, ebx

	invoke	PatternToChar, dword ptr InputLayer[0]
	mov	byte ptr Line[0], al
	invoke	PatternToChar, dword ptr InputLayer[4]
	mov	byte ptr Line[2], al
	invoke	PatternToChar, dword ptr Expected
	mov	byte ptr Line[7], al

	invoke	StdOut, offset Line
	inc	ebx
	cmp	ebx, SAMPLE_COUNT
	jb	@@next

	; controllo robustezza: un campione fuori range deve essere rifiutato
	invoke	LoadSample, SAMPLE_COUNT
	test	eax, eax
	jnz	@@rangebad

	invoke	StdOut, offset szRangeOK
	jmp	@@done

@@rangebad:
	invoke	StdOut, offset szRangeBad

@@done:
	; attende il tasto INVIO per chiudere il programma
	invoke	StdOut, offset szExit
	invoke	StdIn, offset KeyBuf, 4		; attende INVIO
	invoke	ExitProcess, 0			;esce a windows

end start

