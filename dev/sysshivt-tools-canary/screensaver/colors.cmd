@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.0.2 or higher
	pause>nul
	goto end
)
set rgbm=1
for /l %%a in (1 1 %rgbm%) do call :main
goto end
:main
setlocal
call batbox /g 0 %sst.defaultresY%
for /l %%a in (0 %rgbm% 255) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=%%a
	set /a sst.rgby=0
	set /a sst.rgbz=0
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
for /l %%a in (0 %rgbm% 255) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=255
	set /a sst.rgby=%%a
	set /a sst.rgbz=0
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
for /l %%a in (255 -%rgbm% 0) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=%%a
	set /a sst.rgby=255
	set /a sst.rgbz=0
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
for /l %%a in (0 %rgbm% 255) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=0
	set /a sst.rgby=255
	set /a sst.rgbz=%%a
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
for /l %%a in (255 -%rgbm% 0) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=0
	set /a sst.rgby=%%a
	set /a sst.rgbz=255
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
for /l %%a in (0 %rgbm% 255) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=%%a
	set /a sst.rgby=0
	set /a sst.rgbz=255
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
for /l %%a in (0 %rgbm% 255) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=255
	set /a sst.rgby=%%a
	set /a sst.rgbz=255
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
for /l %%a in (255 -%rgbm% 0) do (
	if exist "%temp%\screensaverexit.cww" exit
	set /a sst.rgbx=%%a
	set /a sst.rgby=%%a
	set /a sst.rgbz=%%a
	echo.[48;2;!sst.rgbx!;!sst.rgby!;!sst.rgbz!m
)
endlocal
:end