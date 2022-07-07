@echo off
set sst.updatever=3.1.0
set sst.updatefile=SysShivt-tools-3-1-0-0707.zip
if "%sst.ver%" equ "%sst.updatever%" goto UpToLate
if "%sst.ver%" equ "3.1.i" goto dev
echo.Update avalible! [build: 0526]
echo.Current version: %sst.ver%
echo.Update version: %sst.updatever%
echo.Downloading lates version
call spin 26 7 4 0f /c
if not exist sstoolsupdate md sstoolsupdate
cd sstoolsupdate
if exist "%sst.updatefile%" del "%sst.updatefile%"
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/%sst.updatefile%" %sst.updatefile%
if not exist "%sst.updatefile%" (
  echo.Download failed!
  pause
) else (
  start .
)
goto end
:UpToLate
echo.You are up to late! [build: 0707]
pause
goto end
:dev
echo.You are running the lates developer edition.
:end
