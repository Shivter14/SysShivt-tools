@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.0 or higher! Press any key to exit. . .
	pause>nul
	goto end
)
if %sst.defaultresY% lss 21 (
	call rtltrp.cmd 96 24
	goto trueexit
)
if %sst.defaultresX% lss 91 (
	call rtltrp.cmd 96 24
	goto trueexit
)
setlocal enabledelayedexpansion
set sst.cwt.dir=
set sst.cwt.filename=%~1
set sst.cwt.boxX=%~2
set sst.cwt.boxY=%~3
if not exist "%sst.cwt.filename%" (
	echo.File not found.
	goto trueexit
)
set sst.cwt.dir=
if not defined sst.cwt.boxX set /a sst.cwt.boxX=%sst.defaultresX%/2-45
if not defined sst.cwt.boxY set /a sst.cwt.boxY=%sst.defaultresY%/2-10
set /a sst.cwt.home=%sst.cwt.boxX%+5
set /a sst.cwt.cor=%sst.cwt.boxX%+91
set /a sst.cwt.exit=%sst.cwt.cor%-2
call box %sst.cwt.boxX% %sst.cwt.boxY% 21 92 - " " %sst.window.BGcolor%%sst.window.TIcolor%
call line %sst.cwt.boxX% %sst.cwt.boxY% %sst.cwt.cor% %sst.cwt.boxY% 0 %sst.window.TIcolor%%sst.window.FGcolor%
call batbox /c 0xcf /g %sst.cwt.exit% %sst.cwt.boxY% /d " X " /c 0x9f /g %sst.cwt.boxX% %sst.cwt.boxY% /d " Home " /c 0x%sst.window.TIcolor%%sst.window.FGcolor% /d "   CWTedit "
set /a sst.cwt.rdboxX=%sst.cwt.boxX%+2
set /a sst.cwt.rdX=%sst.cwt.rdboxX%+2
set /a sst.cwt.rdboxY=%sst.cwt.boxY%+2
set /a sst.cwt.rdY=%sst.cwt.boxX%+29
set /a sst.cwt.chobox=%sst.cwt.rdY%+3
set /a sst.cwt.crdX=%sst.cwt.chobox%+2
set /a sst.cwt.crdY=%sst.cwt.crdX%+28
set /a sst.cwt.cmX=%sst.cwt.boxX%+2
set /a sst.cwt.cmY=%sst.cwt.boxY%+1
set /a sst.cwt.cm1=%sst.cwt.cmX%+3
set /a sst.cwt.cm2=%sst.cwt.cm1%+3
set /a sst.cwt.cm3=%sst.cwt.cm2%+3
set /a sst.cwt.cm4=%sst.cwt.cm3%+3
set sst.cwt.wiew=
set sst.cwt.forX=0
set sst.cwt.forY=15
set sst.cwt.furX=0
set sst.cwt.furY=15
for /l %%a in (%sst.cwt.forX% 1 %sst.cwt.forY%) do set /a sst.cwt.rd%%a=%sst.cwt.rdboxY%+1+%%a-%sst.cwt.forX%
for /l %%a in (%sst.cwt.furX% 1 %sst.cwt.furY%) do set /a sst.cwt.rb%%a=%sst.cwt.rdboxY%+1+%%a-%sst.cwt.furX%
:start
if not exist "%sst.cwt.filename%" (
	echo.File not found.
	goto exit
)
call batbox /c 0x1f /g %sst.cwt.cmX% %sst.cwt.cmY% /d " +  - " /c 0x9f /d " +  - " /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /d " D: \%sst.cwt.dir% " /a 179 /d " S: %sst.cwt.forX% - %sst.cwt.forY% " /a 179 /d " Z: %sst.cwt.furX% - %sst.cwt.furY%"
if defined sst.cwt.wiew if "%sst.cwt.filetype%" equ "key" call box %sst.cwt.chobox% %sst.cwt.rdboxY% 18 59 - " " %sst.window.BGcolor%%sst.window.TIcolor%
if defined sst.cwt.wiew if "%sst.cwt.filetype%" equ "key" for /l %%a in (%sst.cwt.furX% 1 %sst.cwt.furY%) do call batbox /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g %sst.cwt.crdX% !sst.cwt.rb%%a! /d "!sst.cwt.keyname.[%%a]:~0,27!" /g %sst.cwt.crdY% !sst.cwt.rb%%a! /d "!sst.cwt.keyvar.[%%a]:~0,27!"
for /l %%a in (%sst.cwt.forX% 1 %sst.cwt.forY%) do set sst.cwt.filename.[%%a]= 
for /l %%b in (%sst.cwt.forX% 1 %sst.cwt.forY%) do for /f "tokens=2" %%a in ('type %sst.cwt.filename% ^| find "[%sst.cwt.dir%%%b]"') do set sst.cwt.filename.[%%b]=%%a
call box %sst.cwt.rdboxX% %sst.cwt.rdboxY% 18 28 - " " %sst.window.BGcolor%%sst.window.TIcolor%
call batbox /c 0x%sst.window.BGcolor%%sst.window.FGcolor%
for /l %%a in (%sst.cwt.forX% 1 %sst.cwt.forY%) do call batbox /g %sst.cwt.rdX% !sst.cwt.rd%%a! /d "!sst.cwt.filename.[%%a]:~0,24!"
call cursor
set sst.cwt.errorlevel=%sst.errorlevel%
call box %sst.cwt.boxX% %sst.cwt.boxY% 21 92 - " " %sst.window.BGcolor%%sst.window.TIcolor%
call line %sst.cwt.boxX% %sst.cwt.boxY% %sst.cwt.cor% %sst.cwt.boxY% 0 %sst.window.TIcolor%%sst.window.FGcolor%
call batbox /c 0xcf /g %sst.cwt.exit% %sst.cwt.boxY% /d " X " /c 0xBf /g %sst.cwt.boxX% %sst.cwt.boxY% /d " Home " /c 0x%sst.window.TIcolor%%sst.window.FGcolor%; /d "   CWTedit "
if %sst.mvc.crrX% geq %sst.cwt.cmX% if %sst.mvc.crrX% lss %sst.cwt.cm1% if %sst.mvc.crrY% equ %sst.cwt.cmY% (
	if "%sst.cwt.errorlevel%" neq "OPTIONS" call :scroll for 4
	if "%sst.cwt.errorlevel%" equ "OPTIONS" call :scroll for 8
)
if %sst.mvc.crrX% geq %sst.cwt.cm1% if %sst.mvc.crrX% lss %sst.cwt.cm2% if %sst.mvc.crrY% equ %sst.cwt.cmY% (
	if "%sst.cwt.errorlevel%" neq "OPTIONS" call :scroll for -4
	if "%sst.cwt.errorlevel%" equ "OPTIONS" call :scroll for -8
)
if %sst.mvc.crrX% geq %sst.cwt.cm2% if %sst.mvc.crrX% lss %sst.cwt.cm3% if %sst.mvc.crrY% equ %sst.cwt.cmY% (
	if "%sst.cwt.errorlevel%" neq "OPTIONS" call :scroll fur 4
	if "%sst.cwt.errorlevel%" equ "OPTIONS" call :scroll fur 8
)
if %sst.mvc.crrX% geq %sst.cwt.cm3% if %sst.mvc.crrX% lss %sst.cwt.cm4% if %sst.mvc.crrY% equ %sst.cwt.cmY% (
	if "%sst.cwt.errorlevel%" neq "OPTIONS" call :scroll fur -4
	if "%sst.cwt.errorlevel%" equ "OPTIONS" call :scroll fur -8
)
for /l %%a in (%sst.cwt.forX% 1 %sst.cwt.forY%) do set /a sst.cwt.rd%%a=%sst.defaultresY%/2-7+%%a-%sst.cwt.forX%
for /l %%a in (%sst.cwt.furX% 1 %sst.cwt.furY%) do set /a sst.cwt.rb%%a=%sst.defaultresY%/2-7+%%a-%sst.cwt.furX%
for /l %%a in (%sst.cwt.forX% 1 %sst.cwt.forY%) do if %sst.mvc.crrX% geq %sst.cwt.rdX% if %sst.mvc.crrX% leq %sst.cwt.rdY% if %sst.mvc.crrY% equ !sst.cwt.rd%%a! call :wiew "%sst.cwt.dir%%%a"
for /l %%a in (%sst.cwt.forX% 1 %sst.cwt.forY%) do if %sst.mvc.crrX% geq %sst.cwt.rdX% if %sst.mvc.crrX% leq %sst.cwt.rdY% if %sst.mvc.crrY% equ !sst.cwt.rd%%a! set sst.cwt.wiew=%sst.cwt.dir%%%a
if %sst.mvc.crrX% geq %sst.cwt.exit% if %sst.mvc.crrX% leq %sst.cwt.cor% if %sst.mvc.crrY% equ %sst.cwt.boxY% goto exit
if %sst.mvc.crrX% geq %sst.cwt.boxX% if %sst.mvc.crrX% leq %sst.cwt.home% if %sst.mvc.crrY% equ %sst.cwt.boxY% set sst.cwt.dir=
goto start
:scroll
set /a sst.cwt.%~1X=!sst.cwt.%~1X!+%~2
set /a sst.cwt.%~1Y=!sst.cwt.%~1Y!+%~2
if !sst.cwt.%~1X! lss 0 set sst.cwt.%~1X=0
if !sst.cwt.%~1Y! lss 15 set sst.cwt.%~1Y=15
if "%~1" equ "fur" if defined sst.cwt.wiew call :lk %sst.cwt.wiew%
goto trueexit
:wiew
set a=
set sst.cwt.filetype=
for /f "tokens=3" %%a in ('type %sst.cwt.filename% ^| find "[%~1]"') do set sst.cwt.filetype=%%a
if "%sst.cwt.filetype%" equ "dir" set sst.cwt.dir=%~1\
if "%sst.cwt.filetype%" equ "key" call :lk %~1
goto trueexit
:lk
for /l %%a in (%sst.cwt.furX% 1 %sst.cwt.furY%) do set sst.cwt.keyname.[%%a]= 
for /l %%a in (%sst.cwt.furX% 1 %sst.cwt.furY%) do set sst.cwt.keyvar.[%%a]= 
for /l %%b in (%sst.cwt.furX% 1 %sst.cwt.furY%) do for /f "tokens=2" %%a in ('type %sst.cwt.filename% ^| find "[%~1\%%b]"') do set sst.cwt.keyname.[%%b]=%%a
for /l %%b in (%sst.cwt.furX% 1 %sst.cwt.furY%) do for /f "tokens=3" %%a in ('type %sst.cwt.filename% ^| find "[%~1\%%b]"') do set sst.cwt.keyvar.[%%b]=%%a
goto trueexit
:exit
color 07
cls
:trueexit