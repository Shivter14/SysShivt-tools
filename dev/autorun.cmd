@echo off
REM BATINFO;CMD;0;SysShivt tools bootloader;1.3.3/SST3.1.3;Shivter
:start
set sst.boot.cd=%cd%
if not exist "%sst.boot.cd%\boot.cwt" (
	cls
	echo.
	echo.  file "~:\boot.cwt" was not found!
	echo.  FATAL: System halted! Press any key to shut down. . .
	pause>nul
	goto end
)
setlocal enabledelayedexpansion
for /f "tokens=1,2,3,4" %%a in ('type "%sst.boot.cd%\boot.cwt" ^| find "[0\"') do (
	set sst.boot.kernel.%%a=%%b
	set sst.boot.kernel.%%a.name=%%~c
	set sst.boot.kernel.%%a.dir=%%~d
)
for /f "tokens=4" %%a in ('type "%sst.boot.cd%\boot.cwt" ^| find "[0]"') do set sst.boot.enabled=%%a
set sst.boot.kernel=%sst.boot.kernel.[0\1]%
set sst.boot.dir=%sst.boot.kernel.[0\1].dir%
set sst.boot.name=%sst.boot.kernel.[0\1].dir%
if exist "%sst.boot.dir%\enterbootmenu.cww" (
	del "%sst.boot.dir%\enterbootmenu.cww"
	goto bootmenu
)
if defined sst.boot.kernel.[0\2] if "%sst.boot.enabled%" equ "True" goto bootmenu
goto \bootmenu
:bootmenu
cls
for %%a in (
	""
	"  SysShivt tools boot menu   | Version"
	"============================ | 1.3.3  "
	"Select a kernel to boot from"
	""
) do echo.  %%~a
for /l %%a in (0 1 9) do if defined sst.boot.kernel.[0\%%a] call :bootmenu.list "%%a" "!sst.boot.kernel.[0\%%a].name!"
goto \bootmenu.list
:bootmenu.list
set sst.boot.list.int=%~1
set sst.boot.list.name=%~2
echo.  %sst.boot.list.int%	: %sst.boot.list.name:~0,64%
goto end
:\bootmenu.list
choice /c:123456789 > nul
set sst.boot.choice=%errorlevel%
set sst.boot.kernel=!sst.boot.kernel.[0\%sst.boot.choice%]!
set sst.boot.dir=!sst.boot.kernel.[0\%sst.boot.choice%].dir!
:\bootmenu
cd "%sst.boot.cd%\%sst.boot.dir%"
if not exist "%sst.boot.kernel%" (
	cls
	echo.
	echo.  The kernel file was not found!
	echo.  You have to reinstall SysShivt tools!
	echo.  FATAL: System halted. Press any key to shut down. . .
	pause>nul
	goto end
)
setlocal
call %sst.boot.kernel% %*%
endlocal
if exist "enterbootmenu.cww" (
	del "enterbootmenu.cww"
	goto bootmenu
)
cd %sst.boot.cd%
if exist "ver\SSVMreboot.txt" (
	move "ver\SSVMreboot.txt" "..\"
) > nul
if exist "SSVMreboot.txt" (
	move "SSVMreboot.txt" "..\"
) > nul
:end