@echo off
if "%~1" equ "/getadmin" (
	call :getadmin /getadmin
	exit /b
)
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
if "%~1" equ "/login" goto login
if "%~1" equ "/session" (
	set sst.session=%~2
	goto sstsession
)
if "%~1" equ "/pe" set sst.pe=True
set sst.marg=%~2
if "%~1" neq "/f" if "%~2" neq "/f" if "%~3" neq "/f" if exist temp\breakatstartup.cww exit
set sst.ver=3.2.k
set sst.build=2327
set sst.builddate=Unknown
set sst.subvinfo=Safe Mode
set sst.ultrafastboot=
set sst.dir=%cd%
set sst.logsonstartup=True
set sst.legacylogsonstartup=False
if "%~1" equ "/safemode" set sst.safemode=True
if exist "%sst.dir%\logoff.txt" set sst.state.logoff=True
if exist "%sst.dir%\logoff.txt" del "%sst.dir%\logoff.txt"
if exist "%sst.dir%\restart.txt" del "%sst.dir%\restart.txt"
if exist "%sst.dir%\restartRM.txt" del "%sst.dir%\restartRM.txt"
if not exist "settings.cwt" set sst.safemode=True
if "%sst.safemode%" equ "True" (
	set sst.defaultresX=96
	set sst.defaultresY=24
	goto skipver
)
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\0]"') do set "sst.defaultresX=%%~a"
for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\1]"') do set "sst.defaultresY=%%~a"
if "%sst.pe%" neq "True" (
	for /f "tokens=3" %%a in ('type settings.cwt ^| find "[2\3] logsonstartup"') do set "sst.logsonstartup=%%~a"
	for /f "tokens=3" %%a in ('type settings.cwt ^| find "[2\4] legacylogsonstartup"') do set "sst.legacylogsonstartup=%%~a"
) else set sst.logsonstartup=True
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
if "%sst.noguiboot%" equ "True" goto NoModeChanging
set sst.defaultres=%sst.defaultresX%,%sst.defaultresY%
mode %sst.defaultres%
cls
:NoModeChanging
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set "sst.crrresY=%%~a"
for /f "tokens=2" %%a in ('mode con ^| find "Columns:"') do set "sst.crrresX=%%~a"
set sst.defaultres=%sst.crrresX%,%sst.crrresY%
call cmdwiz showcursor 0
goto \loadingtext
:loadingtext
for /f "delims=" %%t in ("%~1") do echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[93mSSTSESSION[0m[2m] Loading text: [0m[1m%%t>> "%sst.dir%\log.txt"
if "%sst.noguiboot%" equ "True" exit /b
if "%~2" equ "/logonly" exit /b
set sst.startup.cleartext=/c 0x9f /g %sst.startup.loadingtextX% %sst.startup.loadingtextY% /d "%sst.startup.text%"
call getlen "%~1"
set sst.startup.errorlevel=%errorlevel%
set sst.startup.text=
set /a sst.startup.loadingtextX=(%sst.crrresX%-%sst.startup.errorlevel%)/2
set /a sst.startup.loadingtextY=(%sst.crrresY%/2)+2
for /l %%a in (1 1 %sst.startup.errorlevel%) do set sst.startup.text=!sst.startup.text! 
call batbox /c 0x9f %sst.startup.cleartext% /g %sst.startup.loadingtextX% %sst.startup.loadingtextY% /d "%~1"
exit /b
:\loadingtext
set sst.systext.line=0
set /a sst.systext.width=%sst.crrresX%-10
set sst.systext.blank=
for /l %%a in (1 1 %sst.systext.width%) do set "sst.systext.blank=!sst.systext.blank! "
set /a sst.systext.max=%sst.defaultresY%-6
goto \safetext
:safetext
for /f "delims=" %%t in ("%~1") do echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[93mSSTSESSION[0m[2m] Loading text: [0m[1m%%t>> "%sst.dir%\log.txt"
if "%sst.noguiboot%" equ "True" exit /b
if "%~2" equ "/logonly" exit /b
if "%sst.legacylogsonstartup%" equ "True" (
	echo.%~1
	exit /b
)
if "%~2" equ "/quickline" (
	set sst.systext.lastquick=True
	call batbox /c 0x9f /g 6 %sst.systext.Y% /d "%sst.systext.blank%" /g 6 %sst.systext.Y% /d "%~1"
	exit /b
)
if defined sst.systext.lastquick (
	call batbox /c 0x9f /g 6 %sst.systext.Y% /d "%sst.systext.blank%"
	set /a sst.systext.line=%sst.systext.line%-1
)
set sst.systext.lastquick=
set /a sst.systext.Y=3+%sst.systext.line%
set "sst.systext.line[%sst.systext.line%]=%~1"
set /a sst.systext.line[%sst.systext.line%].len=0
set /a sst.systext.line=%sst.systext.line%+1
if %sst.systext.line% gtr %sst.systext.max% (
	set sst.systext.line=%sst.systext.max%
	for /l %%a in (1 1 %sst.systext.max%) do (
		set /a sst.systext.blfT=%%a-1
		for /f "tokens=2 delims==" %%b in ('set sst.systext.line[!sst.systext.blfT!]') do set "sst.systext.line[!sst.systext.blfT!]=!sst.systext.line[%%a]!"
	)
	for /l %%a in (0 1 %sst.systext.max%) do if "%%~a" neq "%sst.systext.max%" (
		set /a sst.systext.bflY=3+%%a
		call batbox /c 0x99 /g 6 !sst.systext.bflY! /d "%sst.systext.blank%" /c 0x9f /g 6 !sst.systext.bflY! /d "!sst.systext.line[%%a]!"
	)
) else call batbox /c 0x9f /g 6 %sst.systext.Y% /d "%~1"
exit /b
:\safetext
if "%sst.safemode%" neq "True" (
	for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\2]"') do set "sst.maxresX=%%~a"
	for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\3]"') do set "sst.maxresY=%%~a"
	for /f "tokens=3" %%a in ('type settings.cwt ^| find "[1\6]"') do set "sst.screensize.max=%%~a"
)
if not defined sst.maxresX set sst.maxresX=128
if not defined sst.maxresY set sst.maxresY=32
if not defined sst.screensize.max set sst.screensize.max=65536
if "%sst.noguiboot%" equ "True" (
	call setres /loadsettings
) else if "%sst.legacylogsonstartup%" neq "True" (
	call setres /d
	call sbox.cmd 4 2 "%sst.defaultresX%-8" "%sst.defaultresY%-5" 9f
) else call setres /d
call cmdwiz showcursor 0
set /a sst.startup.packX=(%sst.crrresX%/2)-8
set /a sst.startup.packY=(%sst.crrresY%/2)-4
if "%sst.logsonstartup%" equ "True" (
	for %%a in (
		"=================================="
		"  SysShivt tools %sst.ver% build %sst.build% [%sst.subvinfo%]"
	) do call :safetext "%%~a"
	if "%~1" equ "/safemode" (
		call :safetext "  "
		call :safetext "       ===  SAFE  MODE  ==="
	)
	call :safetext "=================================="
	goto NoPack
)
if "%sst.noguiboot%" equ "True" goto NoPack
call mti assets\pack.mti %sst.startup.packX% %sst.startup.packY%
call batbox /g 0 0
:NoPack
if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase2] Loading settings") else (call :loadingtext "Loading settings")
path=%sst.dir%\systemapps;%path%
set sst.state.logoff=False
set sst.userprofile=%sst.dir%\nullprofile
for %%a in ("TIcolor=8" "FGcolor=0" "BGcolor=7" "TTcolor=f") do set "sst.window.%%~a"
for %%a in ("tbbgcolor=7" "tbfgcolor=0x70" "tbbtcolor=0x0f" "tbbacolor=0x06") do set "sst.startmenu.%%~a"
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[1\4]"') do set sst.desktop.tileW=%%a
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[1\5]"') do set sst.desktop.tileH=%%a
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[1\6]"') do set sst.wallpaper.name=%%a
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[2\4]"') do set sst.desktop.showicons=%%a
set sst.wallpaper.name=default
set sst.rgbspeed=0
set sst.bgdelay=3000
set sst.debugonstartup=False
set sst.fullscreenoptimalization=False
if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase3] Loading system files") else (call :loadingtext "Loading system files")
set sftm.[]=VOLUME
call sftm /mkdir "" sst.dir /s
set sftm.[/sst.dir]=VOLUME
call sftm /mkdir /sst.dir assets /s
call sftm /mkdir /sst.dir/assets icons /s
call sftm /store "%sst.dir%\assets\versionlist.cwt" /sst.dir/assets versionlist.cwt /f /s
echo.== SysShivt tools kernel features ==> "%sst.temp%\kernelfeatures.cww"
for %%a in (%sst.krnlfeatures%) do echo.%%~a >> "%sst.temp%\kernelfeatures.cww"
call sftm /store "%sst.temp%\kernelfeatures.cww" /sst.dir kernelfeatures.cww /f /s
del "%sst.temp%\kernelfeatures.cww" > nul
call sftm /store "%sst.dir%\assets\pack.mti" /sst.dir/assets pack.mti /f /s
if defined sst.ultrafastboot goto skipsettings
if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase3] Loading file icons") else call :loadingtext "Loading file icons"
set sst.startup.counter=0
for /f "delims=" %%a in ('dir /b "%sst.dir%\assets\icons"') do (
	set /a sst.startup.counter=!sst.startup.counter!+1
	if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase3] Loading file icon: %%~a" /quickline) else call :loadingtext "Loading file icon: %%~a" /logonly
	call sftm /store "%sst.dir%\assets\icons\%%~a" "/sst.dir/assets/icons" "%%~a" /f /s
)
if "%sst.logsonstartup%" equ "True" call :safetext "[Phase4] Loaded %sst.startup.counter% file icons."
if defined sst.safemode goto skipsettings
if defined sst.pe goto skipsettings
if not exist "%sst.dir%\settings.cwt" goto skipsettings
if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4] Loading theme settings") else call :loadingtext "Loading theme settings"
for /f "tokens=1,2,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] ThemesSettings"') do if "%%~c" equ "key" if "%%~b" equ "ThemesSettings" set "sst.window.cwtroot=%%~a"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowticolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.TIcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowfgcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.FGcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowbgcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.BGcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowttcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.TTcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowtxcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.TXcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] taskbarbgcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.startmenu.tbbgcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] taskbarfgcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.startmenu.tbfgcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] taskbarbtcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.startmenu.tbbtcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] taskbarbacolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.startmenu.tbbacolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowticolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.TIcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowfgcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.FGcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowbgcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.BGcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] windowttcolor "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.window.TTcolor=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] blackbgonsysscene "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.window.cwtroot:~0,-1%" set "sst.theme.blackbgonsysscene=%%~b"
:skipthemes
if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4] Loading custom settings") else call :loadingtext "Loading custom settings"
for /f "tokens=1,2,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "] SystemSettings"') do if "%%~c" equ "key" if "%%~b" equ "SystemSettings" set "sst.cwtroot=%%~a"
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "fullscreenoptimalization"') do set "sst.fullscreenoptimalization=%%~a"
for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "[1\8]"') do set "sst.wallpaper.name=%%~a"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find " rgbspeed "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.cwtroot:~0,-1%" set "sst.rgbspeed=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find " debugonstartup "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.cwtroot:~0,-1%" set "sst.debugonstartup=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find " enableCodePages "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.cwtroot:~0,-1%" set "sst.enablecodepages=%%~b"
for /f "tokens=1,3" %%a in ('type "%sst.dir%\settings.cwt" ^| find " bgdelay "') do for /f "tokens=1 delims=\" %%c in ("%%~a") do if "%%~c" equ "%sst.cwtroot:~0,-1%" set "sst.bgdelay=%%~b"
if "%sst.debugonstartup%" equ "True" (
	call setres /d
	call cmdwiz showcursor 1 25
	call shell.cmd
	call setres /d
	if "%sst.noguiboot%" neq "True" call sbox.cmd 4 2 "%sst.defaultresX%-8" "%sst.defaultresY%-5" 9f
	call cmdwiz showcursor 0
)
:skipsettings
set sst.lang.path=default.cww
for /f "delims=" %%a in ('type lang.txt') do set "sst.%%~a"
if "%sst.state.logoff%" equ "False" (
	echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[93mSSTSESSION[0m[2m] [0m[1mStarting SysShivt tools version %sst.ver% build %sst.build%. . . >> "%sst.dir%\log.txt"
)
title SysShivt tools %sst.ver% build %sst.build%
if "%sst.logsonstartup%" equ "True" call :safetext "[Phase4] Loading language file"
for /f "delims=" %%a in ('type "lang\default.cww"') do set "sst.lang.%%~a"
if "%sst.safemode%" equ "True" goto skiplang
if "%sst.lang.path%" equ "default.cww" goto skiplang
if not exist "lang\%sst.lang.path%" goto skiplang
for /f "delims=" %%a in ('type "lang\%sst.lang.path%"') do set "sst.lang.%%~a"
:skiplang
if defined sst.pe goto skipmsf
if defined sst.ultrafastboot goto skipmsf
if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4] Checking for missing files") else call :loadingtext "Checking for missing files"
if not exist "%sst.dir%\assets\filelist.cww" goto msf
for /f "delims=" %%a in ('type "assets\filelist.cww"') do (
	if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4] Checking file: %%~a" /quickline) else call :loadingtext "Checking file: %%~a" /logonly
	call cmdwiz delay 0
	if not exist "%%~a" call :msf "%%~a"
)
if "%sst.logsonstartup%" equ "True" call :safetext "[Phase4] Passed checking for missing files."
if not defined sst.pe if not exist "%sst.dir%\programs" if exist "%sst.dir%\packages" (
	if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4/OOBE] Installing packages") else call :loadingtext "Installing packages"
	for /f "delims=" %%a in ('dir /b "%sst.dir%\packages"') do (
		if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4/OOBE-SSP] Installing package: %%~a") else call :loadingtext "Installing package: %%~a"
		call batbox /g 0 0
		call ssp "%sst.dir%\packages\%%~a"
	)
) else if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4/OOBE] Failed to install packages: folder not found") else call :loadingtext "Failed to install packages"
:skipmsf
if exist shutdown.txt del shutdown.txt
if exist crashed.txt del crashed.txt
if exist "%sst.temp%\sessionexit.cww" del "%sst.temp%\sessionexit.cww"
if exist "%sst.temp%\login.cww" del "%sst.temp%\login.cww"
if exist "%sst.temp%\switchusr.cww" del "%sst.temp%\switchusr.cww"
if not defined sst.pe if "%sst.safemode%" equ "True" (
	set sst.shell.safekey=
	if exist "%sst.dir%\settings.cwt" (
		for /f "tokens=3" %%a in ('type "%sst.dir%\settings.cwt" ^| find "antishellmode"') do (
			if "%%~a" equ "True" (
				call setres /loadsettings
				if "%sst.theme.blackbgonsysscene%" equ "True" (
					color 0f
					cls
				) else for /l %%a in (0 4 512) do (
					set /a sst.rgbw=%%a/5-1
					call :rgbw
				)
				for %%a in ("title=Access Denied" "args=/keystroke" "height=6" "line2=Safe Mode is disabled on this device." "line4=Press any key to reboot. . .") do set sst.window.%%~a
				call window rem
				for /l %%a in (101 -1 -%sst.defaultresY%) do (
					set /a sst.rgbw=%%a
					call :rgbw
				)
				call shutdown.cmd /restart 1 /nogui
			)
			set sst.shell.safekey=True
		)
	) else (
		call setres /d
		color 9f
		call batbox /g 28 3 /d "System encountered an error and" /g 28 4 /d "had to be shut down to prevent" /g 28 5 /d "damage to this device." /g 4 9 /d "Missing file: ~:!sst.dir:~%sst.sdir%,24!\settings.cwt" /g 4 11 /d "Press any key to enter emergency options. . ."
		call mti assets\bsod.mti 4 2
		pause>nul
		call shutdown /restart 2
	)
	if not defined sst.shell.safekey exit 255
	goto safemode
)
if "%sst.logsonstartup%" equ "True" (call :safetext "[Phase4] Startup finished.") else (call :loadingtext "Welcome.")
if "%sst.state.logoff%" equ "True" goto skipservices
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[93mSSTSESSION[0m[2m] [0m[1mStarting services. . . >> "%sst.dir%\log.txt"
if exist temp\sstools_bl.cmd del temp\sstools_bl.cmd
echo.@call sstools_b.cmd > temp\sstools_bl.cmd
start /b /low cmd /c call temp\sstools_bl.cmd
:skipservices
call cmdwiz showcursor 1 25
set sst.userprofile=%sst.dir%\nullprofile
call setres /loadsettings
goto \rgbp
:rgbw
echo.[48;2;%sst.rgbw%;%sst.rgbw%;%sst.rgbw%m
exit /b
:rgbp
echo.[48;2;%~1;%~2;%~3m%~4
exit /b
:\rgbp
if not defined sst.cd exit /b
call batbox /g 0 %sst.defaultresY%
if "%sst.theme.blackbgonsysscene%" equ "True" (
	color 0f
	cls
) else for /l %%a in (0 1 %sst.defaultresY%) do (
	set /a sst.rgbw=%%a*30/%sst.defaultresY%
	set /a sst.rgbx=%%a*15/%sst.defaultresY%
	set /a sst.rgbw=!sst.rgbw!+96
	set /a sst.rgbx=!sst.rgbx!+48
	echo.[48;2;0;!sst.rgbx!;!sst.rgbw!m
)
if defined sst.pe (
	cd "%sst.dir%"
	call setup.cmd
	goto aftersession
)
if not exist "%sst.cd%\users" md "%sst.cd%\users"
cd "%sst.cd%\users"
if not exist "%sst.cd%\users\administrator" goto oobe
if not exist "%sst.cd%\users\default" goto oobe
set sst.errorlevel=default
for /f "tokens=3* delims=." %%a in ('set sst.lang.login.') do set "sst.window.%%~b"
set sst.window.args=/getinput
call window
set sst.userlogin=%sst.errorlevel%
if not defined sst.userlogin set sst.userlogin=default
if "%sst.errorlevel%" equ "/po" goto poweroptions
goto \poweroptions
:oobe
if exist "%sst.cd%\users\default" goto oobe.adminsetup
if %sst.crrresX% lss 84 mode 96,%sst.crrresY%
if %sst.crrresY% lss 24 mode %sst.crrresX%,24
for %%a in (
	"width=54" "height=11" "title=Welcome to SysShivt tools %sst.ver%"
	"args=/buttons" "line2=Welcome to SysShivt tools."
	"line4=Before you log in for the first time, You have"
	"line5=to agree to the TOS [Terms Of Service]."
	"line7=| Use A / D to move your selection LEFT / RIGHT, |"
	"line8=| also SPACE to confirm, or just use your mouse. |"
) do set sst.window.%%~a
set sst.window.buttons="Show me the TOS" "Restart" "Shut down"
call window
if "%sst.errorlevel%" equ "1" call shutdown.cmd /restart
if "%sst.errorlevel%" equ "2" call shutdown.cmd
call txt "%sst.cd%\LICENCE.txt" 84 22
for %%a in (
	"width=84" "height=23" "title=Welcome to SysShivt tools %sst.ver%" "args=/buttons"
) do set "sst.window.%%~a"
set "sst.window.line10=                      Do you accept the terms of service?"
set sst.window.buttons="Yes, continue" "Restart" "Shutdown"
call window
if "%sst.errorlevel%" equ "1" call shutdown.cmd /restart
if "%sst.errorlevel%" equ "2" call shutdown.cmd
md "%sst.cd%\users\default"
:oobe.adminsetup
call setres /loadsettings
call batbox /g 0 %sst.defaultresY%
for /l %%a in (0 1 %sst.defaultresY%) do (
	set /a sst.rgbw=%%a*30/%sst.defaultresY%
	set /a sst.rgbx=%%a*15/%sst.defaultresY%
	set /a sst.rgbw=!sst.rgbw!+96
	set /a sst.rgbx=!sst.rgbx!+48
	echo.[48;2;0;!sst.rgbx!;!sst.rgbw!m
)
for %%a in (
	"title=Set up an administrator account"
	"args=/getinput"
	"line2=It is now time to set up an"
	"line3=administrator account."
	"line5=Enter a new memorable password."
	"line6=* And dont forget it *"
) do set "sst.window.%%~a"
call window
set sst.oobe.password=%sst.errorlevel%
for %%a in (
	"title=Set up an administrator account"
	"args=/getinput"
	"line8=Repeat the password to continue."
) do set "sst.window.%%~a"
call window
if "%sst.oobe.password%" neq "%sst.errorlevel%" (
	for %%a in ("width=36" "height=7" "args=/buttons" "line2=The passwords are not matching."
	) do set "sst.window.%%~a"
	set sst.window.buttons="Retry" "Cancel"
	call window
	for /f "tokens=1,2 delims==" %%a in ('set sst.errorlevel') do if "%%~a" equ "sst.errorlevel" if "%%~b" equ "1" (
		for %%c in ("width=36" "height=7" "args=/buttons"
			"line2=The administrator account was" "line3=created unsuccessfully."
		) do set "sst.window.%%~c"
		set sst.window.buttons="OK"
		call window
		goto oobe
	)
	goto oobe.adminsetup
)
mkdir "%sst.cd%\users\Administrator"
echo.%sst.oobe.password%> "%sst.cd%\users\Administrator\admin"
for %%c in ("args=/buttons" "line2=The administrator account was" "line3=created successfully."
) do set "sst.window.%%~c"
set sst.window.buttons="OK" "Log into the admin account"
call window
if "%sst.errorlevel%" equ "1" (set sst.userlogin=Administrator
) else set sst.userlogin=default
goto \poweroptions
:poweroptions
cd "%sst.dir%"
set /a sst.window.boxY=%sst.defaultresY%-10
for %%a in ("height=9" "title=Power Options" "args=/buttons" "buttonsmode=list" "buttonsspacing=1") do set "sst.window.%%~a"
set sst.window.buttons="%sst.lang.poweroptions.o1%" "%sst.lang.restartcho.cho1%" "%sst.lang.restartcho.cho2%" "%sst.lang.restartcho.cho3%" "%sst.lang.restartcho.cho4%" "Cancel                                    "
call window
if "%sst.errorlevel%" equ "0" call :shutdown
if "%sst.errorlevel%" equ "1" call :shutdown /restart 1
if "%sst.errorlevel%" equ "2" call :shutdown /restart 2
if "%sst.errorlevel%" equ "3" call :shutdown /restart 3
if "%sst.errorlevel%" equ "4" call :shutdown /restart 4
if "%sst.errorlevel%" equ "5" goto skipservices
if "%sst.errorlevel%" equ "CLOSED" goto skipservices
goto poweroptions
:\poweroptions
call batbox /g 0 %sst.defaultresY%
if "%sst.theme.blackbgonsysscene%" equ "True" (
	color 0f
	cls
) else for /l %%a in (0 1 %sst.defaultresY%) do (
	set /a sst.rgbw=%%a*64/%sst.defaultresY%
	set /a sst.rgbx=%%a*32/%sst.defaultresY%
	set /a sst.rgbw=!sst.rgbw!+160
	set /a sst.rgbx=!sst.rgbx!+80
	echo.[48;2;0;!sst.rgbx!;!sst.rgbw!m
)
if "%sst.userlogin%" equ "$debug" goto debug
goto \debug
:debug
cd %sst.dir%
color 0f
cls
call cmd /c shell.cmd
goto skipservices
:\debug
if not exist "%sst.cd%\users\%sst.userlogin%" (
	for %%a in ("height=8" "title=Log in to SysShivt tools" "args=/buttons" "line2=The account specified was not found.") do set sst.window.%%~a
	set sst.window.buttons="No" "Yes"
	set sst.window.line4=Do you want to create a new account?
	call window rem
	if "!sst.errorlevel!" equ "1" (
		md "%sst.cd%\users\%sst.userlogin%"
	) else (
		for %%a in ("height=8" "title=Log in to SysShivt tools" "args=/displayonly" "line2=Logging off. . .") do set sst.window.%%~a
		call window rem
		goto skipservices
	)
)
if not exist "%sst.dir%\nullprofile" md "%sst.dir%\nullprofile"
cd "%sst.dir%\nullprofile"
cd "%sst.cd%\users\%sst.userlogin%"
set "sst.userprofile=%cd%"
set /a sst.sprofile=%sst.sdir%+7
if "!sst.userprofile:~0,%sst.sprofile%!" neq "%sst.cd%\users\" (
	for %%a in ("height=7" "title=Log in to SysShivt tools" "args=/keystroke" "line2=Something went wrong:" "line3='User directory must be located in ~:\users'" "line5=Press any key to cancel. . .") do set "sst.window.%%~a"
	call window rem
	goto skipservices
)
cd "%sst.dir%"
set sst.session.[=$debug
for /f "tokens=1* delims==" %%a in ('set sst.session.[') do if "%%~b" equ "%sst.userprofile%" (
	for %%c in (
		"width=24"
		"height=4"
		"args=/displayonly"
		"line2=Please wait. . ."
	) do set "sst.window.%%~c"
	call window rem
	echo.%%~a> "%sst.temp%\login.cww"
	goto wait
)
:setsession
call setres /loadsettings
set sst.login.session=%random%
if defined sst.session.[%sst.login.session%] goto setsession
set "sst.session.[%sst.login.session%]=%sst.userprofile%"
start /b /high %0 /login %sst.login.session%
:wait
if exist "%sst.temp%\switchusr.cww" (
	set sst.userlogin=
	for /f "delims=" %%a in ('type "%sst.temp%\switchusr.cww"') do (
		set "sst.userlogin=%%~a"
	)
	del "%sst.temp%\switchusr.cww"
	if defined sst.userlogin goto \debug
	goto skipservices
)
if exist "%sst.dir%\shutdown.txt" call :shutdown /skipsessionclosing
if exist "%sst.dir%\restart.txt" call :shutdown /skipsessionclosing
if exist "%sst.dir%\restartRM.txt" call :shutdown /skipsessionclosing
if exist "%sst.dir%\crash.txt" call :shutdown /skipsessionclosing
if exist "%sst.dir%\crashed.txt" call :shutdown /skipsessionclosing
if exist "%sst.temp%\sessionexit.cww" (
	for /f "delims=" %%a in ('type "%sst.temp%\sessionexit.cww"') do set "sst.session.[%%~a]="
	del "%sst.temp%\sessionexit.cww"
	goto skipservices
)
call cmdwiz delay %sst.bgdelay%
goto wait
:sstsession
if exist "%sst.temp%\switchusr.cww" del "%sst.temp%\switchusr.cww"
if not exist "%sst.dir%\nullprofile" md "%sst.dir%\nullprofile"
cd "%sst.dir%\nullprofile"
cd "%sst.cd%\users\%sst.userlogin%"
set sst.userprofile=%cd%
if "%sst.userprofile%" equ "%sst.cd%\users" (
	set "sst.userprofile=%sst.dir%\nullprofile"
	cd "%sst.dir%\nullprofile"
)
if "%cd%" neq "%sst.cd%\users\Administrator" goto normallogin
:getadmin
set ls.username=Administrator
for %%a in ("height=7" "title=Administrator login" "args=/getinput"
	"line2=Enter the password for the" "line3=administrator account."
) do set "sst.window.%%~a"
call window
set sst.adminpswd=
for /f "delims=" %%a in ('type "%sst.cd%\users\Administrator\admin"') do set "sst.adminpswd=%%~a"
if not defined sst.adminpswd (
	for %%a in ("height=7" "title=Administrator login" "args=/buttons" "line2=Something went wrong."
	) do set "sst.window.%%~a"
	set sst.window.buttons="Retry" "Cancel"
	call window
	for /f "tokens=1,2 delims==" %%a in ('set sst.errorlevel') do if "%%~a" equ "sst.errorlevel" if "%%~b" equ "1" if "%~1" equ "/getadmin" (
		set sst.getadmin=Fail
		exit /b 1
	) else call shutdown /logoff
	goto getadmin
)
if "%sst.errorlevel%" neq "%sst.adminpswd%" (
	for %%a in ("height=7" "title=Administrator login" "args=/buttons" "line2=Incorrect Password."
	) do set "sst.window.%%~a"
	set sst.window.buttons="Retry" "Cancel"
	call window
	for /f "tokens=1,2 delims==" %%a in ('set sst.errorlevel') do if "%%~a" equ "sst.errorlevel" if "%%~b" equ "1" if "%~1" equ "/getadmin" (
		set sst.getadmin=Fail
		exit /b 1
	) else call shutdown /logoff
	goto getadmin
)
set sst.getadmin=
if "%~1" equ "/getadmin" exit /b 0
goto completelogin
:normallogin
set ls.username=AUTHFAILED
call "%sst.dir%\login-system.cmd" "SysShivt tools %sst.ver% build %sst.build%"
cd "%sst.dir%"
if "%ls.username%" equ "AUTHFAILED" set sst.userprofile=%sst.dir%\nullprofile
if "%sst.theme.blackbgonsysscene%" equ "True" (
	call setres /d
) else call setres
set errorlevel=
:completelogin
call getlen "%ls.username%"
set /a sst.window.width=%errorlevel%+14
if %sst.window.width% lss 30 set sst.window.width=30
for %%a in ("height=6" "line2=Welcome, %ls.username%." "line4=Preparing your desktop..." "args=/displayonly") do set "sst.window.%%~a"
call window rem
title SysShivt tools %sst.ver% build %sst.build%
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[93mSSTSESSION[0m[2m] [0m[1mStartup finished. >> "%sst.dir%\log.txt"
if "%ls.username%" equ "AUTHFAILED" (
	for %%a in ("width=32" "height=5" "title=AUTHFAILED" "args=/keystroke" "line2=Authorization Failed") do set "sst.window.%%~a"
	call window rem /f
	goto aftersession
)
cd "%sst.dir%"
call preboot.cmd
rem call desktop.cmd
call sstenv.cmd
cd "%sst.dir%"
call bfshdwn.cmd
:aftersession
call setres /loadsettings
if exist "%sst.dir%\shutdown.txt" exit 0
if exist "%sst.dir%\logoff.txt" exit 0
if exist "%sst.dir%\restartRM.txt" exit 0
if exist "%sst.dir%\crash.txt" exit 0
if exist "%sst.dir%\crashed.txt" exit 0
call cursor
goto aftersession
:safemode
if "%sst.noguiboot%" neq "True" (
	color 0f
	cls
	echo.  SysShivt tools SAFE MODE ^| Sshell
	echo. type "goto skipservices" to log in.
)
call cmdwiz showcursor 1 25
setlocal enabledelayedexpansion
set shl.errorlevel=0
call :shell
cd "%sst.dir%"
call shutdown.cmd /restart 2 /nogui

rem === Modules ===
:shell
if "!cd:~0,%sst.sdir%!" neq "%sst.cd%" cd "%sst.cd%"
set shl.cmd=
set /p "shl.cmd=[104m[97m %shl.errorlevel% [0m[92m ~:!cd:~%sst.sdir%![93m>[38;5;255m "
if "%shl.cmd%" equ "exit" exit /b
if "%shl.cmd%" equ "ver" (
	echo.[93m
	echo.Sshell for SysShivt tools [version 1.2][38;2;255;255;255m
)
set errorlevel=
call %shl.cmd%
set shl.errorlevel=%errorlevel%
goto shell

:login
title SysShivt tools user session %~2
cmd /c %0 /session %~2
set sst.session.errorlevel=%errorlevel%
call setres /loadsettings
if "%sst.session.errorlevel%" neq "0" if "%sst.session.errorlevel%" neq "27" (
	for %%a in (
		"width=42"
		"height=5"
		"title=Error"
		"line1=You were logged out from your session"
		"line2=becose of an unexpected error."
		"line3=Exit code: %sst.session.errorlevel%"
	) do set sst.window.%%~a
	call window rem
)
if exist "%sst.dir%\shutdown.txt" exit
if exist "%sst.dir%\restart.txt" exit
if exist "%sst.dir%\restartRM.txt" exit
if exist "%sst.dir%\crash.txt" exit
if exist "%sst.dir%\crashed.txt" exit
for %%a in (
	"width=42"
	"height=5"
	"args=/displayonly"
	"line2= Please wait. . ."
) do set "sst.window.%%~a"
call window rem
echo.%~2> "%sst.temp%\sessionexit.cww"
exit

:shutdown
call setres
if "%~1" neq "/skipsessionclosing" (
	cmd /c shutdown.cmd %* /nogui
	if "%~1" neq "/restart" (
		for %%a in ("height=5" "title=SysShivt tools %sst.ver%" "args=/displayonly" "line2=Closing sessions. . .") do set "sst.window.%%~a"
		call window rem
		call cmdwiz delay 1536
	)
	for %%a in ("height=5" "title=SysShivt tools %sst.ver%" "args=/displayonly" "line2=SysShivt tools is shutting down. . .") do set "sst.window.%%~a"
	if "%~1" equ "/restart" set sst.window.line2=SysShivt tools is restarting. . .
	call window rem
)
exit 0

:msf
set sst.msf.file=%~1
for %%a in (
	"[FATAL] Missing file: %~1"
	" "
	"  A system file was not found,"
	"  You should reinstall SysShivt tools."
	"  "
) do call :safetext "%%~a"
if "%sst.safemode%" equ "True" (
	call :safetext "  Press any key to continue. . ."
	pause>nul
	exit /b
) else call :safetext "  Press any key to shut down. . ."
pause>nul
echo.STARTUPMSF %sst.msf.file%> "%sst.temp%\errorlevel.cww"
exit