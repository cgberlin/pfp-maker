@if (@CodeSection == @Batch) @then

:: based on fchooser2.bat
:: https://stackoverflow.com/a/15906994/1683264

@echo off
setlocal

if "%~1"=="" (
    call :chooser dir || goto usage
) else if exist "%~1" (
    set "dir=%~1"
) else goto usage


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

:chooser <var_to_set>
setlocal
for /f "delims=" %%I in ('cscript /nologo /e:jscript "%~f0"') do (
    if not "%%~I"=="" if exist "%%~I" (
        endlocal & set "%~1=%%~I"
        exit /b 0
    )
)
exit /b 1

:usage
echo Usage: %~nx0 [directory]
goto :EOF

@end
// JScript portion

var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0, "Please choose a folder.", 0, 0x00);
WSH.Echo(folder ? folder.self.path : '');