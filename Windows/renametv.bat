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
    echo !filename! | findstr /i /r /c:"\(Season .*^|season-specials-poster^|show\)" >nul
    if !errorlevel! equ 0 (
        echo Not renaming: !filename!!extension!
    ) else (
        REM Check if the file is a Season poster
        echo !filename! | findstr /i /r /c:".* Season .*" >nul
        if !errorlevel! equ 0 (
            set "season=!filename:.* Season =!"
            ren "%%F" "Season !season!!extension!"
        ) else (
            REM Check if the file is a Specials poster
            echo !filename! | findstr /i /r /c:".* Specials .*" >nul
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