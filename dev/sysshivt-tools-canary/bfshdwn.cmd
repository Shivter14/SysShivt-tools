@echo off
if "%sst.exitprompt%" neq "True" goto exit
set sst.window.title=Exit Session
set sst.window.args=/keystroke
set sst.window.line2=You are about to exit this session.
set sst.window.line4=Press 1 to open command prompt,
set sst.window.line5=or any other key to continue
call window rem
if "%sst.errorlevel%" equ "49" (
	call setres /d
	call shell.cmd
)
call setres
:exit