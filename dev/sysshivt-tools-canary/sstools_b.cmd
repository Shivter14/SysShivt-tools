@echo off
setlocal enabledelayedexpansion
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[2\0]"') do set sst.controllprocess=%%a
if "%sst.controllprocess%" equ "False" (
	exit
)
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[0\0]"') do set sst.ver=%%a
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[0\1]"') do set sst.build=%%a
:main
if exist shutdown.txt exit
if exist crashed.txt exit
if exist restart.txt exit
if exist restartRM.txt exit
if exist "reloadgraphic.txt" call setres
if exist "reloadgraphic.txt" del reloadgraphic.txt
if not exist "%sst.cd%\autorun.cmd" (
	if not defined sst_b.msf.autorun (
		set sst_b.msf.autorun=True
		call box 2 1 4 38 - " " f8
		call batbox /c 0xf0 /g 4 2 /d "FATAL ERROR" /g 4 3 /d "File ~:\autorun.cmd was not found."
	)
) else set sst_b.msf.autorun=
call cmdwiz delay 1024
goto main