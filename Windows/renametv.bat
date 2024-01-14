@echo off
setlocal enabledelayedexpansion

REM Check if a directory is provided as a command line argument
if "%1"=="" (
    set "target_directory=%CD%"
) else (
    set "target_directory=%1"
)

REM Loop through each directory in the base directory and find image files
for /r "%target_directory%" %%f in (*.jpg *.jpeg *.png) do (
    set "base_name=%%~nxf"
    set "new_name="

    REM Exclude previously renamed files
    echo !base_name! | findstr /R /C:"^((season-specials-poster^|show^|Season.*^|.*S.*E.*)\.\(png^|jpg^|jpeg\))$" >nul 2>&1
    if !errorlevel! equ 0 (
        continue
    )

    REM Determine how to rename files
    echo !base_name! | findstr /R /C:"^.* - Season [0-9][0-9]*\.\(png\|jpg\|jpeg\)$" >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=5 delims=-. " %%a in ("!base_name!") do set "new_name=Season %%a.%%b"
    ) else (
        echo !base_name! | findstr /R /C:"^.* - Specials\.\(png\|jpg\|jpeg\)$" >nul 2>&1
        if !errorlevel! equ 0 (
            set "new_name=season-specials-poster"
        ) else (
            set "new_name=show.!base_name:*.=!"
        )
    )

    REM Rename the file
    if not "!new_name!"=="" ren "%%f" "!new_name!%%~xf"
)