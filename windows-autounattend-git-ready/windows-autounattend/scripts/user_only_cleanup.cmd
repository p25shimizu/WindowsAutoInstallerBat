@echo off
setlocal

echo === User-only cleanup ===
echo.

REM Ensure "user" exists.
net user user >nul 2>&1
if errorlevel 1 (
    echo ERROR: Local account "user" does not exist.
    pause
    exit /b 1
)

REM Ensure "user" is a local administrator.
net localgroup Administrators user /add >nul 2>&1
if errorlevel 1 (
    REM Japanese Windows may localize the group name.
    net localgroup Administrators >nul 2>&1
    if errorlevel 1 (
        powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
          "$g = Get-LocalGroup -SID 'S-1-5-32-544'; Add-LocalGroupMember -SID $g.SID -Member 'user' -ErrorAction SilentlyContinue"
    )
)

REM Remove only the extra account named "Admin".
REM Do NOT delete the built-in Administrator account.
net user Admin >nul 2>&1
if not errorlevel 1 (
    net user Admin /delete
)

echo.
echo Current local users:
net user
echo.
echo Done. Sign in with "user" before running this if you are currently using "Admin".
pause
