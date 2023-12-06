@echo off
setlocal
set sst.krnlfeatures="sst.dir" "sst.root" "sst.sdir" "sst.path" "path_corelinked" "badshutdown" "fastreboot.cww" "temp" "restart.txt" "restartRM.txt" "shutdown.txt" "crashed.txt" "session_process.exit.inc" "sstools.exit.syn" "sstools.exit.inc" "setres.changingmode.pth" "desktop.load.failiure" "startup.sfc.msf" "safemode" "sst.pe" "SSVMreboot.txt" "sst.krnlargs" "ssvmkeypress.cww" "sstools.MSF_IML" "rebootIntoCMDMode.cww"
set sst.krnlargs=%*
set sst.path=%path%
path %cd%\core;%path%
if exist crashed.txt set sst.badst=true
if exist crashed.txt del crashed.txt
if exist crash.txt del crash.txt
if exist temp\memorydump.txt del temp\memorydump.txt
if not exist temp md temp
set sst.temp=%cd%\temp
set temp=%cd%\temp
set tmp=%cd%\temp
if defined ssvm.bge (
	if exist "%ssvm.dir%\ssvmkeypress.cww" (
		for /f "delims=" %%a in ('type "%ssvm.dir%\ssvmkeypress.cww"') do if "%%~a" equ "98" set sst.badst=true
		del "%ssvm.dir%\ssvmkeypress.cww"
	)
)
set sst.crashstate=False
set sst.langclientformat=1.7
set sst.dir=%cd%
cd ..
set sst.cd=%cd%
cd ..
set sst.root=%cd%
cd "%sst.dir%"
call getlen "%sst.cd%"
set sst.sdir=%errorlevel%
:main
if exist "temp\fastreboot.cww" (
	del "temp\fastreboot.cww"
	if exist "temp\rebootIntoCMDMode.cww" (
		del "temp\rebootIntoCMDMode.cww"
		goto CMDOnlyMode
	)
	set sst.noguiboot=True
) else set sst.noguiboot=true
if "%sst.badst%" equ "true" (
	set sst.badst=
	goto badshutdown
)
if not exist shutdown.txt goto badshutdown
if exist shutdown.txt del shutdown.txt
goto \badshutdown
:CMDOnlyMode
color 0f
cls
for %%a in (
	"You are now in CMD-Only mode."
	"Type 'sstsession' to switch back to SysShivt tools."
) do echo.%%~a
call cmd.exe
goto safemode
:badshutdown
set sst.crashstate=
if exist restartRM.txt del restartRM.txt
set sst.safemode=
if "%~1" neq "/pe" call badshutdown.cmd
if defined sst.boot.entermenu goto end
:\badshutdown
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[95mSSTKRNL[0m[2m] [0m[1mStarting SysShivt tools. . . > "%sst.dir%\log.txt"
cd ..
cd "%sst.dir%"
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[95mSSTKRNL[0m[2m] [0m[1mLoading "sysshivt-tools\sstsession.cmd". . . >> "%sst.dir%\log.txt"
if not exist sstsession.cmd (
	call crash.cmd "sstools.MSF_IML" "" "HIGH" "Missing important system file!" "missing file: sysshivt-tools\sstsession.cmd"
	goto badshutdown
)
:session
if "%sst.safemode%" neq "true" goto notsafemode
cmd /c sstsession.cmd /safemode
set sst.errorlevel=%errorlevel%
goto safemode
:notsafemode
if exist temp\breakatstartup.cww (
	call crash.cmd "sstools.emergency.breakatstartup" "Access is denied for emergency reasons" "LOW" "System canceled startup," "becose emergency break was activated." "Please contact staff on github if this is a false alert."
	goto badshutdown
)
cmd /c sstsession.cmd %sst.krnlargs%
set sst.errorlevel=%errorlevel%
:safemode
set sst.crashstate=False
for /f "delims=" %%a in ('type "%sst.temp%\errorlevel.cww"') do set sst.cww.errorlevel=%%a
if not exist shutdown.txt if not exist restart.txt if not exist temp\fastreboot.cww set sst.crashstate=BSD
if "%sst.errorlevel%" equ "-1073741510" set sst.crashstate=PBK
if "%sst.errorlevel%" equ "1" set sst.crashstate=1
if "%sst.errorlevel%" equ "255" set sst.crashstate=255
if "%sst.cww.errorlevel:~:0,13%" equ "CHANGINGMODE " set sst.crashstate=CMF
if "%sst.cww.errorlevel%" equ "DESKTOPLOAD" set sst.crashstate=DLF
if "%sst.cww.errorlevel:~0,11%" equ "STARTUPMSF" (
	set sst.crashstate=SMF
	set sst.msf.file=%sst.cww.errorlevel:~11%
)
if "%sst.crashstate%" equ "PBK" call crash.cmd "session_process.exit.inc" "The session was manually terminated." "HIGH" "The sysshivt tools session process was terminated." "Exit code: %sst.errorlevel%"
if "%sst.crashstate%" equ "1" call crash.cmd "session_process.exit.inc" "The session was forcefully terminated." "HIGH" "The sysshivt tools session process was terminated." "Exit code: %sst.errorlevel%"
if "%sst.crashstate%" equ "255" call crash.cmd "sstools.exit.syn" "Unknown reason" "HIGH" "SysShivt tools did not exit correctly" "Exit code: %sst.errorlevel%"
if "%sst.crashstate%" equ "BSD" call crash.cmd "sstools.exit.inc" "Unknown reason" "NORMAL" "SysShivt tools did not shut down correctly." "Exit code: %sst.errorlevel%"
if "%sst.crashstate%" equ "CMF" call crash.cmd "setres.changingmode.pth" "Changing mode failiure" "NORMAL" "SysShivt tools crashed when clearing the screen, or" "changing resolution. It was propably caused by setting" "the resolution too high."
if "%sst.crashstate%" equ "DLF" call crash.cmd "desktop.load.failiure" "Unknown reason" "HIGH" "SysShivt tools crashed when loading the desktop." "Try rebooting into safe mode." "Exit code: %sst.errorlevel%"
if "%sst.crashstate%" equ "SMF" call crash.cmd "startup.sfc.msf" "MISSING FILE" "HIGH" "SysShivt tools crashed becose a system file was not found." "Try rebooting to safe mode." "" "Missing file: %sst.msf.file%"
if exist "temp\fastreboot.cww" goto main
if exist "restartRM.txt" goto badshutdown
if "%sst.crashstate%" neq "False" goto badshutdown
if exist restart.txt (
	if defined ssvm.ver if not exist "temp\fastreboot.cww" (
		echo.> "..\..\SSVMreboot.txt"
		goto end
	)
	goto main
)
:end
endlocal