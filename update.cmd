@echo off
if "%~1" equ "/sstupdate" (
	color 1f
	cls
	goto sstupdate
)
set sst.update=
set sst.updatever=3.2.1
set sst.updatebuild=2609
set !sst.updateinfo=Service Pack 1!
set "sst.updatefile=SysShivt-tools-%sst.updatever:.=-%-%sst.updatebuild%.zip"
set "sst.updateargs=%~1"
set sst.latestdevbuild=2707
set sst.latestcanarybuild=2607
set "sst.devupdatefile=SysShivt-tools-3-2-i-%sst.latestdevbuild%.ssvm"
if not defined sst.build exit /b
echo.
if %sst.build% gtr %sst.updatebuild% (
  if %sst.build% lss %sst.latestdevbuild% goto dev-outdated
  if %sst.build% gtr %sst.latestdevbuild% (
    if %sst.build% lss %sst.latestcanarybuild% goto canary-outdated
    goto canary
  )
  goto dev
)
if "%sst.build%" equ "%sst.updatebuild%" goto UpToLate
if %sst.build% lss 0707 (
	echo.New update is avaliable.
	echo.Current version: SysShivt tools %sst.ver% build %sst.build%
	echo.Latest stable version: SysShivt tools %sst.updatever% build %sst.updatebuild% [%sst.updateinfo%]
	echo.Updating SysShivt tools. . .
) else (
	for %%a in ("title=SysShivt tools update" "width=64" "height=11" "args=/displayonly"
		"line2=New update is avalible."
		"line4=Current version: SysShivt tools %sst.ver% build %sst.build%"
		"line5=Latest stable version: SysShivt tools %sst.updatever% build %sst.updatebuild%"
		"line7=Please wait. . ."
 	) do set "sst.window.%%~a"
	call window
)
if exist sstoolsupdate rd /s /q sstoolsupdate > nul
md sstoolsupdate
cd sstoolsupdate
if exist "%sst.updatefile%" del "%sst.updatefile%"
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/%sst.updatefile%" %sst.updatefile%
if not exist "%sst.updatefile%" (
  echo.  Download failed! Check your internet connection and try again.
  exit /b
) else if %sst.build% lss 1830 start .
set sst.update=True

if %sst.build% lss 1830 (
	echo.Upgrading reqires at least:
	echo.SysShivt tools 3.1.4 build 1830.
	exit /b
)
call setres
for %%a in ("title=SysShivt tools update" "height=9" "args=/buttons" "line2=There is a system update avaliable [#7]"
	"line3=* If you choose to update, your system will restart."
	"line4=New version: %sst.updatever% build %sst.updatebuild%"
) do set "sst.window.%%~a"
set sst.window.buttons="Update" "Update later"
if %sst.build% lss 2423 (
	set sst.window.args=/keystroke
	set sst.window.line6=Press ENTER to install,
	set sst.window.line7=or any other key to cancel.
)
call window
if %sst.build% lss 2423 (if "%sst.errorlevel%" neq "13" exit
) else if "%sst.errorlevel%" neq "0" exit
call setres /d
if not exist "%sst.temp%\sstoolsupdate" (
	cd "%sst.temp%"
	md sstoolsupdate
)
cd "%sst.temp%\sstoolsupdate"
if ERRORLEVEL 1 exit 255
call 7za.exe x "%sst.updatefile%" > nul
if %sst.build% lss 2423 (set sst.update.filelist=upgrade_filelist_1830.sstenv
) else set sst.update.filelist=upgrade_filelist_2423.sstenv
for %%a in ("title=SysShivt tools update" "height=9" "args=/displayonly" "line2=Please wait. . .") do set "sst.window.%%~a"
call window
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/upgrade/%sst.update.filelist%" %sst.update.filelist%
if not exist "%sst.update.filelist%" (
	for %%a in ("title=SysShivt tools update" "height=7" "args=/buttons" "line2=Update failed:" "line3=%sst.update.filelist% was not found"
	) do set "sst.window.%%~a"
	set sst.window.buttons="OK"
	call window
	exit /b
)
for %%a in ("boxY=1" "height=7" "title=SysShivt tools update" "args=/displayonly" "line2=If the system does not restart in a few" "line3=seconds, Please restart it manually.") do set "sst.window.%%~a"
call window.cmd
copy nul restart.txt > nul 2>&1
copy nul shutdown.txt > nul 2>&1
cd "%sst.temp%"
start /b cmd /c %0 /sstupdate
call shutdown.cmd /restart 3
:sstupdate
cd "%sst.dir%"
timeout 3 /nobreak > nul
for /f "tokens=1,2" %%a in ('type "%sst.temp%\sstoolsupdate\%sst.update.filelist%"') do (
	if exist "%%~a" del /f /q "%%~a"
	if "%%~a" equ "sstsession.cmd" (
		copy "%sst.temp%\sstoolsupdate\sysshivt-tools\%%~a" sstsession_update.cmd
		for %%a in (
			"@echo off"
			"("
				"color 0f"
				"cls"
				"echo.Updating SysShivt tools. . ."
				"del /f /q sstsession.cmd"
				"ren sstsession_update.cmd sstsession.cmd"
				"if exist crash.txt del crash.txt"
				"if exist crashed.txt del crashed.txt"
				"copy nul temp\fastreboot.cww"
				"if not exist shutdown.txt copy nul shutdown.txt"
				"exit"
			")"
		) do echo.%%~a>>sstsession.cmd
	) else if "%%~b" neq "DELETE" copy "%sst.temp%\sstoolsupdate\sysshivt-tools\%%~a" "%%~a"
) > nul
if exist crashed.txt del crashed.txt
timeout 1 /nobreak > nul
if exist crashed.txt del crashed.txt
Exit 0

:UpToLate
call :end-of-life
exit
:end-of-life
for %%a in ("title=SysShivt tools end of life" "args=/buttons" "width=64"
	"line2=Thank you for using SysShivt tools."
	"line3=This project was ended in the favor of Shivtanium."
	"line4=Shivtanium is the successor to SysShivt tools"
	"line5=For more information, you may check out"
	"line6=https://github.com/Shivter14/Shivtanium"
	"line8=Latest Dev/Pre-release build: %sst.latestdevbuild%"
	"line9=Latest Canary build: %sst.latestcanarybuild%"
) do set "sst.window.%%~a"
set sst.window.buttons="OK"
call window
exit /b
:canary-outdated
for %%a in (
  "WARNING: You are running an outdated canary build."
  "    That means you should upgrade to the latest"
  "    canary build for bugfixes and new features."
  "    Download the latest canary build from https://github.com/Shivter14/SysShivt-tools/dev"
  "  Current version: SysShivt tools %sst.ver% build %sst.build% [%sst.subvinfo%]"
  "  Latest stable version: %sst.updatever%"
  "  Latest Dev build: %sst.latestdevbuild%"
  "  Latest Canary build: %sst.latestcanarybuild%"
) do echo.%%~a
call :end-of-life
exit
:canary
for %%a in ("title=SysShivt tools update" "args=/buttons" "width=60" "height=11"
	"line2=You are running the latest canary build."
	"line3=Current version: SysShivt tools %sst.ver% build %sst.build%"
	"line4=[%sst.subvinfo%]"
	"line5=Latest stable version: %sst.updatever%"
	"line6=Latest Dev/Pre-release build: %sst.latestdevbuild%"
	"line7=Latest Canary build: %sst.latestcanarybuild%"
) do set "sst.window.%%~a"
set sst.window.buttons="OK"
call window
call :end-of-life
exit
:dev-outdated
for %%a in (
  "WARNING: You are running an outdated dev/pre-release build."
  "    That means you should upgrade to the latest"
  "    dev/pre-release build for bugfixes and new features."
  "    Download latest builds at https://github.com/Shivter14/SysShivt-tools"
  "  Current version: SysShivt tools %sst.ver% build %sst.build% [%sst.subvinfo%]"
  "  Latest stable version: %sst.updatever%"
  "  Latest Dev build: %sst.latestdevbuild%"
  "  Latest Canary build: %sst.latestcanarybuild%"
) do echo.%%~a
call :end-of-life
exit /b
:dev
for %%a in (
  "You are running the latest dev/pre-release build."
  "Current version: SysShivt tools %sst.ver% build %sst.build% [%sst.subvinfo%]"
  "Latest stable version: %sst.updatever%"
  "Latest Dev build: %sst.latestdevbuild%"
  "Latest Canary build: %sst.latestcanarybuild%"
) do echo.  %%~a
call :end-of-life
:end
