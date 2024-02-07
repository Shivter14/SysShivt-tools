@echo off
setlocal enabledelayedexpansion
set sst.recovery.arg=%~2
if "%~1" equ "/ins" echo.  [90m[[91mERROR[90m][91m Invalid variable: [93m"%sst.recovery.arg%"[0m [107m[90m[2m[7m %~3 [0m
if "%~1" equ "/msf" echo.  [90m[[91mFATAL[90m][91m Missing File: [107m[90m[2m[7m ~:!sst.recovery.arg:~%sst.sdir%! [0m
timeout 0 /nobreak > nul