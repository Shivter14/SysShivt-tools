@echo off
if "%~1%" equ "" (
	echo.Usage: call spin.cmd [X] [Y] [Number of times]
	goto exit
)
call cmdwiz showcursor 0
set spintimes=%~3
if "%spintimes%" equ "" set spintimes=1
if exist "%sst.temp%\spinexit.cww" del "%sst.temp%\spinexit.cww"
set spin=0
:spin
if %spintimes% leq 0 goto end
set /a spintimes=%spintimes%-1
if "%spin%" equ "0" call batbox /g %~1 %~2 /a 124
if "%spin%" equ "1" call batbox /g %~1 %~2 /a 47
if "%spin%" equ "2" call batbox /g %~1 %~2 /a 45
if "%spin%" equ "3" call batbox /g %~1 %~2 /a 92
call cmdwiz.exe delay 100
if exist "%sst.dir%\shutdown.txt" goto exit
if exist "%sst.dir%\restart.txt" goto exit
if exist "%sst.dir%\restartRM.txt" goto exit
if exist "%sst.dir%\logoff.txt" goto exit
if exist "%sst.temp%\spinexit.cww" goto exit
set /a spin=%spin%+1
if %spin% gtr 3 set spin=0
goto spin
:end
if "%~5" equ "/c" call batbox /g %~1 %~2 /d " "
set spin=
call cmdwiz showcursor 1 25
:exit