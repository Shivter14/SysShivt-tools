@echo off
set /a sst.startmenu.cl1=%sst.defaultresX%-8
set /a sst.startmenu.cl2=%sst.startmenu.cl1%+5
setlocal enabledelayedexpansion
set /a sst.startmenu.tbX=%sst.defaultresX%-2
set /a sst.startmenu.boxY=%sst.defaultresY%-6
set /a sst.startmenu.boxX=%sst.lang.startmenu.width%+1
set /a sst.startmenu.len=%sst.lang.startmenu.width%+%sst.lang.startmenu.lblen%
set /a sst.startmenu.ch1=%sst.defaultresY%-1
set /a sst.startmenu.ch2=%sst.defaultresY%-2
set /a sst.startmenu.ch3=%sst.defaultresY%-3
set /a sst.startmenu.ch4=%sst.defaultresY%-4
set /a sst.startmenu.ch5=%sst.defaultresY%-5
set /a sst.startmenu.ch6=%sst.defaultresY%-6
set /a sst.startmenu.ls=%sst.defaultresY%-7
if "%~1" equ "/display" if "%~2" equ "/t" (
	goto displayT
) else (
	goto display
)
goto \display
:display
call mti assets\taskbar.mti 19 %sst.defaultresY%
call batbox /c %sst.startmenu.tbbtcolor% /g 1 %sst.defaultresY% /d "  SysShivt Tools  " /c %sst.startmenu.tbfgcolor% /g %sst.startmenu.cl1% %sst.defaultresY% /d "%time:~0,-6% []" /g 19 %sst.defaultresY%
setlocal enabledelayedexpansion
for %%a in (%sstenv.tasks.render%) do if "!sstenv.task.[%%~a].hideFromTB!" equ "" call batbox /d " %%~a |"
endlocal
goto exit
:\display
goto \displayT
:displayT
call mti assets\taskbar.mti 19 %sst.defaultresY%
call batbox /c %sst.startmenu.tbbacolor% /g 1 %sst.defaultresY% /d "  SysShivt Tools  " /c %sst.startmenu.tbfgcolor% /g %sst.startmenu.cl1% %sst.defaultresY% /d "%time:~0,-6% []" /g 19 %sst.defaultresY%
setlocal enabledelayedexpansion
for %%a in (%sstenv.tasks.render%) do if "!sstenv.task.[%%~a].hideFromTB!" equ "" call batbox /d " %%~a |"
endlocal
goto exit
:\displayT
echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mSSTMENU[0m[2m] [0m[1mLoading start menu. . . >> "%sst.dir%\log.txt"
:main
set sst.startmenu.exit=
if exist shutdown.txt exit
if exist crashed.txt exit
if exist restart.txt exit
if "%sst.errorlevel%" equ "" set sst.errorlevel=1
call sbox 1 %sst.startmenu.ls% %sst.startmenu.len% 6 0
call sbox 1 %sst.startmenu.boxY% %sst.lang.startmenu.width% 5 %sst.startmenu.tbbgcolor%%sst.startmenu.tbbgcolor%
call batbox /c %sst.startmenu.tbfgcolor% /g 1 %sst.startmenu.ch6% /d "  %sst.lang.startmenu.menu3%" /g 1 %sst.startmenu.ch5% /d "  %sst.lang.startmenu.menu5%" /g 1 %sst.startmenu.ch4% /d "  %sst.lang.startmenu.menu6%" /g 1 %sst.startmenu.ch3% /d "  %sst.lang.startmenu.menu4%" /g 1 %sst.startmenu.ch2% /d "  %sst.lang.startmenu.menu2%" /g 1 %sst.startmenu.ch1% /d "  %sst.lang.startmenu.menu1%"
call batbox /c 0x0f /g %sst.startmenu.boxX% %sst.startmenu.ch5% /d "%sst.lang.shellbutton%" /g %sst.startmenu.boxX% %sst.startmenu.ch4% /d "%sst.lang.aboutbutton%" /g %sst.startmenu.boxX% %sst.startmenu.ch3% /d "%sst.lang.storebutton%" /g %sst.startmenu.boxX% %sst.startmenu.ch2% /d "%sst.lang.setbutton%" /g %sst.startmenu.boxX% %sst.startmenu.ch1% /d "   All programs" /g %sst.startmenu.len% %sst.startmenu.ch1% /a 62 /c 0x06 /g 1 %sst.startmenu.ls% /d "  %ls.username%"
call %0 /display /t
call cursor /startmenu
if "%sst.startmenu.exit%" equ "1" (
	call setres
	goto exit
)
set sst.errorlevel=%errorlevel%
set errorlevel=
if %sst.mvc.crrX% geq 1 (
	if %sst.mvc.crrX% leq %sst.lang.startmenu.width% (
		if "%sst.mvc.crrY%" equ "%sst.startmenu.ch6%" exit
		if "%sst.mvc.crrY%" equ "%sst.startmenu.ch5%" call shutdown.cmd /sleep
		if "%sst.mvc.crrY%" equ "%sst.startmenu.ch4%" call shutdown.cmd /switchuser
		if "%sst.mvc.crrY%" equ "%sst.startmenu.ch3%" call shutdown.cmd /logoff
		if "%sst.mvc.crrY%" equ "%sst.startmenu.ch2%" call shutdown.cmd /restart
		if "%sst.mvc.crrY%" equ "%sst.startmenu.ch1%" call shutdown.cmd
	)
	if %sst.mvc.crrX% geq %sst.startmenu.boxX% if %sst.mvc.crrX% leq %sst.startmenu.len% if "%sst.mvc.crrY%" equ "%sst.startmenu.ch1%" goto list
)
goto \list
:list
set /a sst.list.boxX=37
set sst.list.totalItems=-1
set sst.list.len=0
for /f "tokens=2,3,4" %%a in ('type "%sst.dir%\assets\programs.cwt"') do if "%%~a" neq "list" call :list.getTotalItems "%%~a" "%%~b" "%%~c"
goto \list.getTotalItems
:list.getTotalItems
set sst.list.temp=%~1
set sst.list.tmpp=%~2
set sst.list.tmpe=%~3
set /a sst.list.totalItems=%sst.list.totalItems%+1
set sst.list.i.[%sst.list.totalItems%].name=%sst.list.temp%
set sst.list.i.[%sst.list.totalItems%].path=%sst.list.tmpp%
set sst.list.i.[%sst.list.totalItems%].file=%sst.list.tmpe%
set errorlevel=
call getlen "%sst.list.temp%"
set sst.list.tmpl=%errorlevel%
if %sst.list.tmpl% gtr %sst.list.len% set sst.list.len=%sst.list.tmpl%
goto end
:\list.getTotalItems
setlocal enabledelayedexpansion
set /a sst.list.len=%sst.list.len%+2
set /a sst.list.edg=%sst.list.boxX%+%sst.list.len%
set /a sst.list.boxY=%sst.defaultresY%-%sst.list.totalItems%-1
for /l %%a in (0 1 %sst.list.totalItems%) do set /a sst.list.i.[%%a].Y=%sst.list.boxY%+%%a
set /a sst.list.boxH=%sst.list.totalItems%+1
set /a sst.list.item=%sst.list.boxX%+1
call box %sst.list.boxX% %sst.list.boxY% %sst.list.boxH% %sst.list.len% - " " %sst.window.BGcolor%%sst.window.BGcolor%
for /l %%a in (0 1 %sst.list.totalItems%) do if defined sst.list.i.[%%a].name (
	call batbox /c 0x%sst.window.BGcolor%%sst.window.FGcolor% /g %sst.list.item% !sst.list.i.[%%a].Y! /d "!sst.list.i.[%%a].name!"
)
call cursor
for /l %%a in (0 1 %sst.list.totalItems%) do if %sst.mvc.crrY% equ !sst.list.i.[%%a].Y! if %sst.mvc.crrX% geq %sst.list.boxX% if %sst.mvc.crrX% lss %sst.list.edg% (
	cd "%sst.dir%\!sst.list.i.[%%a].path!"
	call !sst.list.i.[%%a].file!
)
goto exit
:\list
if %sst.mvc.crrX% geq %sst.startmenu.boxX% if %sst.mvc.crrX% leq %sst.startmenu.len% if %sst.mvc.crrY% equ %sst.startmenu.ch5% (
	echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mDESKTOP[0m[2m] [0m[1mLoading TERMINAL. . . >> "%sst.dir%\log.txt"
	call setres /d
	mode %sst.defaultres%
	cmdwiz setcursorpos 0 0
	call shell.cmd
	call setres
	goto exit
)
if %sst.mvc.crrX% geq %sst.startmenu.boxX% if %sst.mvc.crrX% leq %sst.startmenu.len% if %sst.mvc.crrY% equ %sst.startmenu.ch4% (
	echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mDESKTOP[0m[2m] [0m[1mLoading UPDATE. . . >> "%sst.dir%\log.txt"
	call about.cmd
	call setres
	goto exit
)
if %sst.mvc.crrX% geq %sst.startmenu.boxX% if %sst.mvc.crrX% leq %sst.startmenu.len% if %sst.mvc.crrY% equ %sst.startmenu.ch3% (
	echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mDESKTOP[0m[2m] [0m[1mLoading STORE. . . >> "%sst.dir%\log.txt"
	call store.cmd
	call setres
	goto exit
)
if %sst.mvc.crrX% geq %sst.startmenu.boxX% if %sst.mvc.crrX% leq %sst.startmenu.len% if %sst.mvc.crrY% equ %sst.startmenu.ch2% (
	echo.[0m[2m[[0m[94m%date%, %time%[0m[2m] [0m[2m[[0m[96mDESKTOP[0m[2m] [0m[1mLoading SETTINGS. . . >> "%sst.dir%\log.txt"
	call settings.cmd
	call setres
	goto exit
)
:exit
set sst.errorlevel=STARTMENU
:end