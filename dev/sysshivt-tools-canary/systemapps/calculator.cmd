@echo off
if "%sst.build%" equ "" (
    echo.This program reqires SysShivt tools 3. Press any key to exit.
    pause>nul
    goto end
)
call batbox /c %sst.startmenu.tbfgcolor%
call box 2 1 4 34 - " "
call batbox /c %sst.startmenu.tbfgcolor% /g 4 2 /d "exit = exit" /g 4 3 /d "Press any key to continue. . ."
pause>nul
:start
call box 2 1 4 34 - " "
call batbox /c %sst.startmenu.tbfgcolor% /g 4 2 /d "%calc.errorlevel%" /g 4 3
set /p calc.errorlevel=
call batbox /g 4 3
if "%calc.errorlevel%" equ "exit" goto end
set /a calc.errorlevel=%calc.errorlevel%> nul
goto start
:end
