@echo off
if "%sst.time%" neq "%time:~0,-6%" call batbox /c %sst.startmenu.tbfgcolor% /g %sst.startmenu.cl1% %sst.defaultresY% /d "%time:~0,-6%" /g %1 %2
set sst.time=%time:~0,-6%