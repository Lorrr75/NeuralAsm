; test di avvio del programma sotto console windows

.386
.model	flat, stdcall

option	casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc

includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib

.data

szTitle			db "NeuralAsm v0.1 - avvio ok", 13, 10
			db "Premi INVIO per uscire...", 13, 10

.data?

KeyBuf			db 8 dup(?)		; buffer di tastiera

.code

start:
	invoke	StdOut, offset szTitle		; scrive nella console
	invoke	StdIn, offset KeyBuf, 4		; attende tasto INVIO


	invoke	ExitProcess, 0			;esce a windows

end start

