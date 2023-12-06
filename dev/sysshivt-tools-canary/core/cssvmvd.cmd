@echo off
if "%~1" equ "/boot" (
	cls
	goto boot
)
goto \boot
:boot
for %%a in (
	"sst" "ls" "sftm" "ssp" "ssp" "fdc" "sstenv"
) do (
	set "%%~a.=nul"
	for /f "tokens=1 delims==" %%b in ('set %%~a.') do set %%~b=
)
if "%~2" equ "/sstnoguiboot" set sst.noguiboot=True
:bootmgr
if not exist autorun.cmd (
	echo.FATAL: autorun.cmd was not found!
	choice /c rx /n /m "Press X to exit or R to retry. . ."
	if ERRORLEVEL 2 exit
	goto bootmgr
)
call autorun.cmd
exit
:\boot
setlocal enabledelayedexpansion
call cmdwiz showcursor 0
set cssvmvd.path=%~f1
call getlen "!cssvmvd.path:~%sst.sdir%!"
set /a sst.window.width=%errorlevel%+4
if "%sst.window.width%" equ "" (
	echo.The path of the file is invalid.
	exit /b
)
if not defined sst.build goto main
if %sst.window.width% lss 44 set sst.window.width=44
set sst.window.title=Connect virtual boot disk
set sst.window.args=/displayonly
set sst.window.line2=Are you sure you want to boot from this
set sst.window.line3=virtual boot disk file?
set sst.window.line4=!cssvmvd.path:~%sst.sdir%!
set sst.window.line6=Y / N
set sst.window.height=8
call window rem
choice /c:yn > nul
set cssvmvd.errorlevel=%errorlevel%
call cmdwiz showcursor 1 25
if "%cssvmvd.errorlevel%" equ "2" goto end
:main
cd "%temp%"
if exist "cssvmvd" (
	del /F /S /Q cssvmvd\* > nul
	rd /S /Q cssvmvd > nul
)
md cssvmvd
cd cssvmvd
if "%~2" neq "/q" (
	color 07
	cls
	echo.
	echo.  SysShivt tools CMD virtual machine BIOS
	echo.  This virtual machine is running on SysShivt tools version %sst.ver% build %sst.build%
	timeout 0 /nobreak > nul
	echo.
	echo.  Extracting the virtual disk file. . .
)
call 7za.exe x "%cssvmvd.path%" > nul
if "%~2" neq "/q" (
	echo.  Loading settings. . .
	if exist "SSVM.cww" (
		for /f "tokens=2 delims==" %%a in ('type "SSVM.cww" ^| find "BOOT"') do set cssvmvd.name=%%a
	)
	title Command Prompt
	title %cssvmvd.name%
	echo.  Booting. . .
)
call cmd /i /c %0 /boot
if not defined sst.build exit /b
if "%~2" neq "/q" exit /b
call setres /loadsettings
call cmdwiz showcursor 0
set sst.window.title=SysShivt tools SandBox
set sst.window.args=/keystroke
set sst.window.height=5
set sst.window.line2=INFO: The virtual machine was shut down.
set sst.window.line3=Press any key to exit. . .
call window rem
call cmdwiz showcursor 1 25
:end