@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools! Press any key to exit. . .
	pause>nul
	goto exit
)
setlocal enabledelayedexpansion
set shl.errorlevel=0
:main
if "!cd:~0,%sst.sdir%!" neq "%sst.cd%" cd "%sst.cd%"
set shl.cmd=
set /p "shl.cmd=[106m[93m %ls.username% [104m[97m %shl.errorlevel% [0m[92m ~:!cd:~%sst.sdir%![93m>[38;5;255m "

set shl.dir=%cd%
cd "%temp%"
if exist shellBE.txt del shellBE.txt
call cmdwiz saveblock shellBE 0 0 96 23 txt " " 0 f
cd "%shl.dir%"

if "%shl.cmd:~0,5%" equ "exit" goto exit
if "%shl.cmd:~0,4%" equ "ver" (
	echo.[93m
	echo.Sshell BE for SysShivt tools 3.1 [version 1.3][38;2;255;255;255m
)
set errorlevel=
call %shl.cmd%
set shl.errorlevel=%errorlevel%
goto main
:exit