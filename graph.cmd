@echo off
REM  This is an archive of the random graph project.
:truestart
color 0f
mode 96,25
cls
set sgn.ver=1.0.0
title Shivter's Grapth %sgn.ver%
cls
echo.
echo.  Shivter's Graph version %sgn.ver%
echo.
echo Underscore lines?
choice /c:yn
set sgn.err=%errorlevel%
if "%sgn.err%" equ "1" (
	set sgn.char1=[107m[2m__[0m
	set sgn.char2=[0m[2m__[0m
) else (
	set sgn.char1=[107m[1m  [0m
	set sgn.char2=[8m  [0m
)
set sgn.b=0
set sgn.g=0
set sgn.max=24
echo.
set /p sgn.max=display limit: 
echo.
echo done = skip
set /a sgn.limit=%sgn.max%/24
set /a sgn.max2=%sgn.max%/24*2
set /a sgn.max3=%sgn.max%/24*3
set /a sgn.max4=%sgn.max%/24*4
set /a sgn.max5=%sgn.max%/24*5
set /a sgn.max6=%sgn.max%/24*6
set /a sgn.max7=%sgn.max%/24*7
set /a sgn.max8=%sgn.max%/24*8
set /a sgn.max9=%sgn.max%/24*9
set /a sgn.max10=%sgn.max%/24*10
set /a sgn.max11=%sgn.max%/24*11
set /a sgn.max12=%sgn.max%/24*12
set /a sgn.max13=%sgn.max%/24*13
set /a sgn.max14=%sgn.max%/24*14
set /a sgn.max15=%sgn.max%/24*15
set /a sgn.max16=%sgn.max%/24*16
set /a sgn.max17=%sgn.max%/24*17
set /a sgn.max18=%sgn.max%/24*18
set /a sgn.max19=%sgn.max%/24*19
set /a sgn.max20=%sgn.max%/24*20
set /a sgn.max21=%sgn.max%/24*21
set /a sgn.max22=%sgn.max%/24*22
set /a sgn.max23=%sgn.max%/24*23
set /p sgn.b=1: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
:start
if %sgn.w% geq 24 (
	set sgn.d.24=%sgn.d.24%%sgn.char1%
) else (
	set sgn.d.24=%sgn.d.24%%sgn.char2%
)
if %sgn.w% geq 23 (
	set sgn.d.23=%sgn.d.23%%sgn.char1%
) else (
	set sgn.d.23=%sgn.d.23%%sgn.char2%
)
if %sgn.w% geq 22 (
	set sgn.d.22=%sgn.d.22%%sgn.char1%
) else (
	set sgn.d.22=%sgn.d.22%%sgn.char2%
)
if %sgn.w% geq 21 (
	set sgn.d.21=%sgn.d.21%%sgn.char1%
) else (
	set sgn.d.21=%sgn.d.21%%sgn.char2%
)
if %sgn.w% geq 20 (
	set sgn.d.20=%sgn.d.20%%sgn.char1%
) else (
	set sgn.d.20=%sgn.d.20%%sgn.char2%
)
if %sgn.w% geq 19 (
	set sgn.d.19=%sgn.d.19%%sgn.char1%
) else (
	set sgn.d.19=%sgn.d.19%%sgn.char2%
)
if %sgn.w% geq 18 (
	set sgn.d.18=%sgn.d.18%%sgn.char1%
) else (
	set sgn.d.18=%sgn.d.18%%sgn.char2%
)
if %sgn.w% geq 17 (
	set sgn.d.17=%sgn.d.17%%sgn.char1%
) else (
	set sgn.d.17=%sgn.d.17%%sgn.char2%
)
if %sgn.w% geq 16 (
	set sgn.d.16=%sgn.d.16%%sgn.char1%
) else (
	set sgn.d.16=%sgn.d.16%%sgn.char2%
)
if %sgn.w% geq 15 (
	set sgn.d.15=%sgn.d.15%%sgn.char1%
) else (
	set sgn.d.15=%sgn.d.15%%sgn.char2%
)
if %sgn.w% geq 14 (
	set sgn.d.14=%sgn.d.14%%sgn.char1%
) else (
	set sgn.d.14=%sgn.d.14%%sgn.char2%
)
if %sgn.w% geq 13 (
	set sgn.d.13=%sgn.d.13%%sgn.char1%
) else (
	set sgn.d.13=%sgn.d.13%%sgn.char2%
)
if %sgn.w% geq 12 (
	set sgn.d.12=%sgn.d.12%%sgn.char1%
) else (
	set sgn.d.12=%sgn.d.12%%sgn.char2%
)
if %sgn.w% geq 11 (
	set sgn.d.11=%sgn.d.11%%sgn.char1%
) else (
	set sgn.d.11=%sgn.d.11%%sgn.char2%
)
if %sgn.w% geq 10 (
	set sgn.d.10=%sgn.d.10%%sgn.char1%
) else (
	set sgn.d.10=%sgn.d.10%%sgn.char2%
)
if %sgn.w% geq 9 (
	set sgn.d.9=%sgn.d.9%%sgn.char1%
) else (
	set sgn.d.9=%sgn.d.9%%sgn.char2%
)
if %sgn.w% geq 8 (
	set sgn.d.8=%sgn.d.8%%sgn.char1%
) else (
	set sgn.d.8=%sgn.d.8%%sgn.char2%
)
if %sgn.w% geq 7 (
	set sgn.d.7=%sgn.d.7%%sgn.char1%
) else (
	set sgn.d.7=%sgn.d.7%%sgn.char2%
)
if %sgn.w% geq 6 (
	set sgn.d.6=%sgn.d.6%%sgn.char1%
) else (
	set sgn.d.6=%sgn.d.6%%sgn.char2%
)
if %sgn.w% geq 5 (
	set sgn.d.5=%sgn.d.5%%sgn.char1%
) else (
	set sgn.d.5=%sgn.d.5%%sgn.char2%
)
if %sgn.w% geq 4 (
	set sgn.d.4=%sgn.d.4%%sgn.char1%
) else (
	set sgn.d.4=%sgn.d.4%%sgn.char2%
)
if %sgn.w% geq 3 (
	set sgn.d.3=%sgn.d.3%%sgn.char1%
) else (
	set sgn.d.3=%sgn.d.3%%sgn.char2%
)
if %sgn.w% geq 2 (
	set sgn.d.2=%sgn.d.2%%sgn.char1%
) else (
	set sgn.d.2=%sgn.d.2%%sgn.char2%
)
if %sgn.w% geq 1 (
	set sgn.d.1=%sgn.d.1%%sgn.char1%
) else (
	set sgn.d.1=%sgn.d.1%%sgn.char2%
)
if %sgn.g% gtr 0 goto sgn%sgn.g%
set /p sgn.b=2: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn1
set /p sgn.b=3: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn2
set /p sgn.b=4: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn3
set /p sgn.b=5: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn4
set /p sgn.b=6: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn5
set /p sgn.b=7: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn6
set /p sgn.b=8: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn7
set /p sgn.b=9: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn8
set /p sgn.b=10: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn9
set /p sgn.b=11: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn10
set /p sgn.b=12: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn11
set /p sgn.b=13: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn12
set /p sgn.b=14: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn13
set /p sgn.b=15: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn14
set /p sgn.b=16: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn15
set /p sgn.b=17: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn16
set /p sgn.b=18: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn17
set /p sgn.b=19: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn18
set /p sgn.b=20: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn19
set /p sgn.b=21: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn20
set /p sgn.b=22: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn21
set /p sgn.b=23: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn22
set /p sgn.b=24: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn23
set /p sgn.b=25: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn24
set /p sgn.b=26: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn25
set /p sgn.b=27: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn26
set /p sgn.b=28: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn27
set /p sgn.b=29: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn28
set /p sgn.b=30: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn29
set /p sgn.b=31: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn30
set /p sgn.b=32: 
if "%sgn.b%" equ "done" goto done
set /a sgn.w=%sgn.b%/%sgn.limit%
set /a sgn.g=%sgn.g%+1
goto start
:sgn31
:done
set /a sgn.max=%sgn.max%
set /a sgn.limit=%sgn.limit%
cls
echo.%sgn.d.24% - %sgn.max%
echo.%sgn.d.23% - %sgn.max23%
echo.%sgn.d.22% - %sgn.max22%
echo.%sgn.d.21% - %sgn.max21%
echo.%sgn.d.20% - %sgn.max20%
echo.%sgn.d.19% - %sgn.max19%
echo.%sgn.d.18% - %sgn.max18%
echo.%sgn.d.17% - %sgn.max17%
echo.%sgn.d.16% - %sgn.max16%
echo.%sgn.d.15% - %sgn.max15%
echo.%sgn.d.14% - %sgn.max14%
echo.%sgn.d.13% - %sgn.max13%
echo.%sgn.d.12% - %sgn.max12%
echo.%sgn.d.11% - %sgn.max11%
echo.%sgn.d.10% - %sgn.max10%
echo.%sgn.d.9% - %sgn.max9%
echo.%sgn.d.8% - %sgn.max8%
echo.%sgn.d.7% - %sgn.max7%
echo.%sgn.d.6% - %sgn.max6%
echo.%sgn.d.5% - %sgn.max5%
echo.%sgn.d.4% - %sgn.max4%
echo.%sgn.d.3% - %sgn.max3%
echo.%sgn.d.2% - %sgn.max2%
echo.%sgn.d.1% - %sgn.limit%
timeout 1 /nobreak > nul
pause>nul
set sgn.d.1=
set sgn.d.2=
set sgn.d.3=
set sgn.d.4=
set sgn.d.5=
set sgn.d.6=
set sgn.d.7=
set sgn.d.8=
set sgn.d.9=
set sgn.d.10=
set sgn.d.11=
set sgn.d.12=
set sgn.d.13=
set sgn.d.14=
set sgn.d.15=
set sgn.d.16=
set sgn.d.17=
set sgn.d.18=
set sgn.d.19=
set sgn.d.20=
set sgn.d.21=
set sgn.d.22=
set sgn.d.23=
set sgn.d.24=
goto truestart
