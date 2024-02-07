@echo off
setlocal enabledelayedexpansion
set bboc.args=%*
set bboc.token=0
:main
set /a bboc.token=%bboc.token%+1
set /a bboc.tokenX=%bboc.token%+1
set /a bboc.tokenY=%bboc.tokenX%+1
set /a bboc.tokenZ=%bboc.tokenY%+1
for /f "tokens=%bboc.token%,%bboc.tokenX%,%bboc.tokenY%,%bboc.tokenZ%" %%a in ('set bboc.args') do (
	set bboc.token.[%bboc.token%]=%%a
	if "%%~a" equ "/g" (
		echo./g argument found
		set /a bboc.token.[%bboc.tokenX%]=%%b+2
		set /a bboc.token.[%bboc.tokenY%]=%%c+1
		set /a bboc.token=%bboc.token%+2
	)
)
if defined bboc.token.[%bboc.token%] goto main
set bboc.out=
for /l %%a in (1 1 %bboc.token%) do set bboc.out=!bboc.out! !bboc.token.[%%a]!
call batbox %bboc.out%