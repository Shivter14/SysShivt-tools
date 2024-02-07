@echo off
cd "%sst.dir%"
color 7f
cls
call setres /loadsettings
for %%a in ("args=/buttons" "buttonsmode=list" "buttonsspacing=1" "buttonsoffset=2" "width=62" "height=11" "line2=Welcome to SysShivt tools recovery.") do set "sst.window.%%~a"
set sst.window.buttons="   Start recovery                                       " "   Exit                                                 " "   Enter command prompt                                 " "   Start SysShivt tools pre-installation environment    " "   Start SysShivt tools recovery partition 3.1.r        " "   Start SysShivt tools with custom batch parameters    "
call window
if "%sst.errorlevel%" equ "CLOSED" (
	color 7f
	cls
	timeout 1 /nobreak > nul
	exit /b
)
if "%sst.errorlevel%" equ "1" (
	color 7f
	cls
	timeout 1 /nobreak > nul
	exit /b
)
if "%sst.errorlevel%" equ "2" goto shell
if "%sst.errorlevel%" equ "3" (
	color 0f
	cls
	echo.Warning: This will boot sysshivt tools as an installer:
	echo.Don't try to install SysShivt tools on this drive using this,
	echo.it will corrupt this installation.
	echo.[or in other words: Use only the recovery option.]
	pause
	cmd.exe /c sstsession.cmd /pe
	exit 0
)
if "%sst.errorlevel%" equ "4" goto pe
if "%sst.errorlevel%" equ "5" goto arg
goto \pe
:pe
call cssvmvd.cmd SST_PE.ssvm /q
exit 0
:\pe
goto \arg
:arg
call cmdwiz showcursor 1 25
set sst.bsd.arg=nul
call setres /d
for %%a in ("title=Start with custom batch parameters" "height=7" "args=/getinput" "line2=Type your custom arguments to run SysShivt tools.") do set "sst.window.%%~a"
call window
set sst.bsd.arg=%sst.errorlevel%
cls
cmd.exe /c sstsession.cmd - %sst.bsd.arg%
exit 0
:\arg
color 0f
cls
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
exit 0
:shell
if not defined sst.ver set sst.ver=3.1.k
if not defined sst.build set sst.build=1622
if not defined sst.dir set sst.dir=%cd%
cls
call shell.cmd