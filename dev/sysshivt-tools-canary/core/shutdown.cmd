@echo off
set sst.shutdown.help=
if "%~1" equ "/?" set sst.shutdown.help=True
if "%~1" equ "-?" set sst.shutdown.help=True
if "%~1" equ "-help" set sst.shutdown.help=True
if "%~1" equ "/help" set sst.shutdown.help=True
if defined sst.shutdown.help (
	set sst.shutdown.help=
	for %%a in (
		""
		"Syntax: call shutdown.cmd [/help|/restart [1|2|3]|/logoff|/sleep|/switchuser] [/nogui]"
		"	/restart	- Restarts the system"
		"		1		- Restarts the whole system"
		"		2		- Restarts the system and brings up the BADSHUTDOWN.CMD options"
		"		3		- Quickly logs off all accounts and restarts SysShivt tools"
		"		4		- Exits SysShivt tools and opens CMD"
		"	/logoff		- Logs off, and shuts down the current session"
		"	/sleep		- Displays the screensaver until any key is pressed"
		"	/nogui		- Does not display the graphical interface"
	) do echo.  %%~a
	goto exit
)
if "%~1" equ "/switchuser" goto switchusr
if "%~1" equ "-switchuser" goto switchusr
if "%~1" equ "/sleep" goto sleep
if "%~1" equ "-sleep" goto sleep
goto \sleep
:switchusr
if "%sst.userprofile%" equ "%sst.dir%\nullprofile" (
	for %%a in (
		"width=36"
		"height=5"
		"title=shutdown.cmd:switchusr"
		"line2=Failed to switch:"
		"line3=Cannot log out of nullprofile"
	) do set "sst.window.%%~a"
	call window rem
	exit /b -1
)
for %%a in (
	"width=24"
	"height=4"
	"args=/displayonly"
	"line2=Please wait. . ."
) do set "sst.window.%%~a"
call window rem
echo.> "%sst.temp%\switchusr.cww"
if "%~2" neq "" echo."%~2"> "%sst.temp%\switchusr.cww"
:wait
if exist "%sst.dir%\shutdown.txt" exit
if exist "%sst.dir%\restart.txt" exit
if exist "%sst.dir%\restartRM.txt" exit
if exist "%sst.dir%\crash.txt" exit
if exist "%sst.dir%\crashed.txt" exit
if exist "%sst.temp%\login.cww" for /f "delims=" %%a in ('type "%sst.temp%\login.cww"') do if "%%~a" equ "sst.session.[%sst.session%]" (
	del "%sst.temp%\login.cww"
	call cmdwiz showcursor 1 25
	if "%sst.userprofile%" equ "%sst.cd%\users\Administrator" (
		call setres /loadsettings
		call sstsession.cmd /getadmin
		if defined sst.getadmin goto switchusr
		call setres /d
	) else call setres /d
	goto exit
)
call cmdwiz delay 2000
goto wait
:sleep
call cmdwiz showcursor 0
color 0f
cls
set sst.sleepmode.dir=%cd%
cd "%sst.dir%\screensaver"
call screensaver.cmd
cd "%sst.sleepmode.dir%"
call cmdwiz showcursor 1 25
goto exit
:\sleep
cd "%sst.dir%"
if "%~1" neq "/logoff" if "%~1" neq "-logoff" goto logoff
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[91mPOWERMGR[0m[2m] [0m[1mLogging off "%ls.username%". . . >> "%sst.dir%\log.txt"
if "%~2" neq "/nogui" if "%~2" neq "-nogui" for %%a in (
	"TIcolor=%sst.window.BGcolor%"
	"width=24"
	"height=3"
	"args=/displayonly"
	"line1=Logging off. . ."
) do set "sst.window.%%~a"
call window rem
exit 27
:logoff
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[91mPOWERMGR[0m[2m] [0m[1mLogging off "%ls.username%". . . >> "%sst.dir%\log.txt"
call bfshdwn.cmd
if "%~1" equ "/restart" set sst.shutdown.restart=True
if "%~1" equ "-restart" set sst.shutdown.restart=True
if "%sst.shutdown.restart%" equ "True" (
	if "%~2" equ "1" (
		echo.> "%sst.dir%\restart.txt"
		goto \restartcheck
	)
	if "%~2" equ "2" (
		echo.> "%sst.dir%\restart.txt"
		echo.> "%sst.dir%\restartRM.txt"
		goto \restartcheck
	)
	if "%~2" equ "3" (
		echo.> "%sst.dir%\restart.txt"
		echo.> "%sst.temp%\fastreboot.cww"
		goto \restartcheck
	)
	if "%~2" equ "4" (
		echo.> "%sst.dir%\restart.txt"
		echo.> "%sst.temp%\fastreboot.cww"
		echo.> "%sst.temp%\rebootIntoCMDMode.cww"
		goto \restartcheck
	)
	goto restartcheck
)
goto \restartcheck
:restartcheck
for %%a in (
	"title=%sst.lang.restartcho.title%"
	"args=/keystroke"
	"line2=%sst.lang.restartcho.info%"
	"line4=1 = %sst.lang.restartcho.cho1%"
	"line5=2 = %sst.lang.restartcho.cho2%"
	"line6=3 = %sst.lang.restartcho.cho3%"
	"line7=4 = %sst.lang.restartcho.cho4%"
) do set "sst.window.%%~a"
call window rem
set sst.restart=True
if "%sst.errorlevel%" equ "50" goto restartRM
if "%sst.errorlevel%" equ "51" echo.> "%sst.temp%\fastreboot.cww"
if "%sst.errorlevel%" equ "52" (
	echo.> "%sst.temp%\fastreboot.cww"
	echo.> "%sst.temp%\rebootIntoCMDMode.cww"
)
goto \restartRM
:restartRM
if "%~3" neq "/nogui" (
	for %%a in (
		"width=42"
		"height=5"
		"title=SysShivt tools %sst.ver% build %sst.build%"
		"args=/displayonly"
		"line2=%sst.lang.restartRM%"
	) do set "sst.window.%%~a"
	call window rem
)
echo.>"%sst.dir%\restartRM.txt"
echo.>"%sst.dir%\restart.txt"
goto \restartcheck
:\restartRM
if "%~3" neq "/nogui" (
	for %%a in (
		"width=42"
		"height=5"
		"title=SysShivt tools %sst.ver% build %sst.build%"
		"args=/displayonly"
		"line2=%sst.lang.restart%"
	) do set "sst.window.%%~a"
	call window rem
)
echo.>"%sst.dir%\restart.txt"
:\restartcheck
if "%sst.shutdown.restart%" neq "True" goto shutdown
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[91mPOWERMGR[0m[2m] [0m[1mSysShivt tools is restarting. . . >> "%sst.dir%\log.txt"
goto restart
:shutdown
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[91mPOWERMGR[0m[2m] [0m[1mSysShivt tools is shutting down. . . >> "%sst.dir%\log.txt"
if "%~1" neq "/nogui" (
	for %%a in (
		"width=42"
		"height=5"
		"title=SysShivt tools %sst.ver% build %sst.build%"
		"args=/displayonly"
		"line2=%sst.lang.shutdown%"
	) do set "sst.window.%%~a"
	call window rem
)
:restart
if exist "%sst.dir%\crashed.txt" del "%sst.dir%\crashed.txt"
if exist "%sst.dir%\crash.txt" del "%sst.dir%\crash.txt"
echo.> "%sst.dir%\shutdown.txt"
exit 0
:exit