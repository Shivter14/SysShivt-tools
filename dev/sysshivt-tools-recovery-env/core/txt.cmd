@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.0 or higher. Press any key to exit. . .
	pause>nul
	goto end
)
if not exist "%~1" (
	echo.File not found: "%~1"
	goto end
)
setlocal enabledelayedexpansion
set txt.file=%~f1
set txt.name=!txt.file:~%sst.sdir%!
set txt.boxW=%~2
set txt.boxH=%~3
set txt.boxX=%~4
set txt.boxY=%~5
:reload
if not defined txt.boxW set /a txt.boxW=60
if not defined txt.boxH set /a txt.boxH=14
if not defined txt.boxX set /a txt.boxX=%sst.crrresX%/2-(%txt.boxW%/2)
if not defined txt.boxY set /a txt.boxY=%sst.crrresY%/2-(%txt.boxH%/2)
if %txt.boxW% gtr %sst.defaultresX% set txt.boxW=60
if %txt.boxH% gtr %sst.defaultresY% set txt.boxH=14
set /a txt.txtX=%txt.boxX%+1
set /a txt.txtY=%txt.boxY%+1
set /a txt.navU=%txt.boxX%+2
set /a txt.navD=%txt.navU%+1
set /a txt.navE=%txt.navD%+2
set /a txt.rldX=%txt.navE%+1
set /a txt.rldY=%txt.rldX%+7
set /a txt.menu=%txt.rldY%+1
set /a txt.txtW=%txt.boxW%-2
set /a txt.mnbr=%txt.boxW%-21
set /a txt.eabX=%txt.boxX%+%txt.boxW%-3
set /a txt.eabY=%txt.eabX%+2
call box %txt.boxX% %txt.boxY% %txt.boxH% %txt.boxW% - " " %sst.window.BGcolor%%sst.window.TIcolor% 1 txt.box
set txt.max=0
for /f "delims=" %%a in ('type "%txt.file%"') do (
	set "txt.line.[!txt.max!]=%%~a "
	set /a txt.max=!txt.max!+1
)
set /a txt.con.ls=0
set /a txt.con.le=%txt.con.ls%+%txt.boxH%-3
:main
call batbox %txt.box% /g %txt.boxX% %txt.boxY% /c 0x9f /a 0 /a 30 /d "  " /a 31 /a 0 /c 0xbf /d " Reload " /g %txt.eabX% %txt.boxY% /c 0xcf /d " X " /g %txt.menu% %txt.boxY% /c 0x%sst.window.TIcolor%%sst.window.BGcolor%
set txt.bar=
for /l %%a in (-3 1 %txt.mnbr%) do set txt.bar=!txt.bar! /a 0
call batbox %txt.bar% /g %txt.menu% %txt.boxY% /d " ~:!txt.name:~0,%txt.mnbr%!"
for /l %%a in (%txt.con.ls% 1 %txt.con.le%) do (
	set /a txt.temp=%%a-%txt.con.ls%
	set /a txt.cond=%txt.txtY%+!txt.temp!
	if defined txt.line.[%%a] call batbox /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g %txt.txtX% !txt.cond! /d "!txt.line.[%%a]:~0,%txt.txtW%!"
)
call cursor %2
if "%sst.mvc.crrY%" equ "%txt.boxY%" (
	if %sst.mvc.crrX% geq %txt.boxX% if %sst.mvc.crrX% leq %txt.navU% (
		set /a txt.con.ls=%txt.con.ls%-2
		for /l %%a in (1 1 2) do if !txt.con.ls! lss 0 (
			set /a txt.con.ls=!txt.con.ls!+1
		)
	)
	if %sst.mvc.crrX% geq %txt.navD% if %sst.mvc.crrX% leq %txt.navE% (
		set /a txt.con.ls=%txt.con.ls%+2
		for /l %%a in (1 1 2) do if !txt.con.le! gtr %txt.max% (
			set /a txt.con.ls=!txt.con.ls!-1
		)
	)
	if %sst.mvc.crrX% geq %txt.eabX% if %sst.mvc.crrX% leq %txt.eabY% goto end
)
set /a txt.con.le=%txt.con.ls%+%txt.boxH%-3
goto main
:end