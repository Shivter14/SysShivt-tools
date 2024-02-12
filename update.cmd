@echo off
if "%~1" equ "/sstupdate" (
	color 1f
	cls
	goto sstupdate
)
set sst.update=
set sst.updatever=3.2.1
set sst.updatebuild=2609
set sst.updatefile=SysShivt-tools-3-2-1-%sst.updatebuild%.zip
set sst.updateargs=%~1
set sst.latestdevbuild=2607
set sst.latestcanarybuild=2607
set sst.devupdatefile=SysShivt-tools-3-2-i-%sst.latestdevbuild%.ssvm
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
for %%a in (
  "New update is avalible."
  "Current version: SysShivt tools %sst.ver% build %sst.build%"
  "Latest stable version: SysShivt tools %sst.updatever% build %sst.updatebuild%"
  ""
  "Downloading the latest version. . ."
 ) do echo.  %%~a
if exist sstoolsupdate rd /s /q sstoolsupdate > nul
md sstoolsupdate
cd sstoolsupdate
if exist "%sst.updatefile%" del "%sst.updatefile%"
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/%sst.updatefile%" %sst.updatefile%
if not exist "%sst.updatefile%" (
  echo.  Download failed! Check your internet connection and try again.
  exit /b
) else if %sst.build% lss 2423 start .
set sst.update=True

if %sst.build% lss 2419 (
	echo.Upgrading reqires at least:
	echo.SysShivt tools 3.2.0 build 2423.
	exit /b
)
call setres
for %%a in ("title=SysShivt tools update" "height=9" "args=/buttons" "line2=There is a system update avaliable [#6]"
	"line3=* If you choose to update, your system will restart."
	"line4=New version: %sst.updatever% build %sst.updatebuild%"
) do set "sst.window.%%~a"
set sst.window.buttons="Update" "Update later"
call window
if "%sst.errorlevel%" neq "0" exit
call setres /d
if not exist "%sst.temp%\sstoolsupdate" (
	cd "%sst.temp%"
	md sstoolsupdate
)
cd "%sst.temp%\sstoolsupdate"
if ERRORLEVEL 1 exit 255
call 7za.exe x "%sst.updatefile%" > nul
if not exist upgrade_filelist.sstenv (
	for %%a in ("title=SysShivt tools update" "height=7" "args=/buttons" "line2=Update failed:" "line3=upgrade_filelist.sstenv was not found"
	) do set "sst.window.%%~a"
	set sst.window.buttons="OK"
	call window
	exit /b
)
for %%a in ("boxY=1" "height=7" "title=SysShivt tools update" "args=/displayonly" "line2=If the system does not restart in a few" "line3=seconds, Please restart it manually.") do set "sst.window.%%~a"
call window.cmd
echo.>restart.txt
echo.>shutdown.txt
cd "%sst.temp%"
start /b cmd /c %0 /sstupdate
call shutdown.cmd /restart 3
:sstupdate
cd "%sst.dir%"
timeout 3 /nobreak > nul
for /f "tokens=1,2" %%a in ('type "%sst.temp%\sstoolsupdate\upgrade_filelist.sstenv"') do (
	if exist "%%~a" del /f /q "%%~a"
	if "%%~a" equ "sstsession.cmd" (
		copy "%sst.temp%\sstoolsupdate\sysshivt-tools\%%~a" sstsession_update.cmd
		for %%a in (
			"@echo off" "(" "color 0f" "cls" "echo.Updating SysShivt tools. . ."
			"del /f /q sstsession.cmd" "ren sstsession_update.cmd sstsession.cmd"
			"if exist crash.txt del crash.txt" "if exist crashed.txt del crashed.txt" "copy nul temp\fastreboot.cww"
			"if not exist shutdown.txt copy nul shutdown.txt" "exit" ")"
		) do echo.%%~a>>sstsession.cmd
	) else if "%%~b" neq "DELETE" copy "%sst.temp%\sstoolsupdate\sysshivt-tools\%%~a" "%%~a"
) > nul
if exist crashed.txt del crashed.txt
timeout 1 /nobreak > nul
if exist crashed.txt del crashed.txt
Exit 0

:UpToLate
for %%a in ("title=SysShivt tools update" "args=/buttons" "width=60"
	"line2=You are up to date. [build: %sst.updatebuild%]"
	"line3=* If you want to try beta/pre-release builds of SysShivt tools,"
	"line4=  you might consider checking out https://github.com/Shivter14/sysshivt-tools"
	"line5=(the download server) where you can even download in-dev canary builds."
	"line6=* Latest Dev/Pre-release build: %sst.latestdevbuild%"
	"line7=* Latest Canary build: %sst.latestcanarybuild%"
) do set "sst.window.%%~a"
set sst.window.buttons="OK"
call window
exit
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
exit /b
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
exit /b
:dev
for %%a in (
  "You are running the latest dev/pre-release build."
  "Current version: SysShivt tools %sst.ver% build %sst.build% [%sst.subvinfo%]"
  "Latest stable version: %sst.updatever%"
  "Latest Dev build: %sst.latestdevbuild%"
  "Latest Canary build: %sst.latestcanarybuild%"
) do echo.  %%~a
:end
