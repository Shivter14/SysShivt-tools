@echo off
:start
set sst.bsd.bg=E8F0
color 0F
cls
echo.Please wait. . .
set sst.bsd.head= 
for /f "tokens=2" %%a in ('mode con ^| find "Columns:"') do for /l %%b in (38 1 %%a) do for /f "tokens=2 delims==" %%c in ('set sst.bsd.head') do set sst.bsd.head=%%c 
cls
echo.[7m  SysShivt tools emergency options  %sst.bsd.head%[0m[1m
for %%a in ("" "Use arrow keys or the mouse scroll wheel to navigate," "and press ENTER to confirm." "You can also select the task with your mouse." "Pick a task:" "") do echo.  %%~a
cmdmenusel.exe %sst.bsd.bg% "     Start SysShivt tools normally" "     Open logs" "     Start SysShivt tools in safe mode" "     Exit SysShivt tools" "     Open console" "     Start SysShivt tools recovery" "     Edit boot menu" "     Restart" "     Open boot menu"
set sst.bsd=%errorlevel%
set errorlevel=
if "%sst.bsd%" equ "9" (
	set sst.boot.entermenu=True
	echo.> "%sst.dir%\enterbootmenu.cww"
	goto end
)
if "%sst.bsd%" equ "8" (
	if defined ssvm.ver (
		echo.> "%ssvm.dir%\SSVMreboot.txt"
		exit
	) else (
		color 0f
		mode 96,24
		cls
		for %%a in (
			"Failed to restart the system:" "This option is only avaliable in SSVM mode."
		) do echo.  %%~a
		goto start
	)
)
if "%sst.bsd%" equ "7" goto ebm
if "%sst.bsd%" equ "6" goto recovery
goto \ebm
:ebm
color 0f
cls
for %%a in (
	""
	"Select a line to edit:"
	"[0 = cancel]"
	"Number : Path : Description"
	""
) do echo.  %%~a
for /f "tokens=1,2,3" %%a in ('type "%sst.cd%\boot.cwt" ^| find "[0\"') do call :ebm.ls "%%~a" "%%~b" "%%~c"
goto \ebm.ls
:ebm.ls
set sst.bsd.list.int=%~1
set sst.bsd.list.path=%~2
set sst.bsd.list.name=%~3
echo.  %sst.bsd.list.int:~3,1% : %sst.bsd.list.path:~0,24% : %sst.bsd.list.name:~0,64%
goto trueexit
:\ebm.ls
choice /c:1234567890 > nul
set sst.bsd.ebm.int=%errorlevel%
if "%sst.bsd.ebm.int%" equ "10" goto start
echo.WARNING: Do not use spaces.
call batbox /d "Action [1 = Delete, 2 = Edit, 3 = Cancel]> "
choice /c:123 > nul
set sst.bsd.ebm.action=%errorlevel%
if "%sst.bsd.ebm.action%" equ "3" goto ebm
echo.
if "%sst.bsd.ebm.action%" equ "2" set /p "sst.bsd.ebm.path=Filename> "
if "%sst.bsd.ebm.action%" equ "2" set /p "sst.bsd.ebm.name=Description> "
if "%sst.bsd.ebm.action%" equ "2" set /p "sst.bsd.ebm.dir=Directory> "
if exist "temp\boot.cwt" del temp\boot.cwt"
for /f "delims=" %%a in ('type "%sst.cd%\boot.cwt" ^| find /v "[0\%sst.bsd.ebm.int%]"') do echo.%%a>> "temp\boot.cwt"
del "%sst.root%\boot.cwt"
if "%sst.bsd.ebm.action%" equ "2" echo.[0\%sst.bsd.ebm.int%] %sst.bsd.ebm.path% %sst.bsd.ebm.name% %sst.bsd.ebm.dir%>> "temp\boot.cwt"
xcopy /Q /K "temp\boot.cwt" "%sst.cd%\*"
goto start
:\ebm
goto \recovery
:recovery
call recovery.cmd
if "%sst.errorlevel%" neq "4" goto start
:\recovery
if "%sst.bsd%" equ "5" (
	start cmd /c cmdline.cmd
	goto start
)
if "%sst.bsd%" equ "4" (
	exit
)
if "%sst.bsd%" equ "3" set sst.safemode=true
if "%sst.bsd%" equ "2" (
	start log.txt
	goto start
)
:end
set sst.bsd.bg=E8F0
color 0F
cls
:trueexit