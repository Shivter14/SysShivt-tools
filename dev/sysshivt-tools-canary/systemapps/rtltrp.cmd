@echo off
set sst.window.title=Error: Resolution too low
set sst.window.args=/keystroke
set sst.window.height=9
set sst.window.width=40
set sst.window.line2=Failed to run the program:
set sst.window.line3=The screen resolution is too low.
set sst.window.line4=Minimum screen size reqired to run
set sst.window.line5=this program is %~1 by %~2 chars.
set sst.window.line7=Press any key to exit. . .
call window rem
call setres