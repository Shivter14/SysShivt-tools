@echo off
call cmdwiz showcursor 1 25
set gtxt.input=
set gtxt.blank=
set gtxt.blankcounter=0
:loop
if %gtxt.blankcounter% geq %~1 goto start
set /a gtxt.blankcounter=%gtxt.blankcounter%+1
set gtxt.blank=%gtxt.blank% 
goto loop
:start
call batbox /c 0x%~2 /g %~3 %~4 /d "%gtxt.blank%" /g %~3 %~4 /d "%gtxt.input%"
call getinput
set gtxt.errorlevel=%errorlevel%
if "%gtxt.errorlevel%" equ "13" goto input
if "%gtxt.errorlevel%" equ "8" goto /backspace
goto \backspace
:/backspace
if "%gtxt.input%" equ "" goto start
set gtxt.input=%gtxt.input:~0,-1%
goto start
:\backspace
call getlen "%gtxt.input%"
set gtxt.len=%errorlevel%
if %gtxt.len% geq %~1 goto start
if "%gtxt.errorlevel%" equ "32" set gtxt.input=%gtxt.input% 
if %gtxt.errorlevel% leq 0 goto start
if %gtxt.errorlevel% geq 368 if %gtxt.errorlevel% leq 379 goto start
for /f "tokens=2" %%a in ('type "%sst.dir%\assets\gettext.cwt"') do if "%gtxt.errorlevel%" equ "%%a" goto start
for /f "" %%a in ('call batbox /a %gtxt.errorlevel%') do set gtxt.input=%gtxt.input%%%a
goto start
:input
set sst.errorlevel=%gtxt.input%