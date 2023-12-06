@echo off
if not exist "%sst.dir%\..\downloads" ms "%sst.dir%\..\downloads"
if exist exitrgb.cww del exitrgb.cww
call setres /d
cd "%sst.dir%"
start /b cmd /c loading "Connecting to the internet. . ." 0 80 "" /ef
if exist ..\temp\storedwn.cmd del ..\temp\storedwn.cmd
cd %sst.temp%
call download.exe "https://github.com/Shivter14/SysShivt-tools/raw/main/store.cmd" storedwn.cmd > nul
timeout 2 /nobreak > nul
echo.> "exitrgb.cww"
echo.> "%sst.temp%\exitrgb.cww"
cd "%sst.dir%"
if not exist "%sst.temp%\storedwn.cmd" goto /dwn
goto \dwn
:/dwn
call loading "Download failed. Exitting. . ." 0 8
goto end
:\dwn
timeout 1 /nobreak > nul
call "%sst.temp%\storedwn.cmd"
:end