@echo off
if not defined sst.build goto sysreqfail
if %sst.build% lss 1603 goto sysreqfail
if not defined sstsc.task goto sysreqfail
if not defined sstsc.task.self goto sysreqfail
if not defined sstsc.session goto sysreqfail
setlocal enabledelayedexpansion
goto __init__
:sysreqfail
echo.This program reqires SysShivt tools 3.1.3 build 1603 or higher!
if defined sst.ver if defined sst.build echo.Your SysShivt tools version: %sst.ver% [build %sst.build%]
echo.It also reqires to be run in 'sysscene.cmd'.
echo.Press any key to exit. . .
pause>nul
exit /b -2

rem === Modules ===
:batbox
if not exist "%sst.temp%\sysscene\%sstsc.session%" exit
echo.batbox;%batbox%> "%sst.temp%\sysscene\%sstsc.session%\%random%"
exit /b
:send
if not exist "%sst.temp%\sysscene\%sstsc.session%" exit
echo.%*> "%sst.temp%\sysscene\%sstsc.session%\%random%"
exit /b
:__init__
echo.Running
rem === Main ===
:main
set input=
set /p "input=%sstsc.task.self%@%sstsc.task%>"
if "%input%" equ "exit" exit
if "%input%" equ "test" (
	call box 2 2 9 32 - "_" ff 1 test
	set batbox=!test! /c 0xf0 /g 4 3 /d "Hello    world"
	call :batbox
)
if defined input call :send %input%
if exist "%sst.temp%\sysscene\%sstsc.session%" goto main