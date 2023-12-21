@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.2.0 or higher! Press any key to exit. . .
	pause>nul
	goto endskpcl
)
if "%~2" neq "/f" if %sst.build% lss 2420 (
	echo.This program reqires SysShivt tools 3.2.0 or higher! Press any key to exit. . .
	pause>nul
	goto endskpcl
)
if "%sst.mvc.crrX%" equ "" set sst.mvc.crrX=0
if "%sst.mvc.crrY%" equ "" set sst.mvc.crrY=0
set errorlevel=
if "%~1" equ "/?" (
	for %%a in (
		"window - window GUI for SysShivt tools 3.2.0+"
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
		"      /getinput    = adds an input box into the window"
		"                     [input will be saved in variable sst.errorlevel]"
		"      /displayonly = display the window, exit, and leave it on the screen"
		"      /keystroke   = it will display the window"
		"                     and wait until you press any key to continue"
		"                     [input will be saved in variable sst.errorlevel]"
		"      /buttons     = adds buttons into the window"
		"                     To specify the buttons, set the variable"
		"                     'sst.window.buttons' with the following format:"
		"                     'sst.window.buttons="Example" "Example2"'"
		""
		"  text       = text to be displayed at the line specified"
	) do echo.%%~a
	goto trueexit
)
:start
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
%ind%TXcolor set sst.window.TXcolor=0xf0
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
if "%sst.window.args%" equ "/buttons" set sst.window.selected=0
for /l %%a in (1 1 %sst.window.width%) do call :generateheader
goto \generateheader
:generateheader
set sst.window.header=%sst.window.header% 
goto trueexit
:\generateheader
call cmdwiz showcursor 0
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
set /a sst.window.lastline=%sst.window.lines%+1
if defined sst.window.mti (
	call mti.cmd %sst.window.mti%
	setlocal enabledelayedexpansion
	call batbox /g %sst.window.line% !sst.window.lineY%sst.window.lines%!
	endlocal
)
if "%sst.window.args%" equ "/getinput" goto getinput
goto \getinput
:getinput
call gettext %sst.window.giml% %sst.window.BGcolor%%sst.window.FGcolor% %sst.window.line% %sst.window.crpo%
goto endskpcl
:\getinput
set sst.mvc.errorlevel=
if "%sst.window.args%" equ "/displayonly" goto endskpcl
if "%sst.window.args%" equ "/keystroke" (call getinput
) else if "%sst.window.args%" equ "/buttons" (goto buttons
) else call cursor
goto \buttons
:buttons
setlocal enabledelayedexpansion
set sst.window.counter=0
for %%a in (%sst.window.buttons%) do (
	if "!sst.window.counter!" neq "0" call batbox /c 0x%sst.window.BGcolor%%sst.window.FGColor% /d "  "
	call :buttons.set Start
	if "%sst.window.selected%" equ "!sst.window.counter!" (
		call batbox /c %sst.window.TXcolor% /d " %%~a "
	) else call batbox /c 0x%sst.window.TIcolor%%sst.window.TTcolor% /d " %%~a "
	call :buttons.set End -1
	set /a sst.window.counter=!sst.window.counter!+1
)
set sst.window.button[ > "%sst.temp%\window.sstenv"
endlocal && set /a sst.window.buttoncount=%sst.window.counter%-1
for /f "delims=" %%a in ('type "%sst.temp%\window.sstenv"') do set "%%~a"
call cursor /k
set sst.ext.errorlevel=%errorlevel%
set sst.mvc.errorlevel=%sst.errorlevel%
set sst.errorlevel=%sst.ext.errorlevel%
goto ctrl
goto \buttons
:buttons.set
call cmdwiz getcursorpos x
set /a sst.window.button[%sst.window.counter%].%~1=%errorlevel%%~2
exit /b
:\buttons
set sst.errorlevel=%errorlevel%
set errorlevel=
if "%sst.window.args%" equ "/keystroke" goto endskpcl
:ctrl
if "%sst.mvc.errorlevel%" neq "CHAR" (
	if "%sst.mvc.crrY%" equ "%sst.window.crpo%" (
		setlocal enabledelayedexpansion
		for /l %%a in (0 1 %sst.window.buttoncount%) do if %sst.mvc.crrX% geq !sst.window.button[%%a].Start! if %sst.mvc.crrX% leq !sst.window.button[%%a].End! (
			set sst.window.selected=%%a
			goto buttons.exit
		)
		endlocal
	)
	if %sst.mvc.crrX% geq %sst.window.cxbX% if %sst.mvc.crrX% leq %sst.window.cxbY% if %sst.mvc.crrY% equ %sst.window.boxY% goto end
	if %sst.mvc.crrX% geq %sst.window.cnbX% if %sst.mvc.crrX% leq %sst.window.cnbY% if %sst.mvc.crrY% equ %sst.window.boxY% call setres
) else if "%sst.window.args%" equ "/buttons" (
	if "%sst.errorlevel%" equ "97" if "%sst.window.selected%" neq "0" set /a sst.window.selected=%sst.window.selected%-1
	if "%sst.errorlevel%" equ "100" if "%sst.window.selected%" neq "%sst.window.buttoncount%" set /a sst.window.selected=%sst.window.selected%+1
	if "%sst.errorlevel%" equ "32" (
		set sst.errorlevel=%sst.window.selected%
		exit /b
	)
)
goto \generateheader
:buttons.exit
endlocal && set sst.errorlevel=%sst.window.selected%
:end
call box %sst.window.boxX% %sst.window.boxY% %sst.window.height% %sst.window.width% - " " %sst.window.TIcolor%%sst.window.TIcolor%
:endskpcl
for %%a in ("boxX" "boxY" "height" "width" "title" "args" "header" "mti") do set sst.window.%%~a=
for /l %%a in (1 1 %sst.window.lines%) do set sst.window.line%%a=
set sst.window.lines=
if "%sst.window.args%" equ "/keystroke" exit /b %sst.errorlevel%
exit /b
:trueexit