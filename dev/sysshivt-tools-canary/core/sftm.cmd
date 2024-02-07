@echo off
REM BATINFO;CMD+SST;0707;A program that stores a file into RAM or reads it;1.1;Shivter
set sftm.errorlevel=
if "%~1" equ "/store" goto store
if "%~1" equ "/erase" goto erase
if "%~1" equ "/read" goto read
if "%~1" equ "/dir" goto dir
if "%~1" equ "/mkdir" goto mkdir
setlocal enabledelayedexpansion
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set /a sftm.hsh=%%a-1
for %%a in (
	"Syntax: call sftm.cmd [/store <file> <folder> <name> [/f] [/s]"
	"                      |/erase <rampath> [/s]"
	"                      |/read <rampath> [/s]"
	"                      |/dir <rampath> [/s]"
	"                      |/mkdir <folder> <name> [/s]"
	"                      ]"
	"	/store	: Stores a file into the RAM"
	"		file	: The name of the file to be loaded."
	"		folder	: A RAM path of the folder for the file to be stored in."
	"		name	: A name for the RAM file to be stored."
	"		/f	: Stores the file even if a file exist in that location."
	"		Return values: 1 = File not found, 2 = File Stored Already,"
	"		               3 = Folder not found"
	"	/erase	: Erases a file from the RAM."
	"		rampath	: The RAM path of the file stored."
	"		Possible return values: 'File not found', 'Location is a volume'"
	"	/read	: Reads the content of a file in the RAM."
	"		rampath	: The RAM path of the file stored."
	"		Possible return values: 'File not found',"
	"		                        'Location is a folder or a volume'"
	"	/dir	: Displays a list of files inside a folder stored in RAM."
	"		rampath	: The RAM path of the folder stored."
	"		Possible return values: 'Folder not found', 'Location is a file'"
	"	/mkdir	: Creates a directory in RAM."
	"		folder	: A RAM path of the folder/volume for the folder to be"
	"			  stored in."
	"		name	: A name for the RAM folder to be stored."
	"		Possible return values: 'Location not found',"
	"		                   'mkdir.location.exists', 'Location is a file'"
	"	/s	: Does not display any messages."
	""
	"	Return values are stored in ERRORLEVEL"
) do (
	echo.%%~a
	if defined sftm.delay timeout 0 /nobreak > nul
	set /a sftm.hsh=!sftm.hsh!-1
	if "!sftm.hsh!" equ "0" (
		set sftm.delay=True
		set sftm.hsh=%sftm.hsh%
		if defined sst.build call batbox /g 0 %sftm.hsh% /d " - Press any key - "
		pause>nul
		if defined sst.build call batbox /g 0 %sftm.hsh% /d "                   " /g 0 %sftm.hsh%
	)
)
endlocal
set sftm.errorlevel=Invalid Argument
exit /b
:store
if not defined sftm.[%~3] (
	if "%~5" neq "/s" if "%~6" neq "/s" echo.Folder "%~3" was not found in RAM.
	exit /b 3
)
if defined sftm.[%~3/%~4] (
	if "%~5" neq "/f" if "%~6" neq "/f" (
		if "%~5" neq "/s" if "%~6" neq "/s" echo.There is a file already stored in: %~3/%~4
		exit /b 2
	) else (
		call %0 /erase "%~3/%~4" /s
		if "%sftm.errorlevel%" equ "Location is a volume" (
			if "%~5" neq "/s" if "%~6" neq "/s" echo.Location "%~3" is a volume.
			exit /b -1
		)
		exit /b
	)
)
if not exist "%~2" (
	if "%~5" neq "/s" if "%~6" neq "/s" echo.File "%~2" was not found.
	exit /b 1
)
set sftm.counter=0
for /f "delims=" %%a in ('type "%~2"') do (
	set /a sftm.counter+=1
	for /f "tokens=2 delims==" %%b in ('set sftm.counter') do set sftm.[%~3/%~4].[%%b]=%%a
)
set sftm.[%~3/%~4]=%sftm.counter%
set sftm.counter=1
:sw
if defined sftm.[%~3].[%sftm.counter%] for /f "tokens=2 delims==" %%a in ('set sftm.[%~3].[%sftm.counter%]') do if defined sftm.[%~3/%%a] (
	set /a sftm.counter+=1
	goto sw
)
set sftm.[%~3].[%sftm.counter%]=%~4
exit /b
:erase
if not defined sftm.[%~2] (
	if "%~3" neq "/s" echo.File "%~2" was not found in RAM.
	set sftm.errorlevel=File not found
	exit /b 1
)
for /f "tokens=1,2 delims==" %%a in ('set sftm.[%~2] ^| find "sftm.[%~2]="') do if "%%~a" equ "sftm.[%~2]" (
	if "%%~b" equ "DIR" (
		for /f "tokens=1 delims==" %%a in ('set sftm.[%~2/') do set %%~a=
	)
	if "%%~b" equ "VOLUME" (
		if "%~3" neq "/s" echo.You can't erase a volume.
		set sftm.errorlevel=Location is a volume
		exit /b 2
	)
)
for /f "tokens=1 delims==" %%a in ('set sftm.[%~2]') do set %%~a=
exit /b
:read
if not defined sftm.[%~2] (
	if "%~3" neq "/s" echo.File "%~2" was not found in RAM.
	set sftm.errorlevel=File not found
	exit /b
)
for /f "tokens=1,2 delims==" %%a in ('set sftm.[%~2] ^| find "sftm.[%~2]="') do if "%%~a" equ "sftm.[%~2]" if "%%~b" equ "DIR" (
	if "%~3" neq "/s" (
		echo.File "%~2" is a folder. If you want a list of files stored
		echo.in a RAM folder, use: "call sftm /dir <rampath>"
		echo.Call this program without any parameters to get more info.
	)
	set sftm.errorlevel=Location is a folder or a volume
	exit /b
)
for /f "tokens=1,2 delims==" %%a in ('set sftm.[%~2] ^| find "sftm.[%~2]="') do if "%%~a" equ "sftm.[%~2]" if "%%~b" equ "VOLUME" (
	if "%~3" neq "/s" (
		echo.File "%~2" is a volume. If you want a list of files stored
		echo.in a RAM volume, use: "call sftm /dir <rampath>"
		echo.Call this program without any parameters to get more info.
	)
	set sftm.errorlevel=Location is a folder or a volume
	exit /b
)
setlocal enabledelayedexpansion
for /l %%a in (1 1 !sftm.[%~2]!) do for /f "delims=&" %%b in ('call batbox /d "!sftm.[%~2].[%%a]!"') do echo.%%b
endlocal
exit /b
:dir
if not defined sftm.[%~2] (
	if "%~3" neq "/s" echo.Folder "%~2" was not found in RAM.
	set sftm.errorlevel=Folder not found
	exit /b
)
for /f "tokens=1,2 delims==" %%a in ('set sftm.[%~2] ^| find "sftm.[%~2]="') do if "%%~a" equ "sftm.[%~2]" (
	if "%%~b" neq "DIR" if "%%~b" neq "VOLUME" (
		if "%~3" neq "/s" (
			echo.Folder "%~2" is actualy a file.
			echo.If you want to read a file stored in RAM, use:
			echo."call sftm /read <rampath>"
			echo.Call this program without any parameters to get more info.
		)
		set sftm.errorlevel=Location is a file
		exit /b
	)
)
setlocal enabledelayedexpansion
set sftm.counter=1
:dw
if defined sftm.[%~2].[%sftm.counter%] (
	if defined sftm.[%~2/!sftm.[%~2].[%sftm.counter%]!] echo.!sftm.[%~2].[%sftm.counter%]!
	set /a sftm.counter+=1
	goto dw
)
endlocal
exit /b
:mkdir
if not defined sftm.[%~2] (
	if "%~4" neq "/s" echo.Folder "%~2" was not found in RAM.
	set sftm.errorlevel=Location not found
	exit /b
)
for /f "tokens=1,2 delims==" %%a in ('set sftm.[%~2] ^| find "sftm.[%~2]="') do if "%%~a" equ "sftm.[%~2]" if "%%~b" neq "DIR" if "%%~b" neq "VOLUME" (
	if "%~4" neq "/s" echo.Location "%~2" is a file.
	set sftm.errorlevel=Location is a file
)
if defined sftm.[%~2/%~3] (
	if "%~4" neq "/s" echo."%~2/%~3" already exists in RAM.
	set sftm.errorlevel=mkdir.location.exists
	exit /b
)
set "sftm.[%~2/%~3]=DIR"
set sftm.counter=1
:mkw
if defined sftm.[%~2].[%sftm.counter%] (
	set /a sftm.counter+=1
	goto mkw
)
set sftm.[%~2].[%sftm.counter%]=%~3
set sftm.counter=