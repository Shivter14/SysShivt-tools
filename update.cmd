@echo off
set sst.updatever=3.0.2
set sst.updatefile=SysShivt-tools-3-1-0-0707.zip
if "%sst.ver%" equ "%sst.updatever%" goto uptolate
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
:uptolate
echo.You are up to late! [build: 0526]
pause
:end
