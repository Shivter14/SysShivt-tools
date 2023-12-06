@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.1.0 or higher!
	echo.Press any key to exit. . .
	pause>nul
	exit /b
)
if %sst.build% lss 0707 (
	echo.This program reqires SysShivt tools 3.1.0 or higher!
	echo.Press any key to exit. . .
	pause>nul
	exit /b
)
set sftm.errorlevel=
set sftmshell.cd=
:main
set sftmshell.cmd=
call batbox /c 0xaf /d " SFTM Shell " /c 0x9f /d " %sftm.errorlevel% " /c 0x0a /d " %sftmshell.cd%" /c 0x0e /a 62 /a 0 /c 0x0f
set /p sftmshell.cmd=
for /f "tokens=1*" %%a in ("%sftmshell.cmd%") do (
	if "%%~a" equ "cd" (call :cd %%~b
	) else if "%%~a" equ "dir" (call :dir %%~b
	) else if "%%~a" equ "read" (call :read %%~b
	) else if "%%~a" equ "type" (call :read %%~b
	) else if "%%~a" equ "erase" (call :erase %%~b
	) else if "%%~a" equ "del" (call :erase %%~b
	) else if "%%~a" equ "help" (call sftm
	) else if "%%~a" equ "exit" (exit /b 0
	) else if "%%~a" equ "cls" (call setres /d
	) else echo.Invalid command!
)
goto main
:cd
set "sftmshell.newcd=%~1"
if "%sftmshell.newcd%" equ "\" if defined sftm.[] (
	set sftmshell.cd=
	exit /b
) else (
	echo.Access denied.
	exit /b
) else if not defined sftmshell.newcd (
	if defined sftmshell.cd (
		echo.
		echo.    "
		echo.	If you are so blind that you don't see the green
		echo.	text on the black background behind the yellow
		echo.	">", you should see a doctor.
		echo.                                                           "
		echo.    - Shivter 6/28/2023
		echo.
	) else (
		echo.You are currently in the main root.
		echo.Type "dir" to see all directories/volumes.
	)
	exit /b
)
if "%sftmshell.newcd:~0,1%" equ "/" (
	if defined sftm.[%sftmshell.newcd%] (
		for /f "tokens=1* delims==" %%a in ('set sftm.[%sftmshell.newcd%]') do if "%%~a" equ "sftm.[%sftmshell.newcd%]" (
			if "%%~b" equ "VOLUME" set "sftmshell.cd=%sftmshell.newcd%"
			if "%%~b" equ "DIR" set "sftmshell.cd=%sftmshell.newcd%"
		)
	) else echo.Directory not found!
) else if defined sftm.[%sftmshell.cd%/%sftmshell.newcd%] (
	set "sftmshell.cd=%sftmshell.cd%/%sftmshell.newcd%"
) else echo.Directory not found!
set sftmshell.newcd=
exit /b
:dir
set sftmshell.dir=%~1
if "%sftmshell.dir%" equ "" (call sftm /dir "%sftmshell.cd%"
) else if "%sftmshell.dir%" equ "\" if defined sftm.[] (call sftm /dir "") else echo.Access denied.
) else if "%sftmshell.dir:~0,1%" equ "/" (call sftm /dir "%sftmshell.dir%"
) else call sftm /dir "%sftmshell.cd%/%sftmshell.dir%"
set sftmshell.dir=
exit /b
:read
set sftmshell.read=%~1
if "%sftmshell.read%" equ "" (echo.The syntax of the command is incorrect.
) else if "%sftmshell.read%" equ "\" (call sftm /read ""
) else if "%sftmshell.read:~0,1%" equ "/" (call sftm /read "%sftmshell.read%"
) else call sftm /read "%sftmshell.cd%/%sftmshell.read%"
set sftmshell.read=
exit /b
:mkdir
set sftmshell.mkdir=%~1
set sftmshell.mkdirname=%~2
if "%sftmshell.mkdir%" equ "" (echo.The syntax of the command is incorrect.
) else if "%sftmshell.mkdir%" equ "\" (echo.The syntax of the command is incorrect.
) else if not defined sftmshell.mkdirname (call sftm /mkdir "%sftmshell.cd%" "%sftmshell.mkdir%"
) else call sftm /mkdir "%sftmshell.cd%" "%sftmshell.mkdir%"
set sftmshell.mkdir=
set sftmshell.mkdirname=
exit /b
:erase
set sftmshell.erase=%~1
if "%sftmshell.erase%" equ "" (echo.The syntax of the command is incorrect.
) else if "%sftmshell.erase%" equ "\" (call sftm /erase ""
) else if "%sftmshell.erase:~0,1%" equ "/" (call sftm /erase "%sftmshell.read%"
) else call sftm /erase "%sftmshell.cd%/%sftmshell.erase%"
set sftmshell.erase=
exit /b
:store
set sftmshell.file=%~1
set sftmshell.folder=%~2
set sftmshell.name=%~3
if not defined sftmshell.name (
	set sftmshell.name=%sftmshell.folder%
	set sftmshell.folder=%sftmshell.cd%
)
if not defined sftmshell.name set "sftm.name=%~nx1"
if "%sftmshell.file%" equ "" (
	echo.The syntax of the command is incorrect.
	exit /b
) else if "%sftmshell.folder%" equ "" (
	echo.The syntax of the command is incorrect.
	exit /b
) else if "%sftmshell.folder%" equ "\" (
	echo.The syntax of the command is incorrect.
	exit /b
) else call sftm /store %sftmshell.file% %sftmshell.folder% %sftmshell.name%