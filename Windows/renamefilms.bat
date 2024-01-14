@echo off
setlocal enabledelayedexpansion

REM Check if a directory is provided as a command line argument
if "%1"=="" (
    set "target_directory=%CD%"
) else (
    set "target_directory=%1"
)

REM Loop through each subdirectory in the base directory and find image files
for /r "%target_directory%" %%f in (*.jpg *.jpeg *.png) do (
    set "base_name=%%~nxf"
    
    REM Exclude previously renamed files
    echo !base_name! | findstr /R /C:"^poster\.\(png^|jpg^|jpeg\)$" >nul 2>&1
    if !errorlevel! equ 0 (
        continue
    )

    REM Rename the file
    ren "%%f" "poster%%~xf"
)