@echo off
if "%sst.build%" equ "" (
	echo.This program reqires SysShivt tools. Press any key to exit. . .
	pause>nul
	goto trueexit
)
setlocal enabledelayedexpansion
if exist logoff.txt del logoff.txt
if exist shutdown.txt del shutdown.txt
if exist restart.txt del restart.txt
if exist restartRM.txt del restartRM.txt
if exist crashed.txt del crashed.txt
if exist recovery.txt del recovery.txt
:reload
if exist "%sst.temp%" echo.DESKTOPLOAD> "%sst.temp%\errorlevel.cww"
if not exist "%sst.userprofile%\desktop" md "%sst.userprofile%\desktop"
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\4]"') do set sst.desktop.tileW=%%a
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\5]"') do set sst.desktop.tileH=%%a
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\6]"') do set sst.wallpaper.name=%%a
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[2\4]"') do set sst.desktop.showicons=%%a
if exist "%sst.userprofile%\desktop" if "%sst.desktop.showicons%" equ "True" (
	if defined fdc.[desktop] call fdcore /delsession desktop
	set /a sst.desktop.offset=%sst.crrresX%/%sst.desktop.tileW%
	set /a sst.desktop.offset*=%sst.desktop.tileW%
	set /a sst.desktop.offset=%sst.crrresX%-!sst.desktop.offset!
	set /a sst.desktop.offset=!sst.desktop.offset!/2
	call fdcore /newsession desktop !sst.desktop.offset! 0 %sst.crrresX% %sst.defaultresY% %sst.desktop.tileW% %sst.desktop.tileH%
	for /f "delims=" %%a in ('dir /b "%sst.userprofile%\desktop"') do call :settile "%sst.userprofile%\desktop\%%~a"
)
goto \settile
:settile
call fdcore /addtile desktop "%~nx1" "%~x1" "%~x1"
goto trueexit
:\settile
call setres
if not exist "%sst.userprofile%\." goto premain
if not exist "%sst.userprofile%\settings.cww" echo.disablestartertips=False> "%sst.userprofile%\settings.cww"
for /f "" %%a in ('type "%sst.userprofile%\settings.cww" ^| find "disablestartertips="') do set sst.%%a
:premain
if exist "%sst.temp%" echo.IDLE> "%sst.temp%\errorlevel.cww"
:main
if exist shutdown.txt goto end
if exist crashed.txt goto crash
if exist restart.txt goto end
if exist logoff.txt goto end
cd "%sst.dir%"
call cmdwiz showcursor 0
call setres /o
if exist "%sst.dir%\systemapps\startmenu.cmd" call startmenu /display
set /a sst.menu.ssb.reload=%sst.defaultresY%-2
set /a sst.desktop.gridX=%sst.defaultresX%/%sst.desktop.gridsizeX%-1
set /a sst.desktop.gridY=%sst.defaultresY%/%sst.desktop.gridsizeY%-1
set sst.menu.batbox=/c 0x0f /g 1 %sst.menu.ssb.reload% /d "%sst.lang.reloadbutton%"
if "%sst.desktop.showicons%" equ "True" call fdcore /display desktop 0f
call batbox %sst.menu.batbox%
call cmdwiz showcursor 1 25
call cursor "%sst.dir%\systemapps\programfiles\shell.cmd"
if %sst.mvc.crrY% equ %sst.defaultresY% if %sst.mvc.crrX% geq %sst.startmenu.cl1% if %sst.mvc.crrX% leq %sst.startmenu.cl2% call clock.cmd
if "%sst.mvc.crrX%" equ "0" if "%sst.mvc.crrY%" equ "0" if "%sst.errorlevel%" equ "OPTIONS" goto end
goto \emgc
:emgc
call emgc.cmd /emergency
call setres
:\emgc
if not exist "%sst.dir%\systemapps\startmenu.cmd" goto startmenudisabled
if %sst.mvc.crrX% geq 1 if %sst.mvc.crrX% leq 18 if %sst.mvc.crrY% equ %sst.defaultresY% (
	cmd /c startmenu.cmd
	if "!errorlevel!" equ "27" exit 0
	call setres
)
:startmenudisabled
if %sst.mvc.crrX% geq 1 if %sst.mvc.crrX% leq 18 if %sst.mvc.crrY% equ %sst.menu.ssb.reload% goto reload
if "%sst.desktop.showicons%" equ "True" (
	call fdcore /touch desktop %sst.mvc.crrX% %sst.mvc.crrY%
	if defined fdc.errorlevel (
		for /f "tokens=2,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[4\"') do if "!fdc.errorlevel.icon!" equ "%%~a" (
			if "%sst.errorlevel%" neq "OPTIONS" (
				call %%b "%sst.userprofile%\desktop\!fdc.errorlevel.name!"
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
				goto \emgc
			)
		)
	)
)
if not defined sst.mvc.options (
	if "%sst.errorlevel%" equ "OPTIONS" goto /options
) else (
	set sst.mvc.options=
)
goto \options
:/options
set /a sst.mvc.options.maxX=%sst.crrresX%-16
set /a sst.mvc.options.maxY=%sst.crrresY%-5
if %sst.mvc.crrX% gtr %sst.mvc.options.maxX% set sst.mvc.crrX=%sst.mvc.options.maxX%
if %sst.mvc.crrY% gtr %sst.mvc.options.maxY% set sst.mvc.crrY=%sst.mvc.options.maxY%
set /a sst.mvc.options.mX=%sst.mvc.crrX%+2
set /a sst.mvc.options.o1=%sst.mvc.crrY%+1
set /a sst.mvc.options.o2=%sst.mvc.crrY%+2
call box %sst.mvc.crrX% %sst.mvc.crrY% 4 16 - " " %sst.window.BGcolor%%sst.window.TIcolor%
call batbox /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g %sst.mvc.options.mX% %sst.mvc.options.o1% /d "Reload" /g %sst.mvc.options.mX% %sst.mvc.options.o2% /d "%sst.mvc.crrX%x%sst.mvc.crrY%"
if "%sst.mvc.crrX%" equ "0" if "%sst.mvc.crrY%" equ "0" if "%sst.errorlevel%" equ "OPTIONS" call batbox /c 0xf0 /g %sst.mvc.options.mX% %sst.mvc.options.o1% /d "press SPACE" /g %sst.mvc.options.mX% %sst.mvc.options.o2% /d "to exit"
call cursor.cmd "%sst.dir%\systemapps\programfiles\shell.cmd"
call setres
:\options
goto main
:crash
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mDESKTOP[0m[2m] [0m[1mFATAL: SysShivt tools crashed! Saving memory dump to "\sysshivt-tools\temp\memorydump.cww". . . >> "%sst.dir%\log.txt"
set> "%sst.dir%\temp\memorydump.cww"
:end
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mDESKTOP[0m[2m] [0m[1mSysShivt tools is exitting. . . >> "%sst.dir%\log.txt"
exit 0
:trueexit