@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.3 or higher. Press any key to exit. . .
	pause>nul
	goto end
)
if %sst.build% lss 1418 (
	for %%a in ("title=Package Installer" "line2=Installation initialization failed:" "line4=This program reqires SysShivt tools" "line5=version 3.1.3 or higher.") do set sst.window.%%~a
	goto end
)
set ssp.file=%~f1
if not exist "%ssp.file%" (
	for %%a in ("height=6" "title=Package Installer" "line2=Installation initialization failed:" "line4=The file specified was not found.") do set sst.window.%%~a
	call window rem
	goto end
)
if not exist "%sst.dir%\assets\programs.cwt" (
	for %%a in ("height=6" "title=Package Installer" "line2=Installation initialization failed:" "line4=Program list file was not found.") do set sst.window.%%~a
	goto end
)
setlocal enabledelayedexpansion
set ssp.cd=%cd%
set ssp.temp=%random%
md "%sst.temp%\ssp\%ssp.temp%"
cd "%sst.temp%\ssp\%ssp.temp%"
call 7za.exe x "%ssp.file%" > nul
if not exist "ssp.cwt" (
	for %%a in ("height=6" "title=Package Installer" "line2=Operation failed:" "line4=The package selected is invalid.") do set sst.window.%%~a
	call window rem
	goto exit
)
if not exist "sources" (
	for %%a in ("height=6" "title=Package Installer" "line2=Operation failed:" "line4=The package selected is invalid.") do set sst.window.%%~a
	call window rem
	goto exit
)
for /f "tokens=1,3" %%a in ('type "ssp.cwt" ^| find "[0\0]"') do if "%%~a" equ "[0\0]" set ssp.info.name=%%~b
for /f "tokens=1,3" %%a in ('type "ssp.cwt" ^| find "[0\1]"') do if "%%~a" equ "[0\1]" set ssp.info.dir=%%~b
for /f "tokens=1,3" %%a in ('type "ssp.cwt" ^| find "[0\2]"') do if "%%~a" equ "[0\2]" set ssp.info.file=%%~b
for /f "tokens=1,3" %%a in ('type "ssp.cwt" ^| find "[0\3]"') do if "%%~a" equ "[0\3]" set ssp.info.type=%%~b
if not defined ssp.info.type set ssp.info.type=1
:main
if %ssp.info.type% gtr 1 (
		for /f "tokens=1,2*" %%a in ('type "ssp.cwt" ^| find "[1\0]"') do if "%%~a" equ "[1\0]" set "sst.window.title=%%~c"
		for /f "tokens=1,2*" %%a in ('type "ssp.cwt" ^| find "[1\1]"') do if "%%~a" equ "[1\1]" set "sst.window.width=%%~c"
		for /f "tokens=1,2*" %%a in ('type "ssp.cwt" ^| find "[1\2]"') do if "%%~a" equ "[1\2]" set "sst.window.line2=%%~c"
		for /f "tokens=1,2*" %%a in ('type "ssp.cwt" ^| find "[1\3]"') do if "%%~a" equ "[1\3]" set "sst.window.line4=%%~c"
		for /f "tokens=1,2*" %%a in ('type "ssp.cwt" ^| find "[1\4]"') do if "%%~a" equ "[1\4]" set "sst.window.line5=%%~c"
		for %%a in ("height=10" "args=/keystroke" "line7=Press ENTER to install," "line8=or press ESC to cancel.") do set "sst.window.%%~a"
		call window rem
		if "!sst.errorlevel!" equ "27" goto exit
		if "!sst.errorlevel!" neq "13" goto main
)
set ssp.counter=-1
for /f "" %%a in ('type "%sst.dir%\assets\programs.cwt"') do set /a ssp.counter+=1
echo.[0\%ssp.counter%] %ssp.info.name% programs\%ssp.info.dir% %ssp.info.file%>> "%sst.dir%\assets\programs.cwt"
xcopy "sources" "%sst.dir%\programs\%ssp.info.dir%\*" /E /Q > nul
:exit
cd "%ssp.cd%"
rd "%sst.temp%\ssp\%ssp.temp%" /S /Q > nul
endlocal
:end