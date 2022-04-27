@echo off
set sst.updatever=3.0.0
if "%sst.ver%" equ "%sst.updatever%" goto uptolate
echo.Update avalible!
echo.Current version: %sst.ver%
echo.Update version: %sst.updatever%
echo.Downloading lates version
call "%sst.dir%\spin.cmd" 26 7 4 0f /c
if not exist sstoolsupdate md sstoolsupdate
cd sstoolsupdate
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/SysShivt-tools-3-0-b-0329.zip" SysShivt-tools-3-0-b-0329.zip
if not exist "SysShivt-tools-3-0-b-0329.zip" (
  echo.Download failed!
  pause
) else (
  start .
)
goto end
:uptolate
echo.You are up to late!
pause
:end
