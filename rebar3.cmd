@echo off
setlocal
set rebarscript=%~f0
"C:\Program Files\erl9.1\bin\escript.exe" "%rebarscript:.cmd=%" %*