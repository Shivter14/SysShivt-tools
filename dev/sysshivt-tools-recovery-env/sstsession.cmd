@echo off
setlocal enabledelayedexpansion
set sst.sessionchck=0
for %%a in ("dir" "temp" "cd" "sdir") do if not defined sst.%%~a (
	echo.	Variable sst.%%~a is not defined.
	set /a sst.sessionchck=!sst.sessionchck!+1
)
if %sst.sessionchck% gtr 0 (
	echo.Invalid kernel. Press any key to exit. . .
	pause>nul
	exit /b
)
set sst.marg=%~2
if "%~1" neq "/f" if "%~2" neq "/f" if "%~3" neq "/f" if exist temp\breakatstartup.cww exit
set sst.ver=3.1.k
set sst.build=1817
set sst.builddate=Unknown
set sst.subvinfo=[Unknown service pack]
set sst.dir=%cd%
set sst.noguiboot=True
set sst.pe=True
if exist "%sst.dir%\logoff.txt" set sst.state.logoff=True
if exist "%sst.dir%\logoff.txt" del "%sst.dir%\logoff.txt"
if exist "%sst.dir%\restart.txt" del "%sst.dir%\restart.txt"
if exist "%sst.dir%\restartRM.txt" del "%sst.dir%\restartRM.txt"
if not exist "settings.cwt" set sst.safemode=True
set sst.logsonstartup=True
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\0]"') do set "sst.defaultresX=%%~a"
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\1]"') do set "sst.defaultresY=%%~a"
for /f "delims== tokens=1" %%a in ("%sst.marg%") do if "%%~a" neq "/res" goto \arg.res
for /f "delims== tokens=2" %%a in ("%sst.marg%") do set sst.defaultres=%%~a
for /f "delims=, tokens=2" %%a in ("%sst.defaultres%") do set "sst.defaultresY=%%~a"
for /f "delims=, tokens=1" %%a in ("%sst.defaultres%") do set "sst.defaultresX=%%~a"
:\arg.res
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[0\0]"') do set "sst.ver=%%~a"
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[0\1]"') do set "sst.build=%%~a"
for /f "tokens=2*" %%a in ('type settings.cwt ^| find "[0\2]"') do set "sst.builddate=%%~b"
for /f "tokens=2*" %%a in ('type settings.cwt ^| find "[0\3]"') do set "sst.subvinfo=%%~b"
:skipver
echo.SysShivt tools version %sst.ver% build %sst.build% %sst.subvinfo%
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set "sst.crrresY=%%~a"
for /f "tokens=2" %%a in ('mode con ^| find "Columns:"') do set "sst.crrresX=%%~a"
set sst.defaultres=%sst.crrresX%,%sst.crrresY%
set sst.maxresX=128
set sst.maxresY=32
set sst.screensize.max=65536
call setres /loadsettings
call cmdwiz showcursor 0
set /a sst.startup.packX=%sst.crrresX%*3/4-16
set /a sst.startup.packX=%sst.startup.packX%
set /a sst.startup.packY=%sst.crrresY%/2-3
path=%sst.dir%\systemapps;%path%
set sst.state.logoff=False
set sst.userprofile=%sst.dir%\nullprofile
for %%a in ("TIcolor=8" "FGcolor=0" "BGcolor=7" "TTcolor=f") do set "sst.window.%%~a"
for %%a in ("tbbgcolor=7" "tbfgcolor=0x70" "tbbtcolor=0x0f" "tbbacolor=0x06") do set "sst.startmenu.%%~a"
set sst.wallpaper.name=default
set sst.rgbspeed=0
set sst.fullscreenoptimalization=False
set sftm.[]=VOLUME
call sftm /mkdir "" sst.dir /s
set sftm.[/sst.dir]=VOLUME
call sftm /mkdir /sst.dir assets /s
call sftm /mkdir /sst.dir/assets icons /s
:skipthemes
set sst.lang.path=default.cww
for /f "delims=" %%a in ('type "lang\default.cww"') do set "sst.lang.%%~a"
if exist shutdown.txt del shutdown.txt
if exist crashed.txt del crashed.txt
:skipservices
call cmdwiz showcursor 1 25
set sst.userprofile=%sst.dir%\nullprofile
cd "%sst.dir%"
call setup.cmd