@echo off
setlocal

set dir="videos"

for /R "%dir%" %%F in (*.mp4,*.avi,*.flv,*.mov,*.3gp,*.wmv,*.mkv,*.ts) do (
    C:\ffmpeg\ffmpeg-20191004-e6625ca-win64-static\bin\ffmpeg.exe -i "%%~fF" -filter:v scale=128:-1 -c:a copy "%%~dpF%%~nF_conv.mp4"
    C:\ffmpeg\ffmpeg-20191004-e6625ca-win64-static\bin\ffmpeg.exe -i "%%~dpF%%~nF_conv.mp4" -filter:v "setpts=0.015*PTS" "%%~dpF%%~nF.gif"
    if exist "%%~dpF%%~nF.gif" (
        del "%%~dpF%%~nF_conv.mp4"
    )
)

:: end main runtime.  Pause if dragged-and-dropped or double-clicked.
if /i "%cmdcmdline:~0,6%"=="cmd /c" pause
goto :EOF

