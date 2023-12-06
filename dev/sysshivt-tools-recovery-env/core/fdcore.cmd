@echo off
REM BATINFO;SST;1220;SysShivt tools 3.1.2+ file displayer;1.1.0;Shivter
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.2 or higher. Press any key to exit. . .
	pause>nul
	goto end
)
if %sst.build% lss 1220 (
	echo.This program reqires SysShivt tools 3.1.2 or higher. Press any key to exit. . .
	pause>nul
	goto end
)
if "%~1" equ "" for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set /a fdc.hsh=%%a-1
set fdc.delay=
if "%~1" equ "" for %%a in (
	"Syntax: fdcore.cmd [ /newsession <session> <X> <Y> <width> <height> <tile width> <tile height>"
	"                   | /addtile <session> <name> <icon> <path>"
	"                   | /display <session> <namecolor> [/hideicons]"
	"                   | /delsession <session>"
	"                   | /touch <session> <X> <Y>"
	"                   ]"
	""
	"	/newsession	: Creates a new working session"
	"		session		: Name of the working session"
	"		X		: X location of the working session"
	"		Y		: Y location of the working session"
	"		width		: Width of the working session"
	"		height		: Height of the working session"
	"		tile width	: width of a tile in the working session"
	"		tile height	: height of a tile in the working session"
	"	/addtile	: Adds a tile into a working session"
	"		session	: Name of the working session"
	"		name	: The name of the tile"
	"		icon	: The icon name of the tile"
	"		path	: The full path and filename of the file"
	"	/display	: Displays the working session"
	"		session		: The name of the working session"
	"		namecolor	: The color of the name of the tile [example: 0f]"
	"		/hideicons	: Hides icons"
	"	/delsession	: Deletes an existing working session"
	"		session	: The name of the working session"
	"	/touch	: Checks if a point isn't touching any tile"
	"		session	: The name of the working session"
	"		X	: X location of the point"
	"		Y	: Y location of the point"
	) do (
		echo.%%~a
		if defined fdc.delay timeout 0 /nobreak > nul
		for /f "tokens=1* delims==" %%b in ('set fdc.hsh') do if "%%~b" equ "fdc.hsh" (
			set /a fdc.hsh=%%c-1
			if "%%c" equ "1" (
				set fdc.delay=True
				set fdc.hsh=%fdc.hsh%
				call batbox /g 0 %fdc.hsh% /d " - Press any key - "
				pause>nul
				call batbox /g 0 %fdc.hsh% /d "                   " /g 0 %fdc.hsh%
			)
		)
	)
)
set fdc.session=%~2
if "%~1" equ "/newsession" goto newsession
if "%~1" equ "/addtile" goto addtile
if "%~1" equ "/display" goto display
if "%~1" equ "/delsession" goto delsession
if "%~1" equ "/touch" goto touch
goto \newsession
:newsession
if defined fdc.[%fdc.session%] (
	echo.Session "%fdc.session%" already exists. Press any key to exit. . .
	pause>nul
	goto end
)
set fdcs=True
for /f "tokens=1 delims==" %%a in ('set fdcs') do set %%a=
set fdc.[%fdc.session%]=True
set /a fdcs.X=%~3
set /a fdcs.Y=%~4
set /a fdcs.W=%~5
set /a fdcs.H=%~6
set /a fdcs.tileX=%~7
set /a fdcs.tileY=%~8
set /a fdcs.gridX=%fdcs.W%/%fdcs.tileX%-1
set /a fdcs.gridY=%fdcs.H%/%fdcs.tileY%-1
set /a fdcs.textlen=%fdcs.tileX%-4
for /f "delims=" %%a in ('set fdcs') do set fdc.[%fdc.session%]$%%a
for /f "tokens=1 delims==" %%a in ('set fdcs') do set %%a=
:\newsession
goto \addtile
:addtile
if not defined fdc.[%fdc.session%] (
	echo.Session "%fdc.session%" does not exist. Press any key to exit. . .
	pause>nul
	goto end
)
for /f "tokens=2 delims=$" %%a in ('set fdc.[%fdc.session%]') do set %%a
set fdcs.temp$path=%~f5
set fdcs.temp$name=%~3
set fdcs.temp$icon=%~4
if not defined fdcs.temp$icon set fdcs.temp$icon=%~x4
set fdcs.temp.clX=0
set fdcs.temp.clY=0
:addtile.getpos
if defined fdcs.[%fdcs.temp.clX%x%fdcs.temp.clY%] set /a fdcs.temp.clX=%fdcs.temp.clX%+1
if %fdcs.temp.clX% gtr %fdcs.gridX% (
	set /a fdcs.temp.clY=%fdcs.temp.clY%+1
	set /a fdcs.temp.clX=0
)
if defined fdcs.[%fdcs.temp.clX%x%fdcs.temp.clY%] goto addtile.getpos
set /a fdcs.temp$X=%fdcs.temp.clX%*%fdcs.tileX%+1+%fdcs.X%
set /a fdcs.temp$Y=%fdcs.temp.clY%*%fdcs.tileY%+1+%fdcs.Y%
set /a fdcs.temp$iconX=(%fdcs.tileX%-20)/2
set /a fdcs.temp$iconX=%fdcs.temp$iconX%+%fdcs.temp$X%
set /a fdcs.temp$nameX=%fdcs.temp.clX%*%fdcs.tileX%+1
set /a fdcs.temp$nameX=%fdcs.temp$nameX%+%fdcs.X%
set /a fdcs.temp$nameY=%fdcs.temp.clY%*%fdcs.tileY%+%fdcs.tileY%
set /a fdcs.temp$nameY=%fdcs.temp$nameY%-1+%fdcs.Y%
set /a fdcs.temp$end=%fdcs.temp$X%+%fdcs.tileX%-3
set fdcs.[%fdcs.temp.clX%x%fdcs.temp.clY%]=True
for /f "tokens=2 delims=$" %%a in ('set fdcs.temp$') do set fdcs.[%fdcs.temp.clX%x%fdcs.temp.clY%].%%a
for /f "tokens=1 delims==" %%a in ('set fdcs.temp') do set %%a=
for /f "delims=" %%a in ('set fdcs') do set fdc.[%fdc.session%]$%%a
for /f "tokens=1 delims==" %%a in ('set fdcs') do set %%a=
goto end
:\addtile
goto \display
:display
if not defined fdc.[%fdc.session%] (
	echo.Session "%fdc.session%" does not exist. Press any key to exit. . .
	pause>nul
	goto end
)
setlocal enabledelayedexpansion
for /f "tokens=2 delims=$" %%a in ('set fdc.[%fdc.session%]') do set %%a
if "%~3" neq "/hideicons" for /l %%y in (0 1 %fdcs.gridY%) do for /l %%x in (0 1 %fdcs.gridX%) do if defined fdcs.[%%xx%%y] (
	if exist "%sst.dir%\assets\icons\icon!fdcs.[%%xx%%y].icon!.mti" (
		call mti "%sst.dir%\assets\icons\icon!fdcs.[%%xx%%y].icon!.mti" !fdcs.[%%xx%%y].iconX! !fdcs.[%%xx%%y].Y! 256
	) else (
		call mti "sst.dir\assets\icons\icon!fdcs.[%%xx%%y].icon!.mti" !fdcs.[%%xx%%y].iconX! !fdcs.[%%xx%%y].Y! 256 /sftm
	)
)
for /l %%y in (0 1 %fdcs.gridY%) do for /l %%x in (0 1 %fdcs.gridX%) do if defined fdcs.[%%xx%%y] (
	call batbox /c 0x%~3 /g !fdcs.[%%xx%%y].nameX! !fdcs.[%%xx%%y].nameY! /d " !fdcs.[%%xx%%y].name:~0,%fdcs.textlen%! "
)
endlocal
:\display
goto \delsession
:delsession
if not defined fdc.[%fdc.session%] (
	echo.Session "%fdc.session%" does not exist. Press any key to exit. . .
	pause>nul
	goto end
)
for /f "tokens=1 delims==" %%a in ('set fdc.[%fdc.session%]') do set %%a=
:\delsession
goto \touch
:touch
if not defined fdc.[%fdc.session%] (
	echo.Session "%fdc.session%" does not exist. Press any key to exit. . .
	pause>nul
	goto end
)
setlocal enabledelayedexpansion
for /l %%y in (0 1 !fdc.[%fdc.session%]$fdcs.gridY!) do for /l %%x in (0 1 !fdc.[%fdc.session%]$fdcs.gridX!) do if defined fdc.[%fdc.session%]$fdcs.[%%xx%%y] (
	if !fdc.[%fdc.session%]$fdcs.[%%xx%%y].X! leq %~3 if !fdc.[%fdc.session%]$fdcs.[%%xx%%y].end! geq %~3 if !fdc.[%fdc.session%]$fdcs.[%%xx%%y].Y! leq %~4 if !fdc.[%fdc.session%]$fdcs.[%%xx%%y].nameY! geq %~4 (
		echo.!fdc.[%fdc.session%]$fdcs.[%%xx%%y].name!$!fdc.[%fdc.session%]$fdcs.[%%xx%%y].path!$!fdc.[%fdc.session%]$fdcs.[%%xx%%y].icon!> "%sst.temp%\fdcore.cww"
	)
)
endlocal
set fdc.errorlevel.name=
set fdc.errorlevel.icon=
set fdc.errorlevel.path=
if exist "%sst.temp%\fdcore.cww" (
	for /f "tokens=1,2,3 delims=$" %%a in ('type "%sst.temp%\fdcore.cww"') do (
		set "fdc.errorlevel.name=%%~a"
		set "fdc.errorlevel.path=%%~b"
		set "fdc.errorlevel.icon=%%~c"
	)
	del "%sst.temp%\fdcore.cww"
)
:\touch
:end