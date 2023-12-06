@echo off
title SysShivt tools %sst.ver% build %sst.build%
if exist "%sst.temp%" echo.CHANGINGMODE> "%sst.temp%\errorlevel.cww"
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set /a sst.crrresY=%%a
for /f "tokens=2" %%a in ('mode con ^| find "Columns:"') do set /a sst.crrresX=%%a
for %%a in (1 3 5 7 9) do if "%sst.crrresX:~-1%" equ "%%~a" set /a sst.crrresX=%sst.crrresX%-1
if exist "%sst.temp%" echo.CHANGINGMODE %sst.crrresX% %sst.crrresY%> "%sst.temp%\errorlevel.cww"
call cmdwiz getwindowbounds w
set /a sst.fontsizeW=%errorlevel%-16
call cmdwiz getwindowbounds h
set /a sst.fontsizeH=%errorlevel%-39
set /a sst.fontsizeX=%sst.fontsizeW%/%sst.crrresX%
set /a sst.fontsizeY=%sst.fontsizeH%/%sst.crrresY%
if "%~1" equ "/loadsettings" goto loadsettings
if %sst.crrresX% lss 64 set sst.crrresX=64
if %sst.crrresY% lss 16 set sst.crrresY=16
if %sst.crrresX% gtr %sst.maxresX% set sst.crrresX=%sst.maxresX%
if %sst.crrresY% gtr %sst.maxresY% set sst.crrresY=%sst.maxresY%
set /a sst.screensize=%sst.crrresX%*%sst.crrresY%
if %sst.screensize% gtr %sst.screensize.max% (
	set sst.setres.pX=64
	set sst.setres.pY=16
	set sst.setres.stepX=4
	set sst.setres.stepY=1
	goto setres
)
goto \setres
:setres
set /a sst.setres.pX=%sst.setres.pX%+%sst.setres.stepX%
set /a sst.setres.pY=%sst.setres.pY%+%sst.setres.stepY%
set /a sst.setres.screensize=%sst.setres.pX%*%sst.setres.pY%
if %sst.setres.screensize% leq %sst.screensize.max% goto setres
set /a sst.crrresX=%sst.setres.pX%-%sst.setres.stepX%
set /a sst.crrresY=%sst.setres.pY%-%sst.setres.stepY%
set /a sst.screensize=%sst.crrresX%*%sst.crrresY%
for %%a in ("pX" "pY" "screensize" "stepX" "stepY") do set sst.setres.%%~a=
:\setres
if "%sst.crrresX%,%sst.crrresY%" equ "%sst.defaultres%" if "%~1" equ "/o" goto exit
if "%sst.crrresX%,%sst.crrresY%" equ "%sst.defaultres%" goto skipvar
:loadsettings
set sst.defaultres=%sst.crrresX%,%sst.crrresY%
set /a sst.defaultresX=%sst.crrresX%-1
set /a sst.defaultresY=%sst.crrresY%-1
set /a sst.dividedresX=%sst.crrresX%/2
set /a sst.dividedresY=%sst.crrresY%/2
:skipvar
if "%~1" equ "/loadsettings" goto exit
set sst.wallpaper.name=default
set sst.wallpaper.type=64x16
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "wallpapername"') do set sst.wallpaper.name=%%a
for /l %%w in (64 32 192) do if %sst.crrresX% geq %%w set sst.wallpaper.W=%%w
for /l %%h in (16 8 48) do if %sst.crrresY% geq %%h set sst.wallpaper.H=%%h
set sst.wallpaper.type=%sst.wallpaper.W%x%sst.wallpaper.H%
set /a sst.wallpaper.Y=%sst.defaultresY%-%sst.wallpaper.H%
set /a sst.wallpaper.Y=%sst.wallpaper.Y%/2
if "%sst.fullscreenoptimalization%" neq "True" mode %sst.defaultresX%,%sst.defaultresY%
if "%sst.enablecodepages%" neq "True" mode con CP SELECT=852 > nul
color 07
mode %sst.defaultres%
cls
call batbox /g 0 %sst.wallpaper.Y%
if "%~1" equ "/d" goto exit
if exist "%sst.dir%\wallpapers\%sst.wallpaper.name%_%sst.wallpaper.type%.cww" (
	type "%sst.dir%\wallpapers\%sst.wallpaper.name%_%sst.wallpaper.type%.cww"
	goto exit
)
set /a sst.rgbp=256/%sst.crrresY%
call batbox /g 0 %sst.defaultresY%
for /l %%a in (0 !sst.rgbp! 255) do (
	set /a sst.rgbq=255-%%a
	echo.[48;2;!sst.rgbq!;%%a;255m
)
:exit
if exist "%sst.temp%" echo.IDLE> "%sst.temp%\errorlevel.cww"
:trueexit