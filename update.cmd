@echo off
set sst.updatever=3.2.0
set sst.updatebuild=2423
set sst.updatefile=SysShivt-tools-3-1-4-%sst.updatebuild%.zip
set sst.updateargs=%~1
set sst.latestdevbuild=Not avaliable
set sst.latestcanarybuild=Not avaliable
echo.
if %sst.build% gtr %sst.updatebuild% goto dev
if "%sst.build%" equ "%sst.updatebuild%" goto UpToLate
for %%a in (
  "New update is avalible."
  "Current version: %sst.ver%"
  "Latest version: %sst.updatever%"
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
) else start .
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
:dev
for %%a in (
  "You are running the latest developer edition."
  "Current version: %sst.ver%"
  "Latest version: %sst.updatever%"
) do echo.  %%~a
:end
