@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools. Press any key to exit. . .
	pause>nul
	goto end
)

set run.REM=REM
for /f "tokens=2,3,4,5,6 delims=;" %%c in ('type "%~f1" ^| find "!sst.desktopoptions.REM! BATINFO;"') do (
	set "run.app.type=%%~c"
	set "run.app.build=%%~d"
	set "run.app.info=%%~e"
	set "run.app.ver=%%~f"
	set "run.app.auth=%%~g"
)
if "%run.app.type%" equ "CMD" (
	for %%a in ("width=40" "height=7" "title=Warning!" "args=/keystroke" "line2=You are about to run a legacy batch" "line3=file that is not ment to be run in" "line4=SysShivt tools. Press ESC to exit or" "line5=any other key to continue") do set sst.window.%%~a
	call window rem
	for /f "tokens=1,2 delims==" %%a in ('set sst.errorlevel') do if "%%~a" equ "sst.errorlevel" if "%%~b" equ "27" goto end
)
call %*
:end