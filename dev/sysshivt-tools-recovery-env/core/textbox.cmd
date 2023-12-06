@echo off
setlocal enabledelayedexpansion
:m
if "%~1"=="/g" (for /f "" %%x in ('set /a %~2+1') do for /f "" %%y in ('set /a %~3+1') do set/p"=[%%y;%%xf"<nul
shift/1
shift/1
shift/1
goto m)
if "%~1"=="/d" (set/p"=.%~2"<nul
shift/1
shift/1
goto m)
if "%~1"=="/a" (set/p"=?"<nul
shift/1
shift/1
goto m)
if "%~1" neq "" (shift/1
goto m)
endlocal