@echo off
cd ..
:main
call setres /d
color 1f
echo.
dir /w
call cmdwiz showcursor 0
call line %sst.defaultresX% 0 0 0 0 f0
call batbox /c 0xf0 /d " File Explorer" /g 0 %sst.defaultresY% /c 0x1f /d "  0 = refresh    1 = exit    2 = change dir    3 = run command  "
call getinput
set sse.errorlevel=%errorlevel%
set errorlevel=
if "%sse.errorlevel%" equ "50" goto changedir
if "%sse.errorlevel%" equ "51" goto run
goto \changedir
:changedir
call setres /d
color 1f
cls
echo.
echo.  shortcuts:
echo.    \         = System Root
echo.    \desktop  = Desktop
echo.    A:       = SSVM Boot Disk
echo.
set /p "sse.dir=DIRECTORY: "
if "%sse.dir%" equ "\" (
	cd "%sst.dir%\.."
	goto \changedir
)
if "%sse.dir%" equ "\desktop" (
	if not exist "%sst.dir%\..\desktop" md "%sst.dir%\..\desktop"
	cd "%sst.dir%\..\desktop"
	goto \changedir
)
if "%sse.dir%" equ "A:" (
	cd "%sst.dir%\..\.."
	if exist "A" (
		cd "A"
	) else (
		echo.  SSVM Boot Disk was not found.
		pause
	)
	goto \changedir
)
cd "%sse.dir%"
:\changedir
goto \run
:run
call setres /d
color 1f
cls
set /p "sse.run=COMMAND: "
call %sse.run%
timeout 3 > nul
:\run
if "%sse.errorlevel%" neq "49" goto main
cd "%sst.dir%"
call cmdwiz showcursor 1 25