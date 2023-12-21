@echo off
setlocal enabledelayedexpansion
set arg=0
set out=
set block=0
:main
for %%a in (%*) do (
	set /a arg=!arg!+1
	if "!block!" equ "0" (
		if "%%~a" equ "/g" (
			set block=2
			set out=!out![
		) else if "%%~a" equ "/c" (
			set block=-1
		) else if "%%~a" neq "/d" set out=!out!%%~a
	) else if "!block!" neq "-1" (
		set block.!block!=%%a
		set /a block=!block!-1
		if "!block!" equ "0" set out=!out!!block.1!;!block.2!H
	) else set block=0
)
echo.%out%
endlocal
:end