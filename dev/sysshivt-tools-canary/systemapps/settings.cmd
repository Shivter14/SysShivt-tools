@echo off
if not defined sst.build (
	echo.This program reqires SysShivt tools 3.2.p [Pre-release 1]!
	echo.Press any key to exit. . .
	pause>nul
	goto exit
)
:main
set sst.window.title=Settings
set sst.window.args=/keystroke
set sst.window.line2=1   = Language
set sst.window.line3=2   = Open settings file in CWTedit
set sst.window.line4=3   = Change resolution
set sst.window.line5=4   = Change wallpaper
set sst.window.line6=5   = Local account settings
set sst.window.line7=6   = Customization
set sst.window.line8=ESC = Exit
set sst.window.line10=Current resolution: %sst.defaultres%
call window rem
if "%sst.errorlevel%" equ "50" (
	call cwt.cmd "%sst.dir%\settings.cwt"
	goto exit
)
if "%sst.errorlevel%" equ "51" goto changeres
if "%sst.errorlevel%" equ "52" goto changewallpaper
if "%sst.errorlevel%" equ "53" goto account
if "%sst.errorlevel%" equ "54" goto customization
if "%sst.errorlevel%" equ "49" goto lang
if "%sst.errorlevel%" equ "27" goto exit
goto main
:customization
set sst.cuscho.1=1
set sst.cuscho.2=2
if "%sst.desktop.showicons%" equ "False" set sst.cuscho.1=#
if "%sst.UTF-8%" equ "True" set sst.cuscho.2=#
set sst.window.title=Settings
set sst.window.args=/keystroke
set sst.window.line2=Customization Settings
set sst.window.line4=[%sst.cuscho.1%] Hide icons on desktop
set sst.window.line5=[%sst.cuscho.2%] Enable UTF-8 codepage
call window rem
if exist "%sst.temp%\settings.cwt" del "%sst.temp%\settings.cwt"
if "%sst.errorlevel%" equ "49" (
	for /f "delims=;" %%a in ('type settings.cwt ^| find /v "[2\4]"') do echo.%%a>> "%sst.temp%\settings.cwt"
	if "%sst.desktop.showicons%" equ "False" (
		set sst.desktop.showicons=True
		echo.[2\4] desktopicons True>> "%sst.temp%\settings.cwt"
		del "%sst.dir%\settings.cwt"
		xcopy /Q /K "%sst.temp%\settings.cwt" "%sst.dir%\*"
	) else (
		set sst.desktop.showicons=False
		echo.[2\4] desktopicons False>> "%sst.temp%\settings.cwt"
		del "%sst.dir%\settings.cwt"
		xcopy /Q /K "%sst.temp%\settings.cwt" "%sst.dir%\*"
	)
)
goto main
:account
for %%a in (
	"title=Settings"
	"args=/keystroke"
	"line2=Local account settings"
	"line4=  [System Account]"
	"line6=1   = Delete this local account"
	"line7=2   = Change the name/password"
	"line8=ESC = Exit"
) do set "sst.window.%%~a"
if defined ls.username set "sst.window.line4=  %ls.username:~-40%"
call window rem
if "%sst.errorlevel%" equ "49" goto account:delete
if "%sst.errorlevel%" equ "50" rem
if "%sst.errorlevel%" equ "27" goto main
goto account
:account.delete
if "%sst.userprofile%" equ "%sst.dir%\nullprofile" goto account:delete.err
if "%sst.userprofile%" equ "%sst.cd%\users" goto account:delete.err
if "!sst.userprofile:~0,%sst.sdir%!" neq "%sst.cd%" goto account:delete.err
goto account.delete.pass
:account.delete.err
for %%a in ("width=32" "height=6" "title=Settings:account.delete" "args=/keystroke" "line2=Something went wrong." "line4=Press any key to exit. . .") do set "sst.window.%%~a"
call window rem
goto main
:account.delete.pass
for %%a in (
	"title=Settings"
	"args=/keystroke"
	"line2=Are you sure you want to delete this account?"
	"line4=Y / 1   = Confirm"
	"line5=N / ESC = Cancel"
	"line7=[You will have to enter your password first]"
) do set "sst.window.%%~a"
call window rem
if "%sst.errorlevel%" neq "121" if "%sst.errorlevel%" neq "89" if "%sst.errorlevel%" neq "49" goto account
if not exist "%sst.dir%\nullprofile" md "%sst.dir%\nullprofile"
cd "%sst.dir%\nullprofile"
cd "%sst.userprofile%"
call setres
call "%sst.dir%\login-system.cmd" "SysShivt tools %sst.ver% build %sst.build%"
del /F /S /Q .\* > nul
cd ..
rd /S /Q "%sst.userprofile%" > nul
cd "%sst.dir%"
call shutdown.cmd /logoff
goto main
:changeres
set sst.changeres.X=%sst.crrresX%
set sst.changeres.Y=%sst.crrresY%
for %%a in (
	"title=Settings"
	"args=/keystroke"
	"boxX=2"
	"boxY=1"
	"line2=Screen resolution (chars)"
	"line4=Current resoulutin: %sst.crrresX%,%sst.crrresY%"
	"line6=1 = +X, 2 = -X, 3 = +Y, 4 = -Y, 0 = Reset"
	"line11=ESC = back"
) do set "sst.window.%%~a"
call window rem
if "%sst.errorlevel%" equ "27" goto main
if "%sst.errorlevel%" equ "48" mode 96,24
if "%sst.errorlevel%" equ "49" set /a sst.changeres.X=%sst.changeres.X%+32
if "%sst.errorlevel%" equ "50" set /a sst.changeres.X=%sst.changeres.X%-32
if "%sst.errorlevel%" equ "51" set /a sst.changeres.Y=%sst.changeres.Y%+8
if "%sst.errorlevel%" equ "52" set /a sst.changeres.Y=%sst.changeres.Y%-8
if %sst.changeres.X% lss 64 set sst.changeres.X=64
if %sst.changeres.Y% lss 16 set sst.changeres.Y=16
if "%sst.changeres.X%,%sst.changeres.Y%" neq "%sst.defaultres%" mode %sst.changeres.X%,%sst.changeres.Y%
call setres /o
call startmenu /display
goto changeres
:changewallpaper
set sst.window.title=Settings
set sst.window.args=/keystroke
set sst.window.line2=1   = Default
set sst.window.line3=2   = Dusk
set sst.window.line4=ESC = Back
call window rem
if "%sst.errorlevel%" equ "27" goto main
if exist "%sst.temp%\settings.cwt" del "%sst.temp%\settings.cwt"
if "%sst.errorlevel%" equ "49" for /f "delims=;" %%a in ('type settings.cwt ^| find /v "[1\6]"') do echo.%%a>> "%sst.temp%\settings.cwt"
if "%sst.errorlevel%" equ "49" (
	echo.[1\6] wallpapername default>> "%sst.temp%\settings.cwt"
	del "%sst.dir%\settings.cwt"
	xcopy /Q /K "%sst.temp%\settings.cwt" "%sst.dir%\*"
)
if "%sst.errorlevel%" equ "49" set sst.wallpaper.name=default
if "%sst.errorlevel%" equ "50" for /f "delims=;" %%a in ('type settings.cwt ^| find /v "[1\6]"') do echo.%%a>> "%sst.temp%\settings.cwt"
if "%sst.errorlevel%" equ "50" (
	echo.[1\6] wallpapername dusk>> "%sst.temp%\settings.cwt"
	del "%sst.dir%\settings.cwt"
	xcopy /Q /K "%sst.temp%\settings.cwt" "%sst.dir%\*"
)
if "%sst.errorlevel%" equ "50" set sst.wallpaper.name=dusk
call setres
goto changewallpaper
:lang
call setres /d
color f0
cls
call batbox /c 0xf0 /g 0 5
for /f "delims=;" %%a in ('dir /b "%sst.dir%\langs"') do echo.  ^| %%a
call batbox /c 0xf0 /g 2 2 /d "Selected language pack: %sst.lang.info.title%" /g 2 4 /d "Available language packs:" /c 0x0f /g 0 0 /d "  Change  " /c 0x70 /d " Settings - Language " /a 124 /d " Press Ctrl + Y to open start menu "
call cursor
set sst.errorlevel=%errorlevel%
set errorlevel=
if "%sst.mvc.crrY%" equ "0" goto setlang
goto lang
:setlang
cls
color f0
echo.$debug=%sst.errorlevel%
call batbox /g 0 2
echo.
dir /b langs
call batbox /g 0 2 /d "Anavible Language Packs:"
call line 95 23 0 23 0 f0
call batbox /c 0xf0 /d " Type language pack name: "
cd "%sst.dir%\langs"
set sst.lang.oldpath=%sst.lang.path%
set /p "sst.lang.path=> "
cd "%sst.dir%"
echo.lang.path=%sst.lang.path%> "%sst.dir%\lang.txt"
call loading.cmd ""
call shutdown.cmd /logoff
:exit