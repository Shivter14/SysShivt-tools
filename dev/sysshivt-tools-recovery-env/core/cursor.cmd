@echo off
call cmdwiz showcursor 1 100
if "%sst.mvc.crrX%" equ "" set sst.mvc.crrX=2
if "%sst.mvc.crrY%" equ "" set sst.mvc.crrY=1
set sst.mvc.oldX=2
set sst.mvc.oldY=1
set sst.mvc.file=%~1
:main
if exist "%sst.mvc.file%" call "%sst.mvc.file%" %sst.mvc.crrX% %sst.mvc.crrY% %sst.errorlevel%
call batbox /g %sst.mvc.crrX% %sst.mvc.crrY%
call getinput
set sst.errorlevel=%errorlevel%
set errorlevel=
if %sst.errorlevel% lss 0 goto mtc
if "%sst.errorlevel%" equ "32" set sst.errorlevel=OPTIONS
if "%sst.errorlevel%" equ "OPTIONS" goto exit
if "%sst.errorlevel%" equ "13" goto exit
if "%~1" neq "/d" if "%sst.errorlevel%" equ "25" goto exit.startmenu
if "%~1" neq "/d" if "%sst.errorlevel%" equ "24" goto exit.shell
if "%sst.errorlevel%" equ "295" set /a sst.mvc.crrX=%sst.mvc.crrX%+1
if "%sst.errorlevel%" equ "293" set /a sst.mvc.crrX=%sst.mvc.crrX%-1
if "%sst.errorlevel%" equ "296" set /a sst.mvc.crrY=%sst.mvc.crrY%+1
if "%sst.errorlevel%" equ "294" set /a sst.mvc.crrY=%sst.mvc.crrY%-1
if "%sst.errorlevel%" equ "291" set /a sst.mvc.crrX=%sst.mvc.crrX%+(%sst.defaultresX%/8)
if "%sst.errorlevel%" equ "292" set /a sst.mvc.crrX=%sst.mvc.crrX%-(%sst.defaultresX%/8)
if "%sst.errorlevel%" equ "290" set /a sst.mvc.crrY=%sst.mvc.crrY%+(%sst.defaultresY%/4)
if "%sst.errorlevel%" equ "289" set /a sst.mvc.crrY=%sst.mvc.crrY%-(%sst.defaultresY%/4)
if %sst.mvc.crrX% gtr %sst.defaultresX% set sst.mvc.crrX=%sst.defaultresX%
if %sst.mvc.crrY% gtr %sst.defaultresY% set sst.mvc.crrY=%sst.defaultresY%
if %sst.mvc.crrX% lss 0 set sst.mvc.crrX=0
if %sst.mvc.crrY% lss 0 set sst.mvc.crrY=0
goto main
:exit.shell
set sst.mvc.dir=%cd%
cd "%sst.dir%"
cls
color 07
mode %sst.defaultres%
call shell.cmd
call setres
cd "%sst.mvc.dir%"
goto exit
:exit.startmenu
set sst.mvc.dir=%cd%
cd "%sst.dir%"
if "%~1" equ "/startmenu" set sst.startmenu.exit=1
if "%~1" neq "/startmenu" call startmenu.cmd
call setres
cd "%sst.mvc.dir%"
goto exit
:mtc
call mtc.cmd
:exit
call cmdwiz showcursor 1 25