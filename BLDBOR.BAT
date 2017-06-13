@echo off
cd\
cd cst250\lab3
path c:\borlandc\BIN;%path%
pause
tasm /la /zi lab3
pause
tlink /v lab3
