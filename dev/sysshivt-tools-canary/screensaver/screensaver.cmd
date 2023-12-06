@echo off
if "%sst.ver%" equ "" (
	color 0f
	cls
	echo.This program reqires SysShivt tools
	timeout 3 > nul
	goto exit
)
if exist "exit.txt" del "exit.txt"
:run
echo.@call screensaver-b.cmd>screensaver-bl.cmd
start /b cmd /c screensaver-bl.cmd
pause>nul
echo.>exit.txt
call cmdwiz delay 256
:exit