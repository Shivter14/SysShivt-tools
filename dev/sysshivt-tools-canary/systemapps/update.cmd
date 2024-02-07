@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.2.0 or higher!
	echo.Press any key to exit. . .
	pause>nul
	exit /b
)
if not defined sst.boot.dir goto noautorun
if not defined sst.boot.kernel goto noautorun
if not exist "%sst.cd%\boot.cwt" goto noautorun
goto \noautorun
:noautorun
for %%a in (
	"width=54"
	"height=9"
	"title=SysShivt tools update / update.cmd:noautorun"
	"args=/keystroke"
	"line2=SysShivt tools has detected that you are using a"
	"line3=Third-Party bootloader, or it's broken. If you are"
	"line4=you are using a Third-Party bootloader, please"
	"line5=contact it's creator for a custom SysShivt tools"
	"line6=updater, or install a new version of SysShivt"
	"line7=tools manually. Press any key to exit. . ."
) do set "sst.window.%%~a"
call window rem
exit /b
:\noautorun
call setres /d
cd "%sst.temp%"
if exist updatetmp.cmd del updatetmp.cmd
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/update.cmd" updatetmp.cmd > nul
timeout 1 /nobreak > nul
if not exist "updatetmp.cmd" (
	timeout 1 /nobreak > nul
	echo.Error: Download failed!
	pause
	exit /b
)
timeout 1 /nobreak > nul
cd "%sst.dir%"
cd "%sst.temp%"
call updatetmp.cmd /silent
cd "%sst.temp%"
if not defined sst.update (
	echo.
	echo.  Press any key to continue. . .
	pause>nul
	exit /b
)
if not exist "sstoolsupdate" (
	echo.Unexpected error: "sstoolsupdate" was not found. Press any key to exit. . .
	pause>nul
	exit /b
)
if not exist "sstoolsupdate\%sst.updatefile%" (
	echo.Unexpected error: "%sst.updatefile%" was not found. Press any key to exit. . .
	pause>nul
	exit /b
)
for %%a in (
	"title=SysShivt tools update"
	"args=/keystroke"
	"line2=SysShivt tools update has found a new"
	"line3=update. Here is more info about the version:"
	"line4=Version %sst.updatever% build %sst.updatebuild%"
	"line5=By installing this update, new entries will"
	"line6=be added to your 'boot.cwt' file."
	"line8=Press Y to continue or ESC to exit. . ."
) do set "sst.window.%%~a"
call window rem
if "%sst.errorlevel%" neq "121" if "%sst.errorlevel%" neq "89" exit /b
cd sstoolsupdate
if not exist "%sst.cd%\SysShivt-tools-%sst.updatever%-%sst.updatebuild%" md "%sst.cd%\SysShivt-tools-%sst.updatever%-%sst.updatebuild%"
move "%sst.updatefile%" "%sst.cd%\SysShivt-tools-%sst.updatever%-%sst.updatebuild%\%sst.updatefile%"
cd "%sst.cd%\SysShivt-tools-%sst.updatever%-%sst.updatebuild%"
call 7za x "%sst.updatefile%"
del /Q "%sst.updatefile%"
xcopy /E /Q "%sst.cd%\SysShivt-tools-%sst.updatever%-%sst.updatebuild%\sysshivt-tools" "%sst.cd%\sysshivt-tools-temp\"
cd ..
rd /S /Q "SysShivt-tools-%sst.updatever%-%sst.updatebuild%"
ren "SysShivt-tools-temp" "SysShivt-tools-%sst.updatever%-%sst.updatebuild%"
set sst.counter=1
for /f "" %%a in ('type "%sst.cd%\boot.cwt"') do set /a sst.counter+=1
(
	echo.[0] bootlist key True
	echo.[0\1] sstools.cmd SysShivt-tools-%sst.updatever%-%sst.updatebuild% SysShivt-tools-%sst.updatever%-%sst.updatebuild%
	echo.[0\2] sstpe.cmd SysShivt-tools-%sst.updatever%-%sst.updatebuild%-PE SysShivt-tools-%sst.updatever%-%sst.updatebuild%
	type "%sst.cd%\boot.cwt" | find /v "[0] " | find /v "[0\1] " | find /v "[0\2] "
	echo.[0\%sst.counter%] %sst.boot.kernel% %sst.boot.dir% %sst.boot.dir%
) > "%sst.cd%\boottemp.cwt"
del /Q "%sst.cd%\boot.cwt"
move "%sst.cd%\boottemp.cwt" "%sst.cd%\boot.cwt"
cd "%sst.dir%"
pause