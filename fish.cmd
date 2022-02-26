@echo off
set fg.ver=alpha 1.1.0
title Fish game %fg.ver%
if not exist getinput.exe goto /missing_getinput.exe
goto \missing_getinput.exe
:/missing_getinput.exe
set fg.error=
echo. This program requires getinput.exe.
echo. 1 = continue anyway
echo. 2 = nevermind, exit
set /p "fg.error=> "
if "%fg.error%" equ "1" goto truestart
if "%fg.error%" equ "2" goto exit
echo. Invalid choice!
goto /missing_getinput.exe
:\missing_getinput.exe
:truestart
:start
color f0
mode 96,25
cls
call login-system.cmd "fish game %fg.ver%" "96,25" "f0"
cls
echo.
echo.
echo.     Shivter's Fish Game %fg.ver%
echo.     Welcome.
echo.
pause
set fg.fished=0
set fg.xp=0
set fg.level=1
:load
echo.  select:
echo.  1 = load game
echo.  2 = create new game
getinput
set fg.errorlevel=%errorlevel%
set errorlevel=
if %fg.errorlevel% equ 49 goto /loadfile
if %fg.errorlevel% equ 50 goto /createfile
goto \createfile
:/createfile
echo select location for the game file
set /p "fg.mkfile=> "
if not exist "%fg.mkfile%" (
	md "%fg.mkfile%"
)
set fg.file=%fg.mkfile%\FishGameSave.cmd
(
	echo @set fg.fished=0
	echo @set fg.xp=0
	echo @set fg.level=1
) > "%fg.file%"
call "%fg.file%"
goto game
:\createfile
goto \loadfile
:/loadfile
echo game file location? [do not use following character: "]
set /p "fg.file=> "
if not exist "%fg.file%" (
	echo Error: file "%fg.file%" does not exist!
	goto load
)
call "%fg.file%"
goto game
:\loadfile
goto load
:game
color 0f
mode 96,25
cls
echo.
echo.  You have %fg.fished% fish(s), %fg.level% level(s) and %fg.xp% xp.
echo.
echo.  ENTER = Fish
echo.  ESC   = exit
echo.
timeout 4 /nobreak
getinput
set fg.errorlevel=%errorlevel%
set errorlevel=
if "%fg.errorlevel%" equ "27" (
	goto exit
)
if "%fg.errorlevel%" equ "13" (
	goto /fish
)
goto \fish
:/fish
set fg.fish=%random:~0,1%
set /a fg.fish=%fg.fish%*%fg.level%
set /a fg.xpget=%fg.fish%*3/2
set /a fg.xp=%fg.xp%+%fg.xpget%
:/checkforlevel
if %fg.xp% geq 100 (
	set /a fg.xp=%fg.xp%-100
	set /a fg.level=%fg.level%+1
	goto /checkforlevel
) else (
	goto \checkforlevel
)
:\checkforlevel
set /a fg.fished=%fg.fished%+%fg.fish%
(
	echo @set fg.fished=%fg.fished%
	echo @set fg.xp=%fg.xp%
	echo @set fg.level=%fg.level%
) > "%fg.file%"
color 0f
mode 96,25
cls
echo.
echo.  fish catched: %fg.fish%
echo.  You have %fg.fished% fish(s), %fg.level% level(s) and %fg.xp% xp.
echo.  +%fg.xpget% xp
echo.
pause
:\fish
goto game
:exit
cls
color 07
echo Fish game is shutting down. . .
timeout 1 > nul
echo error code: %fg.errorlevel%
set fg.errorlevel=
set fg.error=