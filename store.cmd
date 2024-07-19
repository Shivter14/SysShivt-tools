@echo off & setlocal enableDelayedExpansion
REM  This is not the original SysShivt tools store, but it's an extended fork of it.
if not defined sst.ver (
	echo.This program requires SysShivt tools. Press any key to exit. . .
	pause>nul
	exit /b
)
:start
color f0
cls
echo=
echo=  Welcome to SysShivt tools store, !ls.username!.
echo=  This store is an archive of old SysShivt tools games.
echo=  Updated ^& archived by: Shivter
echo=  [BACKSPACE] / [ESC] = exit
echo=
echo=  Games:
echo=  1 = Fish Game
:main
getinput
set "sst.errorlevel=!errorlevel!"
set errorlevel=
if "!sst.errorlevel!" equ "8" exit /b
if "!sst.errorlevel!" equ "27" exit /b
if "!sst.errorlevel!" equ "49" call :installfishgame
goto main
:installfishgame
color 0f
cls
if not exist "..\downloads" md "..\downloads"
pushd "..\downloads"
curl -o fishgame.cmd "https://github.com/Shivter14/SysShivt-tools/raw/main/fish.cmd" || (
	echo=Something went wrong. Press any key to exit. . .
	pause>nul
	exit /b 1
)
if not exist "getinput.exe" copy "!sst.dir!\getinput.exe" "getinput.exe"
cmd /c fishgame.cmd
popd
exit /b
