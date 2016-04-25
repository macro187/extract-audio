@echo off
setlocal
set here="%~dp0"


echo.
type "%here%readme.md"
echo.


set "rcpath=%userprofile%\_extract-audio-config.cmd"
if exist "%rcpath%" (
    echo.
    echo ===^> Sourcing %rcpath%
    call "%rcpath%"
)


echo.
echo ===^> Locating tools
if not defined ffmpeg (
    set ffmpeg=%ProgramFiles%\ffmpeg\bin\ffmpeg.exe
)
if not exist "%ffmpeg%" (
    echo ffmpeg not found
    goto :Error
)
echo ffmpeg = "%ffmpeg%"

if not defined ffprobe (
    set ffprobe=%ProgramFiles%\ffmpeg\bin\ffprobe.exe
)
if not exist "%ffprobe%" (
    echo ===^> ffprobe not found
    goto :Error
)
echo ffprobe = "%ffprobe%"


echo.
echo ===^> Locating output directory
if not defined outdir (
    set "outdir=%userprofile%\Music"
)
echo outdir = "%outdir%"
if not exist "%outdir%" (
    echo outdir not found
    goto :Error
)


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
set isopus=
set isvorbis=
set "inpathtmp=%inpath%"
set "inpathtmp=%inpathtmp:)=^)%"
set "inpathtmp=%inpathtmp:&=^&%"
set "inpathtmp=%inpathtmp:,=^,%"
set "inpathtmp=%inpathtmp: =^ %"
for /F "usebackq tokens=1,* delims==" %%i IN (`""%ffprobe%" -loglevel 0 -show_streams "%inpathtmp%""`) DO @(
if "%%i"=="codec_name" echo %%i=%%j
if "%%i=%%j"=="codec_name=mp3" set ismp3=1
if "%%i=%%j"=="codec_name=aac" set isaac=1
if "%%i=%%j"=="codec_name=opus" set isopus=1
if "%%i=%%j"=="codec_name=vorbis" set isvorbis=1
)
if defined ismp3 (
    echo Found MP3 audio stream
    goto :DetectEnd
)
if defined isaac (
    echo Found AAC audio stream
    goto :DetectEnd
)
if defined isopus (
    echo Found OPUS audio stream
    goto :DetectEnd
)
if defined isvorbis (
    echo Found Vorbis audio stream
    goto :DetectEnd
)
echo No recognised audio streams found
goto :Error
:DetectEnd


echo.
echo ===^> Determining full output path
set "convert="
if defined ismp3 (
    set "outpath=%outdir%\%outfilebase%.mp3"
    goto :OutPathEnd
)
if defined isaac (
    set "outpath=%outdir%\%outfilebase%.m4a"
    goto :OutPathEnd
)
if defined isopus (
    set "outpath=%outdir%\%outfilebase%.mka"
    goto :OutPathEnd
)
if defined isvorbis (
    set "outpath=%outdir%\%outfilebase%.oga"
    goto :OutPathEnd
)
set convert=Y
set "outpath=%outdir%\%outfilebase%.mp3"
:OutPathEnd
echo convert = "%convert%"
echo outpath = "%outpath%"
if exist "%outpath%" (
    echo outpath "%outpath%" already exists
    goto :Error
)


if not defined convert (
    echo.
    echo ===^> Extracting audio stream
    echo on
    "%ffmpeg%" -loglevel 1 -stats -i "%inpath%" -map_metadata 0 -vn -acodec copy "%outpath%"
    @echo.
    @if %errorlevel% neq 0 goto :Error
    @echo off
    goto :End
)


echo.
echo ===^> Extracting and converting audio stream
echo on
"%ffmpeg%" -loglevel 1 -stats -i "%inpath%" -vn -map_metadata 0 -f mp3 -ar 44100 -ac 2 -q:a 1 "%outpath%"
@echo.
@if %errorlevel% neq 0 goto :Error
@echo off
goto :End


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

