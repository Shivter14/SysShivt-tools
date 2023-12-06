@echo off
if not defined sst.build (
	This program requires SysShivt tools 3.1.0 or higher! Press any key to exit. . .
	pause>nul
	goto end
)
set sst.startup.dcls=%~4
set sst.startup.timeout=8
if "%~3" neq "" set /a sst.startup.timeout=%~3
set sst.startup.boxL=
set sst.startup.screenwiew=
set sst.startup.screenvar=%~2
set /a sst.startup.boxX=%sst.crrresX%/2-48
set /a sst.startup.boxY=%sst.crrresY%/2-8
set /a sst.loading.pbX=%sst.startup.boxX%+2
if %sst.defaultresX% lss 95 set /a sst.loading.pbX=1
set /a sst.loading.ptY=%sst.startup.boxY%+13
if %sst.defaultresX% lss 95 set /a sst.loading.ptY+=1
set /a sst.loading.pbY=%sst.startup.boxY%+14
set /a sst.loading.ptX=%sst.startup.boxX%+2
set /a sst.startup.packX=%sst.defaultresX%/2-8
set /a sst.startup.packY=%sst.defaultresY%/2-2
set sst.startup.ef=/ef
if "%~5" equ "/ef" set sst.startup.ef=
if "%sst.startup.screenvar%" equ "" goto /skippedloop
if "%sst.startup.screenvar%" equ "0" goto /skippedloop
if %sst.startup.screenvar% gtr 46 set sst.startup.screenvar=46
for /l %%a in (0 1 %sst.startup.screenvar%) do call :loop
:loop
set sst.startup.screenwiew=%sst.startup.screenwiew%__
goto end
goto \skippedloop
:/skippedloop
set sst.startup.screenwiew=False
:\skippedloop
if "%sst.startup.dcls%" neq "/dcls" (
	call setres /d
	color %sst.window.TIcolor%%sst.window.FGcolor%
)
setlocal enabledelayedexpansion
if %sst.crrresX% geq 96 (
	call box %sst.startup.boxX% %sst.startup.boxY% 16 96 - " " %sst.window.BGcolor%%sst.window.TIcolor%
) else (
	call box 0 %sst.startup.boxY% 16 %sst.crrresX% - " " %sst.window.BGcolor%%sst.window.TIcolor%
)
call mti assets\pack.mti %sst.startup.packX% %sst.startup.packY%
call batbox /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g %sst.loading.pbx% %sst.loading.ptY% /d " %~1"
if "%sst.startup.screenwiew%" neq "False" call line %sst.loading.pbX% %sst.loading.pbY% %sst.loading.ptX% %sst.loading.pbY% _ 04
if "%sst.startup.screenwiew%" equ "False" goto /swfalse
call batbox /g %sst.loading.pbX% %sst.loading.pbY%
echo.[92m%sst.startup.screenwiew%
goto \swfalse
:/swfalse
if %sst.startup.timeout% lss 8 set sst.startup.timeout=8
if exist "%sst.dir%\exitrgb.cww" del "%sst.dir%\exitrgb.cww"
if %sst.defaultresX% geq 95 (
	call rgb "%sst.loading.pbX%" "%sst.loading.pbY%" "%sst.startup.timeout%" "%sst.startup.ef%"
) else (
	call cmdwiz delay %sst.startup.timeout%00
)
if exist "%sst.dir%\exitrgb.cww" del "%sst.dir%\exitrgb.cww"
goto nospin
:\swfalse
set /a sst.loading.liX=%sst.defaultresX%/2
set /a sst.loading.liY=%sst.defaultresY%/2+4
call spin %sst.loading.liX% %sst.loading.liY% %sst.startup.timeout% 0f /c
:nospin
if "%sst.startup.dcls%" equ "/dcls" goto dcls2
color 07
cls
:dcls2
call cmdwiz setcursorpos 0 0
:end