@echo off
set sst.dir=%cd%
set ls.username=SYSTEM
set sst.cmdline.input=
if not exist log.txt (
	echo.
	echo.  No signal!
) > log.txt
mode 96,24
:cmdline
color 0f
cls
if not exist log.txt echo.>log.txt
type log.txt
set sst.cmdline.input=
set /p "sst.cmdline.input=[0m[92msstools[0m[2m/[0m[102m[1m%ls.username%[0m[1m> "
if "%sst.cmdline.input%" equ "exit" goto exit
if "%sst.cmdline.input%" equ "help" (
	color 0f
	mode 96,24
	cls
	echo.
	echo.  Help Menu:
	echo.  start = Start SysShivt tools
	echo.  stafx = Start SysShivt tools in recovery mode
	echo.  crash = Crash SysShivt tools
	echo.  exit  = Exit
	echo.  rlgr  = Reload SysShivt tools window
	echo.
	echo.  Press any key to continue. . .
	pause>nul
)
if "%sst.cmdline.input%" equ "start" (
	cd ..
	start cmd /c autorun.cmd
	cd "%sst.dir%"
)
if "%sst.cmdline.input%" equ "stafx" (
	if exist shutdown.txt del shutdown.txt
	cd ..
	start cmd /c autorun.cmd
	cd "%sst.dir%"
)
if "%sst.cmdline.input%" equ "shutdown" goto /shutdown
if "%sst.cmdline.input%" equ "rlgr" goto /rlgr
goto \rlgr
:/rlgr
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[92mCMDLINE[0m[2m] [0m[1mExecuting command "rlgr". >> log.txt
echo.> "reloadgraphic.txt"
:\rlgr
goto \shutdown
:/shutdown
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[92mCMDLINE[0m[2m] [0m[1mExecuting command "shutdown". >> log.txt
echo. > shutdown.txt
:\shutdown
if "%sst.cmdline.input%" equ "crash" goto /crash
goto \crash
:/crash
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[92mCMDLINE[0m[2m] [0m[1mExecuting command "crash". >> log.txt
echo. > crashed.txt
:\crash
goto cmdline
:exit