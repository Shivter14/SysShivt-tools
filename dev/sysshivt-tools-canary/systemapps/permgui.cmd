@echo off
set sst.window.title= SysShivt account reqired to run this program
set sst.window.args=/keystroke
set sst.window.line2=You need to be logged in to a
set sst.window.line3=SysShivt account to run this program.
set sst.window.line4=And the SysShivt account needs to have
set sst.window.line5=one of the following ranks:
if "%~1" neq "" set sst.window.line6=  "%~1"
if "%~2" neq "" set sst.window.line7=  "%~2"
if "%~3" neq "" set sst.window.line8=  "%~3"
if "%~4" neq "" set sst.window.line9=  "%~4"
if "%~5" neq "" set sst.window.line10=  "%~5"
call window.cmd rem