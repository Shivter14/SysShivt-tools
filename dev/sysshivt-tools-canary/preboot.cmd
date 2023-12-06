@echo off
if not exist "%sst.dir%\firstboot.cww" goto end
if %sst.crrresX% lss 84 mode 96,%sst.crrresY%
if %sst.crrresY% lss 24 mode %sst.crrresX%,24
for %%a in ("height=9" "title=Welcome to SysShivt tools %sst.ver%" "args=/keystroke" "line2=Welcome to SysShivt tools." "line4=Before you log in for the first time, You" "line5=have to agree to the TOS [Terms Of Service]." "line7=Press any key to show the TOS. . .") do set sst.window.%%~a
call window rem
call txt "%sst.cd%\LICENCE.txt" 84 23
del /q "%sst.dir%\firstboot.cww" > nul
:end