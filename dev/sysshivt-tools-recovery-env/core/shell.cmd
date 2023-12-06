@echo off
set shl.crash=0
for %%a in ("sst.dir" "sst.sdir" "sst.cd" "sst.temp") do if not defined %%~a (
	echo.	Variable '%%~a' is not defined!
	set /a shl.crash=%shl.crash%+1
)
if not defined sst.build (
	echo.	This program reqires SysShivt tools!
	set /a shl.crash=%shl.crash%+1
) else (
	if %sst.build%0 lss 8310 (
		echo.	This program reqires SysShivt tools version 3.1.1 or higher!
		set /a shl.crash=%shl.crash%+1
	)
)
for /f "tokens=1,2,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] SystemSettings"') do if "%%~c" equ "key" if "%%~b" equ "SystemSettings" set "sst.shell.cwtroot=%%~a"
if exist "%sst.dir%\settings.cwt" (
	for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "%sst.shell.cwtroot:~0,-1%" ^| find "] antishellmode"') do (
		if "%%~a" equ "True" (
			echo.	Command Prompt is disabled on this device.
			set /a shl.crash=%shl.crash%+1
		)
		set sst.shell.safekey=True
	)
	if not defined sst.shell.safekey (
		echo.	An error occured while inspecting the configuration of this device:
		echo.		Access was denied to prevent an exploit:
		echo.		'antishellmode' is missing in '%sst.shell.cwtroot%'
		set /a shl.crash=%shl.crash%+1
	)
) else if not defined sst.dir (
	echo.	An error ocurred while authorizing the current session:
	echo.		Access was denied to prevent an exploit:
	echo.		System file "settings.cwt" is missing.
	set /a shl.crash=%shl.crash%+1
)
if %shl.crash% gtr 0 (
	echo.
	echo.  %shl.crash% error[s] detected!
	echo.  Press any key to exit. . .
	pause>nul
	exit /b
)
set shl.errorlevel=0
:main
set shl.cmd=
echo.> "%temp%\shelldir.cww"
setlocal enabledelayedexpansion
if "!cd:~0,%sst.sdir%!" neq "%sst.cd%" (
	cd "%sst.cd%"
	echo.!cd!> "%temp%\shelldir.cww"
)
call batbox /c 0xbf /d " %ls.username% " /c 0x9f /d " %shl.errorlevel% " /c 0x0a /d " ~:!cd:~%sst.sdir%!" /c 0x0e /a 62 /a 0 /c 0x0f
endlocal
if exist "%temp%\shelldir.cww" for /f "delims=" %%a in ('type "%temp%\shelldir.cww"') do cd "%%~a"
set /p shl.cmd=
if "%shl.cmd%" equ "exit" goto exit
if "%shl.cmd%" equ "ver" (
	call sysver
	goto main
)
set errorlevel=
call %shl.cmd%
set shl.errorlevel=%errorlevel%
goto main
:exit