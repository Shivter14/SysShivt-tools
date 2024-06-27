@echo off
REM DEPRECATED - Only for archive / backward compatibility use
title Shivter's login system v1.0.1
if "%~1%" neq "" (
	title %~1% [Shivter's login system v1.0.1]
)
color 0f
if "%~3%" neq "" (
color %~3%
)
set ls.wait=
set login-system=0
mode 64,18
if "%~2%" neq "" (
	mode %~2%
)
cls
set ls.attempts=10
if "%~4%" neq "" (
	set ls.attempts=%~4%
)
:ls-start
if exist ls-password.cmd (
	call ls-password.cmd
) else (
	set ls.changepass=1
	set ls.username=%username%
	cls
	echo.
	echo.  Welcome.
	echo.  Create new user name.
	echo.
	set /p ls.username=
)
set ls.password=
set ls.numbers=0
set ls.display=
set ls.login=
set ls.errorlevel=
set errorlevel=
:ls-login
cls
echo.
echo.  Welcome, %ls.username%.
echo.
echo.  Enter your password.
echo.
echo.  %ls.display%
getinput
set ls.errorlevel=%errorlevel%
set errorlevel=
if %ls.errorlevel% leq 0 goto ls-login
if %ls.errorlevel% equ 13 goto ls-vertify
set /a ls.numbers=%ls.numbers%+1
if %ls.numbers% geq 60 goto ls-login
set ls.display=%ls.display%*
if "%ls.login%" equ "" (
	set ls.login=%ls.errorlevel%
) else (
	set ls.login=%ls.login%-%ls.errorlevel%
)
goto ls-login
:ls-vertify
if exist ls-password.cmd (
	call ls-password.cmd
) else (
	set ls.password=%ls.login%
	echo @set ls.username=%ls.username%>ls-password.cmd
	echo @set ls.password=%ls.login%>>ls-password.cmd
)
if "%ls.password%" neq "%ls.login%" (
	cls
	echo.
	echo.  Wrong password! Remaining attempts: %ls.attempts%
	echo.
	set /a ls.attempts=%ls.attempts%-1
	if %ls.attempts% leq 0 (
		goto ls-noattempts
	)
	pause
	goto ls-start
)
set login-system=0
if "%ls.changepass%" equ "1" goto ls-end
cls
echo.
echo.  Correct password!
echo.
pause
goto ls-end
:ls-noattempts
if "%ls.wait%" equ "" (
	set ls.wait=100
	if "%~5%" neq "" (
		set ls.wait=%~5%
	)
)
cls
echo.
echo.  Wrong password! You have no remaining attempts!
echo.  You have to wait %ls.wait% seconds to continue. . .
echo.
timeout 1 /nobreak > nul
set /a ls.wait=%ls.wait%-1
if %ls.wait% gtr 0 goto ls-noattempts
set ls.wait=
set ls.attempts=10
if "%~4%" neq "" (
	set ls.attempts=%~4%
)
goto ls-start
:ls-end
cls
echo.
echo.  Do you want to change the password?
echo.
echo.  [ Y / N ]
getinput
set ls.errorlevel=%errorlevel%
set errorlevel=
if %ls.errorlevel% equ 121 (
	del ls-password.cmd
	set ls.changepass=1
	goto ls-start
)
set ls.password=
set ls.login=
set ls.attempts=
set ls.wait=
set ls.numbers=
set ls.display=
cls
set errorlevel=%login-system%
