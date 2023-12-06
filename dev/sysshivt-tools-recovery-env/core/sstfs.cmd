@echo off
REM BATINFO;CMD+SST;1717;SysShivt tools File System [SSTFS] manager;1.1;Shivter
if "%~1" equ "/save" goto save
if "%~1" equ "/load" goto load
setlocal enabledelayedexpansion
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set /a sstfs.hsh=%%a-1
for %%a in (
	"Syntax: call sstfs.cmd [/save <rampath> <file>"
	"                       |/load <file> <rampath>"
	"                       ]"
	"	- Important -"
	"	This program is made to store files from RAM into a file or load them."
	"	Type 'sftm.cmd' for more info."
	""
	"	/save	: Saves a RAM volume/folder into a file."
	"		rampath	: The path of the RAM volume to store."
	"		file	: The path of the file for the RAM volume to be"
	"			  stored in."
	"	/load	: Loads a file into the RAM."
	"		file	: The path of the file to be loaded into the RAM."
	"		rampath	: The RAM location for the files to be stored in."
) do (
	echo.%%~a
	if defined sstfs.delay timeout 0 /nobreak > nul
	set /a sstfs.hsh=!sstfs.hsh!-1
	if "!sstfs.hsh!" equ "0" (
		set sstfs.delay=True
		set sstfs.hsh=%sstfs.hsh%
		if defined sst.build call batbox /g 0 %sstfs.hsh% /d " - Press any key - "
		pause>nul
		if defined sst.build call batbox /g 0 %sstfs.hsh% /d "                   " /g 0 %sstfs.hsh%
	)
)
endlocal
goto end
:save
if not defined sftm.[%~2] (
	echo.Volume "%~2" was not found in memory.
	goto end
)
for /f "tokens=1* delims=]" %%a in ('set "sftm.[%~2]"') do echo.]%%b>> "%~3"
for /f "tokens=2* delims=/" %%a in ('set "sftm.[%~2/"') do echo./%%b>> "%~3"
goto end
:load
if not exist "%~2" (
	echo.File "%~2" was not found.
	goto end
)
for /f "delims=" %%a in ('type "%~2"') do set sftm.[%~3%%a
:end