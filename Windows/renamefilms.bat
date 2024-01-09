@echo off
setlocal enabledelayedexpansion

REM Function to rename files to "poster"
:rename_to_poster
for %%I in ("%1\*.png" "%1\*.jpg" "%1\*.jpeg") do (
    if exist "%%I" (
        set "base_name=%%~nI"

        REM Exclude renamed files
        echo !base_name! | findstr /r /c:"^poster\.\(png^|jpg^|jpeg^\)$" > nul
        if !errorlevel! equ 0 (
            goto :continue
        )

        set "new_name=poster.!base_name:~ -1!"

        REM Rename the file
        ren "%%I" "!new_name!"
    )
    :continue
)

REM Check if a base directory is provided as a command-line argument
if "%1" == "" (
    set "base_dir=."
) else (
    set "base_dir=%1"
)

REM Loop through each directory in the base directory and call the function
for /D %%D in ("%base_dir%\*") do (
    call :rename_to_poster "%%D"
)
