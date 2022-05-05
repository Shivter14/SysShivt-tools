@echo off
set sst.updatever=3.0.1
if "%sst.ver%" equ "%sst.updatever%" goto uptolate
echo.Update avalible! [build: 0505]
echo.Current version: %sst.ver%
echo.Update version: %sst.updatever%
echo.Downloading lates version
if exist "%sst.dir%\spin.cmd" (
  call "%sst.dir%\spin.cmd" 26 7 4 0f /c
 ) else (
  call spin 26 7 4 0f /c
 )
if not exist sstoolsupdate md sstoolsupdate
cd sstoolsupdate
if exist "SysShivt-tools-3-0-0-0427.zip" del "SysShivt-tools-3-0-0-0427.zip"
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/SysShivt-tools-3-0-1-0505.zip" SysShivt-tools-3-0-1-0505.zip
if not exist "SysShivt-tools-3-0-1-0505.zip" (
  echo.Download failed!
  pause
) else (
  start .
)
goto end
:uptolate
echo.You are up to late! [build: 0505]
pause
:end
