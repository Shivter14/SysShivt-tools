@echo off
if "%~1" equ "/c" call :%~2
if "%~1" equ "/c" goto end
setlocal enabledelayedexpansion
set shcmd.window.X=2
set shcmd.window.Y=1
set shcmd.window.mode=WINDOW
call :color 0f
call :mode 64 16
:main
if "!cd:~0,%sst.sdir%!" neq "%sst.cd%" cd "%sst.cd%"
call batbox /c 0x%shcmd.window.color% /g %shcmd.cursor.cpoX% %shcmd.cursor.cpoY%
set shcmd.screen.[%shcmd.window.maxY%]=~:!cd:~%sst.sdir%!" /a 62 /d " 
call box %shcmd.window.X% %shcmd.window.Y% %shcmd.window.fulY% %shcmd.window.fulX% - " " %shcmd.window.color% 1
for /l %%a in (0 1 %shcmd.window.maxY%) do call :display %%a
set /p shcmd.input=
set shcmd.screen.[%shcmd.window.maxY%]=!shcmd.screen.[%shcmd.window.maxY%]!%shcmd.input%
for /l %%a in (1 1 %shcmd.window.maxY%) do (
	for /f "" %%b in ('set /a %%a-1') do set shcmd.screen.[%%b]=!shcmd.screen.[%%a]!
	set shcmd.screen.[%%a]=
)
if "%shcmd.input%" equ "exit" goto end
goto main
:display
setlocal enabledelayedexpansion
set /a shcmd.blit=%~1+%shcmd.window.Y%+1
call batbox /g %shcmd.cursor.cpoX% %shcmd.blit% /d "!shcmd.screen.[%~1]!"
goto end
:mode
set /a shcmd.window.maxX=%~1
set /a shcmd.window.maxY=%~2-1
set /a shcmd.window.fulX=%shcmd.window.maxX%+2
set /a shcmd.window.fulY=%shcmd.window.maxY%+3
set shcmd.cursor.posX=0
set shcmd.cursor.posY=%shcmd.window.maxY%
set /a shcmd.cursor.cpoX=%shcmd.window.X%+1+%shcmd.cursor.posX%
set /a shcmd.cursor.cpoY=%shcmd.window.Y%+1+%shcmd.cursor.posY%
call box %shcmd.window.X% %shcmd.window.Y% %shcmd.window.fulY% %shcmd.window.fulX% - " " %shcmd.window.color% 1
goto end
:color
set shcmd.window.color=%~1
:end