@echo off
if not defined sst.build (
	This program reqires SysShivt tools 3.1.0 or higher! Press any key to exit. . .
	pause>nul
	goto end
)
if %sst.defaultresY% lss 23 (
	call rtltrp.cmd 64 24
	goto end
)
if %sst.defaultresX% lss 63 (
	call rtltrp.cmd 64 24
	goto end
)
set /a sst.clock.boxX=%sst.defaultresX%-46
set /a sst.clock.boxY=%sst.defaultresY%-23
set /a sst.clock.time=%sst.defaultresY%-3
set /a sst.clock.date=%sst.defaultresY%-2
set /a sst.clock.choX=%sst.defaultresX%-44
set /a sst.clock.note=%sst.defaultresY%-22
call box %sst.clock.boxX% %sst.clock.boxY% 23 46 - " " %sst.startmenu.tbfgcolor:~2%
call batbox /c %sst.startmenu.tbfgcolor%
call cmdwiz setcursorpos %sst.clock.choX% %sst.clock.time%
echo.%time:~0,-6%
call cmdwiz setcursorpos %sst.clock.choX% %sst.clock.date%
echo.%date%
if not exist "%sst.dir%\badshutdown.cmd" goto /pcr.badshutdown
goto \pcr.badshutdown
:/pcr.badshutdown
call batbox /c %sst.startmenu.tbfgcolor% /g %sst.clock.choX% %sst.clock.note% /d "Recovery options menu is not installed!"
set /a sst.clock.note=%sst.clock.note%+1
call batbox /c %sst.startmenu.tbfgcolor% /g %sst.clock.choX% %sst.clock.note% /d "Your device might be at risk!"
set /a sst.clock.note=%sst.clock.note%+2
:\pcr.badshutdown
if not exist "%sst.dir%\recovery.cmd" goto /pcr.recovery
if not exist "%sst.dir%\setup.cmd" goto /pcr.recovery
goto \pcr.recovery
:/pcr.recovery
call batbox /c %sst.startmenu.tbfgcolor% /g %sst.clock.choX% %sst.clock.note% /d "Recovery software is not installed!"
set /a sst.clock.note=%sst.clock.note%+1
call batbox /c %sst.startmenu.tbfgcolor% /g %sst.clock.choX% %sst.clock.note% /d "Your device might be at risk!"
set /a sst.clock.note=%sst.clock.note%+2
:\pcr.recovery
if not exist "%sst.cd%\autorun.cmd" goto /pcr.autorun
if not exist "%sst.dir%\sstools.cmd" goto /pcr.autorun
if not exist "%sst.dir%\sstsession.cmd" goto /pcr.autorun
goto \pcr.autorun
:/pcr.autorun
call batbox /c %sst.startmenu.tbfgcolor%
call batbox /c %sst.startmenu.tbfgcolor% /g %sst.clock.choX% %sst.clock.note% /d "Important system file is corrupted!"
set /a sst.clock.note=%sst.clock.note%+1
call batbox /c %sst.startmenu.tbfgcolor% /g %sst.clock.choX% %sst.clock.note% /d "Do not restart your device!"
set /a sst.clock.note=%sst.clock.note%+1
call batbox /c %sst.startmenu.tbfgcolor% /g %sst.clock.choX% %sst.clock.note% /d "You have to contact software support."
set /a sst.clock.note=%sst.clock.note%+2
:\pcr.autorun
call cursor "%sst.dir%\systemapps\programfiles\shell.cmd"
call setres
call startmenu.cmd /display
:end