@echo off

REM Check if WSL is installed
where wsl >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo WSL is not installed. Please install WSL and try again.
    echo WSL install guide: https://learn.microsoft.com/en-us/windows/wsl/install
    exit /b 1
)

REM Determine current directory
SET currentDir=%~dp0

REM Convert Windows path to Linux-readable path
SET linuxDir=%currentDir:\=/%
SET linuxDir=/mnt/%linuxDir:~0,1%%linuxDir~2%

REM Specify rename script
SET renameScript%linuxDir%/Scripts/rename.sh

REM Pass options and arguments to the Linux script
wsl %renameScript% %*
