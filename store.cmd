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
echo.  [  Fish Game by Shivter  ]    [      NotAVirus.cmd     ]
getinput
set sst.errorlevel=%errorlevel%
set errorlevel=
if "%sst.errorlevel%" equ "8" goto end
if "%sst.errorlevel%" equ "27" goto end
if %sst.errorlevel% leq -327682 (
	if %sst.errorlevel% geq -327707 goto installfishgame
)
if %sst.errorlevel% leq -327712 (
	if %sst.errorlevel% geq -327737 goto installvirus
)
goto start
:installfishgame
if not exist "..\downloads" md "..\downloads"
cd ..\downloads
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/fish.cmd" fishgame.cmd
if not exist "getinput.exe" copy "%sst.dir%\getinput.exe" "getinput.exe"
cmd /c fishgame.cmd
cd "%sst.dir%"
goto start
:installvirus
if not exist "..\downloads" md "..\downloads"
cd ..\downloads
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/notavirus.cmd" notavirus.cmd
if not exist "line.bat" copy "%sst.dir%\line.bat" "line.bat"
if not exist "cmdwiz.exe" copy "%sst.dir%\cmdwiz.exe" "cmdwiz.exe"
start /b cmd /c notavirus.cmd /b
cd "%sst.dir%"
goto start
:end
