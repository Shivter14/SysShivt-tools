@echo off
if not defined sst.build (
	This program reqires SysShivt tools! Press any key to exit. . .
	pause>nul
	goto end
)
if "%~1" equ "/?" (
	echo.SSTUTIL.CMD - Displays SysShivt tools utility list
	goto end
)
if "%~1" equ "easteregg" goto game
setlocal enabledelayedexpansion
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set /a sstutil.hsh=%%a-1
echo.SysShivt tools utility list
echo.[GTUI = Graphical text user interface]
for %%a in (
	"sstutil;Displays SysShivt tools utility list"
	"shutdown;Shuts SysShivt tools down"
	"window;SysShivt tools window manager"
	"batbox;A core GTUI tool"
	"box	;A funcion to make boxes using batbox"
	"line	;A funcion to make lines using batbox"
	"spin	;A funcion to make DOS-Like loading icons"
	"setres;A funcion to manage the resolution and wallpapers"
	"desktop;The SysShivt tools GTUI"
	"login-system;The SysShivt tools login system"
	"gettext;The SysShivt tools input funcion"
	"getinput;A core input tool"
	"cwt	;.CWT file mapper"
	"txt	;A User Interface to open text files"
	"loading;The SysShivt tools loading screen"
	"rgb	;An animated smooth line that is used above"
	"bboc	;A program that takes batbox output and shifts the position"
	"shell	;A console that keeps variables after exit"
	"fdcore;File displaying core"
	"sftm	;A program that can store files to RAM and also read them"
	"sstfs	;A filesystem manager based on SFTM"
	"sysenv;SysShivt tools multi-tasking GTUI"
) do (
	for /f "tokens=1,2 delims=;" %%b in ("%%~a") do echo.  %%b	%%c.
	if defined sstutil.delay timeout 0 /nobreak > nul
	set /a sstutil.hsh=!sstutil.hsh!-1
	if "!sstutil.hsh!" equ "2" (
		set sstutil.delay=True
		set sstutil.hsh=%sstutil.hsh%
		call batbox /g 0 %sstutil.hsh% /d " - Press any key - "
		pause>nul
		call batbox /g 0 %sstutil.hsh% /d "                   " /g 0 %sstutil.hsh%
	)
)
endlocal
goto end
:game
setlocal enabledelayedexpansion
call cmdwiz showcursor 1 25
cls
set /p "sstutil.fx=FONTSIZE.WIDTH="
set /p "sstutil.fy=FONTSIZE.HEIGHT="
call cmdwiz showcursor 0
cls
for /l %%a in (0 0 1) do (
set sstutil.ox=!sstutil.cx!
set sstutil.oy=!sstutil.cy!
call cmdwiz getmousecursorpos x
set sstutil.mx=!errorlevel!
call cmdwiz getmousecursorpos y
set sstutil.my=!errorlevel!
call cmdwiz getwindowbounds x
set sstutil.wx=!errorlevel!
call cmdwiz getwindowbounds y
set sstutil.wy=!errorlevel!
set /a sstutil.cx=!sstutil.mx!-!sstutil.wx!-8
set /a sstutil.cx=!sstutil.cx!/!sstutil.fx!
set /a sstutil.cy=!sstutil.my!-!sstutil.wy!-31
set /a sstutil.cy=!sstutil.cy!/!sstutil.fy!
set sstutil.pointer=1
if !sstutil.cx! lss 0 (
	set sstutil.pointer=17
	set sstutil.cx=0
)
if !sstutil.cx! gtr !sst.defaultresX! (
	set sstutil.pointer=16
	set sstutil.cx=!sst.defaultresX!
)
if !sstutil.cy! lss 0 (
	set sstutil.pointer=30
	set sstutil.cy=0
	if "!sstutil.pointer!" equ "17" set sstutil.pointer=1
	if "!sstutil.pointer!" equ "16" set sstutil.pointer=1
)
if !sstutil.cy! geq !sst.defaultresY! (
	set /a sstutil.pointer=31
	set /a sstutil.cy=!sst.defaultresY!-1
	if "!sstutil.pointer!" equ "16" set sstutil.pointer=1
	if "!sstutil.pointer!" equ "17" set sstutil.pointer=1
)
call batbox /g !sstutil.ox! !sstutil.oy! /a 0 /g !sstutil.cx! !sstutil.cy! /a !sstutil.pointer!
)
:end