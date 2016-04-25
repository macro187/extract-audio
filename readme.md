extract-audio.cmd
=================

    Extract (and, if necessary, convert) audio streams to an appropriate audio
    file format in your Music\ folder

Prerequisites
-------------

    ffmpeg

Usage
-----

    extract-audio.cmd <inpath>

        <inpath>    Path to input file. Required. Can be drag-and-dropped in
                    Windows explorer.

Config File
-----------

    %userprofile%\_extract-audio-config.cmd

        <outdir>    Full path to directory to place output files in (no
                    trailing backslash)

                    Default:
                    %userprofile%\Music

                    Example:
                    set "outdir=path\to\output\directory"

        <ffmpeg>    Full path to ffmpeg.exe

                    Default:
                    %ProgramFiles%\ffmpeg\bin\ffmpeg.exe

                    Example:
                    set "ffmpeg=path\to\ffmpeg.exe"

        <ffprobe>   Full path to ffprobe.exe

                    Default:
                    %ProgramFiles%\ffmpeg\bin\ffprobe.exe

                    Example:
                    set "ffprobe=path\to\ffprobe.exe"

Licence
-------

    Copyright (c) 2015 Ron MacNeil

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
    IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
