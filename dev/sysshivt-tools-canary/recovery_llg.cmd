@echo off
echo.  Loading language. . .
for /f "delims=" %%a in ('type lang.txt ^| find "lang.path="') do set sst.%%a
if not exist "lang\%sst.lang.path%" echo.  - Language file not found.>> "%sst.dir%\recovery.txt"
if exist "lang\%sst.lang.path%" for /f "delims=;" %%a in ('type "lang\%sst.lang.path%"') do set sst.lang.%%a
echo.  Selected language: "%sst.lang.path%"
echo.                     %sst.lang.info%
echo.  Language version: "%sst.lang.format%"
echo.  Language client version: "%sst.lang.clientformat%"
if "%sst.lang.format%" neq "%sst.lang.clientformat%" echo.  - Current language is not supported.>> "%sst.dir%\recovery.txt"