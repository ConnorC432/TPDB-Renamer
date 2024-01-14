REM doesnt work
@echo off
setlocal enabledelayedexpansion

REM Function to rename files
:rename_files
for %%F in ("%1\*.jpg" "%1\*.jpeg" "%1\*.png") do (
    if exist "%%F" (
        set "filename=%%~nF"
        set "extension=%%~xF"

        REM Exclude previously renamed files
        echo !filename! | findstr /i /r /c:"\(season-specials-poster^|show^|Season.*^|.*S.*E.*\)\\.\(png^|jpg^|jpeg\)" >nul
        if !errorlevel! equ 0 (
            REM Skip the file if it matches any of the skipping patterns
            echo Not renaming: !filename!!extension!
        ) else (
            REM Check if the file is a Season poster
            echo !filename! | findstr /i /r /c:"(.*) - Season ([0-9]+)\\.\(png^|jpg^|jpeg\)" >nul
            if !errorlevel! equ 0 (
                set "new_name=Season !matches[2]!!extension!"
            ) else (
                REM Check if the file is a Specials poster
                echo !filename! | findstr /i /r /c:"(.*) - Specials\\.\(png^|jpg^|jpeg\)" >nul
                if !errorlevel! equ 0 (
                    set "new_name=season-specials-poster!extension!"
                ) else (
                    REM Assuming it is a Show poster
                    set "new_name=show!extension!"
                )
            )

            REM Rename the file
            ren "%%F" "!new_name!"
            echo Renamed: !filename!!extension! to !new_name!
        )
    )
)
goto :eof

REM Check if a directory argument is provided, otherwise use the current directory
if "%1"=="" (
    set "base_dir=%cd%"
) else (
    set "base_dir=%1"
)

REM Loop through each subdirectory in the base directory and call the function
for /d %%D in ("%base_dir%\*") do (
    call :rename_files "%%D"
)

endlocal
