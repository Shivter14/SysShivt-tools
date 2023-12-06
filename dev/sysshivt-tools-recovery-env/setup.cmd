@echo off
if not defined sst.build (
	echo.This program reqires to be run in SysShivt tools 3
	echo.Pre-installation Enviroment! Press any key to exit. . .
	pause>nul
	goto end
)
if not defined sst.pe (
	for %%a in ("width=42" "height=5" "title=Failed to launch this program" "line1=This program reqires to be run in" "line2=SysShivt tools 3.1.4 Pre-installation" "line3=environment.") do set "sst.window.%%~a"
	call window rem
	goto end
)
:main
if "%sst.defaultres%" neq "96,24" mode 96,24
for %%a in ("C" "D" "E" "F" "G" "H" "I" "J") do (
	if not defined ssvm.%%~a.BOOT set ssvm.%%~a.BOOT=[Empty]
	for /f "tokens=2 delims==" %%b in ('set ssvm.%%~a.BOOT') do if "%%~b" equ " " set ssvm.%%~a.BOOT=[Empty]
)
:recovery
call setres
for %%a in (
	"width=60"
	"height=11"
	"title=SysShivt tools recovery"
	"args=/keystroke"
	"line2=Pick a task:"
	"line4=1: Repair the boot menu of a SysShivt tools installation"
	"line5=2: Open file explorer [in the current drive]"
	"line6=3: Open the settings.cwt file of this instalation"
	"line7=4: Open command prompt [in the current drive]"
	"line9=ESC: Exit"
) do set sst.window.%%~a
call window rem
if "%sst.errorlevel%" equ "49" (
	for %%a in (
		"title=[C/D/E/F/G/H/I/J] = choice"
		"args=/getinput"
		"line1=Select a drive to repair:"
		"line2=Letter  Drive info"
		"line3=   C:   %ssvm.C.BOOT:~0,32%"
		"line4=   D:   %ssvm.D.BOOT:~0,32%"
		"line5=   E:   %ssvm.E.BOOT:~0,32%"
		"line6=   F:   %ssvm.F.BOOT:~0,32%"
		"line7=   G:   %ssvm.G.BOOT:~0,32%"
		"line8=   H:   %ssvm.H.BOOT:~0,32%"
		"line9=   I:   %ssvm.I.BOOT:~0,32%"
		"line10=   J:   %ssvm.J.BOOT:~0,32%"
	) do set sst.window.%%~a
	call window rem
	for /f "tokens=2 delims==" %%a in ('set sst.errorlevel') do for %%b in ("C" "D" "E" "F" "G" "H" "I" "J") do if "%%~a" equ "%%~b" (
		xcopy "%sst.dir%\boot" "%sst.root%\..\..\..\..\%%~b\*" /Q /Y > nul
		for %%c in ("width=30" "height=4" "title=SysShivt tools recovery" "line1=The boot menu of drive %%~b" "line2=was repaired successfully.") do set sst.window.%%~c
		call window rem
	)
)
if "%sst.errorlevel%" equ "50" call fdcexplorer.cmd
if "%sst.errorlevel%" equ "51" (
	if exist "%sst.dir%\settings.cwt" (
		call cwt.cmd "%sst.dir%\settings.cwt"
	) else (
		for %%a in ("height=5" "title=SysShivt tools recovery" "line2=File settings.cwt was not found." "line3=File settings.cww will be displayed instead.") do set sst.window.%%~a
		call window rem
		call cwt.cmd "%sst.dir%\settings.cww"
	)
)
if "%sst.errorlevel%" equ "52" (
	set ls.username=SSTInsProfile
	set sst.userrprofile=%sst.dir%\nullprofile
	call setres /d
	color 0f
	if exist "%sst.dir%\settings.cwt" (
		call sysver
		call shell.cmd
	) else (
		echo.Failed to vertify this session. Any environment variable changes
		echo.made will not remain after exitting this shell.
		echo.
		call sysver
		cmd /c shell.cmd
	)
	set ls.username=
)
if "%sst.errorlevel%" neq "27" (
	call setres
	goto recovery
)
call shutdown.cmd
:end