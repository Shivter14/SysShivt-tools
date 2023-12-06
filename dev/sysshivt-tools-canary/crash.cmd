@echo off
if "%~1" equ "/memorydump" goto memorydump
if "%sst.safemode%" equ "true" timeout 4 /nobreak > nul
if "%~1" neq "/fake" (
	echo.>crashed.txt
	echo [%date%, %time%] [crash] SysShivt tools crashed >> "%sst.dir%\log.txt"
	echo [%date%, %time%] [crash] error code: %~1 >> "%sst.dir%\log.txt"
	echo [%date%, %time%] [crash] error caused by: %~2 >> "%sst.dir%\log.txt"
	echo [%date%, %time%] [crash] error level: %~3 >> "%sst.dir%\log.txt"
	echo [%date%, %time%] [crash] parameters: %* >> "%sst.dir%\log.txt"
	for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[0\0]"') do set sst.ver=%%a
	for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[0\1]"') do set sst.build=%%a
)
set sst.crash.bg=1
set sst.crash.fg=f
set sst.crash.cwtroot=
for /f "tokens=1,2,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "ThemesSettings"') do if "%%~c" equ "key" if "%%~b" equ "ThemesSettings" set "sst.crash.cwtroot=%%~a"
if not defined sst.crash.cwtroot goto memorydump
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] crashfgcolor"') do if "%%~a" neq "%sst.window.cwtroot%" set "sst.crash.fg=%%~a"
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] crashbgcolor"') do if "%%~a" neq "%sst.window.cwtroot%" set "sst.crash.bg=%%~a"
:memorydump
color %sst.crash.bg%%sst.crash.fg%
cls
if "%~1" equ "/memorydump" echo.Creating Memory dump. . .
set> "%sst.temp%\memorydump.txt"
if "%~1" equ "/memorydump" echo.Saved Memory dump to "%sst.temp%\memorydump.txt".
echo.
if "%~1" equ "/memorydump" goto end
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set sst.crrresY=%%~a
for /f "tokens=2" %%a in ('mode con ^| find "Columns:"') do set sst.crrresX=%%~a
set /a sst.crash.head=%sst.crrresX%-56
set /a sst.crash.head=%sst.crash.head%/2
set /a sst.crash.icoX=%sst.crrresX%/2-9
set /a sst.crash.icoY=%sst.crrresY%/2-6
set /a sst.crash.boxX=%sst.crash.head%-4
set /a sst.crash.boxY=%sst.crash.icoY%-2
call core\box.bat %sst.crash.boxX% %sst.crash.boxY% 16 64 - " " %sst.crash.bg%%sst.crash.fg%
call core\displaydvr.exe /g %sst.crash.icoX% %sst.crash.icoY% /c 0x%sst.crash.fg%%sst.crash.bg% /d "  SysShivt tools  " /c 0x%sst.crash.bg%%sst.crash.fg%
setlocal enabledelayedexpansion
set /a sst.crash.counter=%sst.crash.icoY%+2
for %%a in (
	"error code: %~1"
	"error caused by: %~2"
	"error level: %~3"
	"--more info--"
	"%~4"
	"%~5"
	"%~6"
	"%~7"
	"%~8"
	"%~9"
) do (
	call core\displaydvr.exe /g %sst.crash.head% !sst.crash.counter! /d "%%~a"
	set /a sst.crash.counter=!sst.crash.counter!+1
)
endlocal
:end
pause>nul