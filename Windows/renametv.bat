@echo off
setlocal enabledelayedexpansion

REM Check if a directory argument is provided, otherwise use the current directory
if "%1"=="" (
    set "target_dir=%cd%"
) else (
    set "target_dir=%1"
)

REM Loop through each subdirectory in the base directory and find image files
for /r "%target_dir%" %%F in (*.jpg *.jpeg *.png) do (
    set "filename=%%~nF"
    set "extension=%%~xF"

    REM Check for previously renamed files
    echo !filename! | findstr /i /r /c:"\(season-specials-poster^|show^|Season.*^|.*S.*E.*\)\.\(png^|jpg^|jpeg\)" >nul
    if !errorlevel! equ 0 (
        echo Skipping: !filename!!extension!
    ) else (
        REM Check if the file is a Season poster
        echo !filename! | findstr /i /r /c:"(.*) - Season ([0-9]+)\.\(png^|jpg^|jpeg\)" >nul
        if !errorlevel! equ 0 (
            set "showname=!matches[1]!"
            set "season=!matches[2]!"
            ren "%%F" "Season !season!!extension!"
        ) else (
            REM Check if the file is a Specials poster
            echo !filename! | findstr /i /r /c:"(.*) - Specials\.\(png^|jpg^|jpeg\)" >nul
            if !errorlevel! equ 0 (
                ren "%%F" "season-specials-poster!extension!"
            ) else (
                REM Assuming it is a Show poster
                ren "%%F" "show!extension!"
            )
        )
    )
)

endlocal