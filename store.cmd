@echo off
if "%sst.dir%" equ "" (
	echo.This program requires SysShivt tools.
	timeout 5 > nul
	goto end
)
:start
color 0f
mode 96,25
cls
echo.$debug=%sst.errorlevel%
echo.  Welcome to SysShivt tools store %ls.username%.
echo.  [still in developement]
echo.  [BACKSPACE] / [ESC] = exit
getinput
set sst.errorlevel=%errorlevel%
set errorlevel=
goto start
:end
