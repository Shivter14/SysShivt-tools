@echo off
if "%sst.dir%" equ "" (
	echo.This program requires SysShivt tools.
	timeout 5 > nul
	goto end
)
:start
color f0
mode 96,25
cls
echo.$debug=%sst.errorlevel%
echo.  Welcome to SysShivt tools store %ls.username%.
echo.  [BACKSPACE] / [ESC] = exit
echo.
echo.  Games:
echo.  [  Fish Game by Shivter  ]
getinput
set sst.errorlevel=%errorlevel%
set errorlevel=
if "%sst.errorlevel%" equ "8" goto end
if "%sst.errorlevel%" equ "27" goto end
if %sst.errorlevel% leq -327682 (
	if %sst.errorlevel% geq -327707 goto installfishgame
)
goto start
:installfishgame
if not exist "..\downloads" md "..\downloads"
cd ..\downloads
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/fish.cmd" fishgame.cmd
if not exist "getinput.exe" copy "%sst.dir%\getinput.exe" "getinput.exe"
call fishgame.cmd
cd "%sst.dir%"
goto start
:end
