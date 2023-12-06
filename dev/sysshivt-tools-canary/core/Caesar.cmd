@ECHO OFF
REM BATINFO;CMD+SST;831;A simple program that encrypts and decrypts files;1.1;Shivter, Mangoo on stackoverflow
if not defined sst.build set sst.build=0
if not defined sst.crrresX set sst.crrresX=0
if not defined sst.crrresY set sst.crrresY=0
if defined sst.build if "%sst.build%" neq "0" (
	if %sst.build% lss 831 (
		echo.This program reqires SysShivt tools version 3.1.1 or higher. Press any key to exit. . .
		pause>nul
		goto end
	)
	if %sst.crrresX% lss 64 call rtltrp.cmd 64 16
	if %sst.crrresY% lss 16 call rtltrp.cmd 64 16
)
set cipher1=%~4
set                           abet=abcdefghijklmnopqrstuvwxyz@#-/\ .0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ[];_{}*
if not defined cipher1 set cipher1=8p#Aj4 9z\6w.GK;RaY}e@TC0Xu2INr[E5o_xMHk-VcWfJS1b3OL*gB7hmqD]iZl/UsPntdFvyQ{
setlocal enabledelayedexpansion
set maxlines=0
set status=0
if "%~1" equ "-en" (
	for /f "" %%a in ('type "%~2"') do set /a maxlines=!maxlines!+1
	echo.[  0%%] Encrypting !maxlines! lines. . . > con
	FOR /f "delims=" %%a IN ('type "%~2"') DO (
		SET "line=%%~a"
		CALL :encipher
	)
	goto end
) > "%~3"
if "%~1" equ "-de" (
	for /f "" %%a in ('type "%~2"') do set /a maxlines=!maxlines!+1
	echo.[  0%%] Decrypting !maxlines! lines. . . > con
	FOR /f "delims=" %%a IN ('type "%~2"') DO (
		set "line=%%~a"
		call :decipher
	)
	goto end
) > "%~3"
for %%a in (
	"Syntax: call Caesar.cmd [-en|-de] Filename OutPutFile [Key] [-silent]"
	""
	"	-en		[Encrypts]"
	"	-de		[Decrypts]"
	"	Filename	The name of the file to be encrypted/decrypted"
	"	OutPutFile	The name of the file to save the output"
	"	Key		The string the text is encrypted/decrypted with"
	"	-silent		Disables displaying the output on the screen"
	""
) do echo.%%~a
set args=
set /p "args=> call Caesar.cmd "
if defined args call %0 %args%
goto end
:decipher
SET "morf=%abet%"
SET "from=%cipher1%"
GOTO trans
:encipher
SET "from=%abet%"
SET "morf=%cipher1%"
:trans
SET "enil="
:transl
SET "$1=%from%"
SET "$2=%morf%"
:transc
if "%line:~0,1%" equ "%$1:~0,1%" (
	set "enil=%enil%%$2:~0,1%"
	goto transnc
)
set "$1=%$1:~1%"
set "$2=%$2:~1%"
IF DEFINED $2 GOTO transc
:: No translation - keep
SET "enil=%enil%%line:~0,1%"
:transnc
SET "line=%line:~1%"
IF DEFINED line GOTO transl
ECHO %enil%
set /a status=!status!+1
set /a crrstatus=!status!*100/%maxlines%
if %crrstatus% lss 100 set crrstatus= %crrstatus%
if %crrstatus% lss 10 set crrstatus= %crrstatus%
if "%~5" neq "-silent" echo.[!crrstatus!%%] !enil! > con
GOTO :eof
:end