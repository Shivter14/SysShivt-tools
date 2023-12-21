@echo off
color 0f
mode 96,25
cls
echo.[0m[1m[7m  Emergency options for SysShivt tools                                                          [0m[1m
echo.
call cmdmenusel 0FF0 "          Restart SysShivt tools" "          Shut down" "          Force Exit [ Warning: It will end every batch process! ]" "          Cancel"
set sst.errorlevel=%errorlevel%
if "%sst.errorlevel%" equ "1" call shutdown.cmd /restart
if "%sst.errorlevel%" equ "2" call shutdown.cmd
if "%sst.errorlevel%" equ "3" taskkill /im cmd.exe
:end