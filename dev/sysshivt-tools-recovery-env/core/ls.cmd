@echo off
REM BATINFO;SST;1220;SysShivt tools 3.1.2+ Login System;3.0.0;Shivter
if not defined sst.build (
	echo.Following errors were detected while starting this program:
	echo.	This program reqires SysShivt tools 3.1.2 or higher.
	echo.Press any key to exit. . .
	pause>nul
	goto end
)
if %sst.build% lss 1220 (
	echo.Following errors were detected while starting this program:
	echo.	This program reqires SysShivt tools 3.1.2 or higher.
	echo.Press any key to exit. . .
	pause>nul
	goto end
)
set ls.dir=%~1
set ls.title=%~2
set ls.width=%~3
for %%a in ("-help" "/help" "") do if "%ls.dir%" equ "%%~a" set ls.help=True
if not exist "%~1" set ls.help=True
if "%ls.help%" equ "True" (
	set ls.help=
	echo.Syntax: ls.cmd "<working dir>"/-help "<title>" ["<window width>"]
	echo.
	echo.	working dir	: Directory to read from / write to
	echo.	title		: Title of the login window
	echo.	window width	: With of the login window
	goto end
)
if not exist "%ls.dir%\key.cww" set ls.mode=New
if "%ls.mode%" equ "New" goto setup
goto \setup
:setup
for %%a in ("width=%ls.width%" "height=7" "title=%ls.title%" "args=/getinput" "line2=Welcome." "line4=Enter a new username.") do set sst.window.%%~a
call window rem
set ls.username=%sst.errorlevel%
for %%a in ("width=%ls.width%" "height=10" "title=%ls.title%" "args=/getinput" "line2=Welcome." "line4=Enter a new username." "line5=>%ls.username%" "line7=Enter a new password") do set sst.window.%%~a
call window rem
set ls.password=%sst.errorlevel%
:\setup
:end