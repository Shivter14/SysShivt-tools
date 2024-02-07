@echo off
if not defined sst.build goto sysreqfail
if %sst.build% lss 2220 goto sysreqfail
goto \sysreqfail
:sysreqfail
if defined sst.build goto msysreqfail
:ssysreqfail
color 0f
cls
echo.This program reqires SysShivt tools 3.1.i build 2220
echo.[Service pack 5] or higher!
if defined sst.ver if defined sst.build echo.Your SysShivt tools version: %sst.ver% [build %sst.build% / %sst.subvinfo%]
echo.Press any key to exit. . .
pause>nul
exit /b -2
:msysreqfail
if %sst.build% lss 1220 goto ssysreqfail
for %%a in ("width=42" "height=7" "title=Failed to launch this program" "line2=This program reqires to be run in" "line3=SysShivt tools 3.1.i build 2220" "line4=[Service Pack 5]") do set "sst.window.%%~a"
call window rem
exit /b -2
:\sysreqfail
if "%~1" equ "/module" goto access_module
goto __init__

rem === Modules ===
:access_module
for %%a in ("exit", "tasks.trigger") do if "%%~a" equ "%~2" goto access_module.run
exit /b
:access_module.run
set sstenv.access_module=%~2
shift /1
shift /1
goto sstenv.%sstenv.access_module%

:sstenv.exit
set sstenv.cursor=Used
setlocal enabledelayedexpansion
set sstenv.newtasks=
for %%a in (%sstenv.tasks%) do if "%%~a" neq "%~1" (set sstenv.newtasks=!sstenv.newtasks! %%a
) else set sstenv.exit=True
for %%a in (%sstenv.tasks.render%) do if "%%~a" neq "%~1" (set sstenv.newtasks.render=!sstenv.newtasks.render! %%a
) else set sstenv.exit=True
if defined "sstenv.task.[%~1]" (set "sstenv.task.[%~1]="
) else if defined sstenv.exit echo.echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mSSTENV[0m[2m] [0m[91m{:sstenv.exit} Something went wrong: TASK_NULL_POINTER from "%~1" >> "%sst.dir%\log.txt"
set sstenv.exit=
(
	endlocal
	set sstenv.tasks=%sstenv.newtasks%
	set sstenv.tasks.render=%sstenv.newtasks.render%
	set sstenv.task.[%~1]=nul
	for /f "delims==" %%a in ('set sstenv.task.[%~1]') do set %%a=
)
exit /b
:sstenv.tasks.trigger
call cmdwiz showcursor 0
set sstenv.focused=True
for %%a in (%sstenv.tasks%) do (
	call %%~a %%a
	set sstenv.focused=False
)
set sstenv.focused=True
for %%a in (%sstenv.tasks.render%) do (
	call %%~a %%a /render
	set sstenv.focused=False
)
exit /b


rem === embedded programs ===

:desktop
if not defined sstenv.desktop goto desktop.__init__
goto desktop.main
:desktop.__init__
call setres
set sstenv.desktop=True
if exist "%sst.userprofile%" if not exist "%sst.userprofile%\desktop" md "%sst.userprofile%\desktop"
if not exist "%sst.userprofile%\desktop" if "%sst.desktop.showicons%" neq "True" goto \settile
if defined fdc.[desktop] call fdcore /delsession desktop
set /a sst.desktop.offset=%sst.crrresX%/%sst.desktop.tileW%
set /a sst.desktop.offset*=%sst.desktop.tileW%
set /a sst.desktop.offset=%sst.crrresX%-%sst.desktop.offset%
set /a sst.desktop.offset=%sst.desktop.offset%/2
call fdcore /newsession desktop %sst.desktop.offset% 0 %sst.crrresX% %sst.defaultresY% %sst.desktop.tileW% %sst.desktop.tileH%
for /f "delims=" %%a in ('dir /b "%sst.userprofile%\desktop"') do call :desktop.settile "%sst.userprofile%\desktop\%%~a"
goto desktop.main
:desktop.settile
call fdcore /addtile desktop "%~nx1" "%~x1" "%~f1"
exit /b
:desktop.main
if "%~2" equ "/render" goto desktop.render
if "%sst.desktop.showicons%" equ "True" if "%sstenv.focused%" equ "True" (
	call batbox %sst.menu.batbox%
	call fdcore /display desktop 0f
)
if "%sstenv.cursor%" neq "Not used" exit /b
if not defined sst.mvc.crrX exit /b
if not defined sst.mvc.crrY exit /b
if %sst.mvc.crrX% geq 1 if %sst.mvc.crrX% leq 18 if %sst.mvc.crrY% equ %sst.menu.ssb.reload% (
	set sstenv.cursor=Used
	goto desktop.__init__
)
if %sst.mvc.crrY% equ %sst.defaultresY% if %sst.mvc.crrX% geq %sst.startmenu.cl1% if %sst.mvc.crrX% leq %sst.startmenu.cl2% (
	set sstenv.cursor=Used
	call clock.cmd
	call :sstenv.tasks.trigger
	exit /b
)
if %sst.mvc.crrX% geq 1 if %sst.mvc.crrX% leq 18 if %sst.mvc.crrY% equ %sst.defaultresY% (
	set sstenv.cursor=Used
	cmd /c startmenu.cmd
	if ERRORLEVEL 27 exit 0
	for %%a in ("shutdown.txt" "restart.txt" "crash.txt" "crashed.txt" "restartRM.txt") do if exist "%sst.dir%\%%~a" exit 0
	call setres
	call :sstenv.tasks.trigger
	exit /b
)
if "%sst.mvc.crrX%,%sst.mvc.crrY%" equ "0,0" if "%sst.crr.errorlevel%" equ "OPTIONS" (
	call setres /d
	goto exit
)
if "%sst.desktop.showicons%" equ "True" if "%sstenv.focused%" equ "True" (
	call fdcore /touch desktop %sst.mvc.crrX% %sst.mvc.crrY%
	if defined fdc.errorlevel for /f "tokens=1* delims==" %%a in ('set fdc.errorlevel') do if "%%~a" equ "fdc.errorlevel" if "%%~b" neq "nul" (
		set sstenv.cursor=Used
		goto desktop.iconinteraction
	)
)
exit /b
:desktop.iconinteraction
setlocal enabledelayedexpansion
for /f "tokens=2,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[4\"') do if "%fdc.errorlevel.icon%" equ "%%~a" (
	if "%sst.errorlevel%" neq "OPTIONS" (
		call %%b "%sst.userprofile%\desktop\%fdc.errorlevel.name%"
		call setres
	) else (
		set sst.mvc.options=True
		set sst.desktopoptions.boxX=%sst.mvc.crrX%
		set sst.desktopoptions.boxY=%sst.mvc.crrY%
		set sst.desktopoptions.width=20
		set sst.desktopoptions.height=3
		set /a sst.desktopoptions.endX=!sst.desktopoptions.boxX!+!sst.desktopoptions.width!
		set /a sst.desktopoptions.endY=!sst.desktopoptions.boxY!+!sst.desktopoptions.height!
		if !sst.desktopoptions.endX! geq %sst.defaultresX% (
			set /a sst.desktopoptions.boxX=!sst.desktopoptions.boxX!-!sst.desktopoptions.width!
			set /a sst.desktopoptions.endX=!sst.desktopoptions.boxX!+!sst.desktopoptions.width!
		)
		if !sst.desktopoptions.endY! geq %sst.defaultresY% (
			set /a sst.desktopoptions.boxY=!sst.desktopoptions.boxX!-!sst.desktopoptions.height!
			set /a sst.desktopoptions.endY=!sst.desktopoptions.boxX!+!sst.desktopoptions.height!
		)
		set /a sst.desktopoptions.list=!sst.desktopoptions.boxX!+2
		set /a sst.desktopoptions.options=!sst.desktopoptions.boxY!+1
		set sst.desktopoptions.batbox=
		if "!fdc.errorlevel.icon!" == ".cmd" (
			set sst.desktopoptions.app.type=UNKNOWN
			set sst.desktopoptions.app.build=%sst.build%
			set sst.desktopoptions.app.info=UNKNOWN
			set sst.desktopoptions.app.ver=UNKNOWN
			set sst.desktopoptions.app.auth=UNKNOWN
			for /f "tokens=2,3,4,5,6 delims=;" %%c in ('type "%sst.userprofile%\desktop\!fdc.errorlevel.name!" ^| find "EM BATINFO;"') do (
				set "sst.desktopoptions.app.type=%%~c"
				set "sst.desktopoptions.app.build=%%~d"
				set "sst.desktopoptions.app.info=%%~e"
				set "sst.desktopoptions.app.ver=%%~f"
				set "sst.desktopoptions.app.auth=%%~g"
			)
			call getlen "!sst.desktopoptions.app.info!"
			set /a sst.desktopoptions.width=!errorlevel!+4
			if !sst.desktopoptions.width! lss 24 set sst.desktopoptions.width=24
			set /a sst.desktopoptions.height=!sst.desktopoptions.height!+5
			set /a sst.desktopoptions.info=!sst.desktopoptions.boxY!+1
			set /a sst.desktopoptions.ver=!sst.desktopoptions.info!+1
			set /a sst.desktopoptions.auth=!sst.desktopoptions.ver!+1
			set /a sst.desktopoptions.build=!sst.desktopoptions.auth!+1
			set /a sst.desktopoptions.type=!sst.desktopoptions.build!+1
			set /a sst.desktopoptions.options=!sst.desktopoptions.type!+1
			set sst.desktopoptions.batbox=/c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g !sst.desktopoptions.list! !sst.desktopoptions.info! /d "!sst.desktopoptions.app.info!" /g !sst.desktopoptions.list! !sst.desktopoptions.ver! /d "Version: !sst.desktopoptions.app.ver!" /g !sst.desktopoptions.list! !sst.desktopoptions.auth! /d "Author: !sst.desktopoptions.app.auth!" /g !sst.desktopoptions.list! !sst.desktopoptions.build! /d "SST build: !sst.desktopoptions.app.build!" /g !sst.desktopoptions.list! !sst.desktopoptions.type! /d "App Type: !sst.desktopoptions.app.type!"
		)
		call box !sst.desktopoptions.boxX! !sst.desktopoptions.boxY! !sst.desktopoptions.height! !sst.desktopoptions.width! - " " %sst.window.BGcolor%%sst.window.TIcolor% 1
		call batbox !sst.desktopoptions.batbox! /c 0x%sst.window.BGcolor%%sst.window.TIcolor% /g !sst.desktopoptions.list! !sst.desktopoptions.options! /d "= Options =" /g !sst.desktopoptions.list! !sst.desktopoptions.boxY! /d "!sst.desktop.[%%xx%%y].name!"
		call cursor "%sst.dir%\systemapps\programfiles\shell.cmd"
		call setres
	)
)
call :sstenv.tasks.trigger
endlocal
:desktop.render
if "%sstenv.focused%" equ "True" (call setres /o
) else call setres
set /a sst.menu.ssb.reload=%sst.defaultresY%-2
set /a sst.desktop.gridX=%sst.defaultresX%/%sst.desktop.gridsizeX%-1
set /a sst.desktop.gridY=%sst.defaultresY%/%sst.desktop.gridsizeY%-1
set sst.menu.batbox=/c 0x0f /g 1 %sst.menu.ssb.reload% /d "%sst.lang.reloadbutton%"
call batbox %sst.menu.batbox%
exit /b

rem === Initialization ===
:__init__
if not defined sstenv.tasks (
	set sstenv.tasks=":desktop"
	set sstenv.tasks.render=":desktop"
	set sstenv.task.[:desktop]=FullScreenMode
	set sstenv.task.[:desktop].hideFromTB=True
)
set sst.mvc.char=0
set sstenv.cursor=No change

rem === Finally, the main loop ===
:main
set sstenv.focused=True
call cmdwiz showcursor 0
for %%a in (%sstenv.tasks.render%) do (
	call %%~a %%a /render
	set sstenv.focused=False
)
set sstenv.focused=True
for %%a in (%sstenv.tasks%) do (
	call %%~a %%a
	set sstenv.focused=False
)
call startmenu.cmd /display
set sst.errorlevel=
if exist shutdown.txt exit
if exist crashed.txt exit
if exist crash.txt exit
if exist restart.txt exit
call cursor /k
set sst.mvc.char=%errorlevel%
set sst.crr.errorlevel=%sst.errorlevel%
if "%sst.crr.errorlevel%" equ "CHAR" (
	set sstenv.cursor=No change
) else set sstenv.cursor=Not used

if defined sstenv.tasks goto main
setres
call cmdwiz showcursor 1 25