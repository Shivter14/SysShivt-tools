@echo off
call :setres
call :header
if not defined ssvm.ver (
	for %%a in (
		"This program reqires to be run in SSVM version 2.4.2 up to"
		"2.5.1 recommended." "" "Press any key to exit. . ."
	) do echo.  %%~a
	pause>nul
	goto exit
)
for %%a in (
	"2.4.2"
	"2.4.3"
	"2.4.4"
	"2.4.5"
	"2.5.0"
	"2.5.1"
) do if "%ssvm.ver%" equ "%%~a" set ssti.ssvm=True
if not defined ssti.ssvm (
	for %%a in (
		"You are using an incompatible version of SSVM: %ssvm.ver%"
		"This program recommends to use SSVM version 2.4.2 up to 2.5.1."
		""
	) do echo.  %%~a
	choice /m "  Do you want to continue"
	if ERRORLEVEL 2 goto exit
	call :setres
	call :header
)
set ssti.ssvm=
call sysshivt-tools\core\displaydvr.exe /g 2 %ssti.bbY%
choice /c xq /t 5 /d x /n /m "Press Q if you want to quit [X = Skip]"
if ERRORLEVEL 2 goto exit
call sysshivt-tools\core\displaydvr.exe /g 2 %ssti.bbY% /d "                                        " /g 2 %ssti.bbY%
:main
call :setres
call :header
for %%a in (
	"Welcome to the SysShivt tools setup."
	"Select the version of SysShivt tools you want to load/install:" "" "    Version	Build	Name"
) do echo.  %%~a
for /f "delims=" %%a in ('dir /b /a:d') do if exist "%%~a\settings.cwt" (
	for /f "tokens=3" %%b in ('type "%%~a\settings.cwt" ^| find "[0\0] ver"') do (
		for /f "tokens=3" %%c in ('type "%%~a\settings.cwt" ^| find "[0\1] build"') do (
			for %%d in ("  %%~b	%%~c	%%~a") do echo.    %%~d
		)
	)
)
echo.
set /p "ssti.insname=  Your choice> "
for /f "tokens=1* delims==" %%a in ('set ssti.insname') do if not exist "%%~b\settings.cwt" (
	choice /t 5 /c xq /d x /n /m "  Your choice is invalid. [X = Ok, Q = Quit]"
	if not ERRORLEVEL 2 goto main
)
cd "%ssti.insname%"
call sstools.cmd /pe
call :setres
call :header
echo.  The system will restart in 10 seconds.
call core\displaydvr.exe /g 2 %ssti.bbY%
choice /c X /t 5 /d x /n /m "[X = Restart]"
goto exit
:header
for %%a in (
	""
	"   SysShivt tools [archived] setup"
	"  ================================="
	""
) do echo.%%~a
goto end
:setres
for /f "tokens=2" %%a in ('mode con ^| find "Columns:"') do set /a ssti.crrX=%%~a
for /f "tokens=2" %%a in ('mode con ^| find "Lines:"') do set /a ssti.crrY=%%~a
if %ssti.crrX% lss 64 (
	set ssti.setres=True
	set ssti.crrX=64
)
if %ssti.crrY% lss 16 (
	set ssti.setres=True
	set ssti.crrY=16
)
color 1f
cls
if defined ssti.setres (
	set ssti.setres=
	mode %ssti.crrX%,%ssti.crrY%
)
set /a ssti.bbY=%ssti.crrY%-2
goto end
:exit
color 07
cls
:end
