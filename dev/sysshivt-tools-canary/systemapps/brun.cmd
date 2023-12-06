@echo off
if "%sst.oup.rank%" neq "Owner" if "%sst.oup.rank%" neq "VIP" if "%sst.oup.rank%" neq "Admin" goto /nopremission
goto \nopremission
:/nopremission
call permgui.cmd Owner Admin VIP
goto exit
:\nopremission
call cmdwiz showcursor 1 25
call setres /d
set sst.sus=
call batbox /g 2 1 /d "Type the path of the program you want to run. . ." /g 2 2 /d "WARNING: This program will not run a program with administrators premissions," /g 2 3 /d "It will only make the program think its running with administrators premissions!" /g 2 4
set /p "sst.sus="
if not exist "%sst.sus%" goto exit
cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "SysShivt tools embeeded client" "%sst.sus%"
:exit