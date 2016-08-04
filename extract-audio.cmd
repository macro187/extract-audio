@echo off
setlocal
set here="%~dp0"


echo.
type "%here%readme.md"
echo.


if "%~1"=="" (
    echo No ^<inpath^> specified
    goto :Error
)


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
echo ===^> Locating outdir
if not defined outdir (
    set "outdir=%userprofile%\Music"
)
if not exist "%outdir%" (
    echo outdir "%outdir%" not found
    goto :Error
)
if /i "%outdir:~0,2%"=="\\" goto :OutDirEnd
echo on
pushd "%outdir%"
@if %errorlevel% neq 0 goto :Error
@set "outdir=%cd%"
popd
@echo off
:OutDirEnd
echo outdir = "%outdir%"


echo.
echo ===^> Locating indir
set "indir=%~dp1"
if not defined indir (
    set "indir=%cd%"
    goto :InDirEnd
)
if /i "%indir:~0,2%"=="\\" goto :InDirEnd
echo on
pushd "%indir%"
@if %errorlevel% neq 0 goto :Error
@set "indir=%cd%"
popd
@echo off
:InDirEnd
echo indir = "%indir%"


echo.
echo ===^> Examining ^<inpath^>
set "infilebase=%~n1"
if "%infilebase%"=="" (
    echo No file in ^<inpath^> "%~1"
    goto :Error
)
set "infile=%~nx1"
set "inpath=%indir%\%infile%"
echo ^<inpath^> = "%inpath%"
echo infilebase = "%infilebase%"
echo infile = "%infile%"


if /i not "%indir%"=="%outdir%" goto :InPlaceEnd

echo.
echo ===^> Looking for original
set "origpathbase=%indir%\__%infilebase%"
set "origpath="
echo on
for /f "delims=" %%i in ('dir /b "%origpathbase%.*"') do set "origpath=%%i"
@echo off
if not defined origpath set "origpath=%indir%\__%infile%"
echo origpathbase = "%origpathbase%"
echo origpath = "%origpath%"


if exist "%origpath%" goto :KeepOrigEnd
echo.
echo ===^> No original found, keeping ^<inpath^> as original
echo on
move "%inpath%" "%origpath%"
@if %errorlevel% neq 0 goto :Error
@echo off
:KeepOrigEnd


if not exist "%inpath%" goto :DeleteInpathEnd
echo.
echo ===^> Removing existing ^<inpath^>
echo on
del /f /q "%inpath%"
@if %errorlevel% neq 0 goto :Error
@echo off
:DeleteInpathEnd


echo.
echo ===^> Switching ^<inpath^> to original
set "inpath=%origpath%"
echo inpath = "%inpath%"

:InPlaceEnd


echo.
echo ===^> Examining audio streams in ^<inpath^>
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
echo ===^> Determining outpath based on audio stream
set "convert="
if defined ismp3 (
    set "outpath=%outdir%\%infilebase%.mp3"
    goto :OutPathEnd
)
if defined isaac (
    set "outpath=%outdir%\%infilebase%.m4a"
    goto :OutPathEnd
)
if defined isopus (
    set "outpath=%outdir%\%infilebase%.mka"
    goto :OutPathEnd
)
if defined isvorbis (
    set "outpath=%outdir%\%infilebase%.oga"
    goto :OutPathEnd
)
set convert=Y
set "outpath=%outdir%\%infilebase%.mp3"
:OutPathEnd
echo convert = "%convert%"
echo outpath = "%outpath%"


echo.
echo ===^> Making sure outpath doesn't already exist
if exist "%outpath%" (
    echo outpath "%outpath%" already exists
    goto :Error
)


if defined convert goto :ExtractEnd
echo.
echo ===^> Extracting audio stream
echo on
"%ffmpeg%" -loglevel 1 -stats -i "%inpath%" -map_metadata 0 -vn -acodec copy "%outpath%"
@if %errorlevel% neq 0 goto :Error
@echo off
goto :End
:ExtractEnd


echo.
echo ===^> Extracting and converting audio stream
echo on
"%ffmpeg%" -loglevel 1 -stats -i "%inpath%" -vn -map_metadata 0 -f mp3 -ar 44100 -ac 2 -q:a 1 "%outpath%"
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

