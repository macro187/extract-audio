@echo off
setlocal
set here="%~dp0"


echo.
type "%here%readme.md"
echo.


echo.
echo ===^> Locating tools
set ffmpeg=%ProgramFiles%\ffmpeg\bin\ffmpeg.exe
if not exist "%ffmpeg%" (
    echo ffmpeg not found
    goto :Error
)
echo ffmpeg = "%ffmpeg%"

set ffprobe=%ProgramFiles%\ffmpeg\bin\ffprobe.exe
if not exist "%ffprobe%" (
    echo ===^> ffprobe not found
    goto :Error
)
echo ffprobe = "%ffprobe%"


echo.
echo ===^> Examining ^<inpath^>
set "inpath=%~1"
if not defined inpath (
    echo No ^<inpath^> specified
    goto :Error
)
if not exist "%inpath%" (
    echo ^<inpath^> "%inpath%" not found
    goto :Error
)
for /f "usebackq delims=" %%i in ('"%inpath%"') do @set "outfilebase=%%~ni"
echo ^<inpath^> = "%inpath%"
echo outfilebase = "%outfilebase%"


echo.
echo ===^> Examining audio streams in input file
set ismp3=
set isaac=
set "inpathtmp=%inpath%"
set "inpathtmp=%inpathtmp:)=^)%"
set "inpathtmp=%inpathtmp:&=^&%"
set "inpathtmp=%inpathtmp:,=^,%"
set "inpathtmp=%inpathtmp: =^ %"
for /F "usebackq tokens=1,* delims==" %%i IN (`""%ffprobe%" -loglevel 0 -show_streams "%inpathtmp%""`) DO @(
if "%%i"=="codec_name" echo %%i=%%j
if "%%i=%%j"=="codec_name=mp3" set ismp3=1
if "%%i=%%j"=="codec_name=aac" set isaac=1
)
if defined ismp3 (
    echo Found MP3 audio stream
    goto :DetectEnd
)
if defined isaac (
    echo Found AAC audio stream
    goto :DetectEnd
)
echo No recognised audio streams found
goto :Error
:DetectEnd


echo.
echo ===^> Determining full output path
if defined isaac (
set "outpath=%userprofile%\Music\%outfilebase%.m4a"
goto :OutPathEnd
)
set "outpath=%userprofile%\Music\%outfilebase%.mp3"
:OutPathEnd
echo outpath = "%outpath%"
if exist "%outpath%" (
    echo outpath "%outpath%" already exists
    goto :Error
)


if defined ismp3 (
    echo.
    echo ===^> Extracting MP3 audio
    echo on
    "%ffmpeg%" -loglevel 1 -stats -i "%inpath%" -map_metadata 0 -vn -acodec copy "%outpath%"
    @echo.
    @if %errorlevel% neq 0 goto :Error
    @echo off
    goto :End
)


if defined isaac (
    echo.
    echo ===^> Extracting AAC audio
    echo on
    "%ffmpeg%" -loglevel 1 -stats -i "%inpath%" -map_metadata 0 -vn -acodec copy "%outpath%"
    @echo.
    @if %errorlevel% neq 0 goto :Error
    @echo off
    goto :End
)


echo.
echo ===^> Extracting and converting audio to MP3
echo on
"%ffmpeg%" -loglevel 1 -stats -i "%inpath%" -vn -map_metadata 0 -f mp3 -ar 44100 -ac 2 -q:a 1 "%outpath%"
@echo.
@if %errorlevel% neq 0 goto :Error
@echo off


:End
echo.
echo ===^> Done
::pause
exit /b 0


:Error
@echo off
echo.
echo ===^> Error
pause
exit /b 1

