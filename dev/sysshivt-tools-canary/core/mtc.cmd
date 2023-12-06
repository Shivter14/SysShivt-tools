@echo off
set sst.mvc.crrY=0
:getheight
if %sst.errorlevel% leq -65536 goto setheight
goto nnrheight
:setheight
set /a sst.mvc.crrY=%sst.mvc.crrY%+1
set /a sst.errorlevel=%sst.errorlevel%+65536
goto getheight
:nnrheight
set sst.mvc.crrX=%sst.errorlevel:~1%
if not defined sst.mvc.crrX set sst.mvc.crrX=0
if %sst.mvc.crrX% geq 32768 (
	set /a sst.mvc.crrX=%sst.mvc.crrX%-32768
	exit /b 1
)