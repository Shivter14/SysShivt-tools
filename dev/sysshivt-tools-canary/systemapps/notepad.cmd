@echo off
color f0
mode %sst.defaultres%
cls
echo.[0m[1m  Notepad for SysShivt tools  ^|  Press ^^Z to complete  [7m
type con > notepad.txt
set /p "ssnp.errorlevel= Save | Exit > "
if "%ssnp.errorlevel%" neq "save" if "%ssnp.errorlevel%" neq "Save" goto exit
set /p "ssnp.errorlevel=Path: "
copy "notepad.txt" "%ssnp.errorlevel%"
if exist "%ssnp.errorlevel%" (
	echo.Saved. Press any key to exit
	pause>nul
)
:exit