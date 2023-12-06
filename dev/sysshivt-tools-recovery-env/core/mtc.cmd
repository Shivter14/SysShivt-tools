@echo off
set sst.mvc.crrX=2
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
if "%sst.mvc.crrX%" equ "" set sst.mvc.crrX=0