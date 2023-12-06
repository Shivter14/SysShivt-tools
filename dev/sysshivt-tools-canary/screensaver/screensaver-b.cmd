@echo off
del exit.txt
call cmdwiz showcursor 0
set sct.x=%sst.defaultresX%/4
set sct.y=%sst.defaultresY%/2
set sct.dx=0
set sct.dy=0
set sct.rotation=SD
set /a sct.mx=%sst.defaultresX%/2-7
color 0f
mode %sst.defaultres%
cls
:start
if exist exit.txt call cmdwiz showcursor 1 25
if exist exit.txt goto exit
if exist "%sst.dir%\shutdown.txt" goto exit
if exist "%sst.dir%\restart.txt" goto exit
if exist "%sst.dir%\crash.txt" goto exit
if exist "%sst.dir%\logoff.txt" goto exit
set sct.lx=%sct.dx%
set sct.ly=%sct.dy%
set /a sct.dx=%sct.x%*2
set /a sct.dy=%sct.y%*1
call batbox /c 0x0f /g %sct.dx% %sct.dy% /d "[SysShivt-tools]" /g %sct.lx% %sct.ly% /d "                "
call cmdwiz delay 128
if %sct.y% leq 0 if "%sct.rotation%" equ "WD" set sct.rotation=SD
if %sct.x% geq %sct.mx% if "%sct.rotation%" equ "SD" set sct.rotation=SA
if %sct.y% geq %sst.defaultresY% if "%sct.rotation%" equ "SA" set sct.rotation=WA
if %sct.x% leq 0 if "%sct.rotation%" equ "WA" set sct.rotation=WD
if %sct.y% leq 0 if "%sct.rotation%" equ "WA" set sct.rotation=SA
if %sct.x% leq 0 if "%sct.rotation%" equ "SA" set sct.rotation=SD
if %sct.y% geq %sst.defaultresY% if "%sct.rotation%" equ "SD" set sct.rotation=WD
if %sct.x% geq %sct.mx% if "%sct.rotation%" equ "WD" set sct.rotation=WA
if %sct.y% leq 0 if "%sct.rotation%" equ "WD" set sct.rotation=SD
if %sct.x% geq %sct.mx% if "%sct.rotation%" equ "SD" set sct.rotation=SA
if %sct.y% geq %sst.defaultresY% if "%sct.rotation%" equ "SA" set sct.rotation=WA
if %sct.x% leq 0 if "%sct.rotation%" equ "WA" set sct.rotation=WD
if %sct.y% leq 0 if "%sct.rotation%" equ "WA" set sct.rotation=SA
if %sct.x% leq 0 if "%sct.rotation%" equ "SA" set sct.rotation=SD
if %sct.y% geq %sst.defaultresY% if "%sct.rotation%" equ "SD" set sct.rotation=WD
if %sct.x% geq %sct.mx% if "%sct.rotation%" equ "WD" set sct.rotation=WA

if "%sct.rotation%" equ "WD" set /a sct.x=%sct.x%+1
if "%sct.rotation%" equ "WD" set /a sct.y=%sct.y%-1
if "%sct.rotation%" equ "SD" set /a sct.x=%sct.x%+1
if "%sct.rotation%" equ "SD" set /a sct.y=%sct.y%+1
if "%sct.rotation%" equ "SA" set /a sct.x=%sct.x%-1
if "%sct.rotation%" equ "SA" set /a sct.y=%sct.y%+1
if "%sct.rotation%" equ "WA" set /a sct.x=%sct.x%-1
if "%sct.rotation%" equ "WA" set /a sct.y=%sct.y%-1
goto start
:exit