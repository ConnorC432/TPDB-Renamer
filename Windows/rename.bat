@echo off
setlocal enabledelayedexpansion

REM Default directories
set "TV_defaultdir=C:\path\to\testdir"
set "Film_defaultdir=C:\path\to\testdir"

REM Define script directory
set "script_dir=%~dp0"

REM Display help
:Display_help
echo "TPDB to Plex renamer options"
echo "Usage: %~nx0 [OPTIONS] [ARGUMENTS]"
echo.
echo.
echo "Options:"
echo.
echo "[-h|--help]"
echo.
echo.
echo "[-t|-tv] [TV Directory] [Second TV Directory...]"
echo "    Specify the root TV directory(s) to rename"
echo "    Leave empty to rename files in the current directory"
echo.
echo "[-f|-film] [Film Directory] [Second Film Directory...]"
echo "    Specify the root Film directory(s) to rename"
echo "    Leave empty to rename files in the current directory"
echo.
echo "[-d|-default]"
echo "    Rename both TV and Film default directory(s)"
echo.
echo "[-dt|-defaulttv]"
echo "    Rename TV default directory(s)"
echo.
echo "[-df|-defaultfilm]"
echo "    Rename Film default directory(s)"
echo.
echo.
goto :EOF

REM Execute rename scripts
:execute_rename
if /I "%1"=="TV" (
    call "%script_dir\renametv.bat" "%2"
    if "%2"=="./" (
        echo Current directory renamed.
    ) else (
        echo %2 renamed.
    )
) else if /I "%1"=="Film" (
    call "%script_dir\renamefilms.bat" "%2"
    if "%2"=="./" (
        echo Current directory renamed.
    ) else (
        echo %2 renamed.
    )
) else (
    echo Error: Unknown directory type.
)
goto :EOF

REM Directory array rename function
:rename_array
set "dir_type=%1"
shift
set "input_array=%*"
for %%I in (%input_array%) do (
    if exist "%%I" (
        if exist "%%I\" (
            echo Renaming %%I
            call :execute_rename !dir_type! "%%I"
        ) else (
            echo %%I is not a valid directory.
        )
    ) else (
        echo %%I is not a valid directory.
    )
)
goto :EOF

REM Check for no options
if "%~#"=="0" (
    echo Unknown usage: use -h or --help
    exit /B 1
)

REM Check options
:parse_options
set "tv_used=false"
set "film_used=false"
:parse_loop
if /I "%~1"=="-h" goto Display_help
if /I "%~1"=="--help" goto Display_help
if /I "%~1"=="-t" goto parse_tv
if /I "%~1"=="-tv" goto parse_tv
if /I "%~1"=="-f" goto parse_film
if /I "%~1"=="-film" goto parse_film
if /I "%~1"=="-d" goto parse_default
if /I "%~1"=="-dt" goto parse_defaulttv
if /I "%~1"=="-df" goto parse_defaultfilm
echo Unknown usage: use -h or --help
exit /B 1

:parse_tv
set "tv_used=true"
shift
set "tv_dir="
:parse_tv_loop
if "%~1"=="" goto parse_loop
if /I "%~1"=="-f" goto parse_film
if /I "%~1"=="-film" goto parse_film
set "tv_dir=!tv_dir! %1"
shift
goto parse_tv_loop

:parse_film
set "film_used=true"
shift
set "film_dir="
:parse_film_loop
if "%~1"=="" goto parse_loop
if /I "%~1"=="-t" goto parse_tv
if /I "%~1"=="-tv" goto parse_tv
set "film_dir=!film_dir! %1"
shift
goto parse_film_loop

:parse_default
set "tv_used=true"
set "film_used=true"
set "tv_dir=%TV_defaultdir%"
set "film_dir=%Film_defaultdir%"
goto parse_loop

:parse_defaulttv
set "tv_used=true"
set "tv_dir=%TV_defaultdir%"
goto parse_loop

:parse_defaultfilm
set "film_used=true"
set "film_dir=%Film_defaultdir%"
goto parse_loop

REM Rename TV directories
if "%tv_used%"=="true" (
    echo Renaming TV Directories
    call :rename_array "TV" %tv_dir%
)

REM Rename Film directories
if "%film_used%"=="true" (
    echo Renaming Film Directories
    call :rename_array "Film" %film_dir%
)

goto :EOF
