@echo off
set sst.updatever=3.0.b
if "%sst.ver%" equ "%sst.updatever%" goto uptolate
echo.Update avalible!
echo.Current version: %sst.ver%
echo.Update version: %sst.updatever%
echo.Downloading lates version
call "%sst.dir%\spin.cmd" 26 7 4 0f /c
goto end
:uptolate
echo.You are up to late!
pause
:end
