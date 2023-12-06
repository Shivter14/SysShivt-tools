@echo off
if not defined sst.build exit /b -1
if %sst.build% lss 0707 exit /b -1
for %%a in ("X" "Y" "W" "H" "E" "B") do set box.%%~a=
set /a box.X=%~1
set /a box.Y=%~2
set /a box.W=%~3
set /a box.H=%~4
set box.C=%~5
set /a box.E=%box.Y%+%box.H%
set "box.B=                                                                                                                                                                                                                                                                "
setlocal enabledelayedexpansion
set /a box.M=%sst.crrresX%-%box.X%
set box.L=!box.L:~0,%box.M%!
set box.B=!box.B:~0,%box.M%!
for /l %%a in (%box.Y% 1 %box.E%) do if %%a leq %sst.defaultresY% call batbox /c 0x%box.C% /g %box.X% %%a /d "!box.B:~0,%box.W%!"
endlocal
for %%a in ("X" "Y" "W" "H" "E" "B") do set box.%%~a=