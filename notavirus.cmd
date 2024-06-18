@echo off
REM   Warning: This is *not* a virus!
REM   It only does a bit of funny with the CMD window and the cursor.

if "%~1" neq "/b" (
	echo Usage: start /b cmd /c %0 /b
	goto b
)
:a
set /a sst.random=%random:~-1%+%random:~-1%+%random:~-1%
if %sst.random% gtr 24 set sst.random=24
set sst.random2=%random:~-2%
call line %sst.random2% %sst.random% %sst.random2% %sst.random% %random:~-2% %random:~-2%
if exist "%sst.dir%\shutdown.txt" exit
if exist "%sst.dir%\crashed.txt" exit
if exist "%sst.dir%\logoff.txt" exit
if exist "%sst.dir%\restart.txt" exit
call cmdwiz.exe delay 10
call cmdwiz.exe setwindowpos 30%random:~-1% 15%random:~-1%
call cmdwiz.exe setwindowtransparency 1%random:~-1%
call cmdwiz.exe setmousecursorpos 100%random:~-1% 50%random:~-1%
goto a
:b
