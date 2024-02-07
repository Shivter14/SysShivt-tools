@echo off
setlocal enabledelayedexpansion

REM This Line Algorithm is not created by kvc, but it is created [not completely] and modified by Kvc for making it more simple and
REM Easy to use, and making it more efficient for printing at once using batbox.exe plugin.

REM Created and Modified by Kvc, at 1:05 AM, 23.2.2016
REM For more, visit: www.thebateam.org
REM #TheBATeam

REM Checking for various parameters of the function...
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "-help" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "ver" (echo.1.0&&goto :End)
If /i "%~1" == "" (goto :help)
If /i "%~2" == "" (goto :help)
If /i "%~3" == "" (goto :help)
If /i "%~4" == "" (goto :help)

:Main
set x1=%1
set y1=%2
set x2=%3
set y2=%4
If /i "%~5" == "" (Set _Char=/a 111) Else (
	Set _Temp_Char=%~50123456789
	For /l %%A in (0,1,9) do (Set _Temp_Char=!_Temp_Char:%%A=!)
	IF /i "!_Temp_Char!" == "" (Set _Char=/a %~5) Else (Set _Char=/d %~5)
)
If /i "%~6" == "" (Set _Color=07) Else (Set _Color=%~6)


REM We've used Bresenham's algorithm for this purpose...
set stepy=1
set stepx=1

set /a dx=x2-x1
set /a dy=y2-y1

if %dy% lss 0 set /a "dy=-dy","stepy=-1"
if %dx% lss 0 set /a "dx=-dx","stepx=-1"
 
set /a "dy <<= 1"
set /a "dx <<= 1"
 
if %dx% gtr %dy% (
	set /a "fraction=dy-(dx>>1)"
	set _X=%x1%
	set _Y=%y1%
	set _Line=
	for /l %%x in (%x1%,%stepx%,%x2%) do (
		set "_Line=!_Line!/g !_X! !_Y! !_Char! "
		if !fraction! geq 0 (
			set /a _Y+=stepy
			set /a fraction-=dx
		)
		set /a fraction+=dy
		set /a _X+=stepx
	)
) else (
	set /a "fraction=dx-(dy>>1)"
	set _X=%x1%
	set _Y=%y1%
	set _Line=
	for /l %%y in (%y1%,%stepy%,%y2%) do (
		set "_Line=!_Line!/g !_X! !_Y! !_Char! "
		if !fraction! geq 0 (
			set /a _X+=stepx
			set /a fraction-=dy
		)
		set /a fraction+=dx
		set /a _Y+=stepy
	)
)
If /i "%~7" == "" (batbox /c 0x%_Color% %_Line% /c 0x07) Else (Endlocal && Set "%~7=/c 0x%_Color% %_Line% /c 0x07")
goto :End

:End
Goto :EOF

:Help
Echo.
Echo. This function will simply print a GUI Line on console window.
echo. It will help in making batch files little more advanced and effective.
Echo. This file uses 'batbox.exe' plugin for printing lines fastly on console.
echo.
echo. Syntax: call Line [X1] [Y1] [X2] [Y2] [Char ^| Char Code] [color] [Result]
echo. Syntax: call Line [help ^| /^? ^| -h ^| -help]
echo. Syntax: call Line ver
echo.
echo. Where:-
echo.
echo. X1		: It is the X Co-ordinate of the Starting point of the line.
Echo. Y1		: It is the Y Co-ordinate of the Starting point of the line.
echo. X2		: It is the X Co-ordinate of the Ending point of the line.
Echo. Y2		: It is the Y Co-ordinate of the Ending point of the line.
Echo. Char^|Char_Code : It maybe either Directly the character or the ASCII
Echo.		  Value of the Character.
Echo. Color		: The color of the Line.
Echo. Result		: No need of always specifying this parameter, it is a 
Echo.		  special case parameter.In any case, if you needed the
Echo.		  code of the Line instead of directly printing it on
Echo.		  console, then you can specify this parameter, and the
Echo.		  respective code for the Line will be saved into the
Echo.		  variable named in this parameter...
Echo.
Echo. Example: Call Line 15 15 5 5 111 0a
Echo. Example: Call Line 15 15 5 5 o 0a
Echo. Example: Call Line 15 15 5 5 111 0a _Result
Echo. 
Echo. Now, you can execute the code saved in '_Result' variable, using 'Batbox.exe'
Echo. file...
Echo. www.thebateam.org
Echo. #TheBATeam
Goto :End