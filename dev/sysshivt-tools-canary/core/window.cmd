@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.1 or higher! Press any key to exit. . .
	pause>nul
	goto endskpcl
)
if "%~2" neq "/f" if %sst.build% lss 831 (
	echo.This program reqires SysShivt tools 3.1.1 or higher! Press any key to exit. . .
	pause>nul
	goto endskpcl
)
if "%sst.mvc.crrX%" equ "" set sst.mvc.crrX=0
if "%sst.mvc.crrY%" equ "" set sst.mvc.crrY=0
set errorlevel=
if "%~1" equ "/?" (
	for %%a in (
		"window - window GUI for SysShivt tools 3.1.1+"
		"call window <rem|filename>"
		""
		"  Script:"
		"      set sst.window.title=<title>"
		"      set sst.window.args=<argument>"
		"      set sst.window.line<line>=<text>"
		""
		"  title        = sets the title for the window"
		""
		"  arguments:"
		"      /getinput    = adds input box to the window"
		"                     [input will be saved in variable sst.errorlevel]"
		"      /displayonly = it will only display the window, exit, and leave it on the screen"
		"      /keystroke   = it will display the window"
		"                     and pause until you press any key to continue"
		"                     [input will be saved in variable sst.errorlevel]"
		""
		"  text       = text to be displayed at the line specified"
	) do echo.%%~a
	goto trueexit
)
:start
if "%~1" equ "" goto startc
call %1
:startc
set "ind=if not defined sst.window."
%ind%height set sst.window.height=13
%ind%width set sst.window.width=48
%ind%boxX set /a sst.window.boxX=%sst.defaultresX%/2-(%sst.window.width%/2-1)
%ind%boxY set /a sst.window.boxY=%sst.defaultresY%/2-(%sst.window.height%/2)
%ind%lines set /a sst.window.lines=%sst.window.height%-2 
for /l %%a in (1 1 %sst.window.lines%) do set /a sst.window.lineY%%a=%sst.window.boxY%+%%a
%ind%TIcolor set sst.window.TIcolor=8
%ind%FGcolor set sst.window.FGcolor=0
%ind%BGcolor set sst.window.BGcolor=7
%ind%TTcolor set sst.window.TTcolor=f
set ind=
set ssa=set /a sst.window.
%ssa%line=%sst.window.boxX%+2
%ssa%cnbX=%sst.window.boxX%+%sst.window.width%-6
%ssa%cxbX=%sst.window.boxX%+%sst.window.width%-3
%ssa%cxbY=%sst.window.boxX%+%sst.window.width%-1
%ssa%cnbX=%sst.window.boxX%+%sst.window.width%-6
%ssa%cnbY=%sst.window.boxX%+%sst.window.width%-3
%ssa%conb=%sst.window.boxX%+%sst.window.width%-6
%ssa%crpo=%sst.window.boxY%+%sst.window.height%-2
%ssa%giml=%sst.window.width%-4
set ssa=
set sst.window.header=
for /l %%a in (1 1 %sst.window.width%) do call :generateheader
goto \generateheader
:generateheader
set sst.window.header=%sst.window.header% 
goto trueexit
:\generateheader
call box %sst.window.boxX% %sst.window.boxY% %sst.window.height% %sst.window.width% - " " %sst.window.BGcolor%%sst.window.TIcolor%
call batbox /c 0x%sst.window.TIcolor%%sst.window.BGcolor% /g %sst.window.boxX% %sst.window.boxY% /d "%sst.window.header%" /g %sst.window.boxX% %sst.window.boxY% /d " %sst.window.title%" /c 0x%sst.window.BGcolor%%sst.window.FGcolor%
call batbox /c 0x%sst.window.TIcolor%%sst.window.BGcolor% /g %sst.window.cnbX% %sst.window.boxY% /d "      "
if "%sst.window.args%" neq "/getinput" if "%sst.window.args%" neq "/keystroke" if "%sst.window.args%" neq "/displayonly" call batbox /c 0xbf /g %sst.window.cnbX% %sst.window.boxY% /d " - " /c 0xcf /d " X "
for /l %%a in (1 2 %sst.window.lines%) do for /f "" %%b in ('set /a %%a+1') do (
	setlocal enabledelayedexpansion
	call batbox /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g %sst.window.line% !sst.window.lineY%%a! /d "!sst.window.line%%a!"
	if defined sst.window.line%%b call batbox /g %sst.window.line% !sst.window.lineY%%b! /d "!sst.window.line%%b!"
	endlocal
)
if "%sst.window.args%" equ "/getinput" goto getinput
goto \getinput
:getinput
call gettext %sst.window.giml% %sst.window.BGcolor%%sst.window.FGcolor% %sst.window.line% %sst.window.crpo%
goto endskpcl
:\getinput
if "%sst.window.args%" equ "/displayonly" goto endskpcl
if "%sst.window.args%" neq "/keystroke" call cursor
if "%sst.window.args%" equ "/keystroke" call getinput
set sst.errorlevel=%errorlevel%
set errorlevel=
if "%sst.window.args%" equ "/keystroke" goto endskpcl
if %sst.mvc.crrX% geq %sst.window.cxbX% if %sst.mvc.crrX% leq %sst.window.cxbY% if %sst.mvc.crrY% equ %sst.window.boxY% goto end
if %sst.mvc.crrX% geq %sst.window.cnbX% if %sst.mvc.crrX% leq %sst.window.cnbY% if %sst.mvc.crrY% equ %sst.window.boxY% call setres
goto start
:end
call box %sst.window.boxX% %sst.window.boxY% %sst.window.height% %sst.window.width% - " " %sst.window.TIcolor%%sst.window.TIcolor%
:endskpcl
set sst.window.boxX=
set sst.window.boxY=
set sst.window.height=
set sst.window.width=
set sst.window.title=
set sst.window.args=
set sst.window.header=
for /l %%a in (1 1 %sst.window.lines%) do set sst.window.line%%a=
set sst.window.lines=
if "%sst.window.args%" equ "/keystroke" set errorlevel=%sst.errorlevel%
:trueexit