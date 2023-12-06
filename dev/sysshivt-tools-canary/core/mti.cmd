@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.0 and higher.
	pause>nul
	goto end
)
if "%~1%~2%~3%~4" equ "" (
	for %%a in (
		"Syntax: call mti <file> <X> <Y> <maxW> [/sftm]"
		""
		"  mti is used to display .mti files."
		""
		"	file	: The path of the MTI file to display."
		"	X	: The X position on the screen."
		"	Y	: The Y position on the screen."
		"	maxW	: Maximum width of the image."
		"	/sftm	: If argument present, file from RAM will be loaded"
		"		  instead with the path <file>."
	) do echo.%%~a
	goto end
)
setlocal enabledelayedexpansion
set /a mti.ta=%sst.defaultresY%-%~3
for /l %%a in (0 1 %mti.ta%) do set mti.Sline%%a=
if "%~5" equ "/sftm" (
	for /f "delims=" %%a in ('call sftm /read "%~1" /s') do set mti.S%%a
) else (
	for /f "delims=" %%a in ('type "%~1"') do set mti.S%%a
)
set /a mti.Dmm=%sst.defaultresX%-1
if %~2 gtr %mti.Dmm% goto end
set /a mti.Dmr=%sst.defaultresX%-%~2
if "%~4" neq "" set /a mti.Dmr=%~4
for /l %%a in (0 1 %mti.ta%) do set /a mti.Dline%%a=%~3+%%a
set mti.src=
for /l %%a in (0 1 %mti.ta%) do if !mti.Dline%%a! leq %sst.defaultresY% if defined mti.Sline%%a call :mti.src= /c 0x%mti.Scolor% /g %~2 !mti.Dline%%a! /d "!mti.Sline%%a:~0,%mti.Dmr%!"
goto \mti.src
:mti.src
set mti.src=%mti.src% %*
goto end
:\mti.src
if "%~5" neq "/nul" call batbox %mti.src% /c 0x07
for /l %%a in (0 1 %mti.ta%) do set mti.Sline%%a=
set mti.Scolor=
:end