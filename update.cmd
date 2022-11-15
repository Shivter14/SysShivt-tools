@echo off
set sst.updatever=3.1.1
set sst.updatebuild=1111
set sst.updatefile=SysShivt-tools-3-1-1-%sst.updatebuild%.zip
set sst.updateargs=%~1
echo.
if "%sst.ver%" equ "%sst.updatever%" goto UpToLate
if "%sst.ver%" equ "3.1.i" goto dev
for %%a in (
  "Update avalible! [build: %sst.updatebuild%]"
  "Current version: %sst.ver%"
  "Update version: %sst.updatever%"
  ""
  "Downloading lates version. . ."
 ) do echo. %%~a
timeout 1 /nobreak > nul
if not exist sstoolsupdate md sstoolsupdate
cd sstoolsupdate
if exist "%sst.updatefile%" del "%sst.updatefile%"
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/%sst.updatefile%" %sst.updatefile%
if "%sst.updateargs%" neq "/silent" if not exist "%sst.updatefile%" (
  echo.  Download failed! Press any key to exit. . .
  pause>nul
) else (
  start .
)
goto end
:UpToLate
echo. You are up to late! [build: %sst.updatebuild%]
if "%sst.updateargs%" neq "/silent" pause
goto end
:dev
echo. You are the lates developer edition.
:end
