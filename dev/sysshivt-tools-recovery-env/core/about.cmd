@echo off
for %%a in (
	"boxY=1"
	"title=SysShivt tools"
	"args=/displayonly"
	"line2=SysShivt tools %sst.ver%"
	"line3=build %sst.build%"
	"line4=[%sst.subvinfo%]"
	"line5=creation date: %sst.builddate%"
	"line7=Logged in as %ls.username:~0,32%."
	"line9=Huge thanks to #batch-man / #thebateam"
	"line10=for providing EXEs."
	"line11=1 = check for updates"
) do set "sst.window.%%~a"
if "%ls.username%" equ "" set sst.window.line7=Not logged in.
call window.cmd rem
set /a sst.about.mtiX=%sst.defaultresX%/2+7
call mti assets\pack.mti %sst.about.mtiX% 3
call cmdwiz showcursor 0
call getinput
set sst.errorlevel=%errorlevel%
call cmdwiz showcursor 1 25
if "%sst.errorlevel%" equ "49" call update.cmd