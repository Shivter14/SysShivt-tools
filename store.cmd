@echo off & setlocal enabledelayedexpansion
if not defined sst.ver (
	echo.This program requires SysShivt tools. Press any key to exit. . .
	pause>nul
	exit /b
)
:start
color f0
cls
echo=$debug=!sst.errorlevel!
echo=  Welcome to SysShivt tools store, !ls.username!.
echo=  This store is an archive of old SysShivt tools games.
echo=  Updated ^& archived by: Shivter
echo=  [BACKSPACE] / [ESC] = exit
echo=
echo=  Games:
echo=  1 = Fish Game
getinput
set "sst.errorlevel=!errorlevel!"
set errorlevel=
if "!sst.errorlevel!" equ "8" goto end
if "!sst.errorlevel!" equ "27" goto end
if "!sst.errorlevel!" equ "49" goto installfishgame
goto start
:installfishgame
color 0f
cls
if not exist "..\downloads" md "..\downloads"
pushd ..\downloads
curl -o fishgame.cmd "https://github.com/Shivter14/SysShivt-tools/raw/main/fish.cmd"
if not exist "getinput.exe" copy "!sst.dir!\getinput.exe" "getinput.exe"
cmd /c fishgame.cmd
popd
goto start
:end
