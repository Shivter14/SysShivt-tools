@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3. Press any key to exit.
	pause>nul
	goto end
)
set gbat.sver1=0707
set gbat.sver2=1418
call setres /d
for %%a in (
	""
	"Welcome to the SysShivt tools basic program generator."
	"Compatible builds: %gbat.sver1% - %gbat.sver2%"
	"client build: %sst.build%"
	""
) do echo.  %%~a
set gbat.sverC=0
if %sst.build% leq %gbat.sver1% set gbat.sverC=-1
if %sst.build% lss %gbat.sver1% set gbat.sverC=-2
if %sst.build% geq %gbat.sver2% set gbat.sverC=1
if %sst.build% gtr %gbat.sver2% set gbat.sverC=2
if "%gbat.sverC%" equ "-2" echo.  Your SysShivt tools version is not compatible with this generator!
if "%gbat.sverC%" equ "-1" echo.  You are running the oldest compatible version supported by this program.
if "%gbat.sverC%" equ "0" echo.  You are running a supported version by this program.
if "%gbat.sverC%" equ "1" echo.  You are running the latest compatible version by this program.
if "%gbat.sverC%" equ "2" echo.  Your SysShivt tools version is not tested yet by this program!
if "%gbat.sverC%" equ "-2" (
	echo.  Press any key to exit.
	pause>nul
	goto end
)
if "%gbat.sverC%" equ "2" (
	echo.  Press any key to exit.
	pause>nul
	goto end
)
for %%a in (
	""
	"Type the path of the file you want to create."
	"WARNING: if the file specified exist, It will be overwritten!"
	"If you dont type just the filename, The file will be saved to following directory:"
	"%cd%"
	""
	"Type nul to exit"
) do echo.  %%~a
set /p "gbat.filename=> "
if "%gbat.filename%" equ "nul" goto end
echo.
echo.  Generating. . .
if exist "%gbat.filename%" type "%gbat.filename%" > "%gbat.filename%.bak"
echo.@echo off> "%gbat.filename%"
echo.if not defined sst.build (>> "%gbat.filename%"
echo.    echo.This program reqires SysShivt tools 3. Press any key to exit.>> "%gbat.filename%"
echo.    pause^>nul>> "%gbat.filename%"
echo.    goto end>> "%gbat.filename%"
echo.)>> "%gbat.filename%"
echo.call setres /d>> "%gbat.filename%"
echo.>> "%gbat.filename%"
echo.rem You can start programing there.>> "%gbat.filename%"
echo.>> "%gbat.filename%"
echo.:end>> "%gbat.filename%"
:end