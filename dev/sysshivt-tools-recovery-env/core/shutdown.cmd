@echo off
set sst.shutdown.help=
if "%~1" equ "/?" set sst.shutdown.help=True
if "%~1" equ "-?" set sst.shutdown.help=True
if "%~1" equ "-help" set sst.shutdown.help=True
if "%~1" equ "/help" set sst.shutdown.help=True
if defined sst.shutdown.help goto exit
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
	call cmdwiz showcursor 1 25
	call setres /d
	del "%sst.temp%\login.cww"
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
rem if "%~2" neq "/nogui" if "%~2" neq "-nogui" call loading.cmd "%sst.lang.logoff%" 0 8
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
	goto restartcheck
)
goto \restartcheck
:restartcheck
set sst.window.title=%sst.lang.restartcho.title%
set sst.window.args=/keystroke
set sst.window.line2=%sst.lang.restartcho.info%
set sst.window.line4=1 = %sst.lang.restartcho.cho1%
set sst.window.line5=2 = %sst.lang.restartcho.cho2%
set sst.window.line6=3 = %sst.lang.restartcho.cho3%
call window rem
set sst.restart=True
if "%sst.errorlevel%" equ "50" goto restartRM
if "%sst.errorlevel%" equ "51" echo.> "%sst.temp%\fastreboot.cww"
goto \restartRM
:restartRM
if "%~3" neq "/nogui" call loading.cmd "%sst.lang.restartRM%" 0 8
echo.>"%sst.dir%\restartRM.txt"
echo.>"%sst.dir%\restart.txt"
goto \restartcheck
:\restartRM
if "%~3" neq "/nogui" call loading.cmd "%sst.lang.restart%" 0 8
echo.>"%sst.dir%\restart.txt"
:\restartcheck
if exist "%sst.dir%\crashed.txt" del "%sst.dir%\crashed.txt"
if exist "%sst.dir%\crash.txt" del "%sst.dir%\crash.txt"
echo.> "%sst.dir%\shutdown.txt"
exit 0
:exit