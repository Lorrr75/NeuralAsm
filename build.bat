@echo off
rem SPDX-License-Identifier: EUPL-1.2
rem Build di NeuralAsm (richiede MASM32 in C:\masm32)
\masm32\bin\ml /c /coff neuralasm.asm
if errorlevel 1 goto fine
\masm32\bin\link /SUBSYSTEM:CONSOLE neuralasm.obj
:fine
pause
