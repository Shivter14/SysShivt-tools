@echo off
set bp1.dir=%cd%
if not defined sst.build (
    echo.This program reqires SysShivt tools 3. Press any key to exit.
    pause>nul
    goto end
)
set bp1.path=%~f1
set bp1.class=%~2
if not defined bp1.class set bp1.class=main
set bp1.args=%3 %4 %5 %6 %7 %8 %9
if not exist "%bp1.path%" (
	echo.File not found!
	goto end
)
set bp1.temp=0
:settemp
set /a bp1.temp+=1
if exist "%temp%\bp1\%bp1.temp%" goto settemp
md "%temp%\bp1\%bp1.temp%"
cd "%temp%\bp1\%bp1.temp%"
call 7za x "%bp1.path%" > nul
if not exist "%bp1.class%.cmd" if not exist "%bp1.class%.bat" if not exist "%bp1.class%" (
	echo.Function not found!
	goto clear
)
call %bp1.class% %bp1.args%
:clear
cd "%bp1.dir%"
del /F /S /Q "%temp%\bp1\%bp1.temp%\*" > nul
rd /S /Q "%temp%\bp1\%bp1.temp%" > nul
:end