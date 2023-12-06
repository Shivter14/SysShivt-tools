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
if "%sst.defaultres%" neq "96,24" (
	mode 96,24
	call setres
)
call cmdwiz showcursor 0
for %%a in ("boxX=24" "boxY=6" "height=11" "title=SysShivt tools %sst.ver%" "args=/displayonly" "line7=  Welcome to the SysShivt tools installer." "line8=  Press Y to continue, X to exit, or press  " "line9=          R to repair this device.          ") do set sst.window.%%~a
call window.cmd rem
call mti assets\pack.mti 39 8
call getinput
set sst.errorlevel=%errorlevel%
for %%a in ("C" "D" "E" "F" "G" "H" "I" "J") do (
	if not defined ssvm.%%~a.BOOT set ssvm.%%~a.BOOT=[Empty]
	for /f "tokens=2 delims==" %%b in ('set ssvm.%%~a.BOOT') do if "%%~b" equ " " set ssvm.%%~a.BOOT=[Empty]
)
if "%sst.errorlevel%" equ "120" call shutdown /restart 1
if "%sst.errorlevel%" equ "114" goto recovery
if "%sst.errorlevel%" neq "121" goto main
goto \recovery
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
		xcopy "%sst.dir%\boot" "%sst.root%\%%~b\*" /Q /Y > nul
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
call setres
goto main
:\recovery
if not defined ssvm.ver goto fail.ssvm
goto \fail.ssvm
:fail.ssvm
set sst.window.title=SysShivt tools Setup - Error
set sst.window.args=/keystroke
set sst.window.line2=Failed to begin the instalation:
set sst.window.line3=  System is not running in SSVM mode
call window.cmd rem
call shutdown
:\fail.ssvm
for %%a in (
	"height=15"
	"title=[C/D/E/F/G/H/I/J = choice] [X = Exit]"
	"args=/getinput"
	"line2=Select a drive to install SysShivt tools to:"
	"line3=Letter  Drive info"
	"line4=   C:   %ssvm.C.BOOT:~0,32%"
	"line5=   D:   %ssvm.D.BOOT:~0,32%"
	"line6=   E:   %ssvm.E.BOOT:~0,32%"
	"line7=   F:   %ssvm.F.BOOT:~0,32%"
	"line8=   G:   %ssvm.G.BOOT:~0,32%"
	"line9=   H:   %ssvm.H.BOOT:~0,32%"
	"line10=   I:   %ssvm.I.BOOT:~0,32%"
	"line11=   J:   %ssvm.J.BOOT:~0,32%"
	"line12=Make sure the drive selected is empty!"
) do set sst.window.%%~a
call window rem
call setres
if "%sst.errorlevel%" equ "X" goto main
if "%sst.errorlevel%" equ "x" goto main
for %%a in ("C" "D" "E" "F" "G" "H" "I" "J") do if "%sst.errorlevel%" equ "%%~a" set sst.ins.letter=%%~a
if not defined sst.ins.letter goto \fail.ssvm
set sst.ins.dir=sysshivt-tools
for %%a in ("height=9" "title=Installation options" "args=/keystroke" "line2=Options:" "line4=1: Change the system directory" "line7=Press any other key to continue. . .") do set sst.window.%%~a
call window rem
if "%sst.errorlevel%" neq "49" goto \changedir
for %%a in ("width=32" "height=9" "title=Installation options" "args=/getinput" "line2=Enter a new name for the" "line3=system directory." "line4=Current name:" "line5=%sst.ins.dir%") do set sst.window.%%~a
call window rem
set sst.ins.dir=%sst.errorlevel%
:\changedir
if exist "%sst.root%\%sst.ins.letter%\%sst.ins.dir%" (
	for %%a in ("height=9" "title=SysShivt tools %sst.ver%" "line2=Failed to begin the installation:" "line4=Drive %sst.ins.letter%: has a system already installed in:" "line5=%sst.ins.dir%" "line6=Try changing the system directory, or" "line7=selecting a diffrent drive.") do set sst.window.%%~a
	call window rem
	call setres
	goto main
)
if not exist "%sst.root%\%sst.ins.letter%" md "%sst.root%\%sst.ins.letter%"
set sst.ins.window="title=SysShivt tools %sst.ver%" "args=/displayonly" "line2=Installing SysShivt tools %sst.ver%"
for %%a in (%sst.ins.window% "line5=> Copying system files" "line6=  Copying additional files" "line7=  Creating booting files") do set "sst.window.%%~a"
call window rem
xcopy "%sst.dir%" "%sst.root%\%sst.ins.letter%\%sst.ins.dir%\*" /Q > nul
for %%a in (
	"core"
	"assets"
	"lang"
	"screensaver"
	"systemapps"
	"wallpapers"
	"packages"
	"boot"
) do (
	for %%b in (%sst.ins.window% "line5=  Copying system files" "line6=> Copying additional files: %%~a" "line7=  Creating booting files") do set "sst.window.%%~b"
	call window rem
	xcopy "%sst.dir%\%%~a" "%sst.root%\%sst.ins.letter%\%sst.ins.dir%\%%~a\*" /Y /E /Q > nul
)
for %%a in (%sst.ins.window% "line5=  Copying system files" "line6=  Copying additional files" "line7=> Creating booting files") do set "sst.window.%%~a"
call window rem
xcopy "%sst.dir%\boot" "%sst.root%\%sst.ins.letter%\*" /Q /Y > nul
del "%sst.root%\%sst.ins.letter%\%sst.ins.dir%\assets\programs.cwt"
type "%sst.root%\%sst.ins.letter%\%sst.ins.dir%\assets\defaultprograms.cwt" >> "%sst.root%\%sst.ins.letter%\%sst.ins.dir%\assets\programs.cwt"
echo.> "%sst.root%\%sst.ins.letter%\%sst.ins.dir%\shutdown.txt"
echo.> "%sst.root%\%sst.ins.letter%\%sst.ins.dir%\firstboot.cww"
if not exist "%sst.root%\%sst.ins.letter%\boot.cwt" (
	echo.[0] bootlist key False> "%sst.root%\%sst.ins.letter%\boot.cwt"
)
set sst.counter=0
for /f "" %%a in ('type "%sst.root%\%sst.ins.letter%\boot.cwt"') do set /a sst.counter+=1
echo.[0\%sst.counter%] sstools.cmd SysShivt-tools %sst.ins.dir%>> "%sst.root%\%sst.ins.letter%\boot.cwt"
set /a sst.counter+=1
echo.[0\%sst.counter%] sstpe.cmd SysShivt-tools-PE %sst.ins.dir%>> "%sst.root%\%sst.ins.letter%\boot.cwt"
for %%a in ("title=Reboot reqired" "args=/displayonly" "line2=To continue installing SysShivt tools," "line3=restarting this device is reqired." "line5=The system will restart in" "line6=10 seconds. . .") do set sst.window.%%~a
call window rem
call cmdwiz delay 10000
call shutdown /restart 1
:exit
setres
goto main
:end