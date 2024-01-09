@echo off
setlocal enabledelayedexpansion

REM Function to rename files
:rename_files
for %%I in ("%1\*.png" "%1\*.jpg" "%1\*.jpeg") do (
    if exist "%%I" (
        set "base_name=%%~nI"
        
        REM Exclude renamed files
        echo !base_name! | findstr /r /c:"\(season-specials-poster^|show^|Season.*^|.*S.*E.*\.\(png^|jpg^|jpeg^\)\)$" > nul
        if !errorlevel! equ 0 (
            goto :continue
        )

        REM Check for * - Season *
        echo !base_name! | findstr /r /c:"\(.* - Season \([0-9][0-9]*\)\.\(png^|jpg^|jpeg^\)\)" > nul
        if !errorlevel! equ 0 (
            set "new_name=Season !matches[2]!.!matches[3]!"
            goto :rename
        )

        REM Check for * - Specials
        echo !base_name! | findstr /r /c:"\(.* - Specials\.\(png^|jpg^|jpeg^\)\)" > nul
        if !errorlevel! equ 0 (
            set "new_name=season-specials-poster.!matches[2]!"
            goto :rename
        )

        REM Default to show for other files
        set "new_name=show.!base_name:~ -1!"
        
        :rename
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
    call :rename_files "%%D"
)