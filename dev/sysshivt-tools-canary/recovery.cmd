@echo off
cd "%sst.dir%"
color 0f
cls
echo.Please wait. . .
set sst.bsd.head= 
for /f "tokens=2" %%a in ('mode con ^| find "Columns:"') do for /l %%b in (29 1 %%a) do for /f "tokens=2 delims==" %%c in ('set sst.bsd.head') do set sst.bsd.head=%%c 
cls
echo.[7m  SysShivt tools recovery  %sst.bsd.head%[0m[1m
echo.
echo.  Welcome to SysShivt tools recovery.
echo.
call cmdmenusel E8F0 "    Start recovery" "    Exit" "    Enter command prompt" "    Start SysShivt tools pre-installation environment [on this installation]" "    Start SysShivt tools recovery partition 3.1.r [stable, isolated]" "    Start SysShivt tools with custom batch parameters"
set sst.errorlevel=%errorlevel%
if "%sst.errorlevel%" equ "2" exit /b
if "%sst.errorlevel%" equ "3" goto shell
if "%sst.errorlevel%" equ "4" (
	cls
	echo.Warning: This will boot sysshivt tools as an installer:
	echo.Don't try to install SysShivt tools on this drive using this,
	echo.it will corrupt this installation.
	echo.[or in other words: Use only the recovery option.]
	pause
	set sst.krnlargs=/pe
	goto exit
)
if "%sst.errorlevel%" equ "5" (
	goto pe
)
if "%sst.errorlevel%" equ "6" goto arg
goto \pe
:pe
call cssvmvd.cmd SST_PE.ssvm /q
exit /b
:\pe
goto \arg
:arg
call cmdwiz showcursor 1 25
set sst.bsd.arg=nul
color 0f
cls
echo.
echo.  Type your custom arguments to run SysShivt tools.
echo.
set /p "sst.bsd.arg=> "
cls
cmd /c sstsession.cmd - %sst.bsd.arg%
exit /b
:\arg
echo.> "%sst.dir%\recovery.txt"
echo.
echo.  Loading settings. . .
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[0\0]"') do set sst.ver=%%a
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[0\1]"') do set sst.build=%%a
echo.  SysShivt tools version %sst.ver% build %sst.build%
call cmd /c recovery_llg.cmd
if "%cd%" neq "%sst.dir%" call recovery_msf /ins sst.dir "#sst.dir# is not equal to #dir#"
echo.  Checking for missing files. . .
set sst.recovery.errors=0
timeout 1 > nul
for /f "delims=" %%a in ('type "assets\filelist.cww"') do if not exist "%%~a" call recovery_msf /msf "%%~a"
echo.
call batbox /d "  "
pause
exit /b
:shell
if not defined sst.ver set sst.ver=3.1.k
if not defined sst.build set sst.build=1622
if not defined sst.dir set sst.dir=%cd%
cls
call shell.cmd