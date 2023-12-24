@echo off
set sst.update=
set sst.updatever=3.2.0
set sst.updatebuild=2423
set sst.updatefile=SysShivt-tools-3-2-0-%sst.updatebuild%.zip
set sst.updateargs=%~1
set sst.latestdevbuild=2423
set sst.latestcanarybuild=2423
set sst.devupdatefile=SysShivt-tools-3-2-i-%sst.latestdevbuild%.zip
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
if not exist sstoolsupdate md sstoolsupdate
cd sstoolsupdate
if exist "%sst.updatefile%" del "%sst.updatefile%"
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/%sst.updatefile%" %sst.updatefile%
if "%sst.updateargs%" neq "/silent" if not exist "%sst.updatefile%" (
  echo.  Download failed! Press any key to exit. . .
  pause>nul
) else if %sst.build% lss 2423 start .
set sst.update=True
goto end
:UpToLate
echo.  You are up to date. [build: %sst.updatebuild%]
echo.  * If you want to try beta/pre-release builds of SysShivt tools,
echo.    you might consider checking out https://github.com/Shivter14/sysshivt-tools
echo.    (the download server) where you can even download in-dev canary builds.
echo.  * Latest Dev/Pre-release build: %sst.latestdevbuild%
echo.  * Latest Canary build: %sst.latestcanarybuild%
if "%sst.updateargs%" neq "/silent" pause
goto end
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
for %%a in (
  "You are running the latest canary build."
  "Current version: SysShivt tools %sst.ver% build %sst.build% [%sst.subvinfo%]"
  "Latest stable version: %sst.updatever%"
  "Latest Dev build: %sst.latestdevbuild%"
  "Latest Canary build: %sst.latestcanarybuild%"
) do echo.  %%~a
exit /b
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
