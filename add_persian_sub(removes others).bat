@echo off
setlocal enabledelayedexpansion

REM Path to ffmpeg (ensure it's in PATH or set the full path)
set "FFMPEG=ffmpeg"

for %%F in ("*.mkv") do (
    set "basename=%%~nF"
    set "tempfile=!basename!_temp.mkv"

    REM Check if matching SRT file exists
    if exist "!basename!.srt" (
        echo Processing: %%F

        REM Remove existing subtitles and add Persian subtitle as default
        %FFMPEG% -i "%%F" -i "!basename!.srt" ^
        -map 0:v -map 0:a -map 1:0 ^
        -c:v copy -c:a copy -c:s srt ^
        -metadata:s:s:0 language=fas -disposition:s:0 default ^
        "!tempfile!"

        REM Replace the original file
        move /Y "!tempfile!" "%%F"
    ) else (
        echo Skipping %%F: No matching .srt file found.
    )
)

echo Done!
pause
