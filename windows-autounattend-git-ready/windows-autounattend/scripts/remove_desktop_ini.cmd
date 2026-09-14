@echo off
echo Removing desktop.ini from desktop folders...

del /f /a "%USERPROFILE%\Desktop\desktop.ini" 2>nul
del /f /a "%PUBLIC%\Desktop\desktop.ini" 2>nul

echo.
echo Done.
pause
