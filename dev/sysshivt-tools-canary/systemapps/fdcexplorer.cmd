@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.3 or higher! Press any key to exit. . .
	pause>nul
	goto end
)
if %sst.build% lss 1418 (
	echo.This program reqires SysShivt tools 3.1.3 or higher! Press any key to exit. . .
	pause>nul
	goto end
)
setlocal enabledelayedexpansion
cd "%sst.userprofile%\desktop"
goto reload
:setdir
call batbox /c 0x%sst.window.TIcolor%%sst.window.BGcolor% /g %explorer.btn.setdir% %explorer.Y% /d " > "
call gettext %explorer.setdir% %sst.window.TIcolor%%sst.window.TTcolor% %explorer.btn.gettext% %explorer.Y%
if not defined sst.errorlevel goto main
if "%sst.errorlevel:~0,3%" equ "~:\" (
	cd "%sst.cd%\%sst.errorlevel:~3%"
)
if "%sst.errorlevel:~0,4%" equ "usr\" (
	cd "%sst.userprofile%\%sst.errorlevel:~4%"
)
if "%sst.errorlevel:~0,5%" equ "root\" (
	cd "%sst.root%"
)
if "%sst.errorlevel:~0,8%" equ "desktop\" (
	cd "%sst.userprofile%\desktop\%sst.errorlevel:~8%"
)
goto reload
:dirup
cd ..
:reload
set "explorer.dir=~:!cd:~%sst.sdir%!"
if "%cd%" equ "%sst.root%" set explorer.dir=root\
set /a explorer.W=%sst.crrresX%-12
set /a explorer.H=%sst.crrresY%-3
set /a explorer.X=(%sst.defaultresX%-%explorer.W%)/2+1
set /a explorer.Y=(%sst.defaultresY%-%explorer.H%)/2
set /a explorer.btn.reload=%explorer.X%+7
set /a explorer.btn.end=%explorer.X%+%explorer.W%-1
set /a explorer.btn.exit=%explorer.btn.end%-2
set /a explorer.btn.upX=%explorer.btn.reload%+1
set /a explorer.btn.upY=%explorer.btn.upX%+2
set /a explorer.btn.setdir=%explorer.btn.upY%+1
set /a explorer.btn.gettext=%explorer.btn.setdir%+3
set /a explorer.setdir=(%explorer.X%-%explorer.btn.setdir%)+%explorer.W%-6
set /a explorer.fdc.X=%explorer.X%+1
set /a explorer.fdc.Y=%explorer.Y%+1
set /a explorer.fdc.W=(%explorer.X%-%explorer.fdc.X%)+%explorer.W%-2
set /a explorer.fdc.H=(%explorer.Y%-%explorer.fdc.Y%)+%explorer.H%-1
if defined fdc.[explorer] call fdcore /delsession explorer
if "%cd%" neq "%sst.root%" (
	call fdcore /newsession explorer %explorer.fdc.X% %explorer.fdc.Y% %explorer.fdc.W% %explorer.fdc.H% 20 6
	for /f "delims=" %%a in ('dir /b') do call :settile "%cd%\%%~a"
) else (
	call fdcore /newsession explorer %explorer.fdc.X% %explorer.fdc.Y% %explorer.fdc.W% %explorer.fdc.H% 40 4
	for %%a in ("A" "B" "C" "D" "E" "F" "G" "H" "I" "J") do if exist "%%~a\SSVM.cww" call :settile "%cd%\%%~a"
)
goto \settile
:settile
if "%cd%" neq "%sst.root%" (
	call fdcore /addtile explorer "%~nx1" "%~x1" "%~f1"
) else (
	for /f "tokens=2 delims==" %%a in ('type "%~1\SSVM.cww" ^| find "BOOT"') do call fdcore /addtile explorer "%~nx1: %%~a" "DISK" "%~f1"
)
goto end
:\settile
:main
call sbox %explorer.X% %explorer.Y% %explorer.W% %explorer.H% %sst.window.BGcolor%%sst.window.TIcolor%
call batbox /c 0xbf /g %explorer.X% %explorer.Y% /d " Reload " /c 0x3f /a 0 /a 30 /a 0 /c 0x%sst.window.TIcolor%%sst.window.TTcolor% /d " %explorer.dir% " /c 0xcf /g %explorer.btn.exit% %explorer.Y% /d " X "
call fdcore /display explorer 0f
call cursor
call fdcore /touch explorer %sst.mvc.crrX% %sst.mvc.crrY%
if "%sst.mvc.crrY%" equ "%explorer.Y%" (
	if %sst.mvc.crrX% geq %explorer.X% if %sst.mvc.crrX% leq %explorer.btn.reload% goto reload
	if %sst.mvc.crrX% geq %explorer.btn.exit% if %sst.mvc.crrX% leq %explorer.btn.end% goto exit
	if %sst.mvc.crrX% geq %explorer.btn.upX% if %sst.mvc.crrX% leq %explorer.btn.upY% goto dirup
	if %sst.mvc.crrX% geq %explorer.btn.setdir% if %sst.mvc.crrX% leq %explorer.btn.exit% goto setdir
)
if defined fdc.errorlevel.path if exist "%fdc.errorlevel.path%" (
	call :attrib "%fdc.errorlevel.path%" "%sst.errorlevel%"
	if defined explorer.reload (
		set explorer.reload=
		goto reload
	)
	if "%cd%" neq "!cd!" goto reload
)
goto \attrib
:attrib
set fdc.attrib=%~a1
if "%sst.errorlevel%" neq "OPTIONS" (
	if "%fdc.attrib:~0,1%" equ "d" (
		cd "%~f1"
		goto end
	)
) 
if "%sst.errorlevel%" neq "OPTIONS" (
	for /f "tokens=2,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[4\"') do if "!fdc.errorlevel.icon!" equ "%%~a" (
		call %%b "!fdc.errorlevel.name!"
		call setres
	)
) else (
	set sst.desktopoptions.boxX=%sst.mvc.crrX%
	set sst.desktopoptions.boxY=%sst.mvc.crrY%
	set sst.desktopoptions.width=20
	set sst.desktopoptions.height=4
	set /a sst.desktopoptions.endX=!sst.desktopoptions.boxX!+!sst.desktopoptions.width!
	set /a sst.desktopoptions.endY=!sst.desktopoptions.boxY!+!sst.desktopoptions.height!
	call getlen "!fdc.errorlevel.name!"
	set sst.desktopoptions.errorlevel=!errorlevel!+4
	if !sst.desktopoptions.errorlevel! gtr !sst.desktopoptions.width! set sst.desktopoptions.width=!sst.desktopoptions.errorlevel!
	if !sst.desktopoptions.endX! geq %sst.defaultresX% (
		set /a sst.desktopoptions.boxX=!sst.desktopoptions.boxX!-!sst.desktopoptions.width!
		set /a sst.desktopoptions.endX=!sst.desktopoptions.boxX!+!sst.desktopoptions.width!
	)
	if !sst.desktopoptions.endY! geq %sst.defaultresY% (
		set /a sst.desktopoptions.boxY=!sst.desktopoptions.boxY!-!sst.desktopoptions.height!
		set /a sst.desktopoptions.endY=!sst.desktopoptions.boxY!+!sst.desktopoptions.height!
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
		set sst.desktopoptions.REM=REM
		for /f "tokens=2,3,4,5,6 delims=;" %%c in ('type "!fdc.errorlevel.name!" ^| find "!sst.desktopoptions.REM! BATINFO;"') do (
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
		if !sst.desktopoptions.endX! geq %sst.defaultresX% (
			set /a sst.desktopoptions.boxX=!sst.desktopoptions.boxX!-!sst.desktopoptions.width!
			set /a sst.desktopoptions.endX=!sst.desktopoptions.boxX!+!sst.desktopoptions.width!
		)
		if !sst.desktopoptions.endY! geq %sst.defaultresY% (
			set /a sst.desktopoptions.boxY=!sst.desktopoptions.boxY!-!sst.desktopoptions.height!
			set /a sst.desktopoptions.endY=!sst.desktopoptions.boxY!+!sst.desktopoptions.height!
		)
		set /a sst.desktopoptions.list=!sst.desktopoptions.boxX!+2
		set /a sst.desktopoptions.options=!sst.desktopoptions.boxY!+1
		set /a sst.desktopoptions.info=!sst.desktopoptions.boxY!+1
		set /a sst.desktopoptions.ver=!sst.desktopoptions.info!+1
		set /a sst.desktopoptions.auth=!sst.desktopoptions.ver!+1
		set /a sst.desktopoptions.build=!sst.desktopoptions.auth!+1
		set /a sst.desktopoptions.type=!sst.desktopoptions.build!+1
		set /a sst.desktopoptions.options=!sst.desktopoptions.type!+1
		set sst.desktopoptions.batbox=/c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g !sst.desktopoptions.list! !sst.desktopoptions.info! /d "!sst.desktopoptions.app.info!" /g !sst.desktopoptions.list! !sst.desktopoptions.ver! /d "Version: !sst.desktopoptions.app.ver!" /g !sst.desktopoptions.list! !sst.desktopoptions.auth! /d "Author: !sst.desktopoptions.app.auth!" /g !sst.desktopoptions.list! !sst.desktopoptions.build! /d "SST build: !sst.desktopoptions.app.build!" /g !sst.desktopoptions.list! !sst.desktopoptions.type! /d "App Type: !sst.desktopoptions.app.type!"
	)
	set /a sst.desktopoptions.delete=!sst.desktopoptions.options!+1
	call box !sst.desktopoptions.boxX! !sst.desktopoptions.boxY! !sst.desktopoptions.height! !sst.desktopoptions.width! - " " %sst.window.BGcolor%%sst.window.TIcolor% 1
	call batbox !sst.desktopoptions.batbox! /c 0x%sst.window.BGcolor%%sst.window.TIcolor% /g !sst.desktopoptions.list! !sst.desktopoptions.options! /d "= Options =" /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g !sst.desktopoptions.list! !sst.desktopoptions.delete! /d "Move to bin" /g !sst.desktopoptions.list! !sst.desktopoptions.boxY! /d "!fdc.errorlevel.name!"
	call cursor.cmd
	if "!sst.mvc.crrX!" gtr "!sst.desktopoptions.boxX!" if "!sst.mvc.crrX!" lss "!sst.desktopoptions.endX!" if "!sst.mvc.crrY!" equ "!sst.desktopoptions.delete!" if "%cd%" neq "%sst.root%" (
		if not exist "%sst.userprofile%\bin" md "%sst.userprofile%\bin" 
		move "%fdc.errorlevel.path%" "%sst.userprofile%\bin\"
		set explorer.reload=True
	) else if "!fdc.errorlevel.path!" neq "%sst.cd%" (
		for %%a in ("boxX=!sst.desktopoptions.boxX!" "boxY=!sst.desktopoptions.boxY!" "height=5" "title=Failed to remove the file specified" "args=/keystroke" "line2=You cant just delete a local disk bro... If" "line3=you really hate it, destroy it in real life.") do set sst.window.%%~a
		call window rem
	) else (
		for %%a in ("boxX=!sst.desktopoptions.boxX!" "boxY=!sst.desktopoptions.boxY!" "height=5" "width=24" "title=Deleting. . ." "args=/displayonly" "line2=Deleting ~:. . .") do set sst.window.%%~a
		call window rem
		call cmdwiz delay !random:~-3!
		set sst.window.TIcolor=8
		set sst.window.FGcolor=0
		set sst.window.BGcolor=7
		set sst.window.TTcolor=f
		call setres /d
		for %%a in ("boxX=!sst.desktopoptions.boxX!" "boxY=!sst.desktopoptions.boxY!" "height=5" "width=24" "title=Deleting. . ." "args=/displayonly" "line2=Deleting ~:. . .") do set sst.window.%%~a
		call window rem
		call cmdwiz delay !random:~-3!
		for %%a in ("height=5" "width=35" "args=/displayonly" "title=setres.cmd: FATAL ERROR" "line2=Can't find the drivers reqired." "line3=Exitting. . .") do set sst.window.%%~a
		call window rem
		call cmdwiz delay !random:~-3!
		for %%a in ("boxX=2" "boxY=1" "height=5" "width=32" "args=/displayonly" "title=desktop.cmd: FATAL ERROR" "line2=System file is missing." "line3=Exitting. . .") do set sst.window.%%~a
		call window rem
		call cmdwiz delay !random:~-3!
		for %%a in ("boxX=!sst.desktopoptions.boxX!" "boxY=!sst.desktopoptions.boxY!" "height=5" "title=Failed to remove the file specified" "args=/displayonly" "line2=Reqired system file is missing." "line3=Operation was not finished.") do set sst.window.%%~a
		call window rem
		call cmdwiz delay !random:~-3!
		call setres /d
		for %%a in ("args=/displayonly" "line2=What have you done..." "line3=You deleted the local disk ~:..." "line4=It is all your fault." "line5=Now the system is gonna die in 10 seconds." "line6=Just kidding its not deleted," "line7=but it is still gonna die.") do set sst.window.%%~a
		call window rem
		call cmdwiz delay 10000
		echo.> "%sst.dir%\crashed.txt"
		echo.> "%sst.dir%\shutdown.txt"
		exit
	)
)
goto end
:\attrib
goto main
:exit
if defined fdc.[explorer] call fdcore /delsession explorer
endlocal
:end