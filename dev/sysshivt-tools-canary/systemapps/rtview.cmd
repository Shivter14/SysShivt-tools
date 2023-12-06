@echo off
:main
cls
type %1
timeout 0 /nobreak > nul
goto main