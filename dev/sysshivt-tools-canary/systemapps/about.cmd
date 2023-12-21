@echo off
set /a sst.about.mtiX=%sst.defaultresX%/2+7
for %%a in (
	"boxY=1"
	"title=SysShivt tools"
	"args=/buttons"
	"mti=/sst.dir/assets/pack.mti %sst.about.mtiX% 3 16 /sftm"
	"line2=SysShivt tools %sst.ver%"
	"line3=build %sst.build%"
	"line4=[%sst.subvinfo%]"
	"line5=creation date: %sst.builddate%"
	"line7=Logged in as %ls.username:~0,32%."
	"line9=Huge thanks to #batch-man / #thebateam"
	"line10=for providing EXEs."
) do set "sst.window.%%~a"
set sst.window.buttons="Close" "Changelog" "Check for updates"
if "%ls.username%" equ "" set sst.window.line7=Not logged in.
call window.cmd
if "%sst.errorlevel%" equ "1" call txt.cmd "%sst.dir%\assets\changelog.txt"
if "%sst.errorlevel%" equ "2" call update.cmd