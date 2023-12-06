@echo off
REM BATINFO;SST;831;SysShivt tools 3.1.1 - 3.1.4 login system;2.1;Shivter
if defined sst.build (
	if %sst.build% lss 831 (
		echo.This program reqires SysShivt tools version 3.1.1 or higher. Press any key to exit. . .
		pause>nul
		goto end
	)
) else (
	echo.This program reqires SysShivt tools 3.1.1 or higher. Press any key to exit. . .
	pause>nul
	goto end
)
set ls.wait=
set login-system=0
set ls.attempts=10
if "%~2%" neq "" (
	set ls.attempts=%~2
)
set /a ls.loginboxX=%sst.defaultresX%/2-45
set /a ls.loginboxY=%sst.defaultresX%/2+46
set /a ls.loginboxZ=%sst.defaultresY%-1
:ls-start
if exist ls-password.cmd (
	call ls-password.cmd
	goto ls-found
)
set ls.changepass=1
set ls.username=%username%
for %%a in ("height=8" "title=Log in" "args=/getinput" "line2=Welcome!" "line4=Create a new username.") do set "sst.window.%%~a"
call window rem
set ls.username=%sst.errorlevel%
:ls-found
set ls.password=
set ls.numbers=0
set ls.display=
set ls.login=
set ls.errorlevel=0
set errorlevel=
:ls-login
if exist ls-pasword.cmd call ls-password.cmd
if "%ls.changepass%" neq "1" if "%ls.pasword%" equ "" goto ls-correct
for %%a in ("height=8" "title=Log in" "args=/displayonly" "line2=Welcome, %ls.username%." "line4=Enter your password.") do set "sst.window.%%~a"
call window rem
:ls-loginbox
if "%ls.errorlevel%" equ "8" (
	set ls.numbers=0
	set ls.display=
	set ls.login=
)
call line %ls.loginboxY% %ls.loginboxZ% %ls.loginboxX% %ls.loginboxZ% 0 70
call batbox /c 0x70 /d "%ls.display%"
call cmdwiz showcursor 1 25
call getinput
set ls.errorlevel=%errorlevel%
set errorlevel=
call cmdwiz showcursor 0
call line %ls.loginboxY% %ls.loginboxZ% %ls.loginboxX% %ls.loginboxZ% 0 70
call batbox /c 0x70 /d "%ls.display%" /a %ls.errorlevel%
if %ls.errorlevel% leq 0 goto ls-loginbox
if %ls.errorlevel% geq 368 if %ls.errorlevel% leq 379 goto ls-loginbox
if "%ls.errorlevel%" equ "13" goto ls-vertify
for %%a in ("27" "13" "292" "291" "302" "9" "249" "2" "239" "243") do if "%ls.errorlevel%" equ "%%~a" goto ls-loginbox
set /a ls.numbers=%ls.numbers%+1
if %ls.numbers% geq 64 goto ls-loginbox
set ls.display=%ls.display%#
if "%ls.login%" equ "" (
	set ls.login=%ls.errorlevel%
) else (
	set ls.login=%ls.login%-%ls.errorlevel%
)
goto ls-loginbox
:ls-vertify
if exist ls-password.cmd (call ls-password.cmd
) else (
	set ls.password=%ls.login%
	echo.@set ls.username=%ls.username%>ls-password.cmd
	echo.@set ls.password=%ls.login%>>ls-password.cmd
)
if "%ls.password%" equ "%ls.login%" goto ls-correct
for %%a in ("title=Log in" "args=/displayonly" "line2=Incorrect password!" "line4=Remaining attempts: %ls.attempts%." "line6=Press any key to continue. . .") do set "sst.window.%%~a"
call window rem
pause>nul
set /a ls.attempts=%ls.attempts%-1
if %ls.attempts% leq 0 goto ls-noattempts
goto ls-start
:ls-correct
set login-system=0
goto ls-end
:ls-noattempts
if "%ls.wait%" equ "" (
	set ls.wait=100
	if "%~5" neq "" set ls.wait=%~5
)
for %%a in ("height=8" "title=Log in" "args=/displayonly" "line2=Incorrect password!" "line4=You have no remaining attempts!" "line6=You have to wait %ls.wait% seconds to continue. . .") do set "sst.window.%%~a"
start /b cmd /c window rem
call cmdwiz delay 920
set /a ls.wait=%ls.wait%-1
if %ls.wait% gtr 0 goto ls-noattempts
set ls.wait=
set ls.attempts=10
if "%~4" neq "" set ls.attempts=%~4
goto ls-start
:ls-end
for %%a in ("height=8" "title=Log in" "args=/keystroke" "line2=Welcome, %ls.username%.") do set "sst.window.%%~a"
if "%ls.password%" neq "" set sst.window.line2=Correct password!
set sst.window.line4=Do you want to change your password?
set sst.window.line6=Y / N
call window rem
set ls.errorlevel=%sst.errorlevel%
if %ls.errorlevel% equ 121 (
	del ls-password.cmd
	set ls.changepass=1
	goto ls-start
)
for %%a in ( "password=" "login=" "attempts=" "wait=" "numbers=" "display=") do set ls.%%~a=
call cmdwiz showcursor 1 25
set errorlevel=%login-system%
:end