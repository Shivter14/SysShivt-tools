@echo off
call cmdwiz showcursor 0
if exist "%sst.temp%\exitrgb.cww" del "%sst.temp%\exitrgb.cww"
set rgbX=%~1
set rgbY=%~2
set rgbarg=%~3
set rgbef=%~4
if "%~3" equ "" set rgbarg=8
set /a rgbarg=%rgbarg%*6
if "%rgbX%" equ "" set rgbX=0
if "%rgbY%" equ "" set rgbY=0
set rgb=97
set rgbout=
set rgbcon=0
:start
set /a rgb=%rgb%+3
set rgbout=%rgbout%[38;2;%rgb%;%rgb%;%rgb%m__
if %rgb% lss 256 goto start
:render
call batbox /g %rgbX% %rgbY%
echo.%rgbout:~-966%
set rgbout=%rgbout:~-21%%rgbout:~0,-21%
set /a rgbcon=%rgbcon%+1
if "%rgbef%" neq "/ef" if exist "%sst.temp%\exitrgb.cww" goto end
if "%rgbef%" neq "/ef" if exist shutdown.txt goto end
if "%rgbef%" neq "/ef" if exist restart.txt goto end
if "%rgbef%" neq "/ef" if exist logoff.txt goto end
if "%rgbef%" neq "/ef" if exist crashed.txt goto end
if %rgbcon% leq %rgbarg% goto render
:end
call cmdwiz showcursor 1 25